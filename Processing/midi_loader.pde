import javax.sound.midi.*;

public class MidiLoader {
    Sequence sequence;
    String midiFilePath;
    File midiFile;
    

    public MidiLoader(){
        selectInput("Select a MIDI file:", "MIDIfileSelected");

        this.midiFile = new File(this.midiFilePath);
        println("MIDI file: " + this.midiFile.getAbsolutePath());
        try {
            Sequence s = MidiSystem.getSequence(this.midiFile);
            println("Division type: " + s.getDivisionType());
            println("Duration (microsec): " + s.getMicrosecondLength());
            println("Resolution: " + s.getResolution());
            println("Duration (ticks): " + s.getTickLength());
            Track[] tracks = s.getTracks();
            println("Tracks: " + tracks.length);
            for(int i = 0; i < tracks.length; i++) {
                Track t = tracks[i];
                println("  Track " + (i+1));
                println("    Events: " + t.size());
                println("    Duration (ticks): " + t.ticks());
            }
        }
        catch(Exception e) {
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
    //   this.midiLoader.setFilePath(selection.getAbsolutePath());
      this.midiFilePath = selection.getAbsolutePath();

    }
  }
}
