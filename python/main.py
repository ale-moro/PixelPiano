import cv2
from landmark_utils import LandmarkUtils

import threading

# cv2
import cv2
# math
import numpy as np

# custom
from video_socket_transmitter import VideoSocketServer
from osc_transmitter import OSCTransmitter
from hand_landmarker import HandLandmarker
from frame_utils import FrameUtils
from landmark_utils import *

frame_width = 640
frame_height = 480

class Application:
    def __init__(self, scale_factor=1/5):
        self.video_capture = cv2.VideoCapture(0)
        self.hand_landmarker = HandLandmarker()
        self.landmark_utils = LandmarkUtils()
        self.landmark_mapper = LandmarkPianoMapper(scale_factor=scale_factor)
        self.flattened_coords_prev = np.zeros(10)
        self.osc_communicator = OSCTransmitter(self.video_capture)
        self.video_transmitter = VideoSocketServer(self.video_capture, grayscale=True, resize=(frame_width, frame_height))
        self.crop_factor = scale_factor

    def run(self):
        # Accept a client connection
        self.video_transmitter.accept_connection()
        # self.video_transmitter.stream_video(on_separate_thread=True)
        # self.osc_communicator.stream_OSC_messages(on_separate_thread=True)

        while True:
            ret, frame_clean = self.video_capture.read()
            frame = frame_clean

            # FRAME IMAGE PROCESSING
            # frame = FrameUtils.flip_frame_horizontally(frame=frame_clean)
            # frame = FrameUtils.flip_frame_vertically(frame=frame_clean)
            frame_cropped = FrameUtils.crop(frame_clean, ratio=self.crop_factor)
            # print landmarks on frame
            self.hand_landmarker.detect_landmarks(frame)
            # print('hlr:', self.hand_landmarker.result)
            # results = self.hand_landmarker.result
            # print(type(results))
            # res = getattr(results, 'hand_landmarks', None)
            # for landmark in res:
            #     landmark.x = landmark.x
            #     landmark.y = landmark.y
            # print(res)
            frame = FrameUtils.draw_landmarks(frame, self.hand_landmarker.result)
            # print grid on frame
            frame, rows_indices, columns_indices = self.landmark_mapper.draw_grid_on_image(frame, return_indices=True)

            # LANDMARK PROCESSING            
            # Process landmarks
            landmarks_coords = LandmarkUtils.xy_fingertips_landmarks(self.hand_landmarker.result)

            # Send landmarks via OSC
            if len(landmarks_coords) > 0:
                self.flattened_coords_prev = self.osc_communicator.send_coords(landmarks_coords, self.flattened_coords_prev)
            landmarks_coords = self.landmark_mapper.scale_landmark_to_video_size(frame, landmarks_coords)

            # map landmarks to MIDI notes and send them via OSC
            midi_notes = self.landmark_mapper.landmarks_to_midi_notes(landmarks_coords)
            self.osc_communicator.send_osc_active_notes(list(midi_notes))

            self.video_transmitter._send_frame(frame_cropped)
            
            # Display frame
            # frame = FrameUtils.flip_frame_horizontally(frame)
            cv2.imshow('frame', frame.astype(np.uint8)) 
            if cv2.waitKey(1) == ord('q') or cv2.waitKey(33) == 27:
                break

        # release everything
        self.hand_landmarker.close()
        self.video_capture.release()
        cv2.destroyAllWindows()
    
if __name__ == "__main__":
    app = Application()
    app.run()
