int gamestate = 0;
/* gamestate index
 0 menu
 1 game
 2 win
 3 lose
*/

int lives = 3;
int ammo = 2;
boolean reload = true;
boolean ADS = false;
boolean held = false;
PVector pos = new PVector(0, -460);
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

PImage road;
PImage barricade;
PImage house;

int chunks = 1;
int count = 0;
enemy[] enemies = new enemy[256];

void setup() {
  size(1920, 1080, P2D);
  pixelDensity(1);
  frameRate(60);
  shell = loadImage("sprites/ammo.png");
  barrel = loadImage("sprites/ammocounter.png");
  road = loadImage("sprites/road.png");
  barricade = loadImage("sprites/barricade.png");
  house = loadImage("sprites/house.png");
  flavour = loadImage("sprites/flavour.png");
  flavourText = loadImage("sprites/flavour0.png");
  portrait = loadImage("sprites/portrait" + expression + ".png");
}


void draw() {
  background(#060B34);
  if (sprite > 1) sprite -= 2;
  if (sprite < 0) sprite = 0;
  // inconsistent input gets it out of bounds, this is the more efficient fix
  
  if (!firing) tgt = new PVector(mouseX, mouseY);
  
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
  testBullet.display();
  if (testBullet.hit(pos)) {
    ellipse(pos.x, pos.y, 50, 50);
  }
  popMatrix();
  
  // fire effect
  if (firing) {
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
  } else {
    walkCycle();
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
  
  // note to self loading a 1080p image every frame is not a very good idea
  if(frameCount%300 == 0) flavourText = loadImage("sprites/flavour" + int(frameCount%900/300) + ".png");
  image(flavourText, 0, 0);
  portrait = loadImage("sprites/portrait" + expression + ".png");
  image(portrait, 1529, 884);
  if (duration != 0) {
    duration -= 1;
  } else if (reload) {
    expression = 1;
  } else if (ADS) {
    expression = 4;
  } else {
    expression = 0;
  }
  fill(#FEFFF5, muzzleFlash);
  stroke(#FEFFF5, muzzleFlash);
  rect(1528, 883, 373, 178);
  if (muzzleFlash > 0) {
    muzzleFlash -= dispersion;
    dispersion += 1;
  } else {
    muzzleFlash = 0;
    dispersion = 0;
  }
  
  print("pos: " + pos.x + ", " + pos.y + "\n");
  print("bullet: " + testBullet.pos.x + ", " + testBullet.pos.y + "\n");
}

void keyPressed() {
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

void keyReleased() {
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
  
  if (nextFramePos.y < -460) nextFramePos.y = -460;
  if (nextFramePos.y > 563) nextFramePos.y = 563;
  if (nextFramePos.x < 0) nextFramePos.x = 0;
  
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

void mousePressed() {
  if (mouseButton == 37) {
    /*
    print("ammo: " + ammo + "\n");
    print("attempting to fire...\n");
    print("fire cooldown: " + fireCD + "\n");
    */
    println(mouseX, mouseY);
    if (reload) {
      loadShell();
    } else if (fireCD == 0 && ammo > 0) {
      firing = true;
      fireCD = 15;
      ammo -= 1;
      muzzleFlash = 320;
      dispersion = 0;
    }
  } else if (mouseButton == 39 && !reload) {
    ADS = true;
    held = true;
    expression = 4;
    duration = -1;
  }
}

void mouseReleased() {
  if (mouseButton == 39) {
    ADS = false;
    held = false;
    if (reload) {
      expression = 1;
      duration = -1;
    } else {
      expression = 0;
      duration = 0;
    }
  }
}

void loadShell() {
  if (ammo == 0) {
    ammo += 1;
    rotation1 = random(0, 2*PI);
    expression = 2;
    duration = 30;
  } else if (ammo == 1) {
    ammo += 1;
    rotation2 = random(0, 2*PI);
    expression = 3;
    duration = 30;
  }
}
