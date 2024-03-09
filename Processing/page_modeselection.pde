class ModeSelectionPage implements Page {
  int pageIndex = MODE_SELECTION_PAGE_INDEX;
  Button freePlayButton;
  float[] freePlayButtonPosition;
  Button pianoHeroButton;
  float[] pianoHeroButtonPosition;
  float[] inactivePosition;
  boolean isVisible;
  ButtonClickListener buttonClickListener;

  public ModeSelectionPage() {
    this.isVisible = false;
    this.buttonClickListener = new ButtonClickListener();
    this.pianoHeroButtonPosition = new float[]{width/2 - 100, height/2 + 50};
    this.freePlayButtonPosition = new float[]{width/2 - 100, height/2 - 50};
    this.inactivePosition = new float[] {-1000, -1000};  

    // Create and customize "Free Play" button
    this.freePlayButton = cp5.addButton("freePlayButton")
       .setPosition(this.inactivePosition)
       .setSize(200, 50)
       .setColorBackground(color(0))
       .setColorForeground(color(50))
       .setVisible(true)
       .setColorActive(color(50));
    this.freePlayButton.setLabel("Free Play");
    this.freePlayButton.getCaptionLabel().setFont(customFont);
    
    // Create and customize "Piano Hero" button
    this.pianoHeroButton = cp5.addButton("pianoHeroButton")
       .setPosition(this.inactivePosition)
       .setSize(200, 50)
       .setColorBackground(color(0))
       .setColorForeground(color(50))
       .setVisible(true\)
       .setColorActive(color(50));
    this.pianoHeroButton.setLabel("Piano Hero");
    this.pianoHeroButton.getCaptionLabel().setFont(customFont);
    this.addListeners(); 
  }

  public int getID(){
    return this.pageIndex;
  }

  public void addListeners(){
    println(this, "add listeners");
    this.freePlayButton.addListener(this.buttonClickListener);
    this.pianoHeroButton.addListener(this.buttonClickListener);
  }

  public void removeListeners(){
    this.freePlayButton.removeListener(this.buttonClickListener);
    this.pianoHeroButton.removeListener(this.buttonClickListener);
  }

  public void setVisibility(boolean isVisible) {
    println(this, "set visible:", isVisible);
    this.isVisible = isVisible;
    if (this.isVisible) {
      println(this, "set visible position");
      this.freePlayButton.setPosition(this.freePlayButtonPosition);
      this.pianoHeroButton.setPosition(this.pianoHeroButtonPosition);
    } else {
      this.freePlayButton.setPosition(this.inactivePosition);
      this.pianoHeroButton.setPosition(this.inactivePosition);
    }
    // this.freePlayButton.setVisible(this.isVisible);
    // this.pianoHeroButton.setVisible(this.isVisible);
        
    // this.freePlayButton.setBroadcast(this.isVisible); 
    // this.pianoHeroButton.setBroadcast(this.isVisible);

    // this.freePlayButton.setUpdate(this.isVisible); 
    // this.pianoHeroButton.setUpdate(this.isVisible);

    // this.freePlayButton.setUserInteraction(this.isVisible);
    // this.pianoHeroButton.setUserInteraction(this.isVisible);
  }

  public void draw(){
  }
}
    
    