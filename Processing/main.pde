import java.util.Arrays;
import controlP5.*;
import oscP5.*;
import javax.sound.midi.*;

int pianoHeight;
boolean isPlaying = false;
boolean beginner = false;
boolean isMouseOverButton = false;
boolean octaveUpLimits = false;
boolean octaveDownLimits = false;
int[] blackKeys = {1,3, 6, 8, 10, 13, 15,18,20,22,25,27,30,32,34};
int[] blackKeysInit = {1,2,4,5,6,8,9,11,12,13};
int[] whiteKeys = {0,2,4,5,7,9,11,12,14,16,17,19,21,23,24,26,28,29,31,33,35};
color[] pastelColors = new color[15];
int[] octaves = {3,4,5};
int shift = 0;
int[] notesInput = new int[5];
int[] notesOutput = new int[5];


Piano keyboard;
Start initialization;
Fingers fingers;
ControlP5 cp5;
OscP5 oscP5;
OscMsg msgClass;

Knob myKnob;
Slider myFader;
Button octaveUp;
Button octaveDown;
Button mode;
Button back;

MidiDevice.Info[] midiDeviceInfo;
MidiDevice midiOutputDevice;
Receiver midiReceiver;
int prevValue = 0;


void setup() {
  fullScreen();
  
  // Classes initialization
  initialization = new Start();
  keyboard = new Piano();
  cp5 = new ControlP5(this);
  fingers = new Fingers();
  msgClass = new OscMsg();
  oscP5 = new OscP5(this, 12000);
  
  
  msgClass.selectMidiOutput("virtualPort");
  pianoHeight = height / 3;
  
  // Pastel Colors generator
  for (int i = 0; i < pastelColors.length; i++) {
    pastelColors[i] = color(random(200, 255), random(200, 255), random(200, 255));
  }
  
  
  
  // Knob
  myKnob = cp5.addKnob("myKnob")
            .setRange(0, 100)
            .setValue(0) // Mappare valore nel range e settare value
            .setPosition(width*11/60, height*5/30)
            .setRadius(80)
            .setNumberOfTickMarks(10)
            .setColorForeground(color(200))
            .setColorBackground(color(0))
            .setVisible(false)
            .setColorActive(color(200));
            
  myKnob.getCaptionLabel().setVisible(false);
  
  // Fader
  myFader = cp5.addSlider("mySlider")
              .setRange(0, 100)
              .setValue(10)
              .setPosition(width*28/60 -10, height*5/30)
              .setSize(60,160)
              .setColorForeground(color(200))
              .setColorBackground(color(0))
              .setVisible(false)
              .setColorActive(color(200));
              
  myFader.getCaptionLabel().setVisible(false);

  // Buttons
  PFont customFont1 = createFont("Monospaced", 20);
  octaveUp = cp5.addButton("octaveUp")
             .setPosition(3*width/5 + width/8 + 90,height*5/30 + 110)
             .setSize(60,60)
             .setColorBackground(color(0))
             .setColorForeground(color(50))
             .setVisible(false)
             .setColorActive(color(50));
             
  octaveUp.setLabel("+");
  octaveUp.getCaptionLabel().setFont(customFont1);
  
  octaveDown = cp5.addButton("octaveDown")
                  .setPosition(3*width/5 + width/8, height*5/30 + 110)
                  .setSize(60,60)
                  .setColorBackground(color(0))
                  .setColorForeground(color(50))
                  .setVisible(false)
                  .setColorActive(color(50));
               
  octaveDown.setLabel("-");
  octaveDown.getCaptionLabel().setFont(customFont1);
  
  PFont customFont = createFont("Monospaced", 20);
  mode = cp5.addButton("mode")
            .setPosition(3*width/5 + width/8 + 16 ,height*5/30 - 15)
            .setSize(120,60)
            .setColorBackground(color(0))
            .setColorForeground(color(50))
            .setVisible(false)
            .setColorActive(color(50));
            
  mode.setLabel("Expert");
  mode.getCaptionLabel().setFont(customFont);
  
  back = cp5.addButton("back")
          .setPosition(9*width/10 + 5, 9*height/10)
          .setSize(width/15,40)
          .setColorBackground(color(0))
          .setColorForeground(color(50))
          .setVisible(false)
          .setColorActive(color(50));
  
  back.setLabel("Back");
  back.getCaptionLabel().setFont(customFont);
  
            
  // Listeners
  back.addListener(new ButtonClickListener());
  mode.addListener(new ButtonClickListener());
  octaveUp.addListener(new ButtonClickListener());
  octaveDown.addListener(new ButtonClickListener());
  myFader.addListener(new ButtonClickListener());

        
}

void draw() {
  background(255);
  
  if(!isPlaying){ //<>//
    keyboard.drawPianoInit();
    initialization.drawText();
    initialization.drawPlayButton();
    myKnob.setVisible(false);
    myFader.setVisible(false);
    octaveUp.setVisible(false);
    octaveDown.setVisible(false);
    mode.setVisible(false);
    back.setVisible(false);

  }else{ //<>//
    notesOutput = fingers.conversion(notesInput, shift);
    keyboard.drawPianoPlay(notesOutput);
    keyboard.drawBox();
    myKnob.setVisible(true);
    myFader.setVisible(true);
    octaveUp.setVisible(true);
    octaveDown.setVisible(true);
    mode.setVisible(true);
    back.setVisible(true);
    

    if(!beginner){
      keyboard.writeNoteLabels(octaves,1);
    }else{
      keyboard.writeNoteLabels(octaves,0);
    }

  }

}


void oscEvent(OscMessage msg) {
    try {
      if (msg.checkAddrPattern("/note_numbers")) {
        int argumentCount = msg.arguments().length; // Get the number of arguments in the message
        int[] receivedValues = new int[argumentCount]; 
  
        for (int i = 0; i < argumentCount; i++) {
            int receivedValue = msg.get(i).intValue();
            receivedValues[i] = receivedValue;
            }
        //print("Received values: ");
        //for (int i = 0; i < receivedValues.length; i++) {
        //  print(receivedValues[i] + " ");
        //}
        //println();
        int noteNumber = receivedValues[1];
        notesInput = receivedValues;
        
        if(noteNumber!= 0 && noteNumber != prevValue){
        //msgClass.sendNoteOff(prevValue);
        //print("Sending note on of index finger: " + noteNumber+"\n");
        //msgClass.sendNoteOn(noteNumber);
        }
        prevValue = noteNumber;
      } else {
        println("Error: Unexpected OSC address pattern.");
      }
    } catch (Exception e) {
      println("Error handling OSC message: " + e.getMessage());
      e.printStackTrace();
    }
    
  }

void mousePressed() {

  if (!isPlaying) {

      println("Play pressed. Start playing.");
      isPlaying = true;
      background(0,0);   
    }
}


class ButtonClickListener implements ControlListener {
  public void controlEvent(ControlEvent event) {
    
    // Back Listener
    if (event.isController() && event.getController().getName().equals("back")){
        isPlaying = false;
        fill(200);
        rect(9*width/10 +5, height*9/10, width/15 +10, 50,10);
    }
    
    // OctaveUp listener
    if (event.isController() && event.getController().getName().equals("octaveUp")){
        for (int i = 0; i < octaves.length; i++) {
          if(octaves[1] < 6){
            octaves[i]++;
             
          }else{
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
    
    // OctaveDown listener
    if (event.isController() && event.getController().getName().equals("octaveDown")){
        for (int i = 0; i < octaves.length; i++) {
          if(octaves[0] > 2 ){
            octaves[i]--;
          }else{
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
    
    // Mode listener
    if (event.isController() && event.getController().getName().equals("mode")){
        if(!beginner){
            mode.setLabel("Beginner");
            beginner = true;
        }else{
            mode.setLabel("Expert");
            beginner = false;
        }
        
        fill(200);
        rect(3*width/5 + width/8 + 15, height*5/30 -15, 130, 70, 10);
    
    }
    
    // Fader listener
    if (event.isController() && event.getController().getName().equals("mySlider")){}
  }
}
