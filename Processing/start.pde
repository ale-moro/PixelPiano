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
    float buttonWidth = 150;
    float buttonHeight = 60;
    float buttonX = width / 2 - buttonWidth / 2;
    float buttonY = height / 3 + height / 6 - buttonHeight;
    
    fill(0);
    rect(buttonX -5, buttonY -5, buttonWidth +10, buttonHeight +10, 10);
    
    fill(0,200);
    rect(buttonX, buttonY, buttonWidth +10, buttonHeight +10, 10);

  }

}
