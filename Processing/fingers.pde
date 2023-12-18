class Fingers{
  int[] noteToPlay = new int[5];
  public int[] conversion(int[] fingers, int shift){
    
    for(int i = 0; i< fingers.length; i++){
      noteToPlay[i] = fingers[i]%36 + shift; //<>//
    }
    
    return noteToPlay;
    
  }
  
    public void positions(float[][] coords){
      
    
    // Finger 1
    fill(color(255,0,0));
    ellipse(coords[0][0]*width, coords[0][1]*height, 10,10);
    
    // Finger 2
    fill(color(138,43,226));
    ellipse(coords[1][0]*width, coords[1][1]*height, 10, 10);
    
    // Finger 3
    fill(color(255,255,0));
    ellipse(coords[2][0]*width, coords[2][1]*height, 10,10);
    
    // Finger 4
    fill(color(0,143,57));
    ellipse(coords[3][0]*width,coords[3][1]*height,10,10);
    
    // Finger 5
    fill(color(0,51,153));
    ellipse(coords[4][0]*width, coords[4][1]*height, 10,10);
    
    
  
  }
}
