class Fingers{
  int[] noteToPlay = new int[5];
  public int[] conversion(int[] fingers, int shift){
    
    for(int i = 0; i< fingers.length; i++){
      noteToPlay[i] = fingers[i]%36 + shift; //<>//
    }
    
    return noteToPlay;
    
  }
  
}
