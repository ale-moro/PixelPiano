from pythonosc import udp_client
import numpy as np
import threading

from landmark_utils import LandmarkUtils
from hand_landmarker import HandLandmarker
from landmark_utils import LandmarkPianoMapper


class OSCTransmitter:
    def __init__(self, video_capture, landmark_mapper:LandmarkPianoMapper, crop_factor=None,):
        self.video_capture = video_capture 
        self.connection = OSCConnection(ip='localhost', port=12000)
        self.hand_landmarker = HandLandmarker()
        self.landmark_mapper = landmark_mapper
        self.flattened_coords_prev = np.zeros(10)
        self.crop_factor = crop_factor


    def send_osc_active_notes(self, note_numbers):
        self.connection.send_osc_active_notes(note_numbers)

    def send_coords(self, coords: list, flattened_coords_prev: np.array):
        self.connection.send_coords(coords, flattened_coords_prev, crop_factor=self.crop_factor)
    
    def stream_OSC_messages(self, on_separate_thread:bool=True):
        if on_separate_thread:
            # Start the thread for receiving frames
            stream_thread = threading.Thread(target=self._stream_OSC_messages, args=([self.video_capture]))
            stream_thread.start()
        else:
            self._stream_active_notes()

    def _stream_OSC_messages(self, video_capture):
        while True:
            # Read a frame from the camera
            ret, frame = video_capture.read()
            if not ret:
                break
            self._stream_OSC_frame_messages(frame)

    def _stream_OSC_frame_messages(self, frame):
        # detect landmarks
        self.hand_landmarker.detect_landmarks(frame)
        # Process landmarks
        landmarks_coords = LandmarkUtils.xy_fingertips_landmarks(self.hand_landmarker.result)

        # Send landmarks via OSC
        if len(landmarks_coords) > 0:
            self.flattened_coords_prev = self.connection.send_coords(landmarks_coords, self.flattened_coords_prev)
        landmarks_coords = self.landmark_mapper.scale_landmark_to_video_size(frame, landmarks_coords)

        # map landmarks to MIDI notes and send them via OSC
        midi_notes = self.landmark_mapper.landmarks_to_midi_notes(landmarks_coords)
        self.connection.send_osc_active_notes(list(midi_notes))

    
class OSCConnection:
    def __init__(self, ip:str='localhost', port:int=12000):
        # Initialize OSC client
        self.ip = ip
        self.port = port
        self.client = udp_client.SimpleUDPClient(self.ip, self.port)

    def _send_midi_notes(self, midi_notes: list):
        # Send MIDI notes via OSC
        self.client.send_message('/note_numbers', midi_notes)

    def send_osc_active_notes(self, note_numbers):
        midi_notes = [int(n) for n in note_numbers]
        self._send_midi_notes(midi_notes)

    def _send_coords(self, coords):
        # Send coordinates via OSC
        self.client.send_message('/coords', coords)

    def send_coords(self, coords: list, flattened_coords_prev: np.array, crop_factor=None):
        flattened_coords = np.array([round(float(coord), 4) for sublist in coords for coord in sublist])
        if crop_factor is not None:
            upperbound = 1 / (1 - crop_factor)
            shift_factor = crop_factor / (2*(1 - crop_factor))
            f = lambda x: x * upperbound - shift_factor
            flattened_coords = f(flattened_coords)  


        flattened_coords_prev = flattened_coords if (flattened_coords!=np.zeros(10)).any() else flattened_coords_prev
        coords = (flattened_coords + flattened_coords_prev)/2
        self._send_coords(coords=coords)
