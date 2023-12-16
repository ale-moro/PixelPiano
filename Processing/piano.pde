class Piano{
  

  
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

    float margin = width / 6; // Set margin to 1/6 of the width

    // Disegna il bordo nero attorno al piano
    fill(0);
    rect(margin, height/2, width - 2 * margin, pianoHeight, 10);
  
    for (int i = 0; i < 14; i++) {
      float keyWidth = (width - 2 * margin) / 14; // Adjust keyWidth based on margins
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

}
