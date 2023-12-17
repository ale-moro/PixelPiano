import java.util.Arrays;
import controlP5.*;
int pianoHeight;
boolean isPlaying = false;
boolean beginner = false;
int[] blackKeys = {1, 2, 4, 5, 6, 8, 9, 11, 12, 13, 15, 16, 18, 19, 20};
boolean isMouseOverButton = false;
color[] pastelColors = new color[15];
int[] octaves = {3,4,5};
Piano keyboard;
Start initialization;
ControlP5 cp5;
Knob myKnob;
Slider myFader;
Button octaveUp;
Button octaveDown;
Button mode;



void setup() {
  fullScreen();
  pianoHeight = height / 3;
  initialization = new Start();
  keyboard = new Piano();
  cp5 = new ControlP5(this);
   
  for (int i = 0; i < pastelColors.length; i++) {
    pastelColors[i] = color(random(200, 255), random(200, 255), random(200, 255));
  }
  
  myKnob = cp5.addKnob("myKnob")
            .setRange(0, 100)
            .setValue(0) // Mappare valore nel range e settare value
            .setPosition(width*11/60, height*5/30)
            .setRadius(80)
            .setNumberOfTickMarks(10)
            .setColorForeground(color(150))
            .setColorBackground(color(0))
            .setColorActive(color(150));
            
  myKnob.getCaptionLabel().setVisible(false);
            
  myFader = cp5.addSlider("mySlider")
              .setRange(0, 100)
              .setValue(10)
              .setPosition(width*28/60 -10, height*5/30)
              .setSize(60,160)
              .setColorForeground(color(150))
              .setColorBackground(color(0))
              .setColorActive(color(150));
              
  myFader.getCaptionLabel().setVisible(false);

  
  PFont customFont1 = createFont("Monospaced", 20);
  octaveUp = cp5.addButton("octaveUp")
             .setPosition(3*width/5 + width/8 + 90,height*5/30 + 110)
             .setSize(60,60)
             .setColorBackground(color(0))
             .setColorForeground(color(150))
             .setColorActive(color(150));
             
  octaveUp.setLabel("+");
  octaveUp.getCaptionLabel().setFont(customFont1);
  
  octaveDown = cp5.addButton("octaveDown")
                  .setPosition(3*width/5 + width/8, height*5/30 + 110)
                  .setSize(60,60)
                  .setColorBackground(color(0))
                  .setColorForeground(color(150))
                  .setColorActive(color(150));
               
  octaveDown.setLabel("-");
  octaveDown.getCaptionLabel().setFont(customFont1);
  
  PFont customFont = createFont("Monospaced", 20);
  mode = cp5.addButton("mode")
            .setPosition(3*width/5 + width/8 + 16 ,height*5/30 - 15)
            .setSize(120,60)
            .setColorBackground(color(0))
            .setColorForeground(color(150))
            .setColorActive(color(150));
            
  mode.setLabel("Expert");
  mode.getCaptionLabel().setFont(customFont);
  
                  
            
            
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
    
  }else{ //<>//
    keyboard.drawPianoPlay();
    keyboard.drawBox();
    myKnob.setVisible(true);
    myFader.setVisible(true);
    octaveUp.setVisible(true);
    octaveDown.setVisible(true);
    mode.setVisible(true);
    
    if(!beginner){
      keyboard.writeNoteLabels(octaves,1);
    }else{
      keyboard.writeNoteLabels(octaves,0);
    }

  }

}



void mousePressed() {
  float buttonWidth = 150;
  float buttonHeight = 60;
  float buttonX = width / 2 - buttonWidth / 2;
  float buttonY = height / 3 + height / 6 - buttonHeight / 2;

  // Controlla se il mouse è sopra il pulsante Play
  if (isMouseOverButton && mouseX >= buttonX && mouseX <= buttonX + buttonWidth && mouseY >= buttonY && mouseY <= buttonY + buttonHeight) {
    // Cambia il colore del pulsante quando viene premuto
    fill(150);  // Colore del pulsante durante il clic
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 10);
    
    // Esegui azioni aggiuntive in base allo stato di riproduzione (play/pause)
    if (isPlaying) {

    } else {
      // Aggiungi azioni per l'inizio della riproduzione
      println("Play pressed. Start playing.");
      isPlaying = true;
      background(0,0);
      
    }
  }
}


void mySlider(float value){
  
}

void octaveUp() {
  println("octaveUp pressed!");
  for (int i = 0; i < octaves.length; i++) {
    octaves[i]++;
  }
}

void octaveDown() {
  println("octaveDown pressed!");
  for (int i = 0; i < octaves.length; i++) {
    octaves[i]--;
  }
}

void mode(){
   
  if(!beginner){
      mode.setLabel("Beginner");
      beginner = true;
      
  
  }else{
      mode.setLabel("Expert");
      beginner = false;
  }
  
}
