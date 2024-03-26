
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
  float pianoHeight;
  float keyWidth;
  float margin;
  float velocity = 1;
  float rectY = 0;
  float barLength;
  float[] heights = new float[36];
  float[] rectHeight = new float[36];
  int[] blackKeys = {1,3,6,8,10,13,15,18,20,22,25,27,30,32,34};
  float[][] played = {
  {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, 
  {0, 0}, {0, 0}, {0, 0}, {0, 0}, {1, 0.5}, {0, 0}, {0, 0}, {0, 0}, 
  {1, 0.2}, {0, 0}, {0, 0}, {1, 0.7}, {0, 0}, {0, 0}, {0, 0}, {1, 1}, 
  {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, 
  {0, 0}, {0, 0}, {0, 0}, {0, 0}
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
      
      heights[i]++;
    
      rectHeight[i] = min(rectHeight[i], barLength);
    
      if(heights[i] + barLength > height/2){
        rectHeight[i]--;
      }
      
      fill(0,255,0);
      rect( keyboard.getCoord(i) , heights[i],  definekey(i)  , rectHeight[i], 10);
    
    }else{
      heights[i] = -10000000;
    }
  
  }



 public void draw() {
      
      notesOutput = this.fingers.getPressedNotes(notesInput, pressedSens, shift, this.keyboard);
      // keyboard
      this.keyboard.setNotes(notesOutput);
      this.keyboard.draw();
      // fingers' positions
      this.fingers.positions(coordinates);
      for(int i = 0; i<played.length; i++){
     
        barLength = played[i][1]/0.001;
        drawRect( i, barLength);
      
      }
      
      delay(10);
 }
     
  

}
    
    
