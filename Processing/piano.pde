class Piano{
  
  String[] whiteNotes = {"C", "D", "E", "F", "G", "A", "B"};
  String[] blackNotes = {"C#", "D#", "F#", "G#", "A#"};


  public void drawPianoInit() {
    
    for (int i = 0; i < 15; i++) {
      float keyWidth = width / 14;
      float keyX = i * keyWidth;
  
      // Disegna i tasti bianchi
      fill(pastelColors[i]);
      rect(keyX, height - pianoHeight, keyWidth, pianoHeight, 10);
  
      // Disegna i tasti neri
      if (Arrays.binarySearch(blackKeys, i) >= 0) {
        float blackKeyWidth = keyWidth / 1.5;
        float blackKeyHeight = pianoHeight / 1.7;
        float blackKeyX = keyX - blackKeyWidth / 2;
  
        // Disegna l'ombra dei tasti neri
        fill(0, 200);
        rect(blackKeyX + 5, height - pianoHeight + 5, blackKeyWidth, blackKeyHeight, 10);  // Ombra
        fill(0);
        rect(blackKeyX, height - pianoHeight, blackKeyWidth, blackKeyHeight, 10);
      }
    }
  }
  
  public void drawPianoPlay() {

    float margin = width / 10; // Set margin to 1/10 of the width

    // Disegna il bordo nero attorno al piano
    //fill(0);
    //rect(margin, height/2, width - 2 * margin, pianoHeight, 10);
  
    for (int i = 0; i < 21; i++) {
      float keyWidth = (width - 2 * margin) / 21; // Adjust keyWidth based on margins
      float keyX = margin + i * keyWidth; // Adjust starting position based on margins
  
      // Disegna i tasti bianchi
      fill(255);
      rect(keyX, height/2, keyWidth, pianoHeight, 10);
  
      // Disegna i tasti neri
      if (Arrays.binarySearch(blackKeys, i) >= 0) {
        float blackKeyWidth = keyWidth / 1.5;
        float blackKeyHeight = pianoHeight / 1.7;
        float blackKeyX = keyX - blackKeyWidth / 2;
  
        // Disegna l'ombra dei tasti neri
        fill(0, 200);
        rect(blackKeyX + 5, height/2 + 5, blackKeyWidth, blackKeyHeight, 10);  // Ombra
        fill(0);
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
    
        // Scrivi la nota sopra il tasto bianco
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
        
          // Scrivi la nota sopra il tasto bianco solo se è C
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
  }
 

}
