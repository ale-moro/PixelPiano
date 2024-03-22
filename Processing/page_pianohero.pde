class PianoHeroPage implements Page {
  int pageIndex = PIANO_HERO_PAGE_INDEX;
  Button backButton;
  Button loadMidiButton;
  float[] backButtonPosition;
  float[] loadMidiButtonPosition;
  float[] inactivePosition;
  ButtonClickListener buttonClickListener;
  MidiLoader midiLoader;

  public PianoHeroPage() {

    this.midiLoader = new MidiLoader("C:\\Users\\Marco Furio Colombo\\Desktop\\PixelPiano\\Processing\\BWV_0578.mid");

    this.buttonClickListener = new ButtonClickListener(this);
    this.backButtonPosition = new float[] {9*width/10 + 5, 9*height/10 +25};
    this.loadMidiButtonPosition = new float[] {5*width/10 + 5, 2*height/10 + 60};
    this.inactivePosition = new float[] {-1000, -1000};

    this.backButton = cp5.addButton("pianoHeroBackButton")
            .setPosition(this.inactivePosition)
            .setSize(width/15,30)
            .setColorBackground(color(0))
            .setColorForeground(color(50))
            .setVisible(true)
            .setColorActive(color(50));
    this.backButton.setLabel("Back");
    this.backButton.getCaptionLabel().setFont(customFont);

    this.loadMidiButton = cp5.addButton("loadMidiButton")
        .setPosition(this.inactivePosition)
        .setSize(width/15,30)
        .setColorBackground(color(0))
        .setColorForeground(color(50))
        .setVisible(true)
        .setColorActive(color(50));
    this.loadMidiButton.setLabel("Load Midi File");
    this.loadMidiButton.getCaptionLabel().setFont(customFont);

    this.addListeners();
  }

  public int getID(){
    return this.pageIndex;
  }

  public void addListeners(){
    this.backButton.addListener(this.buttonClickListener); 
  }
  public void removeListeners(){}

  public void setVisibility(boolean isVisible){
    if(isVisible){
      this.backButton.setPosition(this.backButtonPosition);
    } else {
      this.backButton.setPosition(this.inactivePosition);
    } 
  }

  public void handleButtonClick(ControlEvent event) {
    if (!event.isController()) return;
    String buttonName = event.getController().getName();
    
    if ("pianoHeroBackButton".equals(buttonName)) {
      navigationController.changePage(activePage, modeSelectionPage);
    }
    if ("loadMidiButton".equals(buttonName)) {
      this.midiLoader.loadMidi();
    }
  }

 public void draw() {
  }
}
    
    