class enemy {
  float HP;
  PVector pos;
  boolean engaging;
  
  
  enemy(PVector tpos) {
    pos = tpos;
    engaging = false;
    HP = 2;
  }
  
  void move(PVector destination) {
    if (pow(destination.x-pos.x, 2) + pow(destination.y-pos.y, 2) > 600) {
      
    } else {
      
    }
  }
  
  void fire() {
  
  }
}
