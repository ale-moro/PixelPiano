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
# OSC
from pythonosc import osc_message_builder
from pythonosc import udp_client

from landmark_utils import *

# SETUP
MARGIN = 10  # pixels
FONT_SIZE = 10
FONT_THICKNESS = 1
HANDEDNESS_TEXT_COLOR = (88, 205, 54) # vibrant green

ip = '192.168.1.105'
port = 12000 
client = udp_client.SimpleUDPClient(ip, port)
landmark_utils = LandmarkUtils()
camera_mapper = CameraMapper()
landmark_mapper = LandmarkMapper()

# Hand Landmarks model download
model_path = os.path.abspath('hand_landmarker.task')
if not os.path.exists(model_path):
    print(f"The model '{model_path}' is already downloaded.")
    wget.download('https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task', model_path)

def send_osc_active_notes(note_numbers: list):
  note_numbers = [int(n) for n in note_numbers]
  client.send_message('/note_numbers', note_numbers)

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
        num_hands = 2, # track both hands
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
   while True:
      # pull frame
      ret, frame = cap.read()
      # mirror frame
      frame = cv2.flip(frame, 1)
      # print landmarks
      hand_landmarker.detect_async(frame)
      frame = draw_landmarks_on_image(frame, hand_landmarker.result)
      # print grid
      frame, rows_indices, columns_indices = camera_mapper.draw_grid_on_image(frame, return_indices=True)

      # retrieve and convert landmarks
      landmarks_coords = landmark_utils.xy_fingertips_landmarks(hand_landmarker.result)
      landmarks_coords = landmark_mapper.scale_landmark_to_video_size(frame, landmarks_coords)

      # map landmarks to notes
      midi_notes = landmark_mapper.landmarks_to_midi_notes(landmarks_coords, rows_indices, columns_indices) 
  
      send_osc_active_notes(list(midi_notes))

      # display frame
      cv2.imshow('frame', frame.astype(np.uint8)) 
      if cv2.waitKey(1) == ord('q'):
            break

    # release everything
   hand_landmarker.close()
   cap.release()
   cv2.destroyAllWindows()

if __name__ == "__main__":
   main()