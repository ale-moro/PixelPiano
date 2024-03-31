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
        MidiSequenceAnalyzer analyzer = new MidiSequenceAnalyzer(midiSequence);
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
        return sequence;
    }

    public void setSequence(ArrayList<GameNote> sequence) {
        this.sequence = sequence;
    }

    public int getSize() {
        return sequence.size();
    }

    public GameNote get(int index) {
        return sequence.get(index);
    }

    public void add(GameNote gameNote) {
        sequence.add(gameNote);
    }

    public int size() {
        return sequence.size();
    }
}