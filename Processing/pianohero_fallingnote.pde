class FallingNote {
  float x, y;
  float width, rectHeight;
  float speed;

  FallingNote(float x, float y, float width, float rectHeight, float speed) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.rectHeight = rectHeight;
    this.speed = speed;
  }

  void draw() {
    fill(0,255,0);
    rect(x, y, width, rectHeight, 10);
  }

  void update() {
    y += speed;
  }

  boolean isOffScreen() {
    return y > height/2;
  }
}
    