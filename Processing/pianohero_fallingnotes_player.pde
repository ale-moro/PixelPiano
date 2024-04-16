class FallingNotesPlayer {
    GameNoteSequence noteSequence;
    boolean isPlaying; 
    ArrayList<FallingNote> fallingNotes;
    int index = 0;
    float speed = 3;
    boolean bw;
    PlayPagePiano keyboard;
    int[] blackKeys = {1,3,6,8,10,13,15,18,20,22,25,27,30,32,34};
    long startTime = 0;
    float keyWidth;
    float margin;
    boolean remove = false;
    int currentTime=0;
    int prevTime=0;
    int diff;
    int pressedSingle;
    int [] pressedNotes = new int[5];

    // ================================ Constructor ================================
    FallingNotesPlayer(GameNoteSequence noteSequence, PlayPagePiano keyboard, float margin) {
        this.noteSequence = noteSequence;
        this.isPlaying = false;
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
        if(this.startTime == 0){
            this.startTime = millis();
        }
        return this.isPlaying;
    }

    public void restart() {
        this.isPlaying = false;
        this.index = 0;
        this.fallingNotes.clear();
        this.loadNoteSequence(this.noteSequence);
        this.startTime = 0; 
    }

    public void draw() {
                prevTime = currentTime;
                currentTime = millis();
                diff = currentTime - prevTime;
                //println(currentTime, prevTime, diff);   
        if (this.isPlaying) {
            FallingNote note;
            // println("millis: " + (millis() - this.startTime));

            if (index < this.noteSequence.size() && (millis() - this.startTime) > this.noteSequence.get(index).getTimestampMs()){
                int noteNumber = (int) this.noteSequence.get(index).getCode() % 36;
                note = new FallingNote(
                    this.keyboard.getCoord(noteNumber),
                    -this.noteSequence.get(index).getDurationMs()/diff*this.speed,
                    defineKey(noteNumber),
                    this.noteSequence.get(index).getDurationMs()/diff*this.speed,
                    this.speed,
                    Arrays.binarySearch(blackKeys, noteNumber )>=0
                );
                
                this.fallingNotes.add(note);
                this.index++;
            }
            for (int i = this.fallingNotes.size()-1; i >= 0; i--) {
                
                note = this.fallingNotes.get(i);
                note.update();
                note.draw();
                pressedNotes = this.keyboard.getNotes();
                
                
                if (note.isOffScreen()) {
                  //println(pressedNotes);
                  for(int j = 0; j< pressedNotes.length; j++){
                    
                    pressedSingle = pressedNotes[j];
                    if(pressedSingle>0){
                      //println(this.keyboard.getCoord(pressedSingle));
                      //println(note.getX());
                      if(this.keyboard.getCoord(pressedSingle) == note.getX()){
                        note.colorChange(this.keyboard.getCoord(pressedSingle) == note.getX());
                        //println("dentro");
                      }
                    }
                  }
          
                  remove = note.updateHeight();
                  if (remove){
                    this.fallingNotes.remove(i);
                  }
                }
            }
        }
    }

    private float defineKey(int inx){
        if(Arrays.binarySearch(blackKeys, inx )>=0){ 
            keyWidth = ((width - margin) / 21) / 1.5;  
            bw = false;
        } else {
            keyWidth = (width - margin) / 21; 
            bw = true;
        }
    return keyWidth;
  }
}
