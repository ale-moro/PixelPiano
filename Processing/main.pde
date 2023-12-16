import java.util.Arrays;
int pianoHeight;
int[] blackKeys = {1, 2, 4, 5, 6, 8, 9, 11, 12, 13};
boolean isPlaying = false;
boolean isMouseOverButton = false;

void setup() {
  fullScreen();
  pianoHeight = height / 3;
}

void draw() {
  background(255);
  drawText();
  drawPiano();
  drawPlayButton();
}

void drawText() {
  fill(0);
  textMode(SHAPE);

  float textX = width / 2;
  float textY1 = height / 6 - 30;
  float textY2 = height / 6 + 50;

  // Usa il font monospaced di Processing
  textFont(createFont("Monospaced", 48));

  // Disegna il titolo "PixelPiano" con ombra
  textSize(60);
  textAlign(CENTER, CENTER);

  // Disegna l'ombra del titolo
  fill(150, 50);
  text("PixelPiano", textX + 3, textY1 + 3);
  fill(0);
  text("PixelPiano", textX, textY1);

  // Disegna la sottotitolo "The Interactive Virtual Piano" con ombra
  textSize(40);
  textAlign(CENTER, CENTER);

  // Disegna l'ombra del sottotitolo
  fill(150, 50);
  text("The Interactive Virtual Piano", textX + 3, textY2 + 3);
  fill(0);
  text("The Interactive Virtual Piano", textX, textY2);

  // Ripristina la modalità di testo in 2D per il disegno successivo
  textMode(MODEL);
}

void drawPiano() {
  for (int i = 0; i < 15; i++) {
    float keyWidth = width / 14;
    float keyX = i * keyWidth;

    // Disegna i tasti bianchi
    fill(255);
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

void drawPlayButton() {
  float buttonWidth = 150;
  float buttonHeight = 60;
  float buttonX = width / 2 - buttonWidth / 2;
  float buttonY = height / 3 + height / 6 - buttonHeight;

  // Verifica se il mouse è sopra il pulsante
  if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    isMouseOverButton = true;
  } else {
    isMouseOverButton = false;
  }

  // Cambia il colore del pulsante in base allo stato del mouse
  if (isMouseOverButton) {
    fill(200);  // Colore quando il mouse è sopra il pulsante
  } else {
    fill(255);  // Colore normale del pulsante
  }

  rect(buttonX, buttonY, buttonWidth, buttonHeight, 10);

  // Disegna il testo "Play" con ombra
  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);

  // Cambia il colore del testo in base allo stato del mouse
  if (isMouseOverButton) {
    fill(100);  // Colore del testo quando il mouse è sopra il pulsante
  } else {
    fill(0);  // Colore normale del testo
  }

  // Disegna l'ombra del testo
  fill(150, 50);
  text("Play", buttonX + 3, buttonY + 3, buttonWidth, buttonHeight);
  fill(0);
  text("Play", buttonX, buttonY, buttonWidth, buttonHeight);
}

void mousePressed() {
  float buttonWidth = 150;
  float buttonHeight = 60;
  float buttonX = width / 2 - buttonWidth / 2;
  float buttonY = height / 3 + height / 6 - buttonHeight / 2;

  // Controlla se il mouse è sopra il pulsante Play
  if (isMouseOverButton) {
    // Cambia il colore del pulsante quando viene premuto
    fill(150);  // Colore del pulsante durante il clic
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 10);
    
    // Esegui azioni aggiuntive in base allo stato di riproduzione (play/pause)
    if (isPlaying) {

    } else {
      // Aggiungi azioni per l'inizio della riproduzione
      println("Play pressed. Start playing.");
      PApplet.main("PlayWindow");
      
    }
  }
}
