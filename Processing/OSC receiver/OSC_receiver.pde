import oscP5.*;
import javax.sound.midi.*;

OscP5 oscP5;

MidiDevice.Info[] midiDeviceInfo;
MidiDevice midiOutputDevice;
Receiver midiReceiver;
int prevValue = 0;

void setup() {
  size(400, 300);
  oscP5 = new OscP5(this, 12000); // Listening on port 12000
  
  // Set up MIDI output
  //listAvailableDevices();
  selectMidiOutput("virtualPort"); // Replace with your desired output device name
}

void selectMidiOutput(String outputDeviceName) {
  try {
    // Get available MIDI devices
    midiDeviceInfo = MidiSystem.getMidiDeviceInfo();

    for (MidiDevice.Info info : midiDeviceInfo) {
      if (info.getName().equals(outputDeviceName)) {
        midiOutputDevice = MidiSystem.getMidiDevice(info);
        midiOutputDevice.open();
        midiReceiver = midiOutputDevice.getReceiver();
        break;
      }
    }

    if (midiOutputDevice == null || midiReceiver == null) {
      println("Output MIDI device not found or unable to open.");
    }
  } catch (MidiUnavailableException e) {
    e.printStackTrace();
  }
}

void sendNoteOn(int noteNumber) {
  if (midiReceiver != null) {
    try {
      // Send a MIDI note-on message
      ShortMessage noteOn = new ShortMessage();
      noteOn.setMessage(ShortMessage.NOTE_ON, 0, noteNumber, 127); // MIDI channel 0, note number 60 (C4), velocity 100
      midiReceiver.send(noteOn, -1);
    } catch (InvalidMidiDataException e) {
      e.printStackTrace();
    }
  } else {
    println("MIDI receiver not available.");
  }
}

void sendNoteOff(int noteNumber){
    if (midiReceiver != null) {
    try {
      // Send a MIDI note-off message
      ShortMessage noteOff = new ShortMessage();
      noteOff.setMessage(ShortMessage.NOTE_OFF, 0, noteNumber, 0); // MIDI channel 0, note number 60 (C4), velocity 0
      midiReceiver.send(noteOff, -1);
    } catch (InvalidMidiDataException e) {
      e.printStackTrace();
    }
  } else {
    println("MIDI receiver not available.");
  }
  
}

void draw() {
  // Processing code
}

void oscEvent(OscMessage msg) {
  try {
    if (msg.checkAddrPattern("/note_numbers")) {
      int argumentCount = msg.arguments().length; // Get the number of arguments in the message
      int[] receivedValues = new int[argumentCount]; 

      for (int i = 0; i < argumentCount; i++) {
          int receivedValue = msg.get(i).intValue();
          receivedValues[i] = receivedValue;
          }
      //print("Received values: ");
      //for (int i = 0; i < receivedValues.length; i++) {
      //  print(receivedValues[i] + " ");
      //}
      //println();
      int noteNumber = receivedValues[1];

      if(noteNumber!= 0 && noteNumber != prevValue){
      sendNoteOff(prevValue);
      print("Sending note on of index finger: " + noteNumber+"\n");
      sendNoteOn(noteNumber);
      }
      prevValue = noteNumber;
    } else {
      println("Error: Unexpected OSC address pattern.");
    }
  } catch (Exception e) {
    println("Error handling OSC message: " + e.getMessage());
    e.printStackTrace();
  }
}
