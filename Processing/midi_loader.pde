import javax.sound.midi.*;

public class MidiLoader {
    Sequence sequence;
    String midiFilePath;
    File midiFile;
    MidiSequenceAnalyzer analyzer;

    public MidiLoader(){
      this.analyzer = new MidiSequenceAnalyzer();
    }


  public void printMidiFileInfo(String midiFilePath){
    this.midiFilePath = midiFilePath;
    this.midiFile = new File(this.midiFilePath);
    println("MIDI file: " + this.midiFile.getAbsolutePath());
    try {
      // Load a MIDI sequence from a file
      Sequence s = MidiSystem.getSequence(this.midiFile);

      // print Sequence info
      printMidiInfo(s);

      // print Track info
      Track[] tracks = s.getTracks();

      println("Tracks: " + tracks.length);
      for(int i = 0; i < tracks.length; i++) {
        Track t = tracks[i];
        printTrackInfo(t, i);

        // print MIDI events info
        for (int k = 0; k < min(t.size(), 20); ++k) {
          MidiEvent e = t.get(k);
          printMessage(e.getMessage(), e.getTick()); 
        }
      }
    } catch(Exception e) {
        println("Error: " + e); 
    } 
  }

  public void setFilePath(String path) {
      this.midiFilePath = path;
  }

  public Sequence loadMidiSequence(String path) {
    try {
        // Load a MIDI sequence from a file
        this.sequence = MidiSystem.getSequence(new File(this.midiFilePath));

    } catch (IOException | InvalidMidiDataException e) {
        e.printStackTrace();
    }
    return this.sequence;

  }

  void MIDIfileSelected(File selection) {
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      println("User selected " + selection.getAbsolutePath());
      this.midiFilePath = selection.getAbsolutePath();
    }
  }
  private void printMessage(MidiMessage msg, long timeStamp) {
    // print notes
    if (msg instanceof ShortMessage){
      ShortMessage sm = (ShortMessage) msg;
      if (isNoteMessage(msg)) {
        MidiNote note = new MidiNote(sm, timeStamp);
        note.print("note");
      } else {
        println("Unrecongnized Short MIDI message with command:" + sm.getCommand());}
    } else if (msg instanceof MetaMessage) {
      // print meta messages
      MetaMessage mm = (MetaMessage) msg;
      if (mm.getType() == 0x51) {
        byte[] data = mm.getData();
        int mspq = ((data[0] & 0xff) << 16) | ((data[1] & 0xff) << 8) | (data[2] & 0xff);
        int tempo = Math.round(60000001f / mspq);
        println("Tempo: " + tempo);
      } else {
        println("Unrecongnized Meta MIDI message with type:" + mm.getType());
      }
    } else if (msg instanceof SysexMessage) {   
      println("Sysex message with status: " + msg.getStatus());  
    }
  }

  private void printMidiInfo(Sequence s){
    println("Division type: " + s.getDivisionType());
    println("Duration (microsec): " + s.getMicrosecondLength());
    println("Resolution (PPQ if division = " + s.PPQ + "): " + s.getResolution());
    println("Ticks per 4/4 measure: " + (4 * s.getResolution()));
    println("Duration (ticks length): " + s.getTickLength());
    println("Number of tracks: " + s.getTracks().length);
    this.analyzer.analyze(s);
    println("Analizer BPM: " + this.analyzer.getBPM());
    println("Analizer Quarter note duration (ms): " + this.analyzer.getQuarterNoteDurationMs());
    println("Analizer Tick duration (ms): " + this.analyzer.getTickMs());  
  }

  private void printTrackInfo(Track t, int trackIndex){
    println();
    println("  Track " + (trackIndex+1));
    println("    Events: " + t.size());
    println("    Duration (ticks): " + t.ticks());
  }

  private boolean isNoteMessage(MidiMessage msg) {
    if (msg instanceof ShortMessage) {
      ShortMessage sm = (ShortMessage) msg;
      if(sm.getCommand()==ShortMessage.NOTE_ON || sm.getCommand()==ShortMessage.NOTE_OFF) {
        return true;
      }
    }
    return false;
  }
}