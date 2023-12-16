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
                        # print("x:", x_coord, "y:", y_coord)
                        visible_landmarks_list.append(np.array([x_coord, y_coord]))
                return np.array(visible_landmarks_list)
        except:
            return np.array([])

    
class LandmarkMapper:
    def __init__(self) -> None:
        pass

    def scale_landmark_to_video_size(self, frame, landmarks):
        width = frame.shape[0]
        height = frame.shape[1]
        print('landmarks', landmarks)
        scaled_landmarks = np.array([[round(lm[0]*width), round(lm[1]*height)] for lm in landmarks])
        scaled_landmarks[scaled_landmarks < 0] = 0
        print('scaled landmarks', scaled_landmarks)
        return scaled_landmarks.astype(np.uint8)

    def landmarks_to_midi_notes(self, landmarks_coords, rows_indices, columns_indices):
    #     print('rows_indices', rows_indices)
        print('columns_indices', columns_indices)
        print('landmarks_coords', landmarks_coords)
        keys = []
        for landmark in landmarks_coords:
            horizontal_key = sum(np.array([1 for num in columns_indices if num <= landmark[0]]))
            keys.append(horizontal_key)

        print('active keys:', keys)
        
            
    def prova(self):
        print('hhw')

class CameraMapper:
    def __init__(self) -> None:
        pass


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
        row_step = round(image.shape[0] / n_rows)
        rows_indices = np.array([x*row_step for x in range(n_rows)])
        column_step = round(image.shape[1] / n_columns)
        columns_indices = np.array([x*column_step for x in range(n_columns)])
        grid = np.zeros_like(image)
        grid[rows_indices, :] = 255
        grid[:, columns_indices] = 255
        grid[rows_indices+1, :] = 255
        grid[:, columns_indices+1] = 255
        grid[rows_indices+2, :] = 255
        grid[:, columns_indices+2] = 255
        grid[rows_indices+3, :] = 255
        grid[:, columns_indices+3] = 255
        if return_indices:
            return np.array(grid).astype('int'), rows_indices, columns_indices
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
            return grid_image.astype(np.uint8), rows_indices, columns_indices
        else:
            return grid_image.astype(np.uint8)
