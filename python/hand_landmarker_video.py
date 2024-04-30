# IMPORTS

# utils
import wget
import time
import os

# mediapipe
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe import solutions
from mediapipe.tasks.python import vision
from mediapipe.framework.formats import landmark_pb2

# cv2
import cv2
# math
import numpy as np

# data serialization
import pickle
import struct
# OSC
from pythonosc import osc_message_builder
from pythonosc import udp_client
# socket
import socket

# custom
from landmark_utils import *

# SETUP
MARGIN = 10  # pixels
FONT_SIZE = 10
FONT_THICKNESS = 1
HANDEDNESS_TEXT_COLOR = (88, 205, 54) # vibrant green

#ip = '192.168.1.176'
ip = 'localhost'
port = 12001 
client = udp_client.SimpleUDPClient(ip, port)
landmark_utils = LandmarkUtils()
landmark_mapper = LandmarkPianoMapper()

# Hand Landmarks model download
script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)
model_path = os.path.abspath('hand_landmarker.task')
if not os.path.exists(model_path):
    print(f"The model '{model_path}' is already downloaded.")
    wget.download('https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task', model_path)

# OSC
def send_osc_active_notes(note_numbers: list):
  note_numbers = [int(n) for n in note_numbers]
  client.send_message('/note_numbers', note_numbers)

def send_osc_coords(coords: list, flattened_coords_prev: np.array):
  flattened_coords = np.array([round(float(coord), 4) for sublist in coords for coord in sublist])
  flattened_coords_prev = flattened_coords if (flattened_coords!=np.zeros(10)).any() else flattened_coords_prev
  flattened_coords_prev = (flattened_coords + flattened_coords_prev)/2
  client.send_message('/coords', flattened_coords_prev)

  return flattened_coords_prev

def send_osc_frame(frame):

  def rescale_frame(frame, new_width=600, new_height=480):  
    # Rescale the image
    return cv2.resize(frame, (new_width, new_height))

  def grayscale_frame(frame):
    img_float32 = np.float32(frame)
    return cv2.cvtColor(img_float32, cv2.COLOR_BGR2GRAY)
  
  # Process the image
  processed_frame = grayscale_frame(frame)
  # processed_frame = rescale_frame(frame, new_width=60, new_height=48)
  processed_frame = cv2.resize(processed_frame, (24, 16))
  print('resizedframe.shape', processed_frame.shape)
   # Convert image to byte array
  # processed_frame = np.array([[0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]])
  img_bytes = processed_frame.tobytes()
  # Send the byte array over OSC
  client.send_message("/frame", img_bytes)
  cv2.imshow('frame', processed_frame.astype(np.uint8)) 


def draw_landmarks_on_image(rgb_image, detection_result: mp.tasks.vision.HandLandmarkerResult):
  """Courtesy of https://github.com/googlesamples/mediapipe/blob/main/examples/hand_landmarker/python/hand_landmarker.ipynb"""
  try:
    if detection_result.hand_landmarks == []:
        return rgb_image
    else:
        hand_landmarks_list = detection_result.hand_landmarks
        annotated_image = np.copy(rgb_image)

        # Loop through the detected hands to visualize.
        for idx in range(len(hand_landmarks_list)):
            hand_landmarks = hand_landmarks_list[idx]

        # Draw the hand landmarks.
        hand_landmarks_proto = landmark_pb2.NormalizedLandmarkList()
        hand_landmarks_proto.landmark.extend([
            landmark_pb2.NormalizedLandmark(x=landmark.x, y=landmark.y, z=landmark.z) for landmark in hand_landmarks]
        )
        mp.solutions.drawing_utils.draw_landmarks(
            annotated_image,
            hand_landmarks_proto,
            mp.solutions.hands.HAND_CONNECTIONS,
            mp.solutions.drawing_styles.get_default_hand_landmarks_style(),
            mp.solutions.drawing_styles.get_default_hand_connections_style()
        )
        return annotated_image
  except:
      return rgb_image

class landmarker_and_result():
    def __init__(self):
      self.result = mp.tasks.vision.HandLandmarkerResult
      self.landmarker = mp.tasks.vision.HandLandmarker
      self.createLandmarker()

    def createLandmarker(self):
      # callback function
      def update_result(result: mp.tasks.vision.HandLandmarkerResult, output_image: mp.Image, timestamp_ms: int):
        self.result = result

      # HandLandmarkerOptions (details here: https://developers.google.com/mediapipe/solutions/vision/hand_landmarker/python#live-stream)
      options = mp.tasks.vision.HandLandmarkerOptions( 
        base_options = mp.tasks.BaseOptions(model_asset_path="hand_landmarker.task"), # path to model
        running_mode = mp.tasks.vision.RunningMode.LIVE_STREAM, # running on a live stream
        num_hands = 1, # track both hands
        min_hand_detection_confidence = 0.3, # lower than value to get predictions more often
        min_hand_presence_confidence = 0.3, # lower than value to get predictions more often
        min_tracking_confidence = 0.3, # lower than value to get predictions more often
        result_callback=update_result)
      
      # initialize landmarker
      self.landmarker = self.landmarker.create_from_options(options)

    def detect_async(self, frame):
      # convert np frame to mp image
      mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
      # detect landmarks
      self.landmarker.detect_async(image = mp_image, timestamp_ms = int(time.time() * 500))

    def close(self):
      # close landmarker
      self.landmarker.close()

def main():
   # STEP 1: capture video
   # access webcam
   cap = cv2.VideoCapture(0)
   hand_landmarker = landmarker_and_result()
   flattened_coords_prev = np.zeros(10)

   # Initialize socket
   server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   server_socket.bind(('localhost', 8000))
   server_socket.listen(10)

   # Accept a connection
   client_socket, addr = server_socket.accept()
   connection = client_socket.makefile('wb')


   while True:
    # pull frame
    ret, frame = cap.read()
    print('resizedframe.shape', frame.shape)

    # mirror frame
    # frame = cv2.flip(frame, 1)

    if ret:
      # Serialize frame
      data = pickle.dumps(frame)
      # Pack message length and frame data
      message_size = struct.pack("L", len(data))
      # Send message length followed by frame data
      connection.write(message_size + data)

    # print landmarks
    hand_landmarker.detect_async(frame)
    frame = draw_landmarks_on_image(frame, hand_landmarker.result)
    # print grid
    frame, rows_indices, columns_indices = landmark_mapper.draw_grid_on_image(frame, return_indices=True)

    # retrieve and convert landmarks
    landmarks_coords = landmark_utils.xy_fingertips_landmarks(hand_landmarker.result)
    if len(landmarks_coords) > 0:
      flattened_coords_prev = send_osc_coords(landmarks_coords, flattened_coords_prev)
    landmarks_coords = landmark_mapper.scale_landmark_to_video_size(frame, landmarks_coords)

    # map landmarks to notes
    midi_notes = landmark_mapper.landmarks_to_midi_notes(landmarks_coords) 

    send_osc_active_notes(list(midi_notes))
    # send_osc_frame(frame)

    # display frame
    cv2.imshow('frame', frame.astype(np.uint8)) 
    if cv2.waitKey(1) == ord('q'):
          break

   # release everything
   # Close connections
   connection.close()
   server_socket.close()
   hand_landmarker.close()
   cap.release()
   cv2.destroyAllWindows()

if __name__ == "__main__":
   main()
