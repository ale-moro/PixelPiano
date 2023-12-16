import numpy as np
import matplotlib.pyplot as plt

class LandmarkMapper:
    def __init__(self) -> None:
        pass

    def prova(self):
        print('hhw')

class CameraMapper:
    def __init__(self) -> None:
        pass


    def create_image_grid(self, image, n_rows, n_columns):
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
        grid[:, columns_indices+2] = 255
        return np.array(grid).astype('int')

    def draw_grid_on_image(self, rgb_image):
        grid_image = np.copy(rgb_image) # np.array
        # print(annotated_image.shape) # 480, 640, 3 (rgb)
        grid = self.create_image_grid(
            grid_image,
            n_rows=5,
            n_columns=5
        )

        assert grid_image.shape == grid.shape
        grid_image = grid + grid_image
        grid_image[grid_image>255] = 255
        # print('grid_image', grid_image.shape)
        # plt.imshow(grid_image)
        # plt.show()
        return grid_image.astype(np.uint8)
