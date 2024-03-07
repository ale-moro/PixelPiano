class ModeSelectionPage implements Page {
  int pageIndex = MODE_SELECTION_PAGE_INDEX;
  Button freePlayButton;
  Button pianoHeroButton;
  boolean isVisible;


  public ModeSelectionPage() {
    this.isVisible = false;
    
    // Create and customize "Free Play" button
    this.freePlayButton = cp5.addButton("freePlay")
       .setPosition(width/2 - 100, height/2 - 50)
       .setSize(200, 50)
       .setColorBackground(color(0))
       .setColorForeground(color(50))
       .setVisible(this.isVisible)
       .setColorActive(color(50));
    this.freePlayButton.setLabel("Free Play");
    this.freePlayButton.getCaptionLabel().setFont(customFont);
    
    // Create and customize "Piano Hero" button
    this.pianoHeroButton = cp5.addButton("pianoHero")
       .setPosition(width/2 - 100, height/2 + 50)
       .setSize(200, 50)
       .setColorBackground(color(0))
       .setColorForeground(color(50))
       .setVisible(this.isVisible)
       .setColorActive(color(50));
    this.pianoHeroButton.setLabel("Piano Hero");
    this.pianoHeroButton.getCaptionLabel().setFont(customFont);

    this.addListeners();
  }

  public int getID(){
    return this.pageIndex;
  }

  public void addListeners(){
    this.freePlayButton.addListener(buttonClickListener);
    this.pianoHeroButton.addListener(buttonClickListener);
  }

  public void removeListeners(){
    this.freePlayButton.removeListener(buttonClickListener);
    this.pianoHeroButton.removeListener(buttonClickListener);
  }

  public void setVisibility(boolean isVisible) {
    this.isVisible = isVisible;
    this.freePlayButton.setVisible(this.isVisible);
    this.pianoHeroButton.setVisible(this.isVisible);
  }

  public void draw(){
  }
}
    
    