public abstract class Piano {
  int[] whiteKeys = {0,2,4,5,7,9,11,12,14,16,17,19,21,23,24,26,28,29,31,33,35};
  int[] blackKeys = {1,3,6,8,10,13,15,18,20,22,25,27,30,32,34};
  int[] blackKeysInit = {1,2,4,5,6,8,9,11,12,13};
  String[] whiteNotes = {"C", "D", "E", "F", "G", "A", "B"};
  int pianoHeight = 0;
  float[] coordX = new float[36];

  public Piano(){
    this.pianoHeight = height/3;
  }

  public abstract void draw();

  public boolean contains(int[] array, int key) {
    for (int value : array) {
      if (value == key) {
        return true;
      }
    }
    return false;
  }

}

class InitPagePiano extends Piano {
  int pianoHeight = 0;

  public InitPagePiano(){
    this.pianoHeight = height/3;
  }

  public void draw() {
    for (int i = 0; i < 15; i++) {
      float keyWidth = width / 14;
      float keyX = i * keyWidth;

      // White keys
      stroke(255);
      fill(pastelColors[i]);
      rect(keyX, height - this.pianoHeight, keyWidth, this.pianoHeight, 10);
  
      // Black keys
      if (Arrays.binarySearch(blackKeysInit, i) >= 0) {
        float blackKeyWidth = keyWidth / 1.5;
        float blackKeyHeight = this.pianoHeight / 1.7;
        float blackKeyX = keyX - blackKeyWidth / 2;
  
        // Draw shadow for black keys
        fill(0, 200);
        stroke(0);
        rect(blackKeyX + 5, height - this.pianoHeight + 5, blackKeyWidth, blackKeyHeight, 10);
        fill(0);
        stroke(200);
        rect(blackKeyX, height - this.pianoHeight, blackKeyWidth, blackKeyHeight, 10);
      }
    }
  }
}


class PlayPagePiano extends Piano {
  float pianoX = 0;
  float pianoY = 0;
  float marginX = 0;
  float whiteKeyWidth = 0;
  float blackKeyWidth = 0; 
  float whiteKeyHeight = 0;
  float blackKeyHeight = 0;
  
  int[] notes = {-1,-1,-1,-1,-1};

  public PlayPagePiano() {
    this.pianoHeight = 2*height / 5;
    this.pianoX = width / 20;
    this.pianoY = height / 2;
    this.marginX = width / 10;
    this.whiteKeyWidth = (width - this.marginX) / 21;
    this.blackKeyWidth = (width - this.marginX) / (21*1.5);
    this.whiteKeyHeight = this.pianoHeight;
    this.blackKeyHeight = this.pianoHeight / 1.75;
  }


  public void draw(){
    int j = 0;
    int k = 0;

    // White keys
    for (int i = 0; i < 36; i++) {
      float keyX = this.pianoX + j * this.whiteKeyWidth; 

      if(Arrays.binarySearch(whiteKeys,i)>=0){
        Coord(i, keyX);
        j++;
        if (contains(this.notes, i)){
          fill(150);
        } else {
          fill(255);
        }
        stroke(0);
        rect(keyX, this.pianoY, this.whiteKeyWidth, this.whiteKeyHeight, 10);
      }
    }
      
    // Black keys
    for(int i = 0; i < 36; i++){
      float keyX = width/20 + k * this.whiteKeyWidth; 
      
      if(Arrays.binarySearch(whiteKeys,i) >=0) {
        k++;
      } else if(Arrays.binarySearch(blackKeys, i) >= 0){
          float blackKeyX = keyX - this.blackKeyWidth / 2;
          Coord(i, blackKeyX);
    
          // Draw shadow for black keys 
          fill(0, 200);
          stroke(0);
          rect(blackKeyX + 5, this.pianoY + 5, this.blackKeyWidth, this.blackKeyHeight, 10);  
  
          if(contains(this.notes, i)){
            fill(150);
          } else {
            fill(0);
          }
          stroke(255); // todo: nice or set to stroke(0)?
          rect(blackKeyX, this.pianoY, this.blackKeyWidth, this.blackKeyHeight, 10);
        }
    } 
  }
  public void writeNoteLabels(int[] octaves, int flag) {    
    float margin = width / 10;  // Set margin to 1/10 of the width
    float keyWidth = (width -  margin) / 21;  // Adjust keyWidth based on margins
    
    int j=0;
    for (int i = 0; i < 21; i++) {
      float keyX = width/20 + i * keyWidth; 
      j = min(floor(i / 7), 2);

      // Note visualization only for C
      if (flag == 0 || i % 7 == 0) {
        String noteLabel = whiteNotes[i % 7] + str(octaves[j]);
        fill(100);
        textAlign(CENTER, CENTER);
        textSize(16);
        text(noteLabel, keyX + keyWidth / 2, this.pianoY+this.pianoHeight-23);
      } 
    }
  }

  
  // ================== Getters and Setters ==================
  // Getters  
  public float height() {
    return this.pianoHeight;
  }

  public float width() {
    return this.whiteKeyWidth * this.coordX.length;
  }

  public float getPianoX() {
    return this.pianoX;
  }

  public float getPianoY() {
    return this.pianoY;
  }

  public float getMarginX() {
    return this.marginX;
  }

  public float getWhiteKeyWidth() {
    return this.whiteKeyWidth;
  }

  public float getBlackKeyWidth() {
    return this.blackKeyWidth;
  }

  public float getWhiteKeyHeight() {
    return this.whiteKeyHeight;
  }

  public float getBlackKeyHeight() {
    return this.blackKeyHeight;
  }

  public int[] getNotes() {
    return this.notes;
  }

  public float getCoord(int i) {
    return this.coordX[i];
  }

  public void Coord(int i, float x){
    this.coordX[i] = x;
  }

  // Setters
  public void setNotes(int[] notes) {
    //println(notes);
    //println("a");
    this.notes = notes;
  }
  // =============================================
  
}
