import java.util.Arrays;
import java.util.Optional;
import controlP5.*;
import oscP5.*;
import javax.sound.midi.*;

int activePageIndex = START_PAGE_INDEX;
Page activePage;

int[] octaves = {3, 4, 5};
int shift = 0;
int[] notesInput = new int[5];
int[] notesOutput = new int[5];
float[] coordinates = new float[10];
int[] pressedSens = new int[5];

StartPage startPage;
ModeSelectionPage modeSelectionPage;
PlayPage freePlayPage;
PianoHeroPage pianoHeroPage;
ControlP5 cp5;
OscP5 oscP5;
OscMsg msgClass;
NavigationController navigationController;
StyleManager styleManager;

MidiDevice.Info[] midiDeviceInfo;
MidiDevice midiOutputDevice;
Receiver midiReceiver;
int prevValue = 0;

// color[] pastelColors = new color[15];
color[] pastelColors = { #EAE4E9, #FFF1E6, #FDE2E4, #FAD2E1, #E2ECE9,
                          #BEE1E6, #F0EFEB, #DFE7FD, #EAE4E9, #FFF1E6, #FDE2E4, #FAD2E1, #E2ECE9,
                          #BEE1E6, #F0EFEB, #DFE7FD }; 


String midiLoaderSelectedMIDIFilePath = "";


void setup() {
  fullScreen();
  // // Pastel Colors generator
  // for (int i = 0; i < pastelColors.length; i++) {
  //   pastelColors[i] = color(random(200, 255), random(200, 255), random(200, 255));
  // }
  // Fonts

  // Classes initialization
  cp5 = new ControlP5(this);
  navigationController = new NavigationController();
  styleManager = new StyleManager();
  msgClass = new OscMsg();
  oscP5 = new OscP5(this, 12000);
  startPage = new StartPage();
  modeSelectionPage = new ModeSelectionPage();
  freePlayPage = new PlayPage();
  pianoHeroPage = new PianoHeroPage();
  msgClass.selectMidiOutput("virtualPort");
  activePage = startPage;
}

void draw() { 
  background(255);
  activePage.draw();
}
