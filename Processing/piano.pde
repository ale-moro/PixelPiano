class Piano{
  
  String[] whiteNotes = {"C", "D", "E", "F", "G", "A", "B"};
  
  public void drawPianoInit() {
    
    for (int i = 0; i < 15; i++) {
      float keyWidth = width / 14;
      float keyX = i * keyWidth;
  
      // White keys
      fill(pastelColors[i]);
      rect(keyX, height - pianoHeight, keyWidth, pianoHeight, 10);
  
      // Black keys
      if (Arrays.binarySearch(blackKeysInit, i) >= 0) {
        float blackKeyWidth = keyWidth / 1.5;
        float blackKeyHeight = pianoHeight / 1.7;
        float blackKeyX = keyX - blackKeyWidth / 2;
  
        // Draw shadow for black keys
        fill(0, 200);
        rect(blackKeyX + 5, height - pianoHeight + 5, blackKeyWidth, blackKeyHeight, 10);
        fill(0);
        rect(blackKeyX, height - pianoHeight, blackKeyWidth, blackKeyHeight, 10);
      }
    }
  }
  
  public void drawPianoPlay(int[] notes) {
    int j= 0;
    int k = 0;
    float margin = width / 10; 
    
    // White keys
    for (int i = 0; i < 36; i++) {
      float keyWidth = (width - 2 * margin) / 21;
      float keyX = margin + j * keyWidth; 
      
      if(Arrays.binarySearch(whiteKeys,i)>=0){
        j++;
        
        if(Arrays.binarySearch(notes,i) >= 0 && notes[0]!=0){
          fill(150);
        }else{
          fill(255);
        }
        
        rect(keyX, height/2, keyWidth, pianoHeight, 10);
      }
    }
      
      // Black keys
      for(int i = 0; i < 36; i++){
        float keyWidth = (width - 2 * margin) / 21;
        float keyX = margin + k * keyWidth; 
        
        if(Arrays.binarySearch(whiteKeys,i) >=0){
          k++;
        }else if (Arrays.binarySearch(blackKeys, i) >= 0) {
            float blackKeyWidth = keyWidth / 1.5;
            float blackKeyHeight = pianoHeight / 1.7;
            float blackKeyX = keyX - blackKeyWidth / 2;
      
            // Draw shadow for black keys 
            fill(0, 200);
            rect(blackKeyX + 5, height/2 + 5, blackKeyWidth, blackKeyHeight, 10);  
    
            if(Arrays.binarySearch(notes,i) >= 0){
              fill(150);
            }else{
              fill(0);
            }
            rect(blackKeyX, height/2, blackKeyWidth, blackKeyHeight, 10);
          }
        }
  }
  
  
  public void writeNoteLabels(int[] octaves, int flag) {
    float margin = width / 10;  // Set margin to 1/10 of the width
    float keyWidth = (width - 2 * margin) / 21;  // Adjust keyWidth based on margins
    int j=0;
    
    if(flag == 0){
      for (int i = 0; i < 21; i++) {
        float keyX = margin + i * keyWidth; 
    
        // Notes visualization
        fill(100);
        textAlign(CENTER, CENTER);
        textSize(16);
        if (i < 7) {
          j = 0;
        } else if (i < 14) {
          j = 1;
        } else {
          j = 2;
        }
          
        String noteLabel = whiteNotes[i % 7] + str(octaves[j]);
        text(noteLabel, keyX + keyWidth / 2, height - pianoHeight / 2 - 15);
    
      }
    }else{
        for (int i = 0; i < 21; i++) {
          float keyX = margin + i * keyWidth; 
        
          // Note visualization only for C
          if (i % 7 == 0) {
            fill(100);
            textAlign(CENTER, CENTER);
            textSize(16);
            
            if (i < 7) {
              j = 0;
            } else if (i < 14) {
              j = 1;
            } else {
              j = 2;
            }
              
            String noteLabel = whiteNotes[i % 7] + str(octaves[j]);
            text(noteLabel, keyX + keyWidth / 2, height - pianoHeight / 2 - 15);
          } 
       }
    }
  }

  public void drawBox(){
    
    // Box
    float boxHeight = height / 3;
    float boxWidth = width / 2 ;
    float boxX = width / 10;
    float boxY = height / 4 -  boxX;
    
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
    fill(0, 200);
    ellipse(width*11/60 +85, height*5/30 +85, 160, 160);
    
    // expert/beginner
    fill(0);
    rect(3*width/5 + width/8 + 10 ,height*5/30 -20, 130,70,10);
    fill(0, 200);
    rect(3*width/5 + width/8 + 15, height*5/30 -15, 130, 70, 10);
    
    // octaves
    fill(0);
    rect(3*width/5 + width/8 + 85,height*5/30 + 105, 70,70,10);
    fill(0, 200);
    rect(3*width/5 + width/8 + 90,height*5/30 + 110, 70, 70, 10);
    
    fill(0);
    rect(3*width/5 + width/8 - 5, height*5/30 + 105, 70,70,10);
    fill(0, 200);
    rect(3*width/5 + width/8,height*5/30 + 110, 70, 70, 10);
    
    // back
    fill(0);
    rect(9*width/10, height*9/10 -5, width/15 +10, 50,10);
    fill(0, 200);
    rect(9*width/10 +5, height*9/10, width/15 +10, 50,10);
    
  }
 

}
