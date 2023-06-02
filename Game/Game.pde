import processing.sound.*;

static Character chr;

static ArrayList<Mob> mobList;
static ArrayList<Bullet> bulletList;
static ArrayList<Enemy> enemyList;
static ArrayList<Mob> mNext;
static ArrayList<Bullet> bNext;
static ArrayList<Enemy> eNext;

static String gameState;
static int lastStateChange;
static boolean gameWon;

static int score;
static int timeScore;
static int lives;
static int kills;
static int lastDied;
static final int DEATH_TIME = 2000;

static int gameStart;
int nextSpawn;

static PVector windowPos;
static int WIDTH;
static int HEIGHT;

static int gameTime;
static int deltaTime;

static int[] lastMouseUp;
static int[] lastMouseDown;


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

static SoundFile pldead00;

void loadSounds() {
  pldead00 = new SoundFile(this, "pldead00.wav");
}

void newGame() { 
  gameState = "game";
  gameWon = false;
  gameStart = millis();
  lastStateChange = gameStart;
  
  score = 0;
  timeScore = 0;
  lives = 0;
  kills = 0;
  lastDied = -1;
  
  gameTime = 0;
  deltaTime = 0;
  
  left = false;
  down = false;
  up = false;
  right = false;
  lastLeft = -1;
  lastRight = -1;
  focus = false;
  
  mobList = new ArrayList<Mob>();
  bulletList = new ArrayList<Bullet>();
  enemyList = new ArrayList<Enemy>();
  mNext = new ArrayList<Mob>();
  bNext = new ArrayList<Bullet>();
  eNext = new ArrayList<Enemy>();
  
  chr = new Reimu(new PVector(600,800));
}

boolean inRectCenter(int[] coords, int[] rect) {
  if (coords.length != 2) {
    return false;
  }
  int x = coords[0];
  int y = coords[1];
  int rectX = rect[0];
  int rectY = rect[1];
  int rectWidth = rect[2];
  int rectHeight = rect[3];
  
  int left = rectX - rectWidth/2;
  int right = rectX + rectWidth/2;
  int top = rectY - rectHeight/2;
  int bottom = rectY + rectHeight/2;
  return x >= left && x <= right && y >= top && y <= bottom;
}

void setup() {  
  loadImages();
  loadSounds();
  
  size(1200, 900);
  WIDTH = 700; //640x480
  HEIGHT = 850;
  windowPos = new PVector(50, 25);
  
  lastMouseUp = new int[]{};
  lastMouseDown = new int[]{};
  
  gameState = "start";
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
  text("Kills", windowPos.x + WIDTH + 25, 300);
  text("Time", windowPos.x + WIDTH + 25, 400);
  
  fill(255);
  textSize(48);
  text(score, windowPos.x + WIDTH + 150, 100);
  for (int i = 0; i < lives; i++) {
    image(heart, windowPos.x + WIDTH + 150 + i * heart.width, 200 - heart.height);
  }
  text(kills, windowPos.x + WIDTH + 150, 300);
  //fill(66,135,245);
  //textSize(60);
  //text(gameTime/1000, windowPos.x + WIDTH + 150 - 3, 400 + 4);
  //textSize(48);
  //fill(255);
  //text(gameTime/1000, windowPos.x + WIDTH + 150, 400);
  text(gameTime/1000, windowPos.x + WIDTH + 150, 400);
  
  fill(255);
  stroke(0);
}

void gameOverScreen() {
  textSize(64);
  String txt;
  if (gameWon) {
    txt = "You Won!";
  }
  else {
    txt = "You Died!";
  }
  textAlign(CENTER);
  text(txt, windowPos.x + WIDTH / 2, windowPos.y + 100);
  textSize(36);
  text("Final Score: " + score, windowPos.x + WIDTH / 2, windowPos.y + 300);
  textAlign(BASELINE);
}

void gameTime() {
  deltaTime = millis() - gameStart - gameTime;
  gameTime = millis() - gameStart;
  
  score += (gameTime - timeScore) / 50;
  timeScore += ((gameTime - timeScore) / 50) * 50;
}

void draw() {  
  if (gameState == "start") {
    background(166,60,91);
    int[] playButton = new int[] {width / 2 - 400, height / 2, 300, 100};
    if (!mousePressed && inRectCenter(lastMouseDown, playButton) && inRectCenter(lastMouseUp, playButton)) {
      newGame();
    }
    rectMode(CENTER);
    fill(255,0);
    stroke(12, 220, 19);
    strokeWeight(6);
    rect(playButton[0], playButton[1], playButton[2], playButton[3]);
    
    fill(250, 157, 157);
    textSize(64);
    textAlign(CENTER);
    text("Play", playButton[0], playButton[1] + playButton[3] / 4);
    
    textSize(96);
    fill(255);
    text("Click Play", width / 2, 300);
    textAlign(BASELINE);
    
    rectMode(CORNER);
    fill(255);
    strokeWeight(4);
    stroke(0);
  }
  else if (gameState == "game") {
    gameTime();
    
    background(90, 10, 10);
    
    spawnEnemies();
    updateMobs();
    updateCharacter();
  
    mobList = new ArrayList<Mob>(mNext);
    bulletList = new ArrayList<Bullet>(bNext);
    enemyList = new ArrayList<Enemy>(eNext);
    
    drawBorder();
  }
  else if (gameState == "gameOver") {
    background(90, 10, 10);
    gameOverScreen();
    drawBorder();
  }
  else {
    print(gameState);
  }
}

void gameOver(boolean won) {
  gameState = "gameOver";
  lastStateChange = millis();
  gameWon = won;
  
  mobList = new ArrayList<Mob>();
  bulletList = new ArrayList<Bullet>();
  enemyList = new ArrayList<Enemy>();
}

void updateCharacter() {
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
}

void updateMobs() {
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
}

void spawnEnemies() {
  int elapsed = millis() - gameStart;
  if (elapsed > 2000 && nextSpawn == 0) {
    new Nerd(new PVector(300,300), new PVector(500,500), 1000, 8000);
    new Nerd(new PVector(400,300), new PVector(500,500), 1000, 8000);
    nextSpawn++;
  }
}

void mousePressed() {
  if (lastMouseDown.length == 0) {
    lastMouseDown = new int[2];
  }
  lastMouseDown[0] = mouseX;
  lastMouseDown[1] = mouseY;
}
void mouseReleased() {
  if (lastMouseUp.length == 0) {
    lastMouseUp = new int[2];
  }
  lastMouseUp[0] = mouseX;
  lastMouseUp[1] = mouseY;
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
