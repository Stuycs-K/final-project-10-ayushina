import processing.sound.*;

static Character chr;

static ArrayList<Mob> mobList;
static ArrayList<Bullet> bulletList;
static ArrayList<Enemy> enemyList;
static ArrayList<Mob> mNext;
static ArrayList<Bullet> bNext;
static ArrayList<Enemy> eNext;
static ArrayList<BossEnemy> currentBoss;

static String gameState;
static int stateStart;
static boolean gameWon;
static boolean newHighScore;

static final int WIN_SCORE = 5000;

final static String start = "start";
final static String game = "game";
final static String gameOver = "gameOver";

static int[] bg;
static final int[] DEFAULT_BG = new int[] {90, 10, 10};

static SoundFile bgm;

static int timeCounted;

static int score;
static int timeScore;
static int phaseScore;
static int damageScore;
static int grazeScore;
static int killScore;

static int highScore;

static final int PLAYER_LIVES = 5;

static int lives;
static int kills;
static int lastDied;
static final int DEATH_TIME = 2000;
static int grazes;
static final float GRAZE_RADIUS = 32;
static final int GRAZE_SCORE = 70;

int nextSpawn;

static PVector windowPos;
static int WIDTH;
static int HEIGHT;

static int gameTime;
static int deltaTime;

static float[] lastMouseUp;
static float[] lastMouseDown;
static boolean mouseDown, justDown, justUp;

static boolean left, down, up, right;
static boolean leftDown, rightDown;
static int lastLeft, lastRight;
static int lastLeftUp, lastRightUp;
static int lastFocus, lastFocusUp;
static boolean focus;

static PImage heart;

static PImage reimuStandingLeft[];
static PImage reimuStandingRight[];
static PImage reimuLeft[];
static PImage reimuRight[];
static PImage reimuOrb[];

static PImage nerd;
static PImage book;
static PImage zygarde;
static PImage teacher;

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
  
  //reimu
  PImage reimuSprites = loadImage("reimu-sprites.png");
  reimuStandingLeft = new PImage[4];
  for(int i = 0; i < 4; i++) {
    reimuStandingLeft[i] = reimuSprites.get(i * 64, 0, 64, 96);
  }
  reimuStandingRight = new PImage[4];
  for(int i = 0; i < 4; i++) {
    reimuStandingRight[i] = flipImage(reimuSprites.get(i * 64, 0, 64, 96));
  }
  reimuLeft = new PImage[7];
  for (int i = 0; i < 7; i++) {
    reimuLeft[i] = reimuSprites.get(i * 64, 96, 64, 96);
  }
  reimuRight = new PImage[7];
  for (int i = 0; i < 7; i++) {
    reimuRight[i] = flipImage(reimuSprites.get(i * 64, 96, 64, 96));
  }
  reimuOrb = new PImage[4];
  for (int i = 0; i < 4; i++) {
    reimuOrb[i] = reimuSprites.get(4 * 64 + i * 32, 32, 32, 32);
  }
  
  //nerd
  nerd = loadImage("nerd.png");
  //book
  book = loadImage("book.png");
  //zygarde
  zygarde = loadImage("zygarde.png");
  //teacher
  teacher = loadImage("teacher.png");
}

void shootSound() {
  if (random(3) < 1) {
    tan00.play();
  }
  else if (random(2) < 1) {
    tan01.play();
  }
  else {
    tan02.play();
  }
}

void enepSound() {
  if (random(2) < 1) {
    enep00.play();
  }
  else {
    enep01.play();
  }
}

static SoundFile pldead00;
static SoundFile tan00,tan01,tan02;
static SoundFile graze;
static SoundFile enep00, enep01;

static SoundFile bgm01;
static SoundFile bgm16;
static SoundFile bgm17;

void loadSounds() {
  pldead00 = new SoundFile(this, "pldead00.wav");
  tan00 = new SoundFile(this, "tan00.wav");
  tan01 = new SoundFile(this, "tan01.wav");
  tan02 = new SoundFile(this, "tan02.wav");
  graze = new SoundFile(this, "graze.wav");
  enep00 = new SoundFile(this, "enep00.wav");
  enep01 = new SoundFile(this, "enep01.wav");
  
  bgm01 = new SoundFile(this, "01. Wondrous Tales of Romance ~ Mystic Square.wav");
  bgm16 = new SoundFile(this, "16. Alice in Wonderland.wav");
  bgm17 = new SoundFile(this, "17. the Grimoire of Alice.wav");
}

String getMusicName(SoundFile music) {
  if (music == bgm01) {
    return "01. Wondrous Tales of Romance ~ Mystic Square";
  }
  else if (music == bgm16) {
    return "16. Alice in Wonderland";
  }
  else if (music == bgm17) {
    return "17. the Grimoire of Alice";
  }
  return "";
}

void changeBGM(SoundFile music) {
  if (bgm != null) {
    bgm.stop();
  }
  if (music != null) {
    bgm = music;
    bgm.loop();
  }
}

static final String SCORE_FILE = "highScore.txt";

void loadData() {
  String[] scoreData = loadStrings(SCORE_FILE);
  if (scoreData != null && scoreData.length > 0) {
    highScore = int(scoreData[0]);
  }
}

void newGame(int mode) {
  if (mode == 0) {
    int time = 40000;
    newGame();
    stateStart = millis() - time;
    gameTime = time;
    nextSpawn = 15;
    lives = 99;
  }
  else if (mode == 1) {
    newGame();
    lives = 99;
  }
}

void newGame() { 
  changeState(Game.game);
  gameWon = false;
  newHighScore = false;
  
  bg = DEFAULT_BG;
  
  score = 0;
  timeCounted = 0;
  timeScore = 0;
  lives = PLAYER_LIVES;
  kills = 0;
  lastDied = -1;
  
  gameTime = 0;
  deltaTime = 0;
  nextSpawn = 0;
  
  left = false;
  down = false;
  up = false;
  right = false;
  leftDown = false;
  rightDown = false;
  lastLeft = -1;
  lastRight = -1;
  lastFocus = -1;
  lastFocusUp = -1;
  focus = false;
  
  mobList = new ArrayList<Mob>();
  bulletList = new ArrayList<Bullet>();
  enemyList = new ArrayList<Enemy>();
  mNext = new ArrayList<Mob>();
  bNext = new ArrayList<Bullet>();
  eNext = new ArrayList<Enemy>();
  currentBoss = new ArrayList<BossEnemy>();
  
  chr = new Reimu(new PVector(600,800));
}

boolean inRectCenter(float[] coords, float[] rect) {
  if (coords.length != 2) {
    return false;
  }
  float x = coords[0];
  float y = coords[1];
  float rectX = rect[0];
  float rectY = rect[1];
  float rectWidth = rect[2];
  float rectHeight = rect[3];
  
  float left = rectX - rectWidth/2;
  float right = rectX + rectWidth/2;
  float top = rectY - rectHeight/2;
  float bottom = rectY + rectHeight/2;
  return x >= left && x <= right && y >= top && y <= bottom;
}

void setup() {  
  loadImages();
  loadSounds();
  loadData();
  
  size(1200, 900);
  WIDTH = 700; //640x480
  HEIGHT = 850;
  windowPos = new PVector(50, 25);
  
  lastMouseUp = new float[]{};
  lastMouseDown = new float[]{};
  
  changeState(Game.start);
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
  textAlign(RIGHT);
  text("High Score", windowPos.x + WIDTH + 225, 100);
  text("Score", windowPos.x + WIDTH + 225, 200);
  text(chr.getName(), windowPos.x + WIDTH + 125, 300);
  text("Boss", windowPos.x + WIDTH + 125, 400);
  text("Kills", windowPos.x + WIDTH + 225, 500);
  text("Graze", windowPos.x + WIDTH + 225, 600);
  text("Time", windowPos.x + WIDTH + 225, 700);
  textAlign(BASELINE);
  
  fill(255);
  textSize(48);
  text(highScore, windowPos.x + WIDTH + 250, 100);
  text(score, windowPos.x + WIDTH + 250, 200);
  for (int i = 0; i < lives; i++) {
    image(heart, windowPos.x + WIDTH + 150 + i * heart.width, 300 - heart.height);
  }
  if (currentBoss.size() == 1) {
    BossEnemy b = currentBoss.get(0);
    int lives = b.maxPhases - b.phase;
    for (int i = 0; i < lives; i++) {
      image(heart, windowPos.x + WIDTH + 150 + i * heart.width, 400 - heart.height);
    }
    double percent = b.health / b.maxHealth;
    rect(10, 10, (float) percent * WIDTH + 20, 10);
    
    if (!gameState.equals(Game.gameOver)) {
      fill(66,135,245);
      textSize(60);
      text((b.timeOut-(millis()-b.phaseStart))/1000, windowPos.x + WIDTH - 60, 70);
      textSize(48);
      fill(255);
      text((b.timeOut-(millis()-b.phaseStart))/1000, windowPos.x + WIDTH - 60, 70);
    }
  }
  text(kills, windowPos.x + WIDTH + 250, 500);
  text(grazes, windowPos.x + WIDTH + 250, 600);
  text(gameTime/1000, windowPos.x + WIDTH + 250, 700);
  
  fill(255);
  stroke(0);
}

void gameOverScreen() {
  int elapsed = millis() - stateStart;
  
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
  if (newHighScore) {
    if (elapsed % 400 < 200) {
      fill(245, 66, 230);
    }
    else {
      fill(255, 193, 23);
    }
    text("New High Score!! ~ " + score, windowPos.x + WIDTH / 2, windowPos.y + 200);
    fill(255);
  }
  else {
    text("Final Score ~ " + score, windowPos.x + WIDTH / 2, windowPos.y + 200);
  }
  textSize(24);
  fill(200);
  text("Time Bonus: " + timeScore, windowPos.x + WIDTH / 2, windowPos.y + 250);
  text("Spellcard Bonus: " + phaseScore, windowPos.x + WIDTH / 2, windowPos.y + 300);
  text("Damage Bonus: " + damageScore, windowPos.x + WIDTH / 2, windowPos.y + 350);
  text("Graze Bonus: " + grazeScore, windowPos.x + WIDTH / 2, windowPos.y + 400);
  text("Kill Bonus: " + killScore, windowPos.x + WIDTH / 2, windowPos.y + 450);
  if (gameWon) {
    text("Stage Clear Bonus: " + WIN_SCORE, windowPos.x + WIDTH / 2, windowPos.y + 500);
  }
  else {
    text("Stage Failed: " + 0, windowPos.x + WIDTH / 2, windowPos.y + 500);
  }
  fill(255);
  textAlign(BASELINE);
  
  //replay button
  float[] playButton = new float[] {windowPos.x + WIDTH / 2, windowPos.y + 700, 400, 100};
  if (mouseOnButton(playButton)) {
    newGame();
  }
  drawButton(playButton, "Play Again?");
}

void gameTime() {
  deltaTime = millis() - stateStart - gameTime;
  gameTime = millis() - stateStart;
  
  score += (gameTime - timeCounted) / 50; //one point every 50 ms, 20 pts per sec
  timeScore += (gameTime - timeCounted) / 50;
  timeCounted += ((gameTime - timeCounted) / 50) * 50;
}

void drawButton(float[] button, String text) {
  int elapsed = millis() - stateStart;
  
  rectMode(CENTER);
  fill(255,0);
  if (elapsed % 400 < 200) {
    stroke(12, 220, 19);
  }
  else {
    stroke(50, 168, 82);
  }

  strokeWeight(6);
  rect(button[0], button[1], button[2], button[3]);
  
  fill(250, 157, 157);
  textSize(64);
  textAlign(CENTER);
  text(text, button[0], button[1] + button[3] / 4);
  
  textAlign(BASELINE);
  fill(255);
  stroke(0);
  rectMode(CORNER);
}

boolean mouseOnButton(float[] button) {
  return justUp && inRectCenter(lastMouseDown, button) && inRectCenter(lastMouseUp, button);
}

void updateMouse() {
  boolean previousDown = mouseDown;
  boolean previousUp = !mouseDown;
  mouseDown = mousePressed;
  justDown = previousDown == false && mouseDown == true;
  justUp = previousUp == false && mouseDown == false;
  
  if (justDown) {
    if (lastMouseDown.length == 0) {
      lastMouseDown = new float[2];
    }
    lastMouseDown[0] = mouseX;
    lastMouseDown[1] = mouseY;
  }

  if (justUp) {
    if (lastMouseUp.length == 0) {
      lastMouseUp = new float[2];
    }
    lastMouseUp[0] = mouseX;
    lastMouseUp[1] = mouseY;
  }
}

void changeState(String state) {
  gameState = state;
  stateStart = millis();
  if (state.equals(Game.start)) {
    changeBGM(bgm01);
  }
  else if (state.equals(Game.game)) {
    changeBGM(bgm16);
  }
  else if (state.equals(Game.gameOver)) {
    bgm.pause();
    bgm.play();
  }
  else {
    changeBGM(null);
  }
}

void draw() {  
  updateMouse();
  
  if (gameState.equals(Game.start)) {
    background(166,60,91);
    float[] playButton = new float[] {width / 2 - 400, height / 2, 400, 100};
    if (mouseOnButton(playButton)) {
      newGame();
    }
    drawButton(playButton, "Play");
    
    textAlign(CENTER);
    textSize(96);
    fill(255);
    text("Click Play", width / 2, 300);
    textAlign(BASELINE);
    
    //cheat 1
    float[] skipButton = new float[] {width / 2 - 400, height / 2 + 150, 400, 100};
    if (mouseOnButton(skipButton)) {
      newGame(0);
    }
    drawButton(skipButton, "Skip + Inf lives");
    
    //cheat 2
    float[] livesButton = new float[] {width / 2 - 400, height / 2 + 300, 400, 100};
    if (mouseOnButton(livesButton)) {
      newGame(1);
    }
    drawButton(livesButton, "Inf lives");
    
    rectMode(CORNER);
    fill(255);
    strokeWeight(4);
    stroke(0);
  }
  else if (gameState.equals(Game.game)) {
    gameTime();
    
    background(bg[0], bg[1], bg[2]);
    
    spawnEnemies();
    updateMobs();
    updateCharacter();
  
    mobList = new ArrayList<Mob>(mNext);
    bulletList = new ArrayList<Bullet>(bNext);
    enemyList = new ArrayList<Enemy>(eNext);
    
    drawBorder();
    
    if (gameTime > 43000 && currentBoss.size() == 0) {// game length
      gameOver(true);
    }
  }
  else if (gameState.equals(Game.gameOver)) {
    background(90, 10, 10);
    gameOverScreen();
    drawBorder();
  }
  else {
    print(gameState);
  }
}

void gameOver(boolean won) {
  changeState(Game.gameOver);
  gameWon = won;
  
  if (won) {
    score += WIN_SCORE;
  }
  
  if (score > highScore) {
    String[] scoreData = new String[1];
    scoreData[0] = "" + score;
    saveStrings(SCORE_FILE, scoreData);
    highScore = score;
    newHighScore = true;
  }
  
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
  if (gameTime > 2000 && nextSpawn == 0) {//2-10
    new Nerd(new PVector(WIDTH/2, 200), 100, 3);
    nextSpawn++;
  }
  for (int i = 0; i < 4; i++) {
    if (gameTime > 8000 + i * 333 && nextSpawn == 1 + i) {
      new Nerd(new PVector(WIDTH/2 - 150 + i * 100,300), 25, 1);
      nextSpawn++;
    }
  }
  if (gameTime > 10000 && nextSpawn == 5) {
    new Book(new PVector(WIDTH/2, 100), "left", 30, 1000, 4);
    nextSpawn++;
  }
  if (gameTime > 13000 && nextSpawn == 6) {
    nextSpawn++;
    new Book(new PVector(300, 200), "right", 20, 1500, 3);
    new Book(new PVector(WIDTH-300, 200), "left", 20, 1500, 3);
    new Nerd(new PVector(WIDTH/2 + 200, 100), 50, 500, 4000); //1 attack;
  }
  if (gameTime > 18000 && nextSpawn == 7) {
    nextSpawn++;
    new Nerd(new PVector(WIDTH/2, 150), 100, 4);
  }
  for (int i = 0; i < 4; i++) {
    if (gameTime > 20000 + i * 2000 && nextSpawn == 8 + i) {
      nextSpawn++;
      String randomDir;
      PVector target;
      if (random(2) < 1) {
        randomDir = "left";
        target = new PVector(WIDTH*2/3, 300);
      }
      else {
        randomDir = "right";
        target = new PVector(WIDTH/3, 300);
      }
      new Book(target, randomDir, 20, 1000, 3);
    }
  }
  for (int i = 0; i < 3; i++) {
    if (gameTime > 29000 + i * 500 && nextSpawn == 12 + i) {
      nextSpawn++;
      new Zygarde(new PVector(WIDTH/2-200 + i*200, 100), 30, 4);
    }
  }
  if (gameTime > 41000 && nextSpawn == 15) {
    new Teacher();
    changeBGM(bgm17);
    nextSpawn++;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (!(leftDown && rightDown)) {
        if (rightDown) { //cancel out
          right = false;
          lastRightUp = millis();
        }
        else {
          if (left == false) {
            lastLeft = millis();
          }
          left = true;
        }
      }
      leftDown = true;
    }
    if (keyCode == DOWN) {
      down = true;
    }
    if (keyCode == UP) {
      up = true;
    }
    if (keyCode == RIGHT) {
      if (!(leftDown && rightDown)) {
        if (leftDown) { //cancel out
          left = false;
          lastLeftUp = millis();
        }
        else {
          if (right == false) {
            lastRight = millis();
          }
          right = true;
        }
      }
      rightDown = true;
    }
    if (keyCode == SHIFT) {
      if (focus == false) {
        lastFocus = millis();
      }
      focus = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (rightDown) { //cancel out
        right = true;
        lastRight = millis();
      }
      else {
        if (left) {
          lastLeftUp = millis();
        }
        left = false;
      }
      leftDown = false;
    }
    if (keyCode == DOWN) {
      down = false;
    }
    if (keyCode == UP) {
      up = false;
    }
    if (keyCode == RIGHT) {
      if (leftDown) { //cancel out
        left = true;
        lastLeft = millis();
      }
      else {
        if (right) {
          lastRightUp = millis();
        }
        right = false;
      }
      rightDown = false;
    }
    if (keyCode == SHIFT) {
      if (focus) {
        lastFocusUp = millis();
      }
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

static void addBoss(BossEnemy e) {
  currentBoss.add(e);
}

static boolean removeBoss(BossEnemy e) {
  return currentBoss.remove(e);
}
