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
    int tot_notes;
    int correct_notes = 0;
    boolean temp = false;
    int pressedSingle;
    int [] pressedNotes = new int[5];
    MidiPlayer midiPlayer;
    boolean midi_player_paused;
    


    // ================================ Constructor ================================
    FallingNotesPlayer(GameNoteSequence noteSequence, PlayPagePiano keyboard, float margin) {
        this.noteSequence = noteSequence;
        this.isPlaying = false;
        this.fallingNotes = new ArrayList<FallingNote>();
        this.keyboard = keyboard;
        this.margin = width / 10;
        this.midiPlayer = new MidiPlayer();
        this.midi_player_paused = true;
    }

    // =============================================================================
    public void loadNoteSequence(GameNoteSequence noteSequence) {
        this.noteSequence = noteSequence;
        this.isPlaying = false;
        this.index = 0;
        this.fallingNotes.clear();
        for (int i = 0; i < 30; ++i) {
            // println("i: " + i + " | code: " +
            //         noteSequence.get(i).getCode() + " | duration: " + 
            //         noteSequence.get(i).getDurationMs() + " | timestamp: " + 
            //         noteSequence.get(i).getTimestampMs()
            //         );
            noteSanityCheck(noteSequence.get(i));
        }
        midiPlayer.load(noteSequence.getMidiSequence());
        this.startTime = 0; 
    }

    public boolean start(){
        this.isPlaying = true;
        if(this.startTime == 0){
            this.startTime = millis();
        }
        return this.isPlaying;  
    }

    public boolean stop(){
        this.isPlaying = false;
        this.midi_player_paused = true;
        this.midiPlayer.stop();
        return this.isPlaying;
    }

    // loads the brand new midi seuqence - but doesn't actually start the game
    // resets the internal clock to zero, so that it will be initialized correctly when the game starts
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

            // create notes (above out of the screen)
            if (index < this.noteSequence.size() && (millis() - this.startTime) > this.noteSequence.get(index).getTimestampMs()){
                int noteNumber = (int) this.noteSequence.get(index).getCode() % 36;
                note = new FallingNote(
                    this.keyboard.getCoord(noteNumber),
                    -this.noteSequence.get(index).getDurationMs()/diff*this.speed,
                    defineKey(noteNumber),
                    this.noteSequence.get(index).getDurationMs()/diff*this.speed,
                    this.speed,
                    Arrays.binarySearch(blackKeys, noteNumber) >= 0
                );
                
                this.fallingNotes.add(note);
                this.index++;
            }

            // update notes and (make them come down) 
            for (int i = this.fallingNotes.size()-1; i >= 0; i--) {
                note = this.fallingNotes.get(i);
                note.update();
                note.draw();
                pressedNotes = this.keyboard.getNotes();
                
                if (note.isOffScreen()) {
                    if(this.midi_player_paused == true){
                      this.midi_player_paused = false;
                      this.midiPlayer.start();
                    }
                    pressedNotes = this.keyboard.getNotes();
                    for(int j = 0; j < pressedNotes.length; j++){
                      
                        pressedSingle = pressedNotes[j];
                        if(pressedSingle > 0){
                            //println(this.keyboard.getCoord(pressedSingle));
                            //println(note.getX());
                            if(this.keyboard.getCoord(pressedSingle) == note.getX()){
                              if(temp != (this.keyboard.getCoord(pressedSingle) == note.getX())){
                                correct_notes += 1;
                                score = computeScore(correct_notes);
                                temp = this.keyboard.getCoord(pressedSingle) == note.getX();
                              }
                                
                                note.colorChange(this.keyboard.getCoord(pressedSingle) == note.getX());
                               
                                break;
                            } else {
                                if(temp != (this.keyboard.getCoord(pressedSingle) == note.getX())){                       
                                  temp = this.keyboard.getCoord(pressedSingle) == note.getX();
                                }
                                note.colorChange(this.keyboard.getCoord(pressedSingle) == note.getX());
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
    
    private float computeScore(int correct){
    
       tot_notes = this.noteSequence.getSequence().size();   
       return (float)correct/tot_notes*100;
       
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

    private void noteSanityCheck(GameNote note){
        try {
            if (note.getDurationMs() < 1) {
                throw new Exception("Midi Note duration is less than 1ms");
            }
            if (note.getTimestampMs() < 0) {
                throw new Exception("Midi Note timestamp is less than 0ms");
            }
            if (note.getCode() < 0 || note.getCode() > 127) {
                throw new Exception("Midi Note code is out of bounds [0-127]: " + note.getCode());
            }
        } catch (Exception e) {
            println(e);
        }
    }
}
