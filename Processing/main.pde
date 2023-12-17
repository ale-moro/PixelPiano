import java.util.Arrays;
import controlP5.*;

int pianoHeight;
boolean isPlaying = false;
boolean beginner = false;
int[] blackKeys = {1, 2, 4, 5, 6, 8, 9, 11, 12, 13, 15, 16, 18, 19, 20};
color[] pastelColors = new color[15];
int[] octaves = {3,4,5};

Piano keyboard;
Start initialization;
Fingers fingers;
ControlP5 cp5;

Knob myKnob;
Slider myFader;
Button octaveUp;
Button octaveDown;
Button mode;
Button back;
Button startBut;



void setup() {
  fullScreen();
  
  // Classes initialization
  initialization = new Start();
  keyboard = new Piano();
  cp5 = new ControlP5(this);
  fingers = new Fingers();
  
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
            .setColorForeground(color(150))
            .setColorBackground(color(0))
            .setVisible(false)
            .setLock(true)
            .setColorActive(color(150));
            
  myKnob.getCaptionLabel().setVisible(false);
  
  // Fader
  myFader = cp5.addSlider("mySlider")
              .setRange(0, 100)
              .setValue(10)
              .setPosition(width*28/60 -10, height*5/30)
              .setSize(60,160)
              .setColorForeground(color(150))
              .setColorBackground(color(0))
              .setVisible(false)
              .setLock(true)
              .setColorActive(color(150));
              
  myFader.getCaptionLabel().setVisible(false);

  // Buttons
  PFont customFont1 = createFont("Monospaced", 20);
  octaveUp = cp5.addButton("octaveUp")
             .setPosition(3*width/5 + width/8 + 90,height*5/30 + 110)
             .setSize(60,60)
             .setColorBackground(color(0))
             .setColorForeground(color(50))
             .setVisible(false)
             .setLock(true)
             .setColorActive(color(50));
             
  octaveUp.setLabel("+");
  octaveUp.getCaptionLabel().setFont(customFont1);
  
  octaveDown = cp5.addButton("octaveDown")
                  .setPosition(3*width/5 + width/8, height*5/30 + 110)
                  .setSize(60,60)
                  .setColorBackground(color(0))
                  .setColorForeground(color(50))
                  .setVisible(false)
                  .setLock(true)
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
            .setLock(true)
            .setColorActive(color(50));
            
  mode.setLabel("Expert");
  mode.getCaptionLabel().setFont(customFont);
  
  back = cp5.addButton("back")
          .setPosition(9*width/10 + 5, 9*height/10)
          .setSize(width/15,40)
          .setColorBackground(color(0))
          .setColorForeground(color(50))
          .setVisible(false)
          .setLock(true)
          .setColorActive(color(50));
  
  back.setLabel("Back");
  back.getCaptionLabel().setFont(customFont);
  
  startBut = cp5.addButton("startBut")
            .setPosition(width / 2 - 150 / 2, height / 3 + height / 6 - 60)
            .setSize(150,60)
            .setColorBackground(color(0))
            .setColorForeground(color(50))
            .setVisible(false)
            .setLock(true)
            .setColorActive(color(50));
  
  startBut.setLabel("Play");
  startBut.getCaptionLabel().setFont(customFont);
            
  // Listeners
  back.addListener(new ButtonClickListener());
  mode.addListener(new ButtonClickListener());
  octaveUp.addListener(new ButtonClickListener());
  octaveDown.addListener(new ButtonClickListener());
  myFader.addListener(new ButtonClickListener());
  startBut.addListener(new ButtonClickListener());
        
}

void draw() {
  background(255);
  
  if(!isPlaying){ //<>//
    keyboard.drawPianoInit();
    initialization.drawText();
    initialization.drawPlayButton();
    startBut.setVisible(true);
    startBut.setLock(false);
  
  }else{ //<>//
    keyboard.drawPianoPlay();
    keyboard.drawBox();
    myKnob.setVisible(true);
    myKnob.setLock(false);
    myFader.setVisible(true);
    myFader.setLock(false);
    octaveUp.setVisible(true);
    octaveUp.setLock(false);
    octaveDown.setVisible(true);
    octaveDown.setLock(false);
    mode.setVisible(true);
    mode.setLock(false);
    back.setVisible(true);
    back.setLock(false);
    startBut.setVisible(false);
    startBut.setLock(true);

    
    if(!beginner){
      keyboard.writeNoteLabels(octaves,1);
    }else{
      keyboard.writeNoteLabels(octaves,0);
    }

  }

}


class ButtonClickListener implements ControlListener {
  public void controlEvent(ControlEvent event) {
    
    // Back Listener
    if (event.isController() && event.getController().getName().equals("back")){
        isPlaying = false;
        fill(255);
        rect(9*width/10 +5, height*9/10, width/15 +10, 50,10);
        myKnob.setVisible(false);
        myFader.setVisible(false);
        octaveUp.setVisible(false);
        octaveDown.setVisible(false);
        mode.setVisible(false);
        back.setVisible(false);
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
        fill(255);
        rect(3*width/5 + width/8 + 90,height*5/30 + 110, 70, 70, 10);
        
    }
    
    // OctaveDown listener
    if (event.isController() && event.getController().getName().equals("octaveDown")){
        for (int i = 0; i < octaves.length; i++) {
          if(octaves[1] > 1){
            octaves[i]--;
          }else{
            octaves[0] = 1;
            octaves[1] = 2;
            octaves[2] = 3;
          }
        }
        
        fill(255);
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
        
        fill(255);
        rect(3*width/5 + width/8 + 15, height*5/30 -15, 130, 70, 10);
    
    }
    
    // Start listener
    if (event.isController() && event.getController().getName().equals("startBut")){
        isPlaying = true;
        startBut.setVisible(false);
        fill(255);
        rect(width / 2 - 150 / 2, height / 3 + height / 6 - 60, 160, 70, 10);
    }
    
    // Fader listener
    if (event.isController() && event.getController().getName().equals("mySlider")){}
  }
}
