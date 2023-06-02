static Character chr;

static ArrayList<Mob> mobList;
static ArrayList<Bullet> bulletList;
static ArrayList<Enemy> enemyList;
static ArrayList<Mob> mNext;
static ArrayList<Bullet> bNext;
static ArrayList<Enemy> eNext;

static boolean gameOver;

static int score;
static int lives;

static int gameStart;
int nextSpawn;

static PVector windowPos;
static int WIDTH;
static int HEIGHT;

static int gameTime;
static int deltaTime;

static boolean left, down, up, right;
static int lastLeft, lastRight;
static boolean focus;

static PImage heart;

static PImage reimuStanding[];
static PImage reimuLeft[];
static PImage reimuRight[];

private PImage flipImage(PImage img) {
  PImage p = img.copy();
  for (int r = 0; r < p.height; r++) {
    for (int c = 0; c < p.width; c++) {
      p.set(c, r, img.get(p.width - 1 - c, r));
    }
  }
  return p;
}

void loadImages() {
  heart = loadImage("heart.png");
  
  PImage reimuSprites = loadImage("reimu-sprites.png");
  reimuStanding = new PImage[4];
  for(int i = 0; i < 4; i++) {
    reimuStanding[i] = reimuSprites.get(i * 64, 0, 64, 96);
  }
  reimuLeft = new PImage[7];
  for (int i = 0; i < 7; i++) {
    reimuLeft[i] = reimuSprites.get(i * 64, 96, 64, 96);
  }
  reimuRight = new PImage[7];
  for (int i = 0; i < 7; i++) {
    reimuRight[i] = flipImage(reimuSprites.get(i * 64, 96, 64, 96));
  }
}

void setup() {  
  loadImages();
  
  size(1200, 900);
  WIDTH = 700; //640x480
  HEIGHT = 850;
  windowPos = new PVector(50, 25);
  
  score = 0;
  lives = 0;
  
  mobList = new ArrayList<Mob>();
  bulletList = new ArrayList<Bullet>();
  enemyList = new ArrayList<Enemy>();
  mNext = new ArrayList<Mob>();
  bNext = new ArrayList<Bullet>();
  eNext = new ArrayList<Enemy>();
  
  chr = new Reimu(new PVector(600,800));
  
  gameStart = millis();
}

void drawBorder() {
  fill(166,60,91);
  stroke(166,60,91);
  rectMode(CORNERS);
  rect(0, 0, width, windowPos.y);
  rect(0, 0, windowPos.x, height);
  rect(windowPos.x + WIDTH, 0, width, height);
  rect(0, windowPos.y + HEIGHT, width, height);
  
  rectMode(CORNER);
  fill(220);
  textSize(36);
  text("Score", windowPos.x + WIDTH + 25, 100);
  text(chr.getName(), windowPos.x + WIDTH + 25, 200);
  fill(255);
  textSize(48);
  text(score, windowPos.x + WIDTH + 150, 100);
  for (int i = 0; i < lives; i++) {
    image(heart, windowPos.x + WIDTH + 150 + i * heart.width, 200 - heart.height);
  }
  
  fill(255);
  stroke(0);
}

void draw() {  
  deltaTime = millis() - gameTime;
  gameTime = millis();
  
  background(90, 10, 10);
  
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
  if (focus) {
    vel.normalize().mult(chr.focusSpeed);
  }
  else {
    vel.normalize().mult(chr.moveSpeed);
  }
  chr.setVelocity(vel);
  
  chr.updateAttack();
  
  mobList = new ArrayList<Mob>(mNext);
  bulletList = new ArrayList<Bullet>(bNext);
  enemyList = new ArrayList<Enemy>(eNext);
  
  
  drawBorder();
}

void spawnEnemies() {
  int elapsed = millis() - gameStart;
  if (elapsed > 2000 && nextSpawn == 0) {
    new Nerd(new PVector(300,300), new PVector(500,500), 1000, 8000);
    new Nerd(new PVector(400,300), new PVector(500,500), 1000, 8000);
    nextSpawn++;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (left == false) {
        lastLeft = millis();
      }
      left = true;
    }
    if (keyCode == DOWN) {
      down = true;
    }
    if (keyCode == UP) {
      up = true;
    }
    if (keyCode == RIGHT) {
      if (right == false) {
        lastRight = millis();
      }
      right = true;
    }
    if (keyCode == SHIFT) {
      focus = true;
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
    if (keyCode == SHIFT) {
      focus = false;
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
