class PlayPage {
  Knob myKnob;
  Slider myFader;
  Button octaveUp;
  Button octaveDown;
  Button mode;
  Button back;
  Fingers fingers;
  Piano keyboard;

  PFont customFont;
  PFont customFont1;

  public PlayPage() {
    this.fingers = new Fingers();
    this.keyboard = new Piano();
    this.customFont = createFont("Monospaced", 20);
    this.customFont1 = createFont("Monospaced", 20);

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
    this.octaveUp.getCaptionLabel().setFont(this.customFont1);
    
    this.octaveDown = cp5.addButton("octaveDown")
                    .setPosition(3*width/5 + width/8 +20, height*5/30 + 110)
                    .setSize(60,60)
                    .setColorBackground(color(0))
                    .setColorForeground(color(50))
                    .setVisible(false)
                    .setColorActive(color(50));
    this.octaveDown.setLabel("-");
    this.octaveDown.getCaptionLabel().setFont(this.customFont1);

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
    
    // Listeners
    this.back.addListener(new ButtonClickListener());
    this.mode.addListener(new ButtonClickListener());
    this.octaveUp.addListener(new ButtonClickListener());
    this.octaveDown.addListener(new ButtonClickListener());
    this.myFader.addListener(new ButtonClickListener());
  }

  public void draw(boolean isVisible){
    this.setPageVisibile(isVisible);

    if(isVisible){
      notesOutput = this.fingers.getPressedNotes(notesInput, pressedSens, shift, this.keyboard);
      this.keyboard.drawBox();
      this.fingers.positions(coordinates);
      if(!beginner){
        this.keyboard.writeNoteLabels(octaves,1);
      } else {
        this.keyboard.writeNoteLabels(octaves,0);
      }
    }
  }

  public void setPageVisibile(boolean isVisible){
    this.keyboard.draw(isVisible, notesOutput);
    this.myKnob.setVisible(isVisible);
    this.myFader.setVisible(isVisible);
    this.octaveUp.setVisible(isVisible);
    this.octaveDown.setVisible(isVisible);
    this.mode.setVisible(isVisible); 
    this.back.setVisible(isVisible);
  }

  public void backButtonPressed(){
    fill(200);
    rect(9*width/10 +5, height*9/10, width/15 +10, 50,10);
    println("isPlaying back btn", isPlaying);
  }

  public void octaveUpButtonPressed(){
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

  public void octaveDownButtonPressed(){
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

  public void modeButtonPressed(){
    if(!beginner){
        mode.setLabel("Beginner");
        beginner = true;
    } else {
        mode.setLabel("Expert");
        beginner = false;
    } 
    fill(200);
    rect(3*width/5 + width/8 + 15, height*5/30 -15, 130, 70, 10);
  }
  
  public void faderPressed(){
  }
}