class enemy {
  float HP;
  PVector epos;
  boolean engaging;
  int stun;
  int CD;
  int wait;
  int shot = 0;
  bullet[] bullets = new bullet[3];
  
  enemy(PVector tpos) {
    epos = tpos;
    engaging = false;
    HP = 2;
    stun = 0;
    CD = 0;
    wait = -1;
    for (int i = 0; i < 3; i++) {
      bullets[i] = new bullet(epos, new PVector(0, 0));
      bullets[i].deactivate();
    }
  }
  
  void move(PVector destination) {
    PVector heading = new PVector(destination.x-epos.x, destination.y-epos.y);
    if (dist(destination.x, destination.y, epos.x, epos.y) > 400 && wait < 0) {
      epos.x += 4*heading.normalize().x;
      epos.y += 4*heading.normalize().y;
      if (dist(destination.x, destination.y, epos.x, epos.y) < 400) {
        epos.x -= 4*heading.normalize().x;
        epos.y -= 4*heading.normalize().y;
      }
    } else if (wait < 0) {
      epos.x -= 2*heading.normalize().x;
      epos.y -= 2*heading.normalize().y;
    }
    if (epos.x < 0) epos.x = 0;
    if (epos.y < -460) epos.y = -460;
    if (epos.y > 563) epos.y = 563;
  }
  
  void display() {
    fill(255);
    stroke(0);
    rectMode(CENTER);
    rect(epos.x, epos.y, 70, 140);
    rectMode(CORNER);
  }
  
  void fire(PVector tgt) {
    stroke(#FF0000);
    if (stun == 0 && (CD == 0 || CD > 180) && dist(tgt.x, tgt.y, epos.x, epos.y) < 450) {
      if (CD == 0) {
        CD = 240;
        wait = 15;
      } else if (CD == 45) {
        bullets[0].deactivate();
      } else if (CD == 30) {
        bullets[1].deactivate();
      } else if (CD == 15) {
        bullets[2].deactivate();
      }
      if (wait == 0 & shot < 3) {
        wait = 15;
        PVector aim = new PVector(tgt.x - epos.x, tgt.y - epos.y);
        bullets[shot] = new bullet(epos, aim.normalize().mult(6));
        
        shot +=1;
        
      } else if (shot == 3) {
        shot = 0;
      }
    }

    wait -= 1;
    if (CD>0) CD -= 1;
    
    

  }
}
