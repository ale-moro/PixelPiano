
class PianoHeroPage implements Page {
  
  int buttons_height = 30;
  String midiFilePath;
  int pageIndex = PIANO_HERO_PAGE_INDEX;
  DropdownList midiFilesDropdown;
  String[] midiFilesDropdownItemList;
  Button backButton;
  Button loadMidiButton;
  Button prepareMidiButton;
  Button startMidiButton;
  Button restartMidiButton;
  float[] midiFilesDropdownPosition;
  float[] backButtonPosition;
  float[] loadMidiButtonPosition;
  float[] startMidiButtonPosition;
  float[] restartMidiButtonPosition;
  float[] prepareMidiButtonPosition;
  float[] inactivePosition;
  float[] midiNameTextPosition;
  ButtonClickListener buttonClickListener;
  GroupControlListener groupControlListener;

  Fingers fingers;
  PlayPagePiano keyboard;

  int currentTime=0;
  int prevTime=0;
  int diff;
  float pianoHeight;
  float keyWidth;
  float margin;
  float rectY = 0;
  float barLength;
  float[] heights = new float[36];
  float[] rectHeight = new float[36];
  ArrayList<float[]> played = new ArrayList<float[]>();

  MidiLoader midiLoader;
  GameNoteSequence noteSequence;
  FallingNotesPlayer fallingNotesPlayer; 
  ArrayList<FallingNote> fallingNotes;

  public PianoHeroPage() {
    this.fingers = new Fingers();
    this.keyboard = new PlayPagePiano();

    this.pianoHeight = height / 3;
    this.margin = width / 10;
    this.keyWidth = (width -  this.margin) / 21;
    this.noteSequence = new GameNoteSequence();

    this.midiFilesDropdownItemList = new String[] {"assets\\BWV_0578.mid", "assets\\HesaPirate.mid", "assets\\Dr Dre - Still Dre.mid"};
    this.midiFilePath = sketchPath() + "\\" + this.midiFilesDropdownItemList[0];

    this.midiLoader = new MidiLoader();

    this.createButtons();
    this.textSetup();

    this.fallingNotesPlayer = new FallingNotesPlayer(this.noteSequence, this.keyboard, this.margin);

    for(int i = 0; i<heights.length; i++){
        heights[i] = -1000000;
    }
    
    for(int j = 0; j<rectHeight.length; j++){
      rectHeight[j] = Float.POSITIVE_INFINITY;
    }
    
    fallingNotes = new ArrayList<FallingNote>();
  }

  public int getID(){
    return this.pageIndex;
  }

  public String[] getMidiFilesDropdownItemList(){
    return this.midiFilesDropdownItemList;
  }

  public void handleButtonClick(ControlEvent event) {
    if (!event.isController()) return;
    String buttonName = event.getController().getName();
    
    if ("pianoHeroBackButton".equals(buttonName)) {
      navigationController.changePage(activePage, modeSelectionPage);

    } else if ("pianoHeroLoadMidiButton".equals(buttonName)) {
      this.midiLoader.setDrawMidiFilePath();

    } else if ("pianoHeroPrepareMidiButton".equals(buttonName)) {
      this.noteSequence = this.midiLoader.computeGameNoteSequence();
      this.midiFilePath = this.midiLoader.getMidiFilePath();
      this.fallingNotesPlayer.loadNoteSequence(this.noteSequence);

    } else if ("pianoHeroStartMidiButton".equals(buttonName)) {
      boolean playing = this.fallingNotesPlayer.startStop();
      if (playing){
        this.startMidiButton.setLabel("Stop");
      } else {
        this.startMidiButton.setLabel("Start");
      }
    } else if ("pianoHeroRestartMidiButton".equals(buttonName)) {
      this.fallingNotesPlayer.restart();      
      this.startMidiButton.setLabel("Start");

    } else if ("pianoHeroMidiFilesDropdown".equals(buttonName)) {
      // text 
      println("value: " + this.midiFilesDropdown.getValue());
      this.midiFilePath = sketchPath() + "\\" + this.midiFilesDropdownItemList[round(this.midiFilesDropdown.getValue())];
      this.midiLoader.setMidiFilePath(this.midiFilePath);
      print("Set new midi file path: " + this.midiFilePath);
      this.drawFilename(); 
    }
  }

  public void setup() {
    styleManager.drawButtonBox(this.backButton, 10);
    styleManager.drawButtonBox(this.loadMidiButton, 10);
    styleManager.drawButtonBox(this.prepareMidiButton, 10);
    styleManager.drawButtonBox(this.startMidiButton, 10);
    styleManager.drawButtonBox(this.restartMidiButton, 10);
    this.textSetup();
  }
  
  public void draw() {
    //prevTime = currentTime;
    //currentTime = millis();
    //diff = currentTime - prevTime;
    //println(currentTime, prevTime, diff);

    // reset falling notes draw
    fill(255);
    noStroke(); 
    rect(0, 0, width, keyboard.getPianoY());

    this.fallingNotesPlayer.draw();

    // keyboard
    this.keyboard.setNotes(notesOutput);
    this.keyboard.draw();
    
    // fingers
    notesOutput = this.fingers.getPressedNotes(notesInput, pressedSens, shift, this.keyboard);
    this.fingers.positions(coordinates);

  }

  private void createButtons(){ 
    this.buttonClickListener = new ButtonClickListener(this);
    this.groupControlListener = new GroupControlListener(this); 
    float bottomButtonRowY = 9.3*height/10;

    this.midiNameTextPosition = new float[] {4.125*width/20, bottomButtonRowY + 12};
    this.midiFilesDropdownPosition = new float[] {width/20, height/20};
    this.backButtonPosition = new float[] {9*width/10 + 5, bottomButtonRowY};
    this.loadMidiButtonPosition = new float[] {width/20 , bottomButtonRowY}; 
    this.prepareMidiButtonPosition = new float[] {4.8*width/10, bottomButtonRowY};
    this.startMidiButtonPosition = new float[] {6.65*width/10 + 3, bottomButtonRowY};
    this.restartMidiButtonPosition = new float[] {7.7*width/10, bottomButtonRowY};
    this.inactivePosition = new float[] {-1000, -1000};

    this.midiFilesDropdown = cp5.addDropdownList("pianoHeroMidiFilesDropdown")
      .setSize(width/5, 300);
    this.setDropdownStyle(this.midiFilesDropdown);
    this.midiFilesDropdown.addItems(this.midiFilesDropdownItemList);

    this.backButton = cp5.addButton("pianoHeroBackButton")
            .setSize(width/15, this.buttons_height);
    styleManager.setDefaultButtonStyle(this.backButton);
    this.backButton.setLabel("Back");

    this.loadMidiButton = cp5.addButton("pianoHeroLoadMidiButton")
      .setSize(width/7, this.buttons_height);
    styleManager.setDefaultButtonStyle(this.loadMidiButton); 
    this.loadMidiButton.setLabel("Load Midi File");

    this.prepareMidiButton = cp5.addButton("pianoHeroPrepareMidiButton")
      .setSize(width/6, this.buttons_height);
    styleManager.setDefaultButtonStyle(this.prepareMidiButton);
    this.prepareMidiButton.setLabel("Prepare Midi File");
      
    this.startMidiButton = cp5.addButton("pianoHeroStartMidiButton")
      .setSize(width/12, this.buttons_height);
    styleManager.setDefaultButtonStyle(this.startMidiButton);
    this.startMidiButton.setLabel("Start");

    this.restartMidiButton = cp5.addButton("pianoHeroRestartMidiButton")
      .setSize(width/12, this.buttons_height);
      styleManager.setDefaultButtonStyle(this.restartMidiButton);
      this.restartMidiButton.setLabel("Restart");
    this.addListeners();
  }

  
  public void setVisibility(boolean isVisible){
    if(isVisible){
      this.backButton.setPosition(this.backButtonPosition);
      this.loadMidiButton.setPosition(this.loadMidiButtonPosition);
      this.prepareMidiButton.setPosition(this.prepareMidiButtonPosition);
      this.startMidiButton.setPosition(this.startMidiButtonPosition);
      this.restartMidiButton.setPosition(this.restartMidiButtonPosition);
      this.midiFilesDropdown.setPosition(this.midiFilesDropdownPosition);
    } else {
      this.backButton.setPosition(this.inactivePosition);
      this.loadMidiButton.setPosition(this.inactivePosition); 
      this.prepareMidiButton.setPosition(this.inactivePosition);
      this.startMidiButton.setPosition(this.inactivePosition);
      this.restartMidiButton.setPosition(this.inactivePosition);
      this.midiFilesDropdown.setPosition(this.inactivePosition);
    } 
  }

  public void addListeners(){
    this.backButton.addListener(this.buttonClickListener); 
    this.loadMidiButton.addListener(this.buttonClickListener);
    this.prepareMidiButton.addListener(this.buttonClickListener);
    this.startMidiButton.addListener(this.buttonClickListener);
    this.restartMidiButton.addListener(this.buttonClickListener);
    this.midiFilesDropdown.addListener(this.groupControlListener);
  }
  public void removeListeners(){}

  
  private void setDropdownStyle(DropdownList ddl) {
    ddl.setPosition(this.inactivePosition);
    ddl.setColorBackground(color(0));
    ddl.setColorForeground(color(50));
    ddl.setVisible(true);
    ddl.setColorActive(color(50));
    ddl.getCaptionLabel().setFont(styleManager.customFont);
    ddl.setItemHeight(30);
    ddl.setBarHeight(30);
    ddl.setColorActive(color(50));
    ddl.setOpen(false);
    ddl.setColorLabel(color(255));
    ddl.setColorValue(color(255));
    ddl.setLabel("Select Midi File"); 
  }

  private void textSetup(){
    this.drawFilename();
  }

  public void drawFilename(){
    fill(255);
    noStroke();
    rect(this.midiNameTextPosition[0], this.loadMidiButtonPosition[1], this.prepareMidiButtonPosition[0]-this.midiNameTextPosition[0]-5, this.buttons_height);  
    fill(0);
    textSize(20);
    textAlign(LEFT, CENTER);
    this.midiFilePath = this.midiFilePath != midiLoaderSelectedMIDIFilePath? midiLoaderSelectedMIDIFilePath : this.midiFilePath;
    String midiFileName = this.midiFilePath.contains("\\") ? this.midiFilePath.substring(this.midiFilePath.lastIndexOf("\\") + 1) : this.midiFilePath;
    println("draw: " + midiFileName);
    text(midiFileName, this.midiNameTextPosition[0], this.midiNameTextPosition[1]);
  }

  public void setMidiFilePath(String filePath) {
    this.midiFilePath = filePath;
  }
}