public class GameNoteSequence {
    private ArrayList<GameNote> sequence;

    public GameNoteSequence(Sequence sequence) {
        this.sequence = createFromMidiSequence(sequence);
    }

    public GameNoteSequence() {
        this.sequence = new ArrayList<GameNote>();
        this.sequence.add(new GameNote());
    }

    // Create GameNote objects from MIDI sequence
    public ArrayList<GameNote> createFromMidiSequence(Sequence midiSequence) {
        // TODO - WIP - need to figure out how to get the correct note durations
        this.sequence = new ArrayList<GameNote>();
        Track[] tracks = midiSequence.getTracks();
        for (Track track : tracks) {
            for (int i = 0; i < track.size(); i++) {
                MidiEvent event = track.get(i);
                MidiMessage message = event.getMessage();
                if (message instanceof ShortMessage) {
                    ShortMessage sm = (ShortMessage) message;
                    int note = sm.getData1();
                    int velocity = sm.getData2();
                    if (sm.getCommand() == ShortMessage.NOTE_ON && velocity != 0) {
                        long timestamp = event.getTick();
                        GameNote gameNote = new GameNote(note, velocity, timestamp);
                        this.sequence.add(gameNote);
                    }
                }
            }
        }
        return this.sequence;
    }

    // Getters and setters for sequence
    public ArrayList<GameNote> getSequence() {
        return sequence;
    }

    public void setSequence(ArrayList<GameNote> sequence) {
        this.sequence = sequence;
    }

    // Getters and setters for sequence and track
    public ArrayList<GameNote> getSequence() {
        return sequence;
    }

    public void setSequence(ArrayList<GameNote> sequence) {
        this.sequence = sequence;
    }
}