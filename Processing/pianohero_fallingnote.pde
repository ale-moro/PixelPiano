class FallingNote {
  float x, y;
  float width, rectHeight;
  float speed;
  boolean bw;

  FallingNote(float x, float y, float width, float rectHeight, float speed, boolean bw) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.rectHeight = rectHeight;
    this.speed = speed;
    this.bw = bw;
  }

  void draw() {
    if (!bw){      
      fill(0,255,0);
      stroke(0, 196, 0);
    }
    else{
      fill(0,180,0);
      stroke(0, 128, 0);
    }
     
    rect(x, y, width, rectHeight, 10);
  }

  void update() {
    y += speed;
  }

  boolean isOffScreen() {
    return y > height/2;
  }
}
    
