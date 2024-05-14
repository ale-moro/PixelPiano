import cv2
import numpy as np
import mediapipe as mp
from mediapipe.framework.formats import landmark_pb2


class FrameUtils:
    @staticmethod
    def resize_frame(frame, width, height):
        return cv2.resize(frame, (width, height))
    
    @staticmethod 
    def convert_frame_to_gray(frame):
        return cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    
    @staticmethod 
    def flip_frame(frame, flip_code):
        return cv2.flip(frame, flip_code)
    
    @staticmethod
    def flip_frame_horizontally(frame):
        return cv2.flip(frame, 1)

    @staticmethod
    def flip_frame_vertically(frame):
        return cv2.flip(frame, 0)
    
    @staticmethod
    def serialize_frame(frame): 
        return frame.tobytes()
    
    @staticmethod 
    def display_frame(frame, window_name):     
        cv2.imshow(window_name, frame)

    @staticmethod
    def wait_key(delay):
        return cv2.waitKey(delay)
    
    @staticmethod
    def draw_landmarks(rgb_frame, detection_result: mp.tasks.vision.HandLandmarkerResult):
        """Courtesy of https://github.com/googlesamples/mediapipe/blob/main/examples/hand_landmarker/python/hand_landmarker.ipynb"""
        try:
            if detection_result.hand_landmarks == []:
                return rgb_frame
            else:
                hand_landmarks_list = detection_result.hand_landmarks
                annotated_image = np.copy(rgb_frame)
                
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
            print("Error drawing landmarks on image. Returning original image.")
            return rgb_frame
    