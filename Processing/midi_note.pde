public class MidiNote {

    private final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};

    private String name;
    private int key;
    private int octave;
    private int velocity;
    private boolean noteOn;
    private long timeStamp;

    public MidiNote(int key, boolean noteOn, long timeStamp, int velocity) {
        this.timeStamp = timeStamp;  
        this.key = key;
        this.noteOn = noteOn;  
        this.octave = (key / 12)-1;
        int note = key % 12;
        this.name = NOTE_NAMES[note];
        this.velocity = velocity;
    }

    public MidiNote(ShortMessage sm, long timeStamp) {
        this.timeStamp = timeStamp;  
        this.key = sm.getData1();;
        this.noteOn = sm.getCommand() == ShortMessage.NOTE_ON;
        this.octave = (key / 12)-1;
        int note = key % 12;
        this.name = NOTE_NAMES[note];
        this.velocity = sm.getData2();
    }

    @Override
    public boolean equals(Object obj) {
        return obj instanceof MidiNote && this.key == ((MidiNote) obj).key;
    }

    @Override
    public String toString() {
        return "Note -> " + this.name + this.octave + " | key=" + this.key +  (this.noteOn? " | NoteOn": " | NoteOff" ) + " | timeStamp=" + this.timeStamp;
    }

    public void print() {
        System.out.println(this.toString());
    }
    
    public void print(String prefix) {
        System.out.println(prefix + this.toString());
    }
}