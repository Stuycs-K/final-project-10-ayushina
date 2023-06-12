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

static int cheatMode;

static final int WIN_SCORE = 5000;

final static String start = "start";
final static String charSelect = "charSelect";
final static String game = "game";
final static String dialogue = "dialogue";
final static String gameOver = "gameOver";

String chosenChar;
int nextDialogue;
int nextMessage;
int messageStart;

static final int MESSAGE_TIME = 1000;

static int[] bg;
static final int[] DEFAULT_BG = new int[] {90, 10, 10};

static int bgmStart;
static SoundFile bgm;

static final double BGM_INFO_TIME = 7000;

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

static PImage[] reimuStandingLeft, reimuStandingRight, reimuLeft, reimuRight, reimuOrb, reimuDialogue;
static PImage[] marisaStandingLeft, marisaStandingRight, marisaLeft, marisaRight, marisaOrb, marisaDialogue;

static PImage[] teacherDialogue;

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
  PImage reimuEmotes = loadImage("reimu-dialogue.png");
  reimuDialogue = new PImage[6];
  for (int i = 0; i < 6; i++) {
    reimuDialogue[i] = reimuEmotes.get(i * 128, 0, 128, 256);
  }
  
  //marisa
  PImage marisaSprites = loadImage("marisa-sprites.png");
  marisaStandingLeft = new PImage[4];
  for(int i = 0; i < 4; i++) {
    marisaStandingLeft[i] = marisaSprites.get(i * 64, 0, 64, 96);
  }
  marisaStandingRight = new PImage[4];
  for(int i = 0; i < 4; i++) {
    marisaStandingRight[i] = flipImage(marisaSprites.get(i * 64, 0, 64, 96));
  }
  marisaLeft = new PImage[7];
  for (int i = 0; i < 7; i++) {
    marisaLeft[i] = marisaSprites.get(i * 64, 96, 64, 96);
  }
  marisaRight = new PImage[7];
  for (int i = 0; i < 7; i++) {
    marisaRight[i] = flipImage(marisaSprites.get(i * 64, 96, 64, 96));
  }
  marisaOrb = new PImage[4];
  for (int i = 0; i < 4; i++) {
    marisaOrb[i] = marisaSprites.get(4 * 64 + i * 32, 64, 32, 32);
  }
  PImage marisaEmotes = loadImage("marisa-dialogue.png");
  marisaDialogue = new PImage[6];
  for (int i = 0; i < 6; i++) {
    marisaDialogue[i] = marisaEmotes.get(i * 128, 0, 128, 256);
  }
  
  PImage teacherEmotes = loadImage("teacher-dialogue.png");
  teacherDialogue = new PImage[3];
  for (int i = 0; i < 3; i++) {
    teacherDialogue[i] = teacherEmotes.get(i * 128, 0, 128, 128);
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

void lazerSound() {
  if (random(2) < 1) {
    lazer00.play();
  }
  else {
    lazer01.play();
  }
}

static SoundFile pldead00;
static SoundFile tan00,tan01,tan02;
static SoundFile graze;
static SoundFile enep00, enep01;
static SoundFile timeout;
static SoundFile lazer00, lazer01;

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
  timeout = new SoundFile(this, "timeout.wav");
  lazer00 = new SoundFile(this, "lazer00.wav");
  lazer01 = new SoundFile(this, "lazer01.wav");
  
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
  if (bgm == music) {
    return;
  }
  if (bgm != null) {
    bgm.stop();
  }
  if (music != null) {
    bgm = music;
    bgmStart = millis();
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

void newGame() { 
  changeState(Game.game);
  gameWon = false;
  newHighScore = false;
  
  bg = DEFAULT_BG;
  
  score = 0;
  timeCounted = 0;
  timeScore = 0;
  phaseScore = 0;
  damageScore = 0;
  grazeScore = 0;
  killScore = 0;
  
  lives = PLAYER_LIVES;
  kills = 0;
  lastDied = -1;
  grazes = 0;
  
  gameTime = 0;
  deltaTime = 0;
  nextSpawn = 0;
  
  nextDialogue = 0;
  nextMessage = 0;
  messageStart = 0;
  
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
  
  if (chosenChar.equals("Reimu")) {
    chr = new Reimu(new PVector(WIDTH/2,800));
  }
  else if (chosenChar.equals("Marisa")) {
    chr = new Marisa(new PVector(WIDTH/2,800));
  }
  else {
    chr = new Reimu(new PVector(WIDTH/2,800));
  }
  
  if (cheatMode == 1) {
    int time = 40000;
    stateStart = millis() - time;
    gameTime = time;
    nextSpawn = 18;
    lives = 99;
  }
  else if (cheatMode == 2) {
    lives = 99;
  }
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
  
  mobList = new ArrayList<Mob>();
  bulletList = new ArrayList<Bullet>();
  enemyList = new ArrayList<Enemy>();
  mNext = new ArrayList<Mob>();
  bNext = new ArrayList<Bullet>();
  eNext = new ArrayList<Enemy>();
  currentBoss = new ArrayList<BossEnemy>();
  
  lastMouseUp = new float[]{};
  lastMouseDown = new float[]{};
  chosenChar = "";
  
  cheatMode = 0;
  
  gameState = "";
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
  text("Damage", windowPos.x + WIDTH + 225, 600);
  text("Graze", windowPos.x + WIDTH + 225, 700);
  text("Time", windowPos.x + WIDTH + 225, 800);
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
  text(damageScore, windowPos.x + WIDTH + 250, 600);
  text(grazes, windowPos.x + WIDTH + 250, 700);
  text(gameTime/1000, windowPos.x + WIDTH + 250, 800);
  
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
  float[] startButton = new float[] {windowPos.x + WIDTH / 2, windowPos.y + 700, 400, 100};
  if (mouseOnButton(startButton)) {
    changeState(Game.start);
  }
  drawButton(startButton, "Play Again?");
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
  String previousState = gameState;
  gameState = state;
  stateStart = millis();
  if (state.equals(Game.start)) {
    changeBGM(bgm01);
    if (!previousState.equals(Game.charSelect)) {
      cheatMode = 0;
    }
  }
  else if (state.equals(Game.charSelect)) {
    menuChars = new ArrayList<Character>();
    menuChars.add(new Reimu(new PVector(width/2 - 300, height - 300)));
    menuChars.add(new Marisa(new PVector(width/2 + 300, height - 300)));
  }
  else if (state.equals(Game.game)) {
    if (previousState.equals(Game.dialogue)) {
      nextMessage = 0;
      nextDialogue++;
    }
    gameTime = 0;
    timeCounted = 0;
    changeBGM(bgm16);
  }
  else if (state.equals(Game.dialogue)) {
    nextMessage = 0;
    messageStart = millis();
  }
  else if (state.equals(Game.gameOver)) {
    bgm.pause();
    bgm.play();
  }
}

private void drawBGM(float x, float y) {
  int elapsed = millis() - bgmStart;
  if (elapsed > BGM_INFO_TIME) {
    return;
  }
  textAlign(LEFT);
  textSize(24);
  float op = pow(255 - (elapsed) / (float) BGM_INFO_TIME * 255, 2);
  fill(255, op);
  text("♪ " + getMusicName(bgm), x, y);
  fill(255);
  textAlign(BASELINE);
}

private ArrayList<Character> menuChars;

void draw() {  
  updateMouse();
  
  if (gameState.equals(Game.start)) {
    background(166,60,91);
    drawBGM(10, height - 5);
    
    float[] playButton = new float[] {width / 2 - 400, height / 2, 400, 100};
    if (mouseOnButton(playButton)) {
      changeState(Game.charSelect);
    }
    if (cheatMode != 0) {
      drawButton(playButton, "Cheats On! (#" + cheatMode + ")");
    }
    else {
      drawButton(playButton, "Play");
    }
    
    textAlign(CENTER);
    textSize(96);
    fill(255);
    text("Click Play", width / 2, 300);
    textAlign(BASELINE);
    
    //cheat 1
    float[] skipButton = new float[] {width / 2 - 400, height / 2 + 150, 400, 100};
    if (mouseOnButton(skipButton)) {
      cheatMode = 1;
    }
    drawButton(skipButton, "Skip + Inf lives");
    
    //cheat 2
    float[] livesButton = new float[] {width / 2 - 400, height / 2 + 300, 400, 100};
    if (mouseOnButton(livesButton)) {
      cheatMode = 2;
    }
    drawButton(livesButton, "Inf lives");
    
    rectMode(CORNER);
    fill(255);
    strokeWeight(4);
    stroke(0);
  }
  else if (gameState.equals(Game.charSelect)) {
    background(166,60,91);
    drawBGM(10, height - 5);
    
    textAlign(CENTER);
    textSize(96);
    fill(255);
    text("Character Select", width / 2, 300);
    textAlign(BASELINE);
    
    float[] startButton = new float[] {200, 50, 400, 100};
    if (mouseOnButton(startButton)) {
      changeState(Game.start);
    }
    drawButton(startButton, "Back");
    
    float[] reimuButton = new float[] {width / 2 - 300, height - 100, 400, 100};
    if (mouseOnButton(reimuButton)) {
      chosenChar = "Reimu";
      newGame();
    }
    drawButton(reimuButton, "Reimu");

    float[] marisaButton = new float[] {width / 2 + 300, height - 100, 400, 100};
    if (mouseOnButton(marisaButton)) {
      chosenChar = "Marisa";
      newGame();
    }
    drawButton(marisaButton, "Marisa");
    
    for (int i = 0; i < menuChars.size(); i++) {
      menuChars.get(i).display();
    }
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
    drawBGM(10, height - 5);
    
    if (nextDialogue == 2 && currentBoss.size() == 0) {
      gameOver(true);
    }
  }
  else if (gameState.equals(Game.dialogue)) {
    background(bg[0], bg[1], bg[2]);
    
    updateMobs();
    chr.setVelocity(new PVector(0,0));
  
    mobList = new ArrayList<Mob>(mNext);
    bulletList = new ArrayList<Bullet>(bNext);
    enemyList = new ArrayList<Enemy>(eNext);
    
    int elapsed = millis() - messageStart;
    
    ArrayList<String[]> messages = getNextDialogue();
    if (nextMessage < messages.size()) {
      String[] msg = messages.get(nextMessage);
      
      if (nextMessage > 0) {
        String[] prevMessage = messages.get(nextMessage - 1);
        if (prevMessage[0] != msg[0]) {
          drawMessage(prevMessage, false, true);
        }
      }
      
      if (elapsed < MESSAGE_TIME) {
        drawMessage(msg, false, false);
      }
      else {
        drawMessage(msg, true, false);
        if (mousePressed) {
          nextMessage++;
          messageStart = millis();
        }
      }
    }
    else {
      changeState(Game.game);
    }
    
    drawBorder();
    drawBGM(10, height - 5);
  }
  else if (gameState.equals(Game.gameOver)) {
    background(90, 10, 10);
    drawBGM(10, height - 5);
    gameOverScreen();
    drawBorder();
  }
  else {
    print(gameState);
  }
}

void drawMessage(String[] msg, boolean skippable, boolean imageOnly) {
  rectMode(CORNERS);
  textSize(36);
  if (msg[0].equals("Player")) {
    int index = 0;
    if (msg[2].equals("Serious")) {
      index = 1;
    }
    else if (msg[2].equals("Laughing")) {
      index = 2;
    }
    else if (msg[2].equals("Resting")) {
      index = 3;
    }
    else if (msg[2].equals("Angry")) {
      index = 4;
    }
    else if (msg[2].equals("Sweating")) {
      index = 5;
    }
    image(chr.charDialogue[index], windowPos.x + 10, windowPos.y + HEIGHT - 300 - 256 - 40);
    
    if (!imageOnly) {
      textAlign(LEFT, BOTTOM);
      text(chr.getName(), windowPos.x + 10, windowPos.y + HEIGHT - 300);
    }
  }
  else if (msg[0].equals("Teacher")) {
    int index = 1;
    if (msg[2].equals("Reading")) {
      index = 0;
    }
    else if (msg[2].equals("Serious")) {
      index = 2;
    }
    image(teacherDialogue[index], windowPos.x + WIDTH - 10 - 128, windowPos.y + HEIGHT - 300 - 128 - 40);
    
    if (!imageOnly) {
      textAlign(RIGHT, BOTTOM);
      text("Teacher", windowPos.x + WIDTH - 10, windowPos.y + HEIGHT - 300);
    }
  }
  
  if (imageOnly) {
    textAlign(BASELINE);
    rectMode(CORNER);
    return;
  }
  
  if (skippable) {
    textAlign(RIGHT, BOTTOM);
    text("Click Anywhere to Continue", windowPos.x + WIDTH - 5, windowPos.y + HEIGHT);
  }
  
  fill(255, 127);
  stroke(0, 0);
  rect(windowPos.x + 5, windowPos.y + HEIGHT - 5, windowPos.x + WIDTH - 5, windowPos.y + HEIGHT - 300);
  stroke(0);
  fill(255);
  
  textSize(32);
  textAlign(LEFT, TOP);
  text(msg[1], windowPos.x + 10, windowPos.y + HEIGHT - 10, windowPos.x + WIDTH - 10, windowPos.y + HEIGHT - 300);
  textAlign(BASELINE);
  rectMode(CORNER);
}

ArrayList<String[]> getNextDialogue() {
  ArrayList<String[]> messages = new ArrayList<String[]>();
  if (nextDialogue == 0) {
    messages.add(new String[] {"Player", "What a nice day it is today. The sun is shining, and the weather is perfect for going outside.", "Resting"});
    messages.add(new String[] {"Player", "I wish I could go outside right now, but my lunch period is almost over...", ""});
    messages.add(new String[] {"Player", "I know! I'll skip Physics!", "Laughing"});
    messages.add(new String[] {"Teacher", "Hey! " + chr.getName() + "! Class is starting soon! What are you doing here?", ""});
    messages.add(new String[] {"Player", "Uhhh, nothing!", "Sweating"});
    messages.add(new String[] {"Teacher", "You suck at physics, so hurry and get to class!", ""});
    messages.add(new String[] {"Player", "?!", "Angry"});
    messages.add(new String[] {"Teacher", "I won't let you skip my class! And I'm changing your grade to -999999!", "Serious"});
    messages.add(new String[] {"Player", "If you think you can get in my way, I won't let you!", "Serious"});
    messages.add(new String[] {"Teacher", "This physics textbook has the most powerful magic spells in this universe!", "Reading"});
    messages.add(new String[] {"Player", "Bring it on!", "Serious"});
  }
  else if (nextDialogue == 1) {
    messages.add(new String[] {"Teacher", "Ahhhh!", ""});
    messages.add(new String[] {"Player", "You weren't that strong! Maybe I am good at physics after all!", "Laughing"});
    messages.add(new String[] {"Teacher", "Fine, you win!", "Serious"});
    messages.add(new String[] {"Player", "See you later!", ""});
  }
  return messages;
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
  if (nextDialogue == 0) {
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
        new Zygarde(new PVector(WIDTH/2-200 + i*200, 100), 20, 4);
      }
    }
    if (gameTime > 33000 && nextSpawn == 15) {
      nextSpawn++;
      new Zygarde(new PVector(200, 100), 10, 1000, 6000);
      new Zygarde(new PVector(400, 100), 10, 1000, 6000);
      new Nerd(new PVector(WIDTH-200, 100), 10, 1000, 6000);
      new Book(new PVector(500, 100), "left", 10, 1000, 2);
    }
    if (gameTime > 35000 && nextSpawn == 16) {
      nextSpawn++;
      new Zygarde(new PVector(WIDTH/2, 100), 20, 500, 5000);
    }
    if (gameTime > 36000 && nextSpawn == 17) {
      nextSpawn++;
      new Nerd(new PVector(200, 100), 10, 500, 4000);
      new Book(new PVector(WIDTH-500, 100), "right", 10, 500, 4000);
    }
    if (gameTime > 41000 && nextSpawn == 18) {
      nextSpawn++;
      changeState(Game.dialogue);
    }
  }
  else if (nextDialogue == 1) {
    if (gameTime > 1000 && nextSpawn == 19) {
      new Teacher();
      changeBGM(bgm17);
      nextSpawn++;
    }
    else if (currentBoss.size() == 0 && nextSpawn == 20) {
      nextSpawn++;
      changeState(Game.dialogue);
    }
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
