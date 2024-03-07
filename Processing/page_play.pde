class PlayPage implements Page{
  int pageIndex = PLAY_PAGE_INDEX;
  boolean isVisible;
  Knob myKnob;
  Slider myFader;
  Button octaveUp;
  Button octaveDown;
  Button mode;
  Button back;
  Fingers fingers;
  PlayPagePiano keyboard;

  public PlayPage() {
    this.fingers = new Fingers();
    this.keyboard = new PlayPagePiano();
    this.isVisible = false;

    // Knob
    this.myKnob = cp5.addKnob("myKnob")
              .setRange(0, 100)
              .setValue(0) // Mappare valore nel range e settare value
              .setPosition(width*11/60, height*5/30)
              .setRadius(80)
              .setNumberOfTickMarks(10)
              .setColorForeground(color(200))
              .setColorBackground(color(0))
              .setVisible(false)
              .setColorActive(color(200));
    this.myKnob.getCaptionLabel().setVisible(false);
    
    // Fader
    this.myFader = cp5.addSlider("mySlider")
                .setRange(0, 100)
                .setValue(10)
                .setPosition(width*28/60 -10, height*5/30)
                .setSize(60,160)
                .setColorForeground(color(200))
                .setColorBackground(color(0))
                .setVisible(false)
                .setColorActive(color(200));
    this.myFader.getCaptionLabel().setVisible(false);

    // Octaves Buttons
    this.octaveUp = cp5.addButton("octaveUp")
              .setPosition(3*width/5 + width/8 + 110,height*5/30 + 110)
              .setSize(60,60)
              .setColorBackground(color(0))
              .setColorForeground(color(50))
              .setVisible(false)
              .setColorActive(color(50));      
    this.octaveUp.setLabel("+");
    this.octaveUp.getCaptionLabel().setFont(customFont);
    
    this.octaveDown = cp5.addButton("octaveDown")
                    .setPosition(3*width/5 + width/8 +20, height*5/30 + 110)
                    .setSize(60,60)
                    .setColorBackground(color(0))
                    .setColorForeground(color(50))
                    .setVisible(false)
                    .setColorActive(color(50));
    this.octaveDown.setLabel("-");
    this.octaveDown.getCaptionLabel().setFont(customFont);

    this.mode = cp5.addButton("mode")
        .setPosition(3*width/5 + width/8 + 36 ,height*5/30 - 15)
        .setSize(120,60)
        .setColorBackground(color(0))
        .setColorForeground(color(50))
        .setVisible(false)
        .setColorActive(color(50));
    this.mode.setLabel("Expert");
    this.mode.getCaptionLabel().setFont(customFont);
    
    this.back = cp5.addButton("back")
            .setPosition(9*width/10 + 5, 9*height/10 +25)
            .setSize(width/15,30)
            .setColorBackground(color(0))
            .setColorForeground(color(50))
            .setVisible(false)
            .setColorActive(color(50));
    this.back.setLabel("Back");
    this.back.getCaptionLabel().setFont(customFont);
    
    this.addListeners();
  }

  public int getID(){
      return this.pageIndex;
  }

  public void addListeners() {
    this.back.addListener(buttonClickListener);
    this.mode.addListener(buttonClickListener);
    this.octaveUp.addListener(buttonClickListener);
    this.octaveDown.addListener(buttonClickListener);
    this.myFader.addListener(buttonClickListener);
  }

  public void removeListeners() {
    this.back.removeListener(buttonClickListener);
    this.mode.removeListener(buttonClickListener);
    this.octaveUp.removeListener(buttonClickListener);
    this.octaveDown.removeListener(buttonClickListener);
    this.myFader.removeListener(buttonClickListener);
  }

  public void setVisibility(boolean isVisible){
    this.isVisible = isVisible;
    this.myKnob.setVisible(this.isVisible);
    this.myFader.setVisible(this.isVisible);
    this.octaveUp.setVisible(this.isVisible);
    this.octaveDown.setVisible(this.isVisible);
    this.mode.setVisible(this.isVisible); 
    this.back.setVisible(this.isVisible);
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
      if(!beginner){
        this.keyboard.writeNoteLabels(octaves,1);
      } else {
        this.keyboard.writeNoteLabels(octaves,0);
      }
      // fingers' positions
      this.fingers.positions(coordinates);
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
    if(!beginner){
        this.mode.setLabel("Beginner");
        beginner = true;
    } else {
        this.mode.setLabel("Expert");
        beginner = false;
    } 
    fill(200);
    rect(3*width/5 + width/8 + 15, height*5/30 -15, 130, 70, 10);
  }
  
  private void faderPressed(){
  }
}