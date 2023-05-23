Character chr;
static int gameTime;

boolean left, down, up, right;

void setup() {
  size(1200, 900);
  chr = new Reimu(new PVector(600,800), 20);
}

static int getTime() {
  return gameTime;
}

void draw() {
  gameTime = millis();
  
  background(255);
  chr.updatePos();
  chr.display();
  
  PVector vel = new PVector(0,0);
  if (left) {
    vel.add(new PVector(-1, 0));
  }
  if (down) {
    vel.add(new PVector(0, 1));
  }
  if (up) {
    vel.add(new PVector(0, -1));
  }
  if (right) {
    vel.add(new PVector(1, 0));
  }
  vel.normalize().mult(chr.moveSpeed);
  chr.setVelocity(vel);
  
  chr.updateAttack();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      left = true;
    }
    if (keyCode == DOWN) {
      down = true;
    }
    if (keyCode == UP) {
      up = true;
    }
    if (keyCode == RIGHT) {
      right = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      left = false;
    }
    if (keyCode == DOWN) {
      down = false;
    }
    if (keyCode == UP) {
      up = false;
    }
    if (keyCode == RIGHT) {
      right = false;
    }
  }
}
