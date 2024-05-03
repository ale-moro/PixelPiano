class PlayPage implements Page {
  int pageIndex = PLAY_PAGE_INDEX;
  boolean isVisible;
  float[] inactivePosition;
  // Knob myKnob;
  // float[] myKnobPosition;
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
  Button[] buttonsArray;
  VideoStream videoStream;

  public PlayPage() {
    this.fingers = new Fingers();
    this.keyboard = new PlayPagePiano();
    this.videoStream = new VideoStream(4 * height / 9, height / 3, width / 10, height / 4 -  width/10);
    this.buttonClickListener = new ButtonClickListener(this);
    this.isVisible = false;
    this.beginnerMode = false;

    this.buttonsSetup();
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
    // this.myKnob.addListener(this.buttonClickListener);
  }

  public void removeListeners() { // WARNING not safe
    this.backButton.removeListener(this.buttonClickListener);
    this.modeButton.removeListener(this.buttonClickListener);
    this.octaveUpButton.removeListener(this.buttonClickListener);
    this.octaveDownButton.removeListener(this.buttonClickListener);
    this.myFader.removeListener(this.buttonClickListener);
    // this.myKnob.removeListener(this.buttonClickListener);
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
      // this.myKnob.setPosition(this.myKnobPosition);    
    } else {
      this.backButton.setPosition(this.inactivePosition);
      this.modeButton.setPosition(this.inactivePosition);
      this.octaveUpButton.setPosition(this.inactivePosition);
      this.octaveDownButton.setPosition(this.inactivePosition);
      this.myFader.setPosition(this.inactivePosition);
      // this.myKnob.setPosition(this.inactivePosition);
    }
  }

  public void setup(){
    println("PlayPage setup"); 
    this.drawPageLayoutLines();
    
    buttonsArray = new Button[4];
    buttonsArray[0] = this.octaveUpButton;
    buttonsArray[1] = this.octaveDownButton;
    buttonsArray[2] = this.modeButton;
    buttonsArray[3] = this.backButton;
  }

  public void draw(){
    if(this.isVisible){
      background(255);
      // outer box
      this.drawPageLayoutLines();
      this.drawButtonsBoxes();
      this.videoStream.draw();
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
    
    for(int i = 0; i < buttonsArray.length; i++){
      checkCoordinates(coordinates, buttonsArray[i], pressedSens);
    }
    
    checkFader(coordinates, myFader, pressedSens);
  }
  
  // =============================== PAGE STYLING ===============================
  private void drawPageLayoutLines(){
    // Box
    float boxHeight = height / 3;
    float boxWidth = width*0.58 ;
    float boxX = width / 20;
    float boxY = height / 4 -  width/10;
    
    fill(255); // todo: make this transparent
    stroke(0);
    rect(boxX, boxY, boxWidth, boxHeight, 10);
    rect(3*boxX/2 + boxWidth , boxY, boxWidth/2, boxHeight,10);  
  }

  private void drawButtonsBoxes(){
    // fader
    styleManager.drawVerticalSliderBox(this.myFader, 10); 
    
    // knob
    //fill(0, 200,0,1);
    //ellipse(width*11/60 +85, height*5/30 +85, 160, 160);
    
    // expert/beginner
    styleManager.drawButtonBox(this.modeButton, 10);

    // octaves
    styleManager.drawButtonBox(this.octaveUpButton, 10);
    styleManager.drawButtonBox(this.octaveDownButton, 10);
    
    // back
    styleManager.drawButtonBox(this.backButton, 10);
  }
  // =============================================================================

  // =============================== BUTTON CLICKS ===============================
  public void handleButtonClick(ControlEvent event) {
    if (!event.isController() && !event.isTab()) return;
    
    String buttonName = event.getName();
    
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
        // case "myFader":
        //     freePlayPage.knobPressed();
        //     break;
      }
    }

  private void backButtonPressed(){
    fill(200);
    stroke(0);
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
    stroke(0);
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
    stroke(0);
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
    stroke(0);
    rect(3*width/5 + width/8 + 15, height*5/30 -15, 130, 70, 10);
  }
  
  private void faderPressed(){
  }

  // private void knobPressed(){
  //   println("knobPressed");
  // }
  // ================================================================================

  // =============================== GRAPHIC ELEMENTS ===============================
  private void buttonsSetup(){
    this.setupButtonPositions();

    // Knob
    // this.myKnob = cp5.addKnob("myKnob")
    //           .setRange(0, 100)
    //           .setValue(0) // todo: Mappare valore nel range e settare value
    //           .setPosition(this.inactivePosition)
    //           .setRadius(80)
    //           .setNumberOfTickMarks(10)
    //           .setColorForeground(color(200))
    //           .setColorBackground(color(0,0,0,1))
    //           .setVisible(true)
    //           .setColorActive(color(200));
    // this.myKnob.getCaptionLabel().setVisible(false);
    
    // Fader
    this.myFader = cp5.addSlider("mySlider")
                .setRange(0, 100)
                .setValue(50)
                .setPosition(this.inactivePosition)
                .setSize(60,160)
                .setColorForeground(color(200))
                .setColorBackground(color(0,0,0,1))
                .setVisible(true)
                .setColorActive(color(200));
    this.myFader.getCaptionLabel().setVisible(false);

    // Octaves Buttons
    this.octaveUpButton = cp5.addButton("octaveUpButton")
    .setSize(60,60);
    styleManager.setDefaultButtonStyle(this.octaveUpButton);
    this.octaveUpButton.setLabel("+");
    
    this.octaveDownButton = cp5.addButton("octaveDownButton");
    styleManager.setDefaultButtonStyle(this.octaveDownButton);
    this.octaveDownButton.setSize(60,60);
    this.octaveDownButton.setColorBackground(color(0,0,0,1));
    this.octaveDownButton.setLabel("-");

    this.modeButton = cp5.addButton("modeButton");
    styleManager.setDefaultButtonStyle(this.modeButton);
    this.modeButton.setSize(120,60);
    this.modeButton.setColorBackground(color(0,0,0,1));
    this.modeButton.setLabel("Expert");
    
    this.backButton = cp5.addButton("freePlayBackButton");
    styleManager.setDefaultButtonStyle(this.backButton);
    this.backButton.setSize(width/15, 40);
    this.backButton.setColorBackground(color(0,0,0,1));
    this.backButton.setLabel("Back");
  }

  void setupButtonPositions(){
    // this.myKnobPosition = new float[] {width*11/60, height*5/30};
    this.myFaderPosition = new float[] {width*28/60 - 10, height*5/30};
    this.octaveUpButtonPosition = new float[] {3*width/5 + width/8 + 110,height*5/30 + 110};
    this.octaveDownButtonPosition = new float[] {3*width/5 + width/8 +20, height*5/30 + 110};
    this.modeButtonPosition = new float[] {3*width/5 + width/8 + 36 ,height*5/30 - 15};
    this.backButtonPosition = new float[] {9*width/10 + 5, 9*height/10 +25};
    this.inactivePosition = new float[] {-1000, -1000};  
  } 

  // ================================================================================
}
