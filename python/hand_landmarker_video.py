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

# SETUP
MARGIN = 10  # pixels
FONT_SIZE = 1
FONT_THICKNESS = 1
HANDEDNESS_TEXT_COLOR = (88, 205, 54) # vibrant green

ip = 'localhost'
port = 12000 
client = udp_client.SimpleUDPClient(ip, port)

# Hand Landmarks model download
model_path = os.path.abspath('hand_landmarker.task')
if not os.path.exists(model_path):
    print(f"The model '{model_path}' is already downloaded.")
    wget.download('https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task', model_path)

# UTIL FUNCTIONS
def draw_landmarks_on_image(rgb_image, detection_result):
  hand_landmarks_list = detection_result.hand_landmarks
  handedness_list = detection_result.handedness
  annotated_image = np.copy(rgb_image)

  # Loop through the detected hands to visualize.
  for idx in range(len(hand_landmarks_list)):
    hand_landmarks = hand_landmarks_list[idx]
    handedness = handedness_list[idx]

    # Draw the hand landmarks.
    hand_landmarks_proto = landmark_pb2.NormalizedLandmarkList()
    hand_landmarks_proto.landmark.extend([
      landmark_pb2.NormalizedLandmark(x=landmark.x, y=landmark.y, z=landmark.z) for landmark in hand_landmarks
    ])
    solutions.drawing_utils.draw_landmarks(
      annotated_image,
      hand_landmarks_proto,
      solutions.hands.HAND_CONNECTIONS,
      solutions.drawing_styles.get_default_hand_landmarks_style(),
      solutions.drawing_styles.get_default_hand_connections_style())

    # Get the top left corner of the detected hand's bounding box.
    height, width, _ = annotated_image.shape
    x_coordinates = [landmark.x for landmark in hand_landmarks]
    y_coordinates = [landmark.y for landmark in hand_landmarks]
    text_x = int(min(x_coordinates) * width)
    text_y = int(min(y_coordinates) * height) - MARGIN

    # Draw handedness (left or right hand) on the image.
    cv2.putText(annotated_image, f"{handedness[0].category_name}",
                (text_x, text_y), cv2.FONT_HERSHEY_DUPLEX,
                FONT_SIZE, HANDEDNESS_TEXT_COLOR, FONT_THICKNESS, cv2.LINE_AA)

  return annotated_image

# Download test image and show it
# image_name = 'image.png'
# print(image_name)
# if not os.path.exists(image_name):
#     print(f"The file '{image_name}' already exists.")
#     wget.download('https://storage.googleapis.com/mediapipe-tasks/hand_landmarker/woman_hands.jpg', image_name)
# image_path = os.path.abspath(image_name)
# img = cv2.imread(image_path)
# cv2.imshow('image', img)

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
            
            # prints and send fingertips landmarks
            for idy in range(4,len(hand_landmarks),4):
               x_coord = hand_landmarks[idy].x
               y_coord = hand_landmarks[idy].y

               print("x:", x_coord, "y:", y_coord)
               client.send_message('/coordinates', [x_coord, y_coord])
            
            
            # Draw the hand landmarks.
            hand_landmarks_proto = landmark_pb2.NormalizedLandmarkList()
            hand_landmarks_proto.landmark.extend([
               landmark_pb2.NormalizedLandmark(x=landmark.x, y=landmark.y, z=landmark.z) for landmark in hand_landmarks])
            mp.solutions.drawing_utils.draw_landmarks(
               annotated_image,
               hand_landmarks_proto,
               mp.solutions.hands.HAND_CONNECTIONS,
               mp.solutions.drawing_styles.get_default_hand_landmarks_style(),
               mp.solutions.drawing_styles.get_default_hand_connections_style())
         
            
         print("\n")
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
      # display frame
      # create landmarker
      # draw landmarks on frame
        
      hand_landmarker.detect_async(frame)
      frame = draw_landmarks_on_image(frame,hand_landmarker.result)
      cv2.imshow('frame',frame)
      

      if cv2.waitKey(1) == ord('q'):
            break



    # release everything
   hand_landmarker.close()
   cap.release()
   cv2.destroyAllWindows()

if __name__ == "__main__":
   main()
''' 
ret, frame = cap.read()
print(ret, frame)
frame = cv2.flip(frame, 1)
cv2.imshow('frame',frame)
cv2.imshow(frame)
if cv2.waitKey(1) == ord('q'):
    break

# STEP 2: Create an HandLandmarker object.
base_options = python.BaseOptions(model_asset_path='hand_landmarker.task')
options = vision.HandLandmarkerOptions(base_options=base_options,
                                       num_hands=2)
detector = vision.HandLandmarker.create_from_options(options)

# STEP 3: Load the input image.
image = mp.Image.create_from_file(image_name)

# STEP 4: Detect hand landmarks from the input image.
detection_result = detector.detect(image)

# STEP 5: Process the classification result. In this case, visualize it.
annotated_image = draw_landmarks_on_image(image.numpy_view(), detection_result)
cv2.imshow('landmarks_image', cv2.cvtColor(annotated_image, cv2.COLOR_RGB2BGR))
cv2.waitKey(0)
print('end')'''