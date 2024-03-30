

class PianoHeroPage implements Page {
  int pageIndex = PIANO_HERO_PAGE_INDEX;
  Button backButton;
  Button loadMidiButton;
  float[] backButtonPosition;
  float[] loadMidiButtonPosition;
  float[] inactivePosition;
  ButtonClickListener buttonClickListener;
  Fingers fingers;
  PlayPagePiano keyboard;
  int currentTime=0;
  int prevTime=0;
  int diff;
  int index = 0;
  ArrayList<FallingNote> fallingNotes;
  float pianoHeight;
  float keyWidth;
  float margin;
  float velocity = 1;
  float rectY = 0;
  float barLength;
  float speed = 3;
  float[] heights = new float[36];
  float[] rectHeight = new float[36];
  int[] blackKeys = {1,3,6,8,10,13,15,18,20,22,25,27,30,32,34};
  float[][] played = {
  {40, 1, 7}, {43,0.5,10},{40, 0.25, 10}, {40,0.25,11}
  };
  MidiLoader midiLoader;

  public PianoHeroPage() {
  
    // this.midiLoader = new MidiLoader();
    this.fingers = new Fingers();
    this.keyboard = new PlayPagePiano();
    this.buttonClickListener = new ButtonClickListener(this);
    this.pianoHeight = height/3;
    this.margin = width / 10;
    this.keyWidth = (width -  margin) / 21;

    //selectInput("Select a MIDI file:", "MIDIfileSelected");
    
    this.backButtonPosition = new float[] {9*width/10 + 5, 9*height/10 +25};
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
    this.addListeners();
    
    for(int i = 0; i<heights.length; i++){
        heights[i] = -1000000;
    }
    
    for(int j = 0; j<rectHeight.length; j++){
      rectHeight[j] = Float.POSITIVE_INFINITY;
    }
    
    fallingNotes = new ArrayList<FallingNote>();
    this.keyboard.draw();
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
    
  }
  
   public float definekey(int inx){
  
        if(Arrays.binarySearch(blackKeys, inx )>=0){ 
          keyWidth = ((width - margin) / 21) / 1.5;
        }else{
          keyWidth = (width - margin) / 21;
        }
        
        return keyWidth;
  }


  public void drawRect(int i, float barLength){
    
    if(heights[i] < -100000){
      heights[i] = -barLength;
    }
        
    if (rectHeight[i] >0){
      
      heights[i] = heights[i] + speed;
    
      rectHeight[i] = min(rectHeight[i], barLength);
    
      if(heights[i] + barLength > height/2){
        rectHeight[i] = rectHeight[i] - speed;
      }
      
      fill(0,255,0);
      rect( keyboard.getCoord(i) , heights[i],  definekey(i)  , rectHeight[i], 10);
    
    }else{
      heights[i] = -10000000;
    }
  
  }



 public void draw() {
     //prevTime = currentTime;
     //currentTime = millis();
     //diff = currentTime - prevTime;
      notesOutput = this.fingers.getPressedNotes(notesInput, pressedSens, shift, this.keyboard);
      // keyboard
      this.keyboard.setNotes(notesOutput);
      
      // fingers' positions
      this.fingers.positions(coordinates);

    if (index<played.length && millis()/1000 > played[index][2]){
      
      int noteNumber = (int)played[index][0]%36; //<>//

      FallingNote note = new FallingNote(keyboard.getCoord(noteNumber), -played[index][1]*1000/30*speed, definekey(noteNumber), played[index][1]*1000/30*speed, speed); //<>//

      fallingNotes.add(note);
      index++;
    }
    
    for (int i = fallingNotes.size()-1; i >= 0; i--) {
      FallingNote note = fallingNotes.get(i);
      note.update();
      note.draw();
      if (note.isOffScreen()) {
        fallingNotes.remove(i);
      }

    }
     //this.keyboard.draw();
     //println(currentTime, prevTime, diff);
     this.keyboard.draw();
     delay(10);
 }

};


class FallingNote {
  float x, y;
  float width, rectHeight;
  float speed;

  FallingNote(float x, float y, float width, float rectHeight, float speed) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.rectHeight = rectHeight;
    this.speed = speed;
  }

  void draw() {
    fill(0,255,0);
    rect(x, y, width, rectHeight, 10);
  }

  void update() {
    y += speed;
  }

  boolean isOffScreen() {
    return y > height/2;
  }
}
    
