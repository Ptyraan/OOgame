int lives = 3;
int ammo = 2;
boolean reload = true;
boolean ADS = false;
PVector pos = new PVector(0, 0);
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

PImage troll;
PImage gun;
PImage fire;
PImage barrel;
PImage shell;
PImage gunUI;

void setup() {
  fullScreen(P2D);
  pixelDensity(1);
  frameRate(60);
  shell = loadImage("sprites/ammo.png");
  barrel = loadImage("sprites/ammocounter.png");
}


void draw() {
  background(100);
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
  
  
  // troll matrix
  pushMatrix();
  if (tgt.x < width/2) {
    scale(-1, 1);
    translate(-width, 0);
  };
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
  translate(-pos.x, -pos.y);
  ellipse(0, 0, 100, 100);
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
  image(barrel, 740, 700);
  pushMatrix();
  translate(685.4, 711.2);
  rotate(rotation1);
  if (ammo > 0) image(shell, 0, 0);
  popMatrix();
  pushMatrix();
  translate(791.9, 711.3);
  rotate(rotation2);
  if (ammo > 1) image(shell, 0, 0);
  popMatrix();
  imageMode(CORNER);
  if (reload) {
    gunUI = loadImage("sprites/open.png");
  } else {
    gunUI = loadImage("sprites/closed.png");
  }
  image(gunUI, 888, 610);
  if (fireCD > 0) fireCD -= 1;
  

}

void keyPressed() {
  if (key == 'r') {
    reload = !reload;
    ADS = false;
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
      
    }
  } else if (mouseButton == 39 && !reload) {
    ADS = true;
  }
}

void mouseReleased() {
  if (mouseButton == 39) {
    ADS = false;
  }
}

void loadShell() {
  if (ammo == 0) {
    ammo += 1;
    rotation1 = random(0, 2*PI);
  } else if (ammo == 1) {
    ammo += 1;
    rotation2 = random(0, 2*PI);
  }
}
