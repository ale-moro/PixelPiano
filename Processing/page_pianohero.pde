class PianoHeroPage implements Page {
  
  String midiFilePath;
  int pageIndex = PIANO_HERO_PAGE_INDEX;

  DropdownList midiFilesDropdown;
  ArrayList<String> midiFilesDropdownItemList;
  Button backButton;
  Button loadMidiButton;
  Button startMidiButton;
  Button restartMidiButton;
  float[] midiFilesDropdownPosition;
  float[] backButtonPosition;
  float[] loadMidiButtonPosition;
  float[] startMidiButtonPausedPosition;
  float[] startMidiButtonPlayingPosition;
  float[] restartMidiButtonPosition;
  float[] inactivePosition;
  float[] midiNameTextPosition;
  ButtonClickListener buttonClickListener;
  GroupControlListener groupControlListener;
  Button[] buttonsArray;

  Fingers fingers;
  PlayPagePiano keyboard;

  int currentTime = 0;
  int prevTime = 0;
  int diff;
  float pianoHeight;
  float keyWidth;
  float margin;
  float rectY = 0;
  boolean isPlaying = false;

  MidiLoader midiLoader;
  boolean waitingForMidiFilePath = false;

  GameNoteSequence noteSequence;
  FallingNotesPlayer fallingNotesPlayer; 

  public PianoHeroPage() {
    this.fingers = new Fingers();
    this.keyboard = new PlayPagePiano();

    this.pianoHeight = height / 3;
    this.margin = width / 10;
    this.keyWidth = (width -  this.margin) / 21;
    this.noteSequence = new GameNoteSequence();

    this.midiFilesDropdownItemList = new ArrayList<String>();
    this.midiFilesDropdownItemList.add("assets\\BWV_0578.mid");
    this.midiFilesDropdownItemList.add("assets\\HesaPirate.mid");
    this.midiFilesDropdownItemList.add("assets\\Dr Dre - Still Dre.mid");
    this.midiFilePath = Utils.safePath(sketchPath() + "\\" + this.midiFilesDropdownItemList.get(0));

    this.midiLoader = new MidiLoader();

    this.createButtons();

    this.fallingNotesPlayer = new FallingNotesPlayer(this.noteSequence, this.keyboard, this.margin);  
  }

  public int getID(){
    return this.pageIndex;
  }

  public ArrayList<String> getMidiFilesDropdownItemList(){
    return this.midiFilesDropdownItemList;
  }

  public void setWaitForMidiFilePath(boolean waiting){
    this.waitingForMidiFilePath = waiting;
  }

  public void handleButtonClick(ControlEvent event) {
    if (!event.isController() && !event.isTab()) return;
    String buttonName = event.getName();
    
    if ("pianoHeroBackButton".equals(buttonName)) {
      navigationController.changePage(activePage, modeSelectionPage);

    } else if ("pianoHeroLoadMidiButton".equals(buttonName)) {
      this.midiLoader.setDrawMidiFilePath();
      // semaphore needed for user file selection in explorer [unlocked in midiLoader.pde: pianoHeroMIDIfileSelected()]
      this.waitingForMidiFilePath = true;
      print("Waiting for midi file path...");
      while (this.waitingForMidiFilePath) {
          delay(100);
          print(".");
      }
      print(" Done!\n");
      // todo: add to dropdownlist or at least set label to ("Select Midi File");
      // DOC: https://sojamo.de/libraries/controlP5/reference/controlP5/DropdownList.html

      // LEGACY: pianoHeroPrepareMidiButton
      this.preparePlayer();
      // todo: when loading a new midi file, add it to the dropdown list - but path loading is not working from "pianoHeroMidiFilesDropdown"
      String newMidiFilePath = Utils.getFileNameFromPath(this.midiFilePath);
      this.midiFilesDropdownItemList.add(this.midiFilePath);
      this.midiFilesDropdown.addItem(newMidiFilePath, this.midiFilesDropdownItemList.size()-1);
      this.midiFilesDropdown.setValue(this.midiFilesDropdownItemList.size()-1);
      this.midiFilesDropdown.setLabel("Select Midi File"); 

    } else if ("pianoHeroStartMidiButton".equals(buttonName)) {
      this.isPlaying = !this.isPlaying ? this.fallingNotesPlayer.start() : this.fallingNotesPlayer.stop();

      if (this.isPlaying){
        this.startMidiButton.setLabel("Stop");
        this.setVisibility(false, true);
      } else {
        this.startMidiButton.setLabel("Start");
        this.setVisibility(true, true);
      }
    } else if ("pianoHeroRestartMidiButton".equals(buttonName)) {
      this.preparePlayer();

    } else if ("pianoHeroMidiFilesDropdown".equals(buttonName)) {
      // text 
      println("Dropdown menu value selected: " + this.midiFilesDropdown.getValue());
      String dropdownPath = this.midiFilesDropdownItemList.get(round(this.midiFilesDropdown.getValue()));
      if (!Utils.isAbsolutePath(dropdownPath)){
        dropdownPath = sketchPath() + "\\" + dropdownPath;
      } 
      this.midiFilePath = Utils.safePath(dropdownPath);

      this.midiLoader.setMidiFilePath(this.midiFilePath);
      this.preparePlayer();
    }
  }

  public void setup() {
    buttonsArray = new Button[5];
    buttonsArray[0] = this.backButton;
    buttonsArray[1] = this.loadMidiButton;
    buttonsArray[2] = this.prepareMidiButton;
    buttonsArray[3] = this.startMidiButton;
    buttonsArray[4] = this.restartMidiButton;
  }
  
  public void draw() {
    // reset falling notes draw
    background(255);

    // buttons 
    styleManager.drawDropdownBox(this.midiFilesDropdown, 10);
    styleManager.drawButtonBox(this.backButton, 10);
    styleManager.drawButtonBox(this.loadMidiButton, 10);
    styleManager.drawButtonBox(this.startMidiButton, 10);
    styleManager.drawButtonBox(this.restartMidiButton, 10);
    styleManager.drawDropdownBox(this.midiFilesDropdown, 10);
    
    for(int i = 0; i < buttonsArray.length; i++){
      checkCoordinates(coordinates, buttonsArray[i], pressedSens);
    }
    
    this.drawFilename();

    // falling notes
    this.fallingNotesPlayer.draw();

    // keyboard
    this.keyboard.setNotes(notesOutput);
    
    this.keyboard.draw();
    // fingers
    notesOutput = this.fingers.getPressedNotes(notesInput, pressedSens, shift, this.keyboard);
    this.fingers.positions(coordinates);
  }

  private void preparePlayer(){
      this.noteSequence = this.midiLoader.computeGameNoteSequence();
      this.midiFilePath = Utils.safePath(this.midiLoader.getMidiFilePath());
      this.fallingNotesPlayer.loadNoteSequence(this.noteSequence);
      this.fallingNotesPlayer.restart();

  }

  private void createButtons(){ 
    this.buttonClickListener = new ButtonClickListener(this);
    this.groupControlListener = new GroupControlListener(this); 
    float bottomButtonRowY = 9.3*height/10;

    // positions
    this.midiNameTextPosition = new float[] {4.125*width/20, bottomButtonRowY + 12};
    this.midiFilesDropdownPosition = new float[] {width/20, height/20};
    this.backButtonPosition = new float[] {9*width/10 + 5, bottomButtonRowY};
    this.loadMidiButtonPosition = new float[] {width/20 , bottomButtonRowY}; 
    this.startMidiButtonPausedPosition = new float[] {6.65*width/10 + 3, bottomButtonRowY};
    this.startMidiButtonPlayingPosition = new float[] {keyboard.getPianoX(), bottomButtonRowY};
    this.restartMidiButtonPosition = new float[] {7.7*width/10, bottomButtonRowY};
    this.inactivePosition = new float[] {-1000, -1000};

    // dropdown
    this.midiFilesDropdown = cp5.addDropdownList("pianoHeroMidiFilesDropdown")
      .setSize(width/5, 300);
    this.setDropdownStyle(this.midiFilesDropdown);
    String[] titles = new String[this.midiFilesDropdownItemList.size()];
    for(int k=0; k < this.midiFilesDropdownItemList.size(); k++){
      titles[k] = Utils.getFileNameFromPath(this.midiFilesDropdownItemList.get(k));
    }
    this.midiFilesDropdown.addItems(titles);

    // buttons
    this.backButton = cp5.addButton("pianoHeroBackButton")
            .setSize(width/15, this.buttons_height);
    styleManager.setDefaultButtonStyle(this.backButton);
    this.backButton.setLabel("Back");

    this.loadMidiButton = cp5.addButton("pianoHeroLoadMidiButton")
      .setSize(width/7, this.buttons_height);
    styleManager.setDefaultButtonStyle(this.loadMidiButton); 
    this.loadMidiButton.setLabel("Load Midi File");
      
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
      this.startMidiButton.setPosition(this.startMidiButtonPausedPosition);
      this.restartMidiButton.setPosition(this.restartMidiButtonPosition);
      this.midiFilesDropdown.setPosition(this.midiFilesDropdownPosition);
    } else {
      background(255);
      this.backButton.setPosition(this.inactivePosition);
      this.loadMidiButton.setPosition(this.inactivePosition); 
      this.startMidiButton.setPosition(this.inactivePosition);
      this.restartMidiButton.setPosition(this.inactivePosition);
      this.midiFilesDropdown.setPosition(this.inactivePosition);
    } 
  }

  public void setVisibility(boolean isVisible, boolean playing_mode){
    if (!playing_mode){
      this.setVisibility((isVisible));
    } else {
      if(isVisible){
        this.backButton.setPosition(this.backButtonPosition);
        this.loadMidiButton.setPosition(this.loadMidiButtonPosition);
        this.restartMidiButton.setPosition(this.restartMidiButtonPosition);
        this.midiFilesDropdown.setPosition(this.midiFilesDropdownPosition);
        this.startMidiButton.setPosition(this.startMidiButtonPausedPosition);
      } else {
        background(255);
        this.backButton.setPosition(this.inactivePosition);
        this.loadMidiButton.setPosition(this.inactivePosition); 
        this.restartMidiButton.setPosition(this.inactivePosition);
        this.midiFilesDropdown.setPosition(this.inactivePosition);
        this.startMidiButton.setPosition(this.startMidiButtonPlayingPosition);
      } 
    }
  }

  public void addListeners(){
    this.backButton.addListener(this.buttonClickListener); 
    this.loadMidiButton.addListener(this.buttonClickListener);
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

  public void drawFilename(){
    if (!this.isPlaying){
      fill(255);
      noStroke();
      rect(this.midiNameTextPosition[0], this.loadMidiButtonPosition[1], this.startMidiButtonPausedPosition[0]-this.midiNameTextPosition[0]-5, this.buttons_height);  
      fill(0);
      textSize(20);
      textAlign(LEFT, CENTER);
      this.midiFilePath = this.midiFilePath != midiLoaderSelectedMIDIFilePath? midiLoaderSelectedMIDIFilePath : this.midiFilePath;
      this.midiFilePath = Utils.safePath(this.midiFilePath);
      String midiFileName = this.midiFilePath.contains("\\") ? this.midiFilePath.substring(this.midiFilePath.lastIndexOf("\\") + 1) : this.midiFilePath;
      text(midiFileName, this.midiNameTextPosition[0], this.midiNameTextPosition[1]);
      }
  }
  
  public void setMidiFilePath(String filePath) {
    this.midiFilePath = filePath;
  }
}
