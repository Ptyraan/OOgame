class bullet{
  PVector bpos, v;
  boolean active;
  
  bullet(PVector tpos, PVector tv) {
    bpos = tpos;
    v = tv;
    active = true;
  }
  
  void fly() {
    bpos = new PVector(bpos.x+v.x, bpos.y+v.y);
    if (bpos.x > tpos+50 && bpos.x < tpos+1134-50 && bpos.y > -250 && bpos.y < 200) active = false;
  }
  
  boolean hit(PVector tgt) {
    if (abs(bpos.x-tgt.x) < 35 && abs(bpos.y-tgt.y) < 70 && active) {
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
    if (active) ellipse(bpos.x, bpos.y, 10, 10);
  }
}
