class FallingNotesPlayer {
    GameNoteSequence noteSequence;
    FallingNotes fallingNotes;
    boolean isPlaying; 

    // ================================ Constructor ================================
    FallingNotesPlayer(GameNoteSequence noteSequence, Piano keyboard) {
        this.noteSequence = noteSequence;
        this.isPlaying = false;
    }
    // =============================================================================

    void play() {
        this.isPlaying = true;
    }

    void draw() {
        if (this.isPlaying) {
            if (index < played.size() && millis()/1000 > played.get(index)[2]){
                int noteNumber = (int) played.get(index)[0] % 36;
                FallingNote note = new FallingNote(keyboard.getCoord(noteNumber), -played.get(index)[1]*1000/30*speed, defineKey(noteNumber), played.get(index)[1]*1000/30*speed, speed); //<>//

                fallingNotes.add(note);
                index++;
            }

            for (int i = fallingNotes.size()-1; i >= 0; i--) {
                FallingNote note = fallingNotes.get(i);
                note.update();
                note.draw();
                if (note.isOffScreen()) {
                    fallingNotes.remove(i);
                }
            }
        }
    }





}