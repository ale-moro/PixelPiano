import themidibus.*; //<>//

MidiBus myBus;

void setup() {
  size(400, 200);

  try {
    MidiBus.list();

    // Open a MIDI output by name
    myBus = new MidiBus(this, "Processing_Vital");
  } catch (Exception e) {
    println("MIDI setup error: " + e);
    exit(); // Exit the sketch if MIDI setup fails
  }
}

void draw() {
  // Your drawing code here
}


void sendMidiMessage() {
  if (myBus != null) {
    int channel = 0; // MIDI channel (0-15)
    int pitch = 60; // MIDI note number (C4)
    int velocity = 100; // Velocity (0-127)

    myBus.sendNoteOn(channel, pitch, velocity);
    delay(100); // Add a small delay to simulate note duration
    myBus.sendNoteOff(channel, pitch, 0); // Note off
  } else {
    println("MIDI bus not initialized properly.");
  }
}
