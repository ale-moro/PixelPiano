class OscMsg{
  
  public void selectMidiOutput(String outputDeviceName) {
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

  public void sendNoteOn(int noteNumber) {
    if (midiReceiver != null) {
      try {
        // Send a MIDI note-on message
        ShortMessage noteOn = new ShortMessage();
        noteOn.setMessage(ShortMessage.NOTE_ON, 0, noteNumber - shift, 127); // MIDI channel 0, note number 60 (C4), velocity 100
        midiReceiver.send(noteOn, -1);
      } catch (InvalidMidiDataException e) {
        e.printStackTrace();
      }
    } else {
      println("MIDI receiver not available.");
    }
  }
  
  public void sendNoteOff(int noteNumber){
      if (midiReceiver != null) {
      try {
        // Send a MIDI note-off message
        ShortMessage noteOff = new ShortMessage();
        noteOff.setMessage(ShortMessage.NOTE_OFF, 0, noteNumber - shift, 0); // MIDI channel 0, note number 60 (C4), velocity 0
        midiReceiver.send(noteOff, -1);
      } catch (InvalidMidiDataException e) {
        e.printStackTrace();
      }
    } else {
      println("MIDI receiver not available.");
    }  
  }
}
