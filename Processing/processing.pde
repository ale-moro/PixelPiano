import java.util.Arrays;
import java.util.Optional;
import controlP5.*;
import oscP5.*;
import javax.sound.midi.*;

int activePageIndex = START_PAGE_INDEX;
Page activePage;
boolean beginner = false;

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
ButtonClickListener buttonClickListener;
NavigationController navigationController;


MidiDevice.Info[] midiDeviceInfo;
MidiDevice midiOutputDevice;
Receiver midiReceiver;
int prevValue = 0;

color[] pastelColors = new color[15];
PFont customFont;


void setup() {
  fullScreen();
  // Pastel Colors generator
  for (int i = 0; i < pastelColors.length; i++) {
    pastelColors[i] = color(random(200, 255), random(200, 255), random(200, 255));
  }
  
  // Fonts
  customFont = createFont("Monospaced", 20);

  // Classes initialization
  cp5 = new ControlP5(this);
  buttonClickListener = new ButtonClickListener();
  navigationController = new NavigationController();
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
