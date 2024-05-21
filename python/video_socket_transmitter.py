import socket
import threading
from frame_utils import FrameUtils

class VideoSocketServer:
    def __init__(self, video_capture, grayscale:bool=True, resize:tuple=(640, 480)):
        self.video_capture = video_capture
        self.server_socket = ServerSocket()

        self.grayscale = grayscale
        self.image_size = resize

    def accept_connection(self):
        self.server_socket.accept_connection()
    
    def stream_video(self, on_separate_thread:bool=True):
        if on_separate_thread:
        # Start the thread for receiving frames
            stream_thread = threading.Thread(target=self._stream_video, args=([self.video_capture]), name='video_stream')
            stream_thread.start()
        else:
            self._stream_video()


    def _stream_video(self, video_capture):
        while True:
            # Read a frame from the camera
            ret, f = video_capture.read()
            if not ret:
                break
            self._send_frame(f)

    def _send_frame(self, f):
        # Convert frame to grayscale
        f = FrameUtils.convert_frame_to_gray(f)

        # Resize the frame
        f = FrameUtils.resize_frame(f, 640, 480)

        # Flip image
        # f = FrameUtils.flip_frame_horizontally(f)

        # Send the frame to the client
        self.server_socket.send_frame(f)

    def close(self):
        self.server_socket.close()


class ServerSocket:
    def __init__(self, host='127.0.0.1', port=12345):
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.bind((host, port))
        self.server_socket.listen()
        print(f"Server is listening on {host}:{port}")
        self.client_socket = None

    def accept_connection(self):
        self.client_socket, client_address = self.server_socket.accept()
        self.server_socket.setblocking(False)  # Set the socket to non-blocking mode

        print(f"Accepted connection from {client_address}")

    def close(self):
        self.server_socket.close()

    def send_frame(self, frame):
        try:
            # Serialize the frame to bytes
            serialized_frame = frame.tobytes()

            # Send the frame size first
            serialized_frame_bytes_len = len(serialized_frame).to_bytes(4, byteorder='big')
            msg = self.client_socket.sendall(serialized_frame_bytes_len)

            # Send the frame data
            msg = self.client_socket.sendall(serialized_frame)

        except Exception as e:
            print("Error sending frame:", e)
            exit(1)


    def receive_frames(self, server_socket, video_capture):
        while True:
            # Read a frame from the camera
            ret, frame = video_capture.read()
            if not ret:
                break
            
            # Convert frame to grayscale
            frame = FrameUtils.convert_frame_to_gray(frame)

            # Resize the frame
            frame = FrameUtils.resize_frame(frame, 640, 480)

            # Send the frame to the client
            server_socket.send_frame(frame)
