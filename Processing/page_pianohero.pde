
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
  float velocity = 3;
  float rectY = 0;
 
  MidiLoader midiLoader;

  public PianoHeroPage() {
  
    // this.midiLoader = new MidiLoader();
    this.fingers = new Fingers();
    this.keyboard = new PlayPagePiano();
    this.buttonClickListener = new ButtonClickListener(this);
    this.pianoHeight = height/3;
    this.margin = width / 10;
    this.keyWidth = (width -  margin) / 21;

    selectInput("Select a MIDI file:", "MIDIfileSelected");
    
    this.backButtonPosition = new float[] {9*width/10 + 5, 9*height/10 +25};
    this.loadMidiButtonPosition = new float[] {width/2 + 10, 2*height/10 + 60};
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
        .setSize(width/6,30)
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
    this.loadMidiButton.addListener(this.buttonClickListener); 

  }
  public void removeListeners(){}

  public void setVisibility(boolean isVisible){
    if(isVisible){
      this.backButton.setPosition(this.backButtonPosition);
      this.loadMidiButton.setPosition(this.loadMidiButtonPosition);
    } else {
      this.backButton.setPosition(this.inactivePosition);
      this.loadMidiButton.setPosition(this.inactivePosition);
    } 
  }

  public void handleButtonClick(ControlEvent event) {
    if (!event.isController()) return;
    String buttonName = event.getController().getName();
    
    if ("pianoHeroBackButton".equals(buttonName)) {
      navigationController.changePage(activePage, modeSelectionPage);
    }
    if ("loadMidiButton".equals(buttonName)) {
      println("Loading Midi File");
      String midiFileName = "BWV_0578.mid";
      String midiFilePath = sketchPath() + "\\" + midiFileName;
      GameNoteSequence gameNoteSequence = this.midiLoader.computeGameNoteSequence(midiFilePath);
      println("GameNoteSequence: " + gameNoteSequence);
      println("GameNoteSequence size: " + gameNoteSequence.size());
    }
  }
  
  


 public void draw() {
      
      notesOutput = this.fingers.getPressedNotes(notesInput, pressedSens, shift, this.keyboard);
      // keyboard
      this.keyboard.setNotes(notesOutput);
      this.keyboard.draw();
      // fingers' positions
      this.fingers.positions(coordinates);

        
       
      fill(80);
      rect(width/2, rectY += velocity ,keyWidth, this.pianoHeight, 10);
      if (rectY + pianoHeight >= height - height / 3 - pianoHeight/2) {
          velocity = 0;
       }
       
       if(velocity == 0){
         rectY++;
        }
        
      }
     
  

}
    
    
