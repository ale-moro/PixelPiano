import javax.sound.midi.*;

public class MidiLoader {
    Sequence sequence;
    String midiFilePath;
    File midiFile;
    MidiSequenceAnalyzer analyzer;

    public MidiLoader(){
      this.analyzer = new MidiSequenceAnalyzer(s);

    }

  public void loadMidi(String midiFilePath){
    this.midiFilePath = midiFilePath;
    this.midiFile = new File(this.midiFilePath);
    println("MIDI file: " + this.midiFile.getAbsolutePath());
    try {
      // Load a MIDI sequence from a file
      Sequence s = MidiSystem.getSequence(this.midiFile);
      this.analyzer.analyze(s);

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

          // print notes
          if (e.getMessage() instanceof ShortMessage){
            if (isNoteMessage(e.getMessage())) {
            ShortMessage sm = (ShortMessage) e.getMessage();
            MidiNote note = new MidiNote(sm, e.getTick());
            note.print("note");
            }
          } else if (
            
            // print meta messages
            e.getMessage() instanceof MetaMessage) {
            MetaMessage mm = (MetaMessage) e.getMessage();
            if (mm.getType() == 0x51) {
              byte[] data = mm.getData();
              int mspq = ((data[0] & 0xff) << 16) | ((data[1] & 0xff) << 8) | (data[2] & 0xff);
              int tempo = Math.round(60000001f / mspq);
              println("Tempo: " + tempo);
            }
          } else if (e.getMessage() instanceof SysexMessage) {     
          }
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
    if (msg instanceof ShortMessage) {
      ShortMessage sm = (ShortMessage) msg;
      if(isNoteMessage(sm)) {
        int channel = sm.getChannel();
        MidiNote note = new MidiNote(sm, timeStamp);
        note.print();
      } else {
        println("Command:" + sm.getCommand());
      }
    }
  }

  private void printMidiInfo(Sequence s){
    println("Division type: " + s.getDivisionType());
    println("Duration (microsec): " + s.getMicrosecondLength());
    println("Resolution (PPQ if division = " + s.PPQ + "): " + s.getResolution());
    println("Ticks per 4/4 measure: " + (4 * s.getResolution()));
    println("Duration (ticks length): " + s.getTickLength());
    println("Anal BPM: " + this.analyzer.getBPM());
    println("Anal Quarter note duration (ms): " + this.analyzer.getQuarterNoteDurationMs());
    println("Anal Tick duration (ms): " + this.analyzer.getTickMs());  
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
import javax.sound.midi.Sequence;

public class MidiSequenceAnalyzer {
    private double bpm;
    private long quarterNoteDurationMs;
    private float tickMs;

    public MidiSequenceAnalyzer() {}
    public MidiSequenceAnalyzer(Sequence sequence) {
        this.analyze(sequence);
    }

    // Method to analyze the sequence and calculate BPM and quarter note duration
    public void analyze(Sequence sequence) {
        this.bpm = calculateBPM(sequence);
        this.quarterNoteDurationMs = calculateQuarterNoteDurationMs(sequence, bpm);
        this.tickMs = calculateTickLength(sequence);
    }

    // Method to calculate BPM (Beats Per Minute)
    private double calculateBPM(Sequence sequence) {
        double microsecondsPerQuarterNote = sequence.getMicrosecondLength();
        double t = 60000000 / microsecondsPerQuarterNote;
        return 600 * t; // 60,000,000 microseconds in a minute
    }

        // Method to calculate BPM (Beats Per Minute)
    private float calculateTickLength(Sequence sequence) {
        double microseconds = sequence.getMicrosecondLength();
        double ticks = sequence.getTickLength();
        this.tickMs = (float) (microseconds / ticks);
        return this.tickMs; // 60,000,000 microseconds in a minute
    }

    // Method to calculate the duration of a quarter note in milliseconds
    private long calculateQuarterNoteDurationMs(Sequence sequence, double bpm) {
        // Assuming 4/4 time signature, one quarter note lasts for one beat
        double secondsPerQuarterNote = 60 / bpm; // 60 seconds in a minute
        return (long) (secondsPerQuarterNote * 1000); // Convert seconds to milliseconds
    }

    // Getter for BPM
    public double getBPM() {
        return bpm;
    }

    // Getter for tick duration in milliseconds
    public float getTickMs() {
        return tickMs;
    } 

    // Getter for quarter note duration in milliseconds
    public long getQuarterNoteDurationMs() {
        return quarterNoteDurationMs;
    }
}
