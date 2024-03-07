String START_TITLE = "Press any key to start";

class StartPage implements Page {
  int pageIndex;
  InitPagePiano keyboard;

  public StartPage(){
    keyboard = new InitPagePiano();
  }

  public int getID(){
      return this.pageIndex;
  }

  public void addListeners(){}
  public void removeListeners(){}
  public void setVisibility(boolean isVisible){}
  
  public void draw(){
    drawText();
    drawPlayButton();
    keyboard.draw();
  }

  private void drawText() {
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

  private void drawPlayButton() {
 
    float buttonHeight = 60;
    float buttonY = height / 3 + height / 6 - buttonHeight;

    // Draw shadow
    fill(0);
    textSize(32);
    textAlign(CENTER, CENTER);

  
    // Draw text shadow
    fill(196, 50);
    text(START_TITLE, width/2-250, buttonY+3, 500, buttonHeight);
    fill(128);
    text(START_TITLE, width/2-250, buttonY, 500, buttonHeight);
  }
 
}
