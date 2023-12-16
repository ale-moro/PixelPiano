class Start{

    public void drawText() {
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



  public void drawPlayButton() {
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

}
