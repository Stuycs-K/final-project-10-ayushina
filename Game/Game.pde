Character chr;
static ArrayList<Mob> mobList;
static ArrayList<Bullet> bulletList;
static ArrayList<Enemy> enemyList;

boolean left, down, up, right;

void setup() {
  size(1200, 900);
  mobList = new ArrayList<Mob>();
  bulletList = new ArrayList<Bullet>();
  enemyList = new ArrayList<Enemy>();
  chr = new Reimu(new PVector(600,800), 20);
  new Enemy(new PVector(300,300), 50, 100);
}

void draw() {  
  background(255);
  for (Mob m : mobList) {
    m.updatePos();
    m.display();
  }
  for (int i = 0; i < bulletList.size(); i++) {
    Bullet b = bulletList.get(i);
    b.registerHit();
    if (b.deleteOffScreen()) {
      i--;
    }
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
  if (m.type == "bullet") {
    bulletList.remove(m);
  }
  if (m.type == "enemy") {
    enemyList.remove(m);
  }
  return mobList.remove(m);
}

static void addEnemy(Enemy e) {
  enemyList.add(e);
}

static boolean removeEnemy(Enemy e) {
  return enemyList.remove(e);
}

static void addBullet(Bullet b) {
  bulletList.add(b);
}

static boolean removeBullet(Bullet b) {
  return bulletList.remove(b);
}
