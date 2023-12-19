class Fingers{
  int[] noteToPlay = new int[5];
  int[] toPlay = new int[5];
  int[] prev = new int[5];
  
  public int[] conversion(int[] fingers, int[] sensors, int[] prevSensors, int shift){
    for(int i = 0; i< fingers.length; i++){
      noteToPlay[i] = fingers[i]%36 + shift; //<>//
      if(noteToPlay[i] < 0){ 
        noteToPlay[i] += 36;
      }else if( noteToPlay[i] >= 36){
        noteToPlay[i] -= 36;
      }
    }

    temp = pressedKeys(noteToPlay, sensors, prevSensors);

    for(int i = 0; i < temp.length; i++){
      if(temp[i]!=-1){
        msgClass.sendNoteOn(temp[i] + 24);
      } else {
        // msgClass.sendNoteOff(temp[i] + 24);
      }
    }
    return temp;

  }
  
  public void positions(float[] coords){
    int j=0;
    for(int i = 0; i < coords.length; i+=2){
      j=i;
      if(i==0){
        // Finger 1
        fill(color(255,0,0));
      } else if(i==2){
        // Finger 2
        fill(color(138,43,226));
      } else if(i==4){
        // Finger 3
        fill(color(255,255,0));
      } else if(i==6){
        // Finger 4
        fill(color(0,143,57));
      } else {
        // Finger 5
        fill(color(0,51,153));
      }

      ellipse(coords[j]*width, coords[j+1]*height, 15,15);
    }      

  }
  
  
  public int[] pressedKeys(int[] notesIn, int[] sensors, int[] prevSensors){
    int[] pressed = {-1,-1,-1,-1,-1};
    int j = 0;
    print("sensors: ");
    for(int i=0; i<sensors.length; i++){
        print(" ", sensors[i]);
        if(sensors[i]>40 && sensors[i] > prevSensors[i]){
          pressed[j] = notesIn[i];
          print("ok");
          j++;
        }
    }  
    print("\n");
    return pressed; 
  }
}
