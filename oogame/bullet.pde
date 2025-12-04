class bullet{
  PVector pos, v;
  boolean active;
  
  bullet(PVector tpos, PVector tv) {
    pos = tpos;
    v = tv;
    active = true;
  }
  
  void fly() {
    pos.x += v.x;
    pos.y += v.y;
  }
  
  boolean hit(PVector tgt) {
    if (abs(pos.x-tgt.x) < 35 && abs(pos.y-tgt.y) < 70 && active) {
      return true;
    } else {
      return false;
    }
  }
  
  void deactivate() {
    active = false;
  }
  
  void display() {
    fill(255);
    stroke(255, 0, 0);
    ellipse(pos.x, pos.y, 10, 10);
  }
}
