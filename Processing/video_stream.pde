import java.io.*;
import java.net.*;
import processing.core.*;



class VideoStream {
    Socket socket;
    DataInputStream in;
    PImage img;
    int image_byte_length = 0;
    int stream_width = 640;
    int stream_height = 480;
    int image_width = 640;
    int image_height = 480;
    int img_x = 0;
    int img_y = 0;
    byte[] imageData;


    VideoStream(int image_width, int image_height, int x, int y){
        this.image_width = image_width;
        this.image_height = image_height;
        this.img_x = x;
        this.img_y = y;

        img = createImage(this.stream_width, this.stream_height, ALPHA);
        // Set the image pixels from the byte array
        img.loadPixels();
        int index = 0;
        for (int h = 0; h < stream_height; h++) {
            for (int w = 0; w < stream_width; w++) {       
                img.pixels[h * stream_width + w] = color('0');
                index++;
            }
        }
        img.updatePixels();

        // setup the connection to the server
        try {
            String hostName = "127.0.0.1";
            int portNumber = 12345;
            socket = new Socket(hostName, portNumber);
            in = new DataInputStream(socket.getInputStream());
            println("Connected to server");
        } catch (UnknownHostException e) {
            println("Don't know about host");
        } catch (IOException e) {
            println("Couldn't get I/O for the connection");
        }
    }

    void draw() {
        try {
            // Check if there's data available from the server
            if (in.available() > 0) {
                // Check if we've received the image size
                if (image_byte_length == 0) {
                    // Read the image size (4 bytes)
                    image_byte_length = in.readInt();
                    // Initialize the image data array
                    imageData = new byte[image_byte_length];
                    // Reset the index for filling the image data array
                    image(img, this.img_x, this.img_y, this.image_width, this.image_height);

                } else {
                    // Read the image data
                    in.readFully(imageData);
                    // Create a new PImage object
                    img = createImage(this.stream_width, this.stream_height, ALPHA);
                    // Set the image pixels from the byte array
                    img.loadPixels();
                    int index = 0;
                    for (int y = 0; y < stream_height; y++) {
                        for (int x = 0; x < stream_width; x++) {
                            int pixelValue = Byte.toUnsignedInt(imageData[index]); // Get pixel value (0-255)
                            int pixel = color(pixelValue);            
                            img.pixels[y * stream_width + x] = pixel;
                            index++;
                        }
                    }
                    img.updatePixels();
                    // Display the image
                    image(img, this.img_x, this.img_y, this.image_width, this.image_height);
                    // Reset image_byte_length to 0 for the next image
                    image_byte_length = 0;
                }
            } else {
                image(img, this.img_x, this.img_y, this.image_width, this.image_height);
            }
        } catch (IOException e) {
            println("Error reading from server");
        }
    }
}