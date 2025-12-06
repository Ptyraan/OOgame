class enemy {
  float HP;
  PVector epos;
  boolean engaging;
  int stun;
  int CD;
  int wait;
  int shot;
  int offset;
  int vfx;
  float r;
  boolean crit;
  PImage esprite;
  PVector KOdirection;
  PVector KOvector;
  PVector Gunvector;
  PVector Helmetvector;
  bullet[] bullets = new bullet[3];
  
  enemy(PVector tpos) {
    epos = tpos;
    engaging = false;
    HP = 2;
    stun = 0;
    CD = int(random(60, 180));
    wait = -1;
    shot = 0;
    vfx = 0;
    crit = false;
    r = random(0, 2*PI);
    offset = int(random(0, 60));
    KOdirection = new PVector(0, 0);
    KOvector = new PVector(0, 0);
    Gunvector = new PVector(0, 0);
    Helmetvector = new PVector(0, 0);
    for (int i = 0; i < 3; i++) {
      bullets[i] = new bullet(epos, new PVector(0, 0));
      bullets[i].deactivate();
    }
    esprite = enemySprites[1];
  }
  
  void move(PVector destination) {
    if (HP > 0 && stun == 0) {
      PVector heading = new PVector(destination.x-epos.x, destination.y-epos.y);
      if ((frameCount + offset)%30 == 0 && wait < -1) {
          esprite = enemySprites[((frameCount + offset)%60)/30];
      }
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
      
      // truck collision
      if (epos.x > tpos && epos.x < tpos + 1134 && epos.y > -320 && epos.y < 270) {
        if (abs(epos.x - tpos) < abs(epos.x - (tpos + 1134))) {
          if (abs(epos.y - -320) < abs (epos.y - 270)) {
            if (abs(epos.x - tpos) < abs(epos.y - -320)) {
              epos.x = tpos;
            } else {
              epos.y = -320;
            }
          } else {
            if (abs(epos.x - tpos) < abs(epos.y - 270)) {
              epos.x = tpos;
            } else {
              epos.y = 270;
            }
          }
        } else {
          if (abs(epos.y - -320) < abs (epos.y - 270)) {
            if (abs(epos.x - (tpos + 1134)) < abs(epos.y - -320)) {
              epos.x = tpos + 1134;
            } else {
              epos.y = -320;
            }
          } else {
            if (abs(epos.x - (tpos + 1134)) < abs(epos.y - 270)) {
              epos.x = tpos + 1134;
            } else {
              epos.y = 270;
            }
          }
        }
      }
    }
    if (stun > 0) stun--;
  }
  
  void display() {
    imageMode(CENTER);
    pushMatrix();
    translate(epos.x, epos.y);
    if (epos.x > pos.x) {
      scale (-1, 1);
    }
    if (HP > 0) {
      if (esprite != null) image(esprite, 0, 0);
      if(wait < -1) {
        rotate(15*PI/180);
        translate(0, 15);
      }
      image(enemyGun, 0, -20);
    } else {
      
      // knockout animation
      if (epos.x > pos.x) {
        scale (-1, 1);
      }
      KOvector.x += 15*KOdirection.x;
      Gunvector.x += 13*KOdirection.x;
      Helmetvector.x += 14*KOdirection.x;
      KOvector.y += 15*KOdirection.y;
      Gunvector.y += 13*KOdirection.y;
      Helmetvector.y += 18*KOdirection.y;
      
      pushMatrix();
      translate(KOvector.x, KOvector.y);
      if (KO != null) image(KO, 0, 0);
      popMatrix();
      pushMatrix();
      translate(Helmetvector.x, Helmetvector.y);
      if (helmet != null) image(helmet, 0, 0);
      popMatrix();
      pushMatrix();
      translate(Gunvector.x, Gunvector.y);
      if (enemyGun != null) image(enemyGun, 0, 0);
      popMatrix();

    }
    popMatrix();

    imageMode(CORNER);
    pushMatrix();
    translate(epos.x, epos.y);
    tint(255, vfx);
    rotate(r);
    imageMode(CENTER);
    if (crit) image(critMarker, 0, 0);
    if (!crit) image(hitMarker, 0, 0);
    imageMode(CORNER);
    tint(255, 255);
    if (vfx > 0) vfx -= 3;
    popMatrix();
  }
  
  void fire(PVector tgt) {
    if (HP > 0 && stun == 0) {
      stroke(#FF0000);
      if (stun == 0 && (CD == 0 || CD > 180) && dist(tgt.x, tgt.y, epos.x, epos.y - 20) < 750) {
        if (CD == 0) {
          CD = 240;
          wait = 15;
          esprite = enemySprites[2];
        } else if (CD == 45) {
          bullets[0].deactivate();
        } else if (CD == 30) {
          bullets[1].deactivate();
        } else if (CD == 15) {
          bullets[2].deactivate();
        }
        if (wait == 0 & shot < 3) {
          wait = 15;
          PVector aim = new PVector(tgt.x - epos.x, tgt.y - epos.y - 20);
          if (tgt.x < epos.x) {
            bullets[shot] = new bullet(new PVector(epos.x-30, epos.y-20), aim.normalize().mult(6));
            shot +=1;
          } else if (tgt.x > epos.x) {
            bullets[shot] = new bullet(new PVector(epos.x+30, epos.y-20), aim.normalize().mult(6));
            shot +=1;
          }
        } else if (shot == 3) {
          shot = 0;
        }
      }
      wait -= 1;
      if (CD>0) CD -= 1;
    }
  }
  
  void hit(int dmg) {
    HP -= dmg;
    stun = 20;
    if (dmg == 1 && HP + dmg > 0) {
      vfx = 255;
      crit = false;
      r = random(0, 2*PI);
    }
    if (dmg == 2 && HP + dmg > 0) {
      vfx = 320;
      crit = true;
      r = random(0, 2*PI);
    }
    if (HP <= 0) {
      KOdirection = new PVector(epos.x - pos.x, epos.y - pos.y);
      KOdirection.normalize();
    }
  }
  

}

void spawnEnemy(PVector epos) {
  enemies[count] = new enemy(epos);
  count ++;
}
