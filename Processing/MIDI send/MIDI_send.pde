import javax.sound.midi.*; //<>//

MidiDevice.Info[] midiDeviceInfo;
MidiDevice midiOutputDevice;
Receiver midiReceiver;

void setup() {
  size(200, 200);
  listAvailableDevices();
  selectMidiOutput("Processing_Vital"); // Replace with your desired output device name
  sendMidiNote();
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

void sendMidiNote() {
  if (midiReceiver != null) {
    try {
      // Send a MIDI note-on message
      ShortMessage noteOn = new ShortMessage();
      noteOn.setMessage(ShortMessage.NOTE_ON, 0, 60, 100); // MIDI channel 0, note number 60 (C4), velocity 100
      midiReceiver.send(noteOn, -1);

      // Add a delay (optional)
      delay(1000); // 1 second delay

      // Send a MIDI note-off message
      ShortMessage noteOff = new ShortMessage();
      noteOff.setMessage(ShortMessage.NOTE_OFF, 0, 60, 0); // MIDI channel 0, note number 60 (C4), velocity 0
      midiReceiver.send(noteOff, -1);
    } catch (InvalidMidiDataException e) {
      e.printStackTrace();
    }
  } else {
    println("MIDI receiver not available.");
  }
}

void listAvailableDevices() {
  MidiDevice.Info[] infos = MidiSystem.getMidiDeviceInfo();
  for (MidiDevice.Info info : infos) {
    println("Device: " + info.getName() + ", " + info.getDescription());
  }
}

void draw() {
  // Your drawing code here
}
