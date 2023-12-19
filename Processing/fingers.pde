class Fingers{
  int[] noteToPlay = new int[5];
  int[] toPlay = new int[5];
  int[] prev = new int[5];
  
  public int[] conversion(int[] fingers, int[] sensors, int shift){
    
    for(int i = 0; i< fingers.length; i++){
      //println("conversione out: " + noteToPlay[i]);
        if(noteToPlay[i] == 0){
          //println("conversione in: " + noteToPlay[i]);
          noteToPlay[i] = -1;
        }else{
          noteToPlay[i] = fingers[i]%36 + shift;
          if(noteToPlay[i] < 0){ 
            noteToPlay[i] += 36;
          }else if( noteToPlay[i] >= 36){
            noteToPlay[i] -= 36;
          }
        
      }
 //<>//

    }
    
    
    toPlay = pressedKeys(noteToPlay, sensors);
    
    //println(temp);
    for(int i = 0; i < toPlay.length; i++){
      //println(toPlay[i]);
      if(toPlay[i]!=-1 && toPlay[i] != prev[i]){
        //println("im in");
        msgClass.sendNoteOn(toPlay[i] + 24);
      }else{
        for(int j=0; j < toPlay.length;j++){
          if(!keyboard.contains(toPlay, prev[j])){
            msgClass.sendNoteOff(prev[j] + 24);
          }
        }
        
      }
    }
    prev = toPlay;
    return toPlay;
    
  }
  
  public void positions(float[] coords){
    int j=0;
    for(int i = 0; i < coords.length; i+=2){
     
      j=i;
      if(i==0){
        // Finger 1
        fill(color(255,0,0));
      }else if(i==2){
        // Finger 2
        fill(color(138,43,226));
      }else if(i==4){
        // Finger 3
        fill(color(255,255,0));
      }else if(i==6){
        // Finger 4
        fill(color(0,143,57));
      }else{
        // Finger 5
        fill(color(0,51,153));
      }
      
      ellipse(coords[j]*width, coords[j+1]*height, 20,20);
    
    }    
    
  }
  
  
  public int[] pressedKeys(int[] notesIn, int[] sensors){
    
    int[] pressed = {-1,-1,-1,-1,-1};
    int j = 0;
    
    for(int i=0; i<sensors.length; i++){
        if(sensors[i]>0){
          pressed[j] = notesIn[i];
          j++;
        }
    }
    
    //println(pressed);
    //println(notesIn);
    
        
    return pressed;
      
  }
  
 
}
