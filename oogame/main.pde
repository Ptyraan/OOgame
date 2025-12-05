int gamestate = 2;
int winCountdown = 300;
int loseCountdown = 120;
int win = 0;
int lose = 0;
/* gamestate index
 0 menu
 1 instructions
 2 game
 3 win
 4 lose
*/

int lives = 3;
int ammo = 2;
boolean reload = true;
boolean ADS = false;
boolean held = false;
PVector pos = new PVector(230, -460);
float speed = 5;

boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;

int sprite = 1;
int animateBy = 7;
boolean walking = false;
int legDirection = 1;
boolean firing = false;
int fireAni = 0;
PVector firePos;
float fireAngle;
int fireCD = 0;
PVector tgt;
float rotation1 = random(0, 2*PI);
float rotation2 = random(0, 2*PI);
int expression = 0;
int duration;
int muzzleFlash = 0;
int dispersion = 0;

PImage troll;
PImage gun;
PImage fire;

PImage barrel;
PImage shell;
PImage gunUI;
PImage flavour;
PImage flavourText;
PImage portrait;
PImage preview;
PImage arrow;

PImage road;
PImage barricade;
PImage house;

PImage[] enemySprites = new PImage[3];
PImage enemyGun;
PImage critMarker;
PImage hitMarker;
PImage truck;
int tpos = 300;
float tv = 0;
int thp = 30;
PVector truckHit = new PVector (-1000, -1000);
int truckHitMarker = 0;
float truckHitRotation = random(0, 2*PI);
float reinforcements = 1;
int reinforcementCountdown = 240;
int timer = 5400;

PImage W;
PImage L;
int blackScreen = 255;

int chunks = 1;
int count = 0;
enemy[] enemies = new enemy[999];

void setup() {
  size(1920, 1080, P2D);
  pixelDensity(1);
  frameRate(60);
  shell = loadImage("sprites/ammo.png");
  barrel = loadImage("sprites/ammocounter.png");
  arrow = loadImage("sprites/arrow.png");
  road = loadImage("sprites/road.png");
  barricade = loadImage("sprites/barricade.png");
  house = loadImage("sprites/house.png");
  flavour = loadImage("sprites/flavour.png");
  flavourText = loadImage("sprites/flavour0.png");
  portrait = loadImage("sprites/portrait" + expression + ".png");
  for (int i = 0; i < 3; i++) {
    enemySprites[i] = loadImage("sprites/enemy" + i + ".png");
    
  }
  enemyGun = loadImage("sprites/enemygun.png");
  preview = loadImage("sprites/ADS.png");
  critMarker = loadImage("sprites/critmarker.png");
  hitMarker = loadImage("sprites/hitmarker.png");
  W = loadImage("sprites/victory.png");
  L = loadImage("sprites/gameover.png");
  truck = loadImage("sprites/truck.png");
}


void draw() {
  if (gamestate == 0) {
  
  } else if (gamestate == 1) {
  
  } else if (gamestate == 2) {
    background(#060B34);
    if (sprite > 1) sprite -= 2;
    if (sprite < 0) sprite = 0;
    // inconsistent input gets it out of bounds, this is the more efficient fix
    
    if (!firing && lose == 0) tgt = new PVector(mouseX, mouseY);
    
    if (ADS) {
      sprite += 2;
      while(sprite > 3){
        sprite -= 2;
      }
    }
    
    troll = loadImage("sprites/troll" + sprite + ".png");
    if (reload) {
      gun = loadImage("sprites/gun_open.png");
    } else {
      gun = loadImage("sprites/gun.png");
    }
    
    // map
    pushMatrix();
    translate(-pos.x, -pos.y);
    if (pos.x > chunks*3840-1920) chunks += 1;
    for (float x = 0; x < chunks; x++) {
      image(road, x*3840, 0);
    }
    image(house, 537, -862);
    image(barricade, 796, -30);
    image(barricade, 803, 250);
    image(barricade, 800, 570);
    image(barricade, 797, 900);
    popMatrix();
    
    //-242 -109 if possible
    // troll matrix
    pushMatrix();
    if (tgt.x < width/2) {
      scale(-1, 1);
      translate(-width, 0);
    }
    imageMode(CENTER);
    image(troll, width/2-15, height/2-5);
    // gun matrix (inside troll matrix)
    pushMatrix();
    if (ADS) {
      translate(width/2, height/2-20);
    } else {
      translate(width/2, height/2);
    }
    
    if (ADS) {
      if (tgt.x > width/2) {
        rotate(-atan2(tgt.x - width/2, tgt.y+30 - height/2) + 2*PI/180);
      } else {
        rotate(atan2(tgt.x - width/2, tgt.y+30 - height/2) + 2*PI/180);
      }
    } else {
      if (tgt.x > width/2) {
        rotate(-atan2(tgt.x - width/2, tgt.y+10 - height/2) + 2*PI/180);
      } else {
        rotate(atan2(tgt.x - width/2, tgt.y+10 - height/2) + 2*PI/180);
      }
    }
    
    image(gun, 0, 0);
    popMatrix();
    imageMode(CORNER);
    popMatrix();
    
    // literally everything else
    pushMatrix();
    translate(-pos.x+width/2, -pos.y+height/2);
    for (int i = 0; i < count; i++) {
      enemies[i].display();
      enemies[i].move(pos);
      enemies[i].fire(pos);
      for (int b = 0; b < 3; b++) {
        enemies[i].bullets[b].fly();
        enemies[i].bullets[b].display();
      }
    }
    stroke(#FF0000);
    PVector hs = new PVector(tgt.x+-width/2, tgt.y+-height/2);
    hs.normalize().mult(625);
    image(truck, tpos, -300);
    tint(255, truckHitMarker);
    imageMode(CENTER);
    pushMatrix();
    translate(truckHit.x, truckHit.y);
    rotate(truckHitRotation);
    image(critMarker, 0, 0);
    popMatrix();
    imageMode(CORNER);
    if (truckHitMarker != 0) truckHitMarker-= 4;
    tint(255, 255);
    if (tv < 2) {
      tv += 0.01;
      if (tv > 2) tv = 2;
    }
    tpos += tv;
    popMatrix();
    
    
    // ADS preview
    pushMatrix();
    translate(width/2, height/2-20);
    rotate(-atan2(tgt.x - width/2, tgt.y+30 - height/2) + 92*PI/180);
    imageMode(CENTER);
    if (tgt.x < width/2) translate(0, 15);
    if (ADS && !firing && lose == 0) image(preview, 375, -10);
    imageMode(CORNER);
    popMatrix();
    
    // firing
    if (firing && lose == 0) {
      fire = loadImage("sprites/fire" + int(fireAni/3) + ".png");
      pushMatrix();
      if (ammo == 1) {
        scale(1, -1);
        if (ADS) {
          translate(width/2, -height/2+35);
        } else {
          translate(width/2, -height/2+15);
        }
        if (ADS) {
          if (tgt.x > width/2) {
            rotate(-atan2(tgt.x - width/2, -tgt.y-30 + height/2) + PI/2 + 2*PI/180);
          } else {
            scale(-1, 1);
            rotate(atan2(tgt.x - width/2, -tgt.y-30 + height/2) + PI/2 + 2*PI/180);
          }
        } else {
          if (tgt.x > width/2) {
            rotate(-atan2(tgt.x - width/2, -tgt.y-10 + height/2) + PI/2 + 2*PI/180);
          } else {
            scale(-1, 1);
            rotate(atan2(tgt.x - width/2, -tgt.y-10 + height/2) + PI/2 + 2*PI/180);
          }
        }
        image(fire, 50, -177);
      } else {
        if (ADS) {
          translate(width/2, height/2-20);
        } else {
          translate(width/2, height/2);
        }
        if (ADS) {
          if (tgt.x > width/2) {
            rotate(-atan2(tgt.x - width/2, tgt.y+30 - height/2) + PI/2 + 2*PI/180);
          } else {
            scale(-1, 1);
            rotate(atan2(tgt.x - width/2, tgt.y+30 - height/2) + PI/2 + 2*PI/180);
          }
        } else {
          if (tgt.x > width/2) {
            rotate(-atan2(tgt.x - width/2, tgt.y+10 - height/2) + PI/2 + 2*PI/180);
          } else {
            scale(-1, 1);
            rotate(atan2(tgt.x - width/2, tgt.y+10 - height/2) + PI/2 + 2*PI/180);
          }
        }
        image(fire, 50, -177);
      }
      popMatrix();
      fireAni += 1;
      if (fireAni == 16) {
        firing = false;
        fireAni = 0;
      }
    } else if (lose == 0) {
      walkCycle();
    }
    
    //if (enemies[0] != null) println("enemy HP: " + enemies[0].HP);
    
    // hitscan
    if (fireCD == 12) {
      // OHKO check
      for (int i = 0; i < count; i++) {
        PVector aimDirection = new PVector(width/2-tgt.x, height/2-tgt.y);
        PVector enemyDirection = new PVector(-enemies[i].epos.x+pos.x, -20-enemies[i].epos.y+pos.y);
        //if (enemies[i].epos.x > pos.x) aimDirection.x = -aimDirection.x; 
        if (dist(enemies[i].epos.x, enemies[i].epos.y, pos.x, pos.y) <= 333 && (abs(aimDirection.heading() - enemyDirection.heading()) <= 14*PI/180) || (abs(aimDirection.heading() - enemyDirection.heading()) >= 346*PI/180)) {
          enemies[i].hit(2);
        }
      }
    }
    if (fireCD == 6) {
      // 2HKO check
      for (int i = 0; i < count; i++) {
        PVector aimDirection = new PVector(width/2-tgt.x, height/2-tgt.y);
        PVector enemyDirection = new PVector(-enemies[i].epos.x+pos.x, -20-enemies[i].epos.y+pos.y);
        if (dist(enemies[i].epos.x, enemies[i].epos.y, pos.x, pos.y) <= 625 && abs(aimDirection.heading() - enemyDirection.heading()) <= 14*PI/180 || (abs(aimDirection.heading() - enemyDirection.heading()) >= 346*PI/180)) {
          enemies[i].hit(1);
        }
      }
    }
    
    if (fireCD == 9) {
      //truck hit check
      PVector hitscan = new PVector(tgt.x+-width/2, tgt.y+-height/2);
      hitscan.normalize().mult(625);
      boolean hit = false;
      for (int i = 0; i < 625; i++) {
        if (!hit) {
          if (pos.x+i*hitscan.x/625 > tpos+50 && pos.x+i*hitscan.x/625 < tpos+1134-50 && pos.y+i*hitscan.y/625 > -300+50 && pos.y+i*hitscan.y/625 < 250-50) {
            hit = true;
            truckHitMarker = 320;
            truckHitRotation = random(0, 2*PI);
            truckHit = new PVector(pos.x+i*hitscan.x/625, pos.y+i*hitscan.y/625);
            thp--;
          }
        }
      }
    }
    
    for (int i = 0; i < count; i++) {
      for (int b = 0; b < 3; b++) {
        if (enemies[i].bullets[b].hit(pos)) {
          lose = 1;
        }
      }
    }
    
    // UI
    imageMode(CENTER);
    image(barrel, 693, 876);
    pushMatrix();
    // -54.6 +11.2
    translate(693-54.9, 876+11.2);
    rotate(rotation1);
    if (ammo > 0) image(shell, 0, 0);
    popMatrix();
    pushMatrix();
    // +51.9 +11.2
    translate(693+51.9, 876+11.2);
    rotate(rotation2);
    if (ammo > 1) image(shell, 0, 0);
    popMatrix();
    imageMode(CORNER);
    if (reload) {
      gunUI = loadImage("sprites/open.png");
    } else {
      gunUI = loadImage("sprites/closed.png");
    }
    image(gunUI, 927, 759);
    if (fireCD > 0) fireCD -= 1;
    image(flavour, 0, 0);
    if (tpos - pos.x > 1000) image(arrow, 0, 0);
    if (pos.x - tpos > 2100) {
      pushMatrix();
      scale(-1, 1);
      image(arrow, -width, 0);
      popMatrix();
    }
    stroke(255);
    noFill();
    rectMode(CORNERS);
    rect(222, 822, 443, 852);
    rect(222, 856, 443, 886);
    rect(222, 890, 443, 920);
    fill(255);
    rectMode(CORNER);
    rect(224, 824, thp*217/30, 26);
    if (timer == 0) {
      lose = 1;
    } else {
      timer--;
    }
    rect(224, 858, 217*timer/5400, 26);
    if (reinforcementCountdown != 0) {
      reinforcementCountdown--;
    } else {
      println(reinforcements);
      if (reinforcements < 5) reinforcements += 0.34;
      for (int i = 0; i < reinforcements; i++) {
        float r = random(0, 2*PI);
        spawnEnemy(new PVector(pos.x+random(500, 600)*cos(r), pos.y+random(500, 600)*sin(r)));
      }
      reinforcementCountdown = 360+int(reinforcements*20);
    }
    rect(224, 892, 217*reinforcementCountdown/(360+int(reinforcements*20)), 26);

    
    // note to self loading a 1080p image every frame is not a very good idea
    if(frameCount%300 == 0) flavourText = loadImage("sprites/flavour" + int(frameCount%900/300) + ".png");
    image(flavourText, 0, 0);
    portrait = loadImage("sprites/portrait" + expression + ".png");
    image(portrait, 1529, 884);
    if (duration != 0) {
      duration -= 1;
    } else if (reload && lose == 0) {
      expression = 1;
    } else if (ADS && lose == 0) {
      expression = 4;
    } else if (lose == 0){
      expression = 0;
    }
    fill(#FEFFF5, muzzleFlash);
    stroke(#FEFFF5, muzzleFlash);
    if (lose == 0) rect(1528, 883, 373, 178);
    if (muzzleFlash > 0) {
      muzzleFlash -= dispersion;
      dispersion += 1;
    } else {
      muzzleFlash = 0;
      dispersion = 0;
    }
    
    if (winCountdown > 0) {
      winCountdown -= win;
    } else {
      gamestate = 3;
    }
    if (loseCountdown > 0) {
      loseCountdown -= lose;
      tint(255, loseCountdown*3);
      imageMode(CENTER);
      if (lose != 0) image(hitMarker, width/2, height/2);
      tint(255, 255);
      imageMode(CORNER);
      fill(0, 255-loseCountdown*2);
      stroke(0, 255-loseCountdown*2);
      rect(0, 0, width, height);
    } else {
      gamestate = 4;
    }
  } else if (gamestate == 3) {

  } else if (gamestate == 4) {
    loseCountdown = 120;
    lose = 0;
    image(L, 0, 0);
    if(blackScreen > 0) blackScreen -= 5;
    stroke(0, blackScreen);
    fill(0, blackScreen);
    rect(0, 0, width, height);
  }
  
}

void keyPressed() {
  if (gamestate == 2) {
    if (key == 'r') {
      reload = !reload;
      if (reload) {
        ADS = false;
        expression = 1;
        duration = -1;
      } else {
        expression = 0;
        duration = 0;
        if (held) {
          ADS = true;
          expression = 4;
          duration = -1;
        }
      }
    }
    if (key == 'w') {
      up = true;
    }
    if (key == 'a') {
      left = true;
    }
    if (key == 's') {
      down = true;
    }
    if (key == 'd') {
      right = true;
    }

  }
  
}

void keyReleased() {
  if (gamestate == 2) {
    if (key == 'w') {
      up = false;
    }
    if (key == 'a') {
      left = false;
    }
    if (key == 's') {
      down = false;
    }
    if (key == 'd') {
      right = false;
    }
  }
}

void walkCycle() {
  float mod = 1;
  PVector nextFramePos = pos.copy();
  // keep speed consistent when moving diagonally
  if ((up || down) && (left || right)) mod = mod/sqrt(2);
  if (ADS) mod = mod/2;
  
  if (up) {
    nextFramePos.y -= mod*speed;
  }
  if (down) {
    nextFramePos.y += mod*speed;
  }
  if (left) {
    nextFramePos.x -= mod*speed;
  }
  if (right) {
    nextFramePos.x += mod*speed;
  }
  
  // map collsion
  if (nextFramePos.y < -460) nextFramePos.y = -460;
  if (nextFramePos.y > 563) nextFramePos.y = 563;
  if (nextFramePos.x < 0) nextFramePos.x = 0;
  
  // truck collsion
  if (nextFramePos.x > tpos && nextFramePos.x < tpos + 1134 && nextFramePos.y > -320 && nextFramePos.y < 270) {
    if (abs(nextFramePos.x - tpos) < abs(nextFramePos.x - (tpos + 1134))) {
      if (abs(nextFramePos.y - -320) < abs (nextFramePos.y - 270)) {
        if (abs(nextFramePos.x - tpos) < abs(nextFramePos.y - -320)) {
          nextFramePos.x = tpos;
        } else {
          nextFramePos.y = -320;
        }
      } else {
        if (abs(nextFramePos.x - tpos) < abs(nextFramePos.y - 270)) {
          nextFramePos.x = tpos;
        } else {
          nextFramePos.y = 270;
        }
      }
    } else {
      if (abs(nextFramePos.y - -320) < abs (nextFramePos.y - 270)) {
        if (abs(nextFramePos.x - (tpos + 1134)) < abs(nextFramePos.y - -320)) {
          nextFramePos.x = tpos + 1134;
        } else {
          nextFramePos.y = -320;
        }
      } else {
        if (abs(nextFramePos.x - (tpos + 1134)) < abs(nextFramePos.y - 270)) {
          nextFramePos.x = tpos + 1134;
        } else {
          nextFramePos.y = 270;
        }
      }
    }
  }
  
  float deltaX = nextFramePos.x - pos.x;
  float deltaY = nextFramePos.y - pos.y;
  if (deltaX*deltaX + deltaY*deltaY > 0) {
    if (animateBy == 0){
      legDirection = -legDirection;
      sprite = sprite+legDirection;
      animateBy = 9;
    } else {
      if (!ADS || frameCount%2 != 0) {
        animateBy -= 1;
      }
    }
  } else {
    sprite = 1;
  }

  pos = nextFramePos;
}

// 333 is OHKO range, 625 is two hit, spread is 14 degrees
void mousePressed() {
  if (gamestate == 0) {
  
  } else if (gamestate == 1) {
  
  } else if (gamestate == 2) {
    if (mouseButton == 37) {
      /*
      print("ammo: " + ammo + "\n");
      print("attempting to fire...\n");
      print("fire cooldown: " + fireCD + "\n");
      */
      //println(mouseX, mouseY);
      if (reload && lose == 0) {
        loadShell();
      } else if (fireCD == 0 && ammo > 0 && lose == 0) {
        firing = true;
        fireCD = 15;
        ammo -= 1;
        muzzleFlash = 320;
        dispersion = 0;
      }
      
    } else if (mouseButton == 39 && !reload) {
      ADS = true;
      held = true;
      if (lose == 0) expression = 4;
      duration = -1;
    }
  } else if (gamestate == 3) {
    
  } else if (gamestate == 4) {
    blackScreen = 255;
    if (mouseButton == 37) gamestate = 2;
    if (mouseButton == 39) gamestate = 0;
  }
}

void mouseReleased() {
  if (mouseButton == 39) {
    ADS = false;
    held = false;
    if (reload) {
      if (lose == 0) expression = 1;
      duration = -1;
    } else {
      if (lose == 0) expression = 0;
      duration = 0;
    }
  }
}

void loadShell() {
  if (ammo == 0) {
    ammo += 1;
    rotation1 = random(0, 2*PI);
    if (lose == 0) expression = 2;
    duration = 30;
  } else if (ammo == 1) {
    ammo += 1;
    rotation2 = random(0, 2*PI);
    if (lose == 0) expression = 3;
    duration = 30;
  }
}
