Character chr;
static ArrayList<Mob> mobList;
static ArrayList<Bullet> bulletList;

boolean left, down, up, right;

void setup() {
  size(1200, 900);
  mobList = new ArrayList<Mob>();
  bulletList = new ArrayList<Bullet>();
  chr = new Reimu(new PVector(600,800), 20);
}

void draw() {  
  background(255);
  for (Mob m : mobList) {
    m.updatePos();
    m.display();
  }
  for (Bullet b: bulletList) {
    b.registerHit();
  }
  
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

static void addMob(Mob m) {
  mobList.add(m);
}

static boolean removeMob(Mob m) {
  return mobList.remove(m);
}

static void addBullet(Bullet b) {
  bulletList.add(b);
}

static boolean removeBullet(Bullet b) {
  return bulletList.remove(b);
}
