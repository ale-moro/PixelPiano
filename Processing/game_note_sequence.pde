public class GameNoteSequence {
    // midiSequence is the Sequence object of midi events from javax.sound.midi 
    private Sequence midiSequence;
    private ArrayList<GameNote> sequence;

    public GameNoteSequence(Sequence midiSequence) {
        this.midiSequence = midiSequence;
        this.sequence = createFromMidiSequence(midiSequence);
    }

    public GameNoteSequence() {
        try {
            this.midiSequence = new Sequence(Sequence.PPQ, 4); // javax.sound.midi.Sequence
        } catch (Exception e) {
            e.printStackTrace();
        }
        this.sequence = new ArrayList<GameNote>(); // ArrayList<GameNote>
        this.sequence.add(new GameNote());
    }

    // Create GameNote objects from MIDI sequence
    public ArrayList<GameNote> createFromMidiSequence(Sequence midiSequence) {
        this.midiSequence = midiSequence; // javax.sound.midi.Sequence

        MidiSequenceAnalyzer analyzer = new MidiSequenceAnalyzer(midiSequence);
        this.sequence = new ArrayList<GameNote>(); // ArrayList<GameNote>
        Track[] tracks = midiSequence.getTracks();
        for (Track track : tracks) {
            for (int i = 0; i < track.size(); i++) {
                MidiEvent event = track.get(i);
                MidiMessage message = event.getMessage();
                if (message instanceof ShortMessage) {
                    ShortMessage sm = (ShortMessage) message;
                    int note = sm.getData1();
                    int velocity = sm.getData2();
                    long timestamp = event.getTick();
                    GameNote gameNote = new GameNote(note, timestamp, analyzer.getTickMs(), velocity);
                    if (sm.getCommand() == ShortMessage.NOTE_ON && velocity != 0) {
                        // Find the duration of the note - look for the noteOff event
                        for (int j = i + 1; j < track.size(); j++) {
                            MidiEvent nextEvent = track.get(j);
                            MidiMessage nextMessage = nextEvent.getMessage();
                            if (nextMessage instanceof ShortMessage) {
                                ShortMessage nextSM = (ShortMessage) nextMessage;
                                int nextNote = nextSM.getData1();
                                if (nextSM.getCommand() == ShortMessage.NOTE_OFF && nextNote == note) {
                                    long duration = nextEvent.getTick() - event.getTick();
                                    gameNote.setTicksDuration(duration);
                                    gameNote.setDurationMs(Math.round(duration * analyzer.getTickMs()));
                                    break;
                                }
                            }
                        }
                        this.sequence.add(gameNote);
                    }
                }
            }
        }
        return this.sequence;
    }

    // Getters and setters for sequence
    public ArrayList<GameNote> getSequence() {
        return this.sequence; 
    }

    // midiSequence is the Sequence object of midi events from javax.sound.midi 
    public Sequence getMidiSequence() {
        return this.midiSequence; // javax.sound.midi.Sequence
    }

    public int getSize() {
        return this.sequence.size();
    }

    public int size() {
        return this.sequence.size();
    }

    public GameNote get(int index) {
        return sequence.get(index);
    }

    public void add(GameNote gameNote) {
        sequence.add(gameNote);
    }
}