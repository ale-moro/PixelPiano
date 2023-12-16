import oscP5.*;
import netP5.*;

OscP5 oscP5;

void setup() {
  size(400, 300);
  oscP5 = new OscP5(this, 12000); // Listening on port 12000
}

void draw() {
  // Processing code
}

void oscEvent(OscMessage msg) {
  try {
    if (msg.checkAddrPattern("/coordinates")) {
      if (msg.checkTypetag("ff")) {
        float receivedValue1 = msg.get(0).floatValue();
        float receivedValue2 = msg.get(1).floatValue();
        println("Received values: " + receivedValue1 + ", " + receivedValue2);
        // Do something with the received values in Processing
      } else {
        println("Error: Unexpected OSC message typetag.");
      }
    } else {
      println("Error: Unexpected OSC address pattern.");
    }
  } catch (Exception e) {
    println("Error handling OSC message: " + e.getMessage());
    e.printStackTrace();
  }
}
