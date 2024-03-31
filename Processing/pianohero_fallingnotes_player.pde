class FallingNotesPlayer {
    GameNoteSequence noteSequence;
    boolean isPlaying; 
    ArrayList<FallingNote> fallingNotes;
    int index = 0;
    float speed = 3;
    PlayPagePiano keyboard;
    int[] blackKeys = {1,3,6,8,10,13,15,18,20,22,25,27,30,32,34};
    long startTime = 0;
    float keyWidth;
    float margin;

    // ================================ Constructor ================================
    FallingNotesPlayer(GameNoteSequence noteSequence, PlayPagePiano keyboard, float margin) {
        this.noteSequence = noteSequence;
        this.isPlaying = true;
        this.fallingNotes = new ArrayList<FallingNote>();
        this.keyboard = keyboard;
        this.margin = width / 10;
    }
    // =============================================================================
    public void loadNoteSequence(GameNoteSequence noteSequence) {
        this.noteSequence = noteSequence;
        this.isPlaying = false;
        this.index = 0;
        for (int i = 0; i < 30; ++i) {
            println("i: " + i + " | code: " +
                    noteSequence.get(i).getCode() + " | duration: " + 
                    noteSequence.get(i).getDurationMs() + " | timestamp: " + 
                    noteSequence.get(i).getTimestampMs()
                    );
        }
    }

    public boolean startStop() {
        this.isPlaying = !this.isPlaying;
        this.startTime = millis();
        return this.isPlaying;
    }

    public void draw() {
        if (this.isPlaying) {
            FallingNote note;
            println("millis: " + (millis() - this.startTime));

            if (index < this.noteSequence.size() && (millis() - this.startTime) > this.noteSequence.get(index).getTimestampMs()){
                int noteNumber = (int) this.noteSequence.get(index).getCode() % 36;
                note = new FallingNote(
                    this.keyboard.getCoord(noteNumber),
                    -this.noteSequence.get(index).getDurationMs()/30*this.speed,
                    defineKey(noteNumber),
                    this.noteSequence.get(index).getDurationMs()/30*this.speed,
                    this.speed
                );
                this.fallingNotes.add(note);
                this.index++;
            }

            for (int i = this.fallingNotes.size()-1; i >= 0; i--) {
                note = this.fallingNotes.get(i);
                note.update();
                note.draw();
                if (note.isOffScreen()) {
                    this.fallingNotes.remove(i);
                }
            }
        }
    }

    private float defineKey(int inx){
        if(Arrays.binarySearch(blackKeys, inx )>=0){ 
            keyWidth = ((width - margin) / 21) / 1.5;
        } else {
            keyWidth = (width - margin) / 21;
        }
    return keyWidth;
  }
}