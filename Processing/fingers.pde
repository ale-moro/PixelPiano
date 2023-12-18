class Fingers{
  int[] noteToPlay = new int[5];
  int[] temp = new int[5];
  
  int[] conversion(int[] fingers, int shift){
    
    for(int i = 0; i< fingers.length; i++){
      noteToPlay[i] = fingers[i]%36 + shift; //<>//
    }
    
    return noteToPlay;
    
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
      
      ellipse(coords[j]*width, coords[j+1]*height, 15,15);
    
    }    
    
  }
  
  
  public int[] pressedKeys(int[] notes, int[] sensors, int shift){
    
    int[] pressed = new int[5];
    int j = 0;
    
    for(int i=0; i<sensors.length; i++){
        if(sensors[i]>10){
          pressed[j] = notes[i];
          j++;
        }
    }
    
    println(pressed);
    temp = conversion(pressed, shift);
        
    return temp;
      
  }
  
 
}
