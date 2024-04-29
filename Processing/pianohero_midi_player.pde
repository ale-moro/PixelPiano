class MidiPlayer {
    Sequencer sequencer;
    Sequence sequence;

    public MidiPlayer(){
      try {
        this.sequence = new Sequence(Sequence.PPQ, 4);
  
        this.sequencer = MidiSystem.getSequencer();
        sequencer.open();
       } catch (Exception e) {
            e.printStackTrace();
        }
      }

    public void load(String midiFilePath){
        try {
            File midiFile = new File(dataPath(midiFilePath));
            this.sequence = MidiSystem.getSequence(midiFile);
            this.sequencer.setSequence(sequence);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void load(Sequence midiSequence){
        try {
            this.sequence = midiSequence;
            this.sequencer.setSequence(sequence);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void start(){
        try {
            this.sequencer.start();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void stop(){
        try {
          this.sequencer.stop();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
