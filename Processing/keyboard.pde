public abstract class Piano {
  int[] whiteKeys = {0,2,4,5,7,9,11,12,14,16,17,19,21,23,24,26,28,29,31,33,35};
  int[] blackKeys = {1,3,6,8,10,13,15,18,20,22,25,27,30,32,34};
  int[] blackKeysInit = {1,2,4,5,6,8,9,11,12,13};
  String[] whiteNotes = {"C", "D", "E", "F", "G", "A", "B"};
  int pianoHeight = 0;

  public Piano(){
    this.pianoHeight = height/3;
  }

  public abstract void draw();


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
        text(noteLabel, keyX + keyWidth / 2, height - this.pianoHeight*0.35);
      } 
    }
  }

  public void drawBox(){
    // Box
    float boxHeight = height / 3;
    float boxWidth = width*0.58 ;
    float boxX = width / 20;
    float boxY = height / 4 -  width/10;
    
    fill(255);
    rect(boxX, boxY, boxWidth, boxHeight, 10);
    fill(255);
    rect(3*boxX/2 + boxWidth , boxY, boxWidth/2, boxHeight,10);
    
    // Mini boxes
  
    // fader
    fill(0);
    rect(width*28/60 - 20, height*5/30 - 5, 100,175,10);
    fill(0, 200);
    rect(width*28/60 - 15, height*5/30, 100, 175, 10); 
    
    // knob
    //fill(0, 200,0,1);
    //ellipse(width*11/60 +85, height*5/30 +85, 160, 160);
    
    // expert/beginner
    fill(0);
    rect(3*width/5 + width/8 + 30 ,height*5/30 -20, 130,70,10);
    fill(0, 200);
    rect(3*width/5 + width/8 + 35, height*5/30 -15, 130, 70, 10);
    
    // octaves
    fill(0);
    rect(3*width/5 + width/8 + 105,height*5/30 + 105, 70,70,10);
    fill(0, 200);
    rect(3*width/5 + width/8 + 110,height*5/30 + 110, 70, 70, 10);
    fill(0);
    rect(3*width/5 + width/8 +15, height*5/30 + 105, 70,70,10);
    fill(0, 200);
    rect(3*width/5 + width/8 +20,height*5/30 + 110, 70, 70, 10);
    
    // back
    fill(0);
    rect(9*width/10, height*9/10 +15, width/15 +10, 50,10);
    fill(0, 200);
    rect(9*width/10 +5, height*9/10 +20, width/15 +10, 50,10);
  }

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
      fill(pastelColors[i]);
      rect(keyX, height - this.pianoHeight, keyWidth, this.pianoHeight, 10);
  
      // Black keys
      if (Arrays.binarySearch(blackKeysInit, i) >= 0) {
        float blackKeyWidth = keyWidth / 1.5;
        float blackKeyHeight = this.pianoHeight / 1.7;
        float blackKeyX = keyX - blackKeyWidth / 2;
  
        // Draw shadow for black keys
        fill(0, 200);
        rect(blackKeyX + 5, height - this.pianoHeight + 5, blackKeyWidth, blackKeyHeight, 10);
        fill(0);
        rect(blackKeyX, height - this.pianoHeight, blackKeyWidth, blackKeyHeight, 10);
      }
    }
  }

}


class PlayPagePiano extends Piano {
  int pianoHeight = 0;
  int[] notes = {};

  public PlayPagePiano(){
    this.pianoHeight = height/3;
  }

  public void setNotes(int[] notes){
    this.notes = notes;
  }

  public void draw(){
    int j = 0;
    int k = 0;
    float margin = width / 10; 

    // White keys
    for (int i = 0; i < 36; i++) {
      float keyWidth = (width - margin) / 21;
      float keyX = width/20  +  j * keyWidth; 

      if(Arrays.binarySearch(whiteKeys,i)>=0){
        j++;
        if (contains(this.notes, i)){
          fill(150);
        } else {
          fill(255);
        }
        rect(keyX, height/2, keyWidth, 2*height/5, 10);
      }
    }
      
    // Black keys
    for(int i = 0; i < 36; i++){
      float keyWidth = (width - margin) / 21;
      float keyX = width/20 + k * keyWidth; 
      
      if(Arrays.binarySearch(whiteKeys,i) >=0) {
        k++;
      } else if(Arrays.binarySearch(blackKeys, i) >= 0){
          float blackKeyWidth = keyWidth / 1.5;
          float blackKeyHeight = this.pianoHeight / 1.5;
          float blackKeyX = keyX - blackKeyWidth / 2;
    
          // Draw shadow for black keys 
          fill(0, 200);
          rect(blackKeyX + 5, height/2 + 5, blackKeyWidth, blackKeyHeight, 10);  
  
          if(contains(this.notes, i)){
            fill(150);
          } else {
            fill(0);
          }
          rect(blackKeyX, height/2, blackKeyWidth, blackKeyHeight, 10);
        }
    } 
  }
}
