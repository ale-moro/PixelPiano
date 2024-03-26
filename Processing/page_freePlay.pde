class PlayPage implements Page {
  int pageIndex = PLAY_PAGE_INDEX;
  boolean isVisible;
  float[] inactivePosition;
  Knob myKnob;
  float[] myKnobPosition;
  boolean beginnerMode;
  Slider myFader;
  float[] myFaderPosition;
  Button octaveUpButton;
  float[] octaveUpButtonPosition;
  Button octaveDownButton;
  float[] octaveDownButtonPosition;
  Button modeButton;
  float[] modeButtonPosition;
  Button backButton;
  float[] backButtonPosition;
  Fingers fingers;
  PlayPagePiano keyboard;
  ButtonClickListener buttonClickListener;

  public PlayPage() {
    this.fingers = new Fingers();
    this.keyboard = new PlayPagePiano();
    this.buttonClickListener = new ButtonClickListener(this);
    this.isVisible = false;
    this.beginnerMode = false;
    
    this.myKnobPosition = new float[] {width*11/60, height*5/30};
    this.myFaderPosition = new float[] {width*28/60 - 10, height*5/30};
    this.octaveUpButtonPosition = new float[] {3*width/5 + width/8 + 110,height*5/30 + 110};
    this.octaveDownButtonPosition = new float[] {3*width/5 + width/8 +20, height*5/30 + 110};
    this.modeButtonPosition = new float[] {3*width/5 + width/8 + 36 ,height*5/30 - 15};
    this.backButtonPosition = new float[] {9*width/10 + 5, 9*height/10 +25};
    this.inactivePosition = new float[] {-1000, -1000};  

    // Knob
    this.myKnob = cp5.addKnob("myKnob")
              .setRange(0, 100)
              .setValue(0) // todo: Mappare valore nel range e settare value
              .setPosition(this.inactivePosition)
              .setRadius(80)
              .setNumberOfTickMarks(10)
              .setColorForeground(color(200))
              .setColorBackground(color(0,0,0,1))
              .setVisible(true)
              .setColorActive(color(200));
    this.myKnob.getCaptionLabel().setVisible(false);
    
    // Fader
    this.myFader = cp5.addSlider("mySlider")
                .setRange(0, 100)
                .setValue(10)
                .setPosition(this.inactivePosition)
                .setSize(60,160)
                .setColorForeground(color(200))
                .setColorBackground(color(0,0,0,1))
                .setVisible(true)
                .setColorActive(color(200));
    this.myFader.getCaptionLabel().setVisible(false);

    // Octaves Buttons
    this.octaveUpButton = cp5.addButton("octaveUpButton")
              .setPosition(this.inactivePosition)
              .setSize(60,60)
              .setColorBackground(color(0,0,0,1))
              .setColorForeground(color(50))
              .setVisible(true)
              .setColorActive(color(50));      
    this.octaveUpButton.setLabel("+");
    this.octaveUpButton.getCaptionLabel().setFont(customFont);
    
    this.octaveDownButton = cp5.addButton("octaveDownButton")
                    .setPosition(this.inactivePosition)
                    .setSize(60,60)
                    .setColorBackground(color(0,0,0,1))
                    .setColorForeground(color(50))
                    .setVisible(true)
                    .setColorActive(color(50));
    this.octaveDownButton.setLabel("-");
    this.octaveDownButton.getCaptionLabel().setFont(customFont);

    this.modeButton = cp5.addButton("modeButton")
        .setPosition(this.inactivePosition)
        .setSize(120,60)
        .setColorBackground(color(0,0,0,1))
        .setColorForeground(color(50))
        .setVisible(true)
        .setColorActive(color(50));
    this.modeButton.setLabel("Expert");
    this.modeButton.getCaptionLabel().setFont(customFont);
    
    this.backButton = cp5.addButton("freePlayBackButton")
            .setPosition(this.inactivePosition)
            .setSize(width/15,30)
            .setColorBackground(color(0,0,0,1))
            .setColorForeground(color(50))
            .setVisible(true)
            .setColorActive(color(50));
    this.backButton.setLabel("Back");
    this.backButton.getCaptionLabel().setFont(customFont);
    this.addListeners();
  }

  public int getID(){
      return this.pageIndex;
  }

  public void addListeners() {
    this.backButton.addListener(this.buttonClickListener);
    this.modeButton.addListener(this.buttonClickListener);
    this.octaveUpButton.addListener(this.buttonClickListener);
    this.octaveDownButton.addListener(this.buttonClickListener);
    this.myFader.addListener(this.buttonClickListener);
    this.myKnob.addListener(this.buttonClickListener);
  }

  public void removeListeners() { // WARNING not safe
    this.backButton.removeListener(this.buttonClickListener);
    this.modeButton.removeListener(this.buttonClickListener);
    this.octaveUpButton.removeListener(this.buttonClickListener);
    this.octaveDownButton.removeListener(this.buttonClickListener);
    this.myFader.removeListener(this.buttonClickListener);
    this.myKnob.removeListener(this.buttonClickListener);
  }

  public void setVisibility(boolean isVisible){
    this.isVisible = isVisible;
    if (this.isVisible) {
      println(this, "set visible position");
      this.backButton.setPosition(this.backButtonPosition);
      this.modeButton.setPosition(this.modeButtonPosition);
      this.octaveUpButton.setPosition(this.octaveUpButtonPosition);
      this.octaveDownButton.setPosition(this.octaveDownButtonPosition);
      this.myFader.setPosition(this.myFaderPosition); 
      this.myKnob.setPosition(this.myKnobPosition);    
    } else {
      this.backButton.setPosition(this.inactivePosition);
      this.modeButton.setPosition(this.inactivePosition);
      this.octaveUpButton.setPosition(this.inactivePosition);
      this.octaveDownButton.setPosition(this.inactivePosition);
      this.myFader.setPosition(this.inactivePosition);
      this.myKnob.setPosition(this.inactivePosition);
    }
  }

  public void draw(){
    if(this.isVisible){
      // outer box
      this.keyboard.drawBox();
      notesOutput = this.fingers.getPressedNotes(notesInput, pressedSens, shift, this.keyboard);
      // keyboard
      this.keyboard.setNotes(notesOutput);
      this.keyboard.draw();
      // note labes on the keyboard
      if(!this.beginnerMode){
        this.keyboard.writeNoteLabels(octaves,1);
      } else {
        this.keyboard.writeNoteLabels(octaves,0);
      }
      // fingers' positions
      this.fingers.positions(coordinates);
    }
  }

  public void handleButtonClick(ControlEvent event) {
    if (!event.isController()) return;
    
    String buttonName = event.getController().getName();
    
    switch (buttonName) {
        case "freePlayBackButton":
            navigationController.changePage(activePage, modeSelectionPage);
            break;
        case "octaveUpButton":
            freePlayPage.octaveUpButtonPressed();
            break;
        case "octaveDownButton":
            freePlayPage.octaveDownButtonPressed();
            break;
        case "modeButton":
            freePlayPage.modeButtonPressed();
            break;
        case "mySlider":
            freePlayPage.faderPressed();
            break;
        case "myFader":
            freePlayPage.knobPressed();
            break;
      }
    }

  private void backButtonPressed(){
    fill(200);
    rect(9*width/10+5, height*9/10, width/15+10, 50,10);
    println("Active page index", activePageIndex);
  }

  private void octaveUpButtonPressed(){
    for (int i = 0; i < octaves.length; i++) {
      if(octaves[1] < 6){
        octaves[i]++;
      } else {
        octaves[0] = 5;
        octaves[1] = 6;
        octaves[2] = 7;
      }
    }

    shift -= 12;
    println(shift);
    fill(200);
    rect(3*width/5 + width/8 + 90,height*5/30 + 110, 70, 70, 10);
  }

  private void octaveDownButtonPressed(){
    for (int i = 0; i < octaves.length; i++) {
      if(octaves[0] > 2 ){
        octaves[i]--;
      } else {
        octaves[0] = 1;
        octaves[1] = 2;
        octaves[2] = 3;
      }
    }
    shift += 12;
    println(shift);
    fill(200);
    rect(3*width/5 + width/8,height*5/30 + 110, 70, 70, 10);  
  }

  private void modeButtonPressed(){
    if(!this.beginnerMode){
        this.modeButton.setLabel("Beginner");
        this.beginnerMode = true;
    } else {
        this.modeButton.setLabel("Expert");
        this.beginnerMode = false;
    } 
    fill(200);
    rect(3*width/5 + width/8 + 15, height*5/30 -15, 130, 70, 10);
  }
  
  private void faderPressed(){
  }

  private void knobPressed(){
    println("knobPressed");
  }
}
