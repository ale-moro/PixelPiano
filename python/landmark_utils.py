import math
import numpy as np
import mediapipe as mp
import matplotlib.pyplot as plt

class LandmarkUtils:
    def xy_fingertips_landmarks(self, detection_result: mp.tasks.vision.HandLandmarkerResult):
        try:
            if detection_result.hand_landmarks == []:
                return np.array([])
            else:
                visible_landmarks_list = []
                hand_landmarks_list = detection_result.hand_landmarks
                # Loop through the detected hands to visualize.
                for idx in range(len(hand_landmarks_list)):
                    hand_landmarks = hand_landmarks_list[idx]
                    # prints and send fingertips landmarks
                    for idy in range(4, len(hand_landmarks), 4):
                        x_coord = hand_landmarks[idy].x
                        y_coord = hand_landmarks[idy].y
                        visible_landmarks_list.append(np.array([x_coord, y_coord]))
                return np.array(visible_landmarks_list)
        except:
            return np.array([])

    
class LandmarkPianoMapper:
    def __init__(self, n_octaves = 2, bottom_C_midi_note=48) -> None:
        self.n_octaves = n_octaves
        self.bottom_C_midi_note = bottom_C_midi_note
        self.black_key_width_factor = 0.5
        self.white_key_width = 20
        self.black_keys_y_end = 200
        self.white_keys_x_indices = []
        self.black_keys_x_indices = []
        self.black_keys_x_start_indices = []

        self.white_keys_y_end = 400
        self.black_keys_y_start = 100

    def create_image_grid(self, image, n_rows, n_columns, return_indices=False):
        """
        Create an image grid with specified step sizes between grid points.
        
        Parameters:
        image (ndarray): image which dimensions you want to use for the grid
        vertical_step (float): Step size between vertical grid points.
        horizontal_step (float): Step size between horizontal grid points.
        
        Returns:
        list: A grid containing sets of normalized pixel coordinates for the image based on the step sizes.
        """
        # x of each key type
        n_white_keys = self.n_octaves * 7
        self.white_key_width = round(image.shape[1] / n_white_keys)
        black_key_width = round(self.white_key_width * self.black_key_width_factor)
        self.white_keys_x_indices = np.array([round(x*self.white_key_width) for x in range(n_white_keys)])
        self.black_keys_x_start_indices = np.array([round(key-(1-self.black_key_width_factor)*self.white_key_width/2) for idx, key in enumerate(self.white_keys_x_indices) if idx%7 not in [0, 3]])
        self.black_keys_x_end_indices = np.array([round(idx + black_key_width) for idx in self.black_keys_x_start_indices])
        self.black_keys_x_indices = np.array([[round(key+i) for i in range(black_key_width)] for key in self.black_keys_x_start_indices])
        self.black_keys_x_indices = self.black_keys_x_indices.flatten()

        # y of each key type
        self.white_keys_y_start = round(image.shape[0]/2)
        self.black_keys_y_start = round(image.shape[0]/4)
        self.white_keys_y_end = round(image.shape[0]*7/8)
        self.black_keys_y_end = self.white_keys_y_start

        # display grid
        grid = np.zeros_like(image)
        # white keys
        grid[self.white_keys_y_start:self.white_keys_y_end, self.white_keys_x_indices] = 255
        grid[self.white_keys_y_end, :] = 255
        # black keys
        # vertical lines
        grid[self.black_keys_y_start:self.black_keys_y_end, self.black_keys_x_start_indices] = 255
        grid[self.black_keys_y_start:self.black_keys_y_end, self.black_keys_x_end_indices] = 255
        # horizontal lines
        grid[self.black_keys_y_start, self.black_keys_x_indices] = 255
        grid[self.black_keys_y_end, self.black_keys_x_indices] = 255

        if return_indices:
            return np.array(grid).astype('int'), self.white_keys_x_indices, [round(grid.shape[0]/2)]
        else:
            return np.array(grid).astype('int')

    def draw_grid_on_image(self, rgb_image, return_indices=False):
        grid_image = np.copy(rgb_image) # np.array
        # print(annotated_image.shape) # 480, 640, 3 (rgb)
        grid, rows_indices, columns_indices = self.create_image_grid(
            grid_image,
            n_rows=1,
            n_columns=8, 
            return_indices=return_indices
        )
        assert grid_image.shape == grid.shape
        grid_image = grid + grid_image
        grid_image[grid_image>255] = 255
        # print('grid_image', grid_image.shape)
        # plt.imshow(grid_image)
        # plt.show()
        if return_indices:
            return grid_image.astype('int'), rows_indices, columns_indices
        else:
            return grid_image.astype('int')


    def scale_landmark_to_video_size(self, frame, landmarks):
        width = frame.shape[0]
        height = frame.shape[1]
        scaled_landmarks = np.array([[round(lm[0]*height), round(lm[1]*width)] for lm in landmarks])
        scaled_landmarks[scaled_landmarks < 0] = 0
        return scaled_landmarks

    def landmarks_to_midi_notes(self, landmarks_coords):
        def black_key_to_midi_note(key):
            # converts the number of the key pressed on the interface into the correct midi number
            key = key - 1
            black_notes_midi_dict = dict([(0, 2), (1, 4), (2, 7), (3, 9), (4, 11)])
            octave = math.floor(key / 5)
            scale_midi_note = black_notes_midi_dict[int(key%5)]
            scale_midi_note = scale_midi_note - 1
            return 12*octave + scale_midi_note + self.bottom_C_midi_note

        def white_key_to_midi_note(key):
            # converts the number of the key pressed on the interface into the correct midi number
            key = key - 1
            white_notes_midi_dict = dict([(0, 1), (1, 3), (2, 5), (3, 6), (4, 8), (5, 10), (6, 12)])
            octave = math.floor(key / 7)
            scale_midi_note = white_notes_midi_dict[int(key%7)]
            scale_midi_note = scale_midi_note - 1
            return 12*octave + scale_midi_note + self.bottom_C_midi_note
        
        # number of fingers
        active_notes = np.zeros(5)
        for idx, landmark in enumerate(landmarks_coords):
            # skip if out of keyboard (vertically)
            if landmark[1] < self.black_keys_y_start or landmark[1] > self.white_keys_y_end:
                continue
            
            # if in the y region of black keys
            if landmark[1] < self.black_keys_y_end and landmark[0] in self.black_keys_x_indices:
                key = sum(np.array([1 for num in self.black_keys_x_start_indices if num <= landmark[0]]))
                active_notes[idx] = black_key_to_midi_note(key)
            # white key region
            else:
                key = sum(np.array([1 for num in self.white_keys_x_indices if num <= landmark[0]]))
                active_notes[idx] = white_key_to_midi_note(key)

        #print('active notes:', active_notes)
        return active_notes
