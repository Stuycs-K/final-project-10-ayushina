static Character chr;

static ArrayList<Mob> mobList;
static ArrayList<Bullet> bulletList;
static ArrayList<Enemy> enemyList;
static ArrayList<Mob> mNext;
static ArrayList<Bullet> bNext;
static ArrayList<Enemy> eNext;

static boolean gameOver;

static int gameStart;
int nextSpawn;

static int gameTime;
static int deltaTime;

boolean left, down, up, right;

void setup() {
  size(1200, 900);
  mobList = new ArrayList<Mob>();
  bulletList = new ArrayList<Bullet>();
  enemyList = new ArrayList<Enemy>();
  mNext = new ArrayList<Mob>();
  bNext = new ArrayList<Bullet>();
  eNext = new ArrayList<Enemy>();
  
  chr = new Reimu(new PVector(600,800));
  
  gameStart = millis();
}

void draw() {  
  deltaTime = millis() - gameTime;
  gameTime = millis();
  
  background(255);
  
  spawnEnemies();
  
  for (Mob m : mobList) {
    m.updatePos();
    m.display();
  }
  for (int i = 0; i < bulletList.size(); i++) {
    Bullet b = bulletList.get(i);
    b.registerHit();
    b.deleteOffScreen();
  }
  for (Enemy e : enemyList) {
    e.updateAttack();
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
  
  mobList = new ArrayList<Mob>(mNext);
  bulletList = new ArrayList<Bullet>(bNext);
  enemyList = new ArrayList<Enemy>(eNext);
}

void spawnEnemies() {
  int elapsed = millis() - gameStart;
  if (elapsed > 2000 && nextSpawn == 0) {
    new Nerd(new PVector(300,300), new PVector(500,500), 1, 8);
    nextSpawn++;
  }
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
  mNext.add(m);
}

static boolean removeMob(Mob m) {
  if (m.type == "bullet") {
    bNext.remove(m);
  }
  if (m.type == "enemy") {
    eNext.remove(m);
  }
  return mNext.remove(m);
}

static void addEnemy(Enemy e) {
  eNext.add(e);
}

static boolean removeEnemy(Enemy e) {
  return eNext.remove(e);
}

static void addBullet(Bullet b) {
  bNext.add(b);
}

static boolean removeBullet(Bullet b) {
  return bNext.remove(b);
}
