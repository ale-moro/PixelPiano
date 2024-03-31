import javax.sound.midi.*;

void MIDIfileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    midiLoaderSelectedMIDIFilePath = selection.getAbsolutePath();
  }
}

public class MidiLoader {
  private Sequence midiSequence;
  private GameNoteSequence gameNoteSequence;
  private String midiFilePath;
  private File midiFile;

  // MidiSequence info  
  private MidiSequenceAnalyzer analyzer;
  private float divisionType;
  private long microsecondLength;
  private int resolution;
  private int numTracks;

  public MidiLoader(){
    this.midiSequence = null;
    this.gameNoteSequence = new GameNoteSequence();
    this.midiFilePath = midiLoaderSelectedMIDIFilePath;
    this.midiFile = null;
    this.analyzer = new MidiSequenceAnalyzer();

    // MidiSequence info  
    this.divisionType = 0;
    this.microsecondLength = 0;
    this.resolution = 0;
    this.numTracks = 0;
  }
  
  // ============================================= computeGameNoteSequence =============================================
  // GameNoteSequence from a file
  public GameNoteSequence computeGameNoteSequence(){
    this.midiFilePath = midiLoaderSelectedMIDIFilePath;
    println("computeGameNoteSequence - Selected MIDI file: " + this.midiFilePath);
    if(this.midiFilePath == "") {
      throw new RuntimeException("No MIDI file path provided. Use setFilePath() method before calling computeGameNoteSequence().");
    }
    Sequence s = getMidiSequence(this.midiFilePath);
    this.gameNoteSequence = new GameNoteSequence(s);
    println("computeGameNoteSequence - GameNoteSequence computed. len: " + this.gameNoteSequence.getSequence().size() + " notes.");
    return this.gameNoteSequence;
  }

  // GameNoteSequence from a file
  public GameNoteSequence computeGameNoteSequence(String midiFilePath){
    println("computeGameNoteSequence - Selected MIDI file: " + this.midiFilePath);
    Sequence s = getMidiSequence(this.midiFilePath);
    this.gameNoteSequence = new GameNoteSequence(s);
    return this.gameNoteSequence;
  }

  // GameNoteSequence from a Sequence
  public GameNoteSequence computeGameNoteSequence(Sequence s){
    this.gameNoteSequence = new GameNoteSequence(s);
    return this.gameNoteSequence;
  }
  // =======================================================================================

  public void setFilePath(String path) {
      this.midiFilePath = path;
  }
  public String setMidiFilePath() {
    selectInput("Select a MIDI file:", "MIDIfileSelected");
    this.midiFilePath = midiLoaderSelectedMIDIFilePath; 
    return this.midiFilePath;
  }

  public void setMidiFilePath(String path) {
    midiLoaderSelectedMIDIFilePath = path;
    this.midiFilePath = path;
  }

  public String getMidiFilePath() {
    return this.midiFilePath;
  } 

  private void extractMidiInfo(Sequence s){
    this.divisionType = s.getDivisionType();
    this.microsecondLength = s.getMicrosecondLength();
    this.resolution = s.getResolution();
    this.numTracks = s.getTracks().length;
    this.analyzer.analyze(s);
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
  
  Sequence getMidiSequence(){
    return this.midiSequence;
  }

  Sequence getMidiSequence(String midiFilePath){
    this.midiFilePath = midiFilePath;
    this.midiFile = new File(this.midiFilePath);
    try {
      this.midiSequence = MidiSystem.getSequence(this.midiFile);
    } catch(Exception e) {
        println("Error: " + e); 
    } 
    return this.midiSequence;
  }

  // ============================================= PRINTING METHODS =============================================

    public void printMidiFileInfo(String midiFilePath){
    Sequence s = getMidiSequence(this.midiFilePath);
    // print Sequence info
    printMidiInfo(s);
    extractMidiInfo(s);

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
  // =======================================================================================
}