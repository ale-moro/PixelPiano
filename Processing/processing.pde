import java.util.Arrays;
import controlP5.*;
import oscP5.*;
import javax.sound.midi.*;

boolean isPlaying = false;
boolean beginner = false;
boolean octaveUpLimits = false;
boolean octaveDownLimits = false;

color[] pastelColors = new color[15];
int[] octaves = {3, 4, 5};
int shift = 0;
int[] notesInput = new int[5];
int[] notesOutput = new int[5];
float[] coordinates = new float[10];
int[] pressedSens = new int[5];

StartPage startPage;
PlayPage playPage;
ControlP5 cp5;
OscP5 oscP5;
OscMsg msgClass;

MidiDevice.Info[] midiDeviceInfo;
MidiDevice midiOutputDevice;
Receiver midiReceiver;
int prevValue = 0;

void setup() {
  fullScreen();
  // Classes initialization
  cp5 = new ControlP5(this);
  msgClass = new OscMsg();
  oscP5 = new OscP5(this, 12000);
  startPage = new StartPage();
  playPage = new PlayPage();
  msgClass.selectMidiOutput("virtualPort");
  
  // Pastel Colors generator
  for (int i = 0; i < pastelColors.length; i++) {
    pastelColors[i] = color(random(200, 255), random(200, 255), random(200, 255));
  }
}


void draw() { 
  background(255);
  if(!isPlaying) startPage.draw();
  playPage.draw(isPlaying);
}
