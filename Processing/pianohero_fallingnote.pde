class FallingNote {
  float x, y;
  float width, rectHeight;
  float speed;
  boolean bw;
  color whiteC;
  color blackC;

  FallingNote(float x, float y, float width, float rectHeight, float speed, boolean bw) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.rectHeight = rectHeight;
    this.speed = speed;
    this.bw = bw;
    this.whiteC = color(0,0,128);
    this.blackC = color(0,0,255);
  }

  void draw() {
    if (!bw){      
      fill(blackC);
      stroke(0, 196, 0);
    }
    else{
      fill(whiteC);
      stroke(0, 128, 0);
    }
     
    rect(x, y, width, rectHeight, 10);
  }

  void update() {
    y += speed;
  }
  
  float getX(){
    return this.x;
  }
  
  boolean updateHeight() {
   if(this.rectHeight > 0){
     this.rectHeight -= speed;
   }else{
     return true;
   }
   return false;
  }
  
  void colorChange(boolean correct){
    if(correct){
      whiteC = color(0,255,0);
      blackC = color(0,255,50);
    }else{
      whiteC = color(255,0,0);
      blackC = color(255,50,0);
    }
  }

  boolean isOffScreen() {
    return y +rectHeight > height/2 - 3;
  }
}
    
