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
if (msg.checkAddrPattern("/note_numbers")) {
      if (msg.checkTypetag("iiiii")) {
        int receivedValue1 = msg.get(0).intValue();
        int receivedValue2 = msg.get(1).intValue();
        int receivedValue3 = msg.get(2).intValue();
        int receivedValue4 = msg.get(3).intValue();
        int receivedValue5 = msg.get(4).intValue();
        println("Received values: " + receivedValue1 + ", " + receivedValue2+", "+ receivedValue3 + ", " + receivedValue4+", "+receivedValue5);
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
