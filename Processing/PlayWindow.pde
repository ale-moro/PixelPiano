import java.util.Arrays;

public class PlayWindow extends PApplet {
  int pianoHeight;  // Dichiarare il campo pianoHeight
  
  void setup() {
    fullScreen();
    pianoHeight = height / 3;
  }
  
  void draw() {
    background(255);
    drawPiano();
  }
  
  void drawPiano() {
    for (int i = 0; i < 15; i++) {
      float keyWidth = width / 14;
      float keyX = i * keyWidth;
  
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
