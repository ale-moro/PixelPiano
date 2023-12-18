class Start{

    public void drawText() {
    fill(0);
    textMode(SHAPE);
  
    float textX = width / 2;
    float textY1 = height / 6 - 30;
    float textY2 = height / 6 + 50;
  
    textFont(createFont("Monospaced", 48));
  
    // Draw the title
    textSize(60);
    textAlign(CENTER, CENTER);
  
    // Draw the shadow
    fill(150, 50);
    text("PixelPiano", textX + 3, textY1 + 3);
    fill(0);
    text("PixelPiano", textX, textY1);
  
    // Draw the subtitle
    textSize(40);
    textAlign(CENTER, CENTER);
  
    // Draw the subtitle's shadow
    fill(150, 50);
    text("The Interactive Virtual Piano", textX + 3, textY2 + 3);
    fill(0);
    text("The Interactive Virtual Piano", textX, textY2);
  
    // 2D mode
    textMode(MODEL);
  }



  public void drawPlayButton() {
 
    float buttonHeight = 60;
    float buttonY = height / 3 + height / 6 - buttonHeight;

  
    // Draw shadow
    fill(0);
    textSize(32);
    textAlign(CENTER, CENTER);
  
    // Change text color
    if (isMouseOverButton) {
      fill(100);  
    } else {
      fill(0);  
    }
  
    // Draw text shadow
    fill(150, 50);
    text("Click anywhere to start!", width/2-250, buttonY + 3, 500, buttonHeight);
    fill(0);
    text("Click anywhere to start!", width/2-250, buttonY, 500, buttonHeight);
  }
 
}
