public abstract class Character extends Mob {
  float moveSpeed;
  float focusSpeed;
  int lastAttack;
  
  String name;
  
  PImage[] charLeft, charRight, charStandingLeft, charStandingRight, charOrb, charDialogue;
  PVector orbPos;
  
  public Character(PVector pos, float siz, float speed, float focus, String name) {
    super(pos, siz);
    moveSpeed = speed;
    focusSpeed = focus;
    birth = millis();
    type = "character";
    this.name = name;
    loadSprites();
    orbPos = downOrb;
  }
  
  public abstract void loadSprites();
  
  public void display() {
    drawOrbs();
    drawChar();
    
    if (focus == true) {
      ellipseMode(RADIUS);
      stroke(255,0,0);
      circle(getDisplayPos().x, getDisplayPos().y, size);
      stroke(0);
    }
  }
  
  public abstract void updateAttack();
  
  public String getName() {
    return name;
  }
  
  public void takeDamage() {
    Game.lastDied = millis();
    Game.lives -= 1;
    Game.pldead00.play();
    if (Game.lives <= 0) {
      gameOver(false);
    }
  }
  public boolean invincible() {
    if (millis() - Game.lastDied <= Game.DEATH_TIME) {
      return true;
    }
    else {
      return false;
    }
  }
  
  public void updatePos() {
    super.updatePos();
    stayOnScreen();
  }
  
  private void stayOnScreen() {
    PVector p = getPos();
    if (p.x < size)
      p.set(size, p.y);
    if (p.x > Game.WIDTH-size)
      p.set(Game.WIDTH-size, p.y);
    if (p.y < size)
      p.set(p.x, size);
    if (p.y > Game.HEIGHT-size)
      p.set(p.x, Game.HEIGHT - size);
    setPos(p);
  }
  
  
  private static final double frame = 1000/30; //for reference
  private static final double animTime = frame * 8;
  
  private void drawMoving(String direction) {
    int elapsed;
    float alpha;
    PImage[] sprites;
    int lastDown;
    int lastUp;
    
    if (direction == "left") {
      sprites = charLeft;
      lastDown = Game.lastLeft;
      lastUp = Game.lastLeftUp;
    }
    else {
      sprites = charRight;
      lastDown = Game.lastRight;
      lastUp = Game.lastRightUp;
    }
    
    if (direction == "left" && Game.left || direction == "right" && Game.right) { //forward
      elapsed = millis() - lastDown;
      alpha = elapsed / (float) animTime;
      alpha = 1 - pow(1 - alpha, 2);
    }
    else { //backward
      elapsed = millis() - lastUp;
      alpha = elapsed / (float) animTime;
      alpha = pow(1 - alpha, 2);
      if (alpha == 1) {
        alpha = 0.999;
      }
    }
    
    if (elapsed < animTime) {
      image(sprites[(int) (alpha * (3))], getDisplayPos().x, getDisplayPos().y); //looping animation starts at 3
    }
    else {
      elapsed -= animTime;
      image(sprites[(int) (3 + (elapsed % (frame * 16))/(frame * 4))], getDisplayPos().x, getDisplayPos().y);
    }
  }
  
  public void drawChar() {
    int deathElapsed = millis() - Game.lastDied;
    if (Game.lastDied != -1 && deathElapsed <= Game.DEATH_TIME) {
      tint(255, sq(deathElapsed / (float) Game.DEATH_TIME) * 255);
    }
    imageMode(CENTER);
    if ((Game.left || millis() - Game.lastLeftUp < animTime) && !Game.right) {
      drawMoving("left");
    }
    else if ((Game.right || millis() - Game.lastRightUp < animTime) && !Game.left) {
      drawMoving("right");
    }
    else {
      int elapsed = millis() - birth;
      if (lastLeftUp > lastRightUp) {
        image(charStandingLeft[(int) ((elapsed % (frame * 16))/(frame * 4))], getDisplayPos().x, getDisplayPos().y);
      }
      else {
        image(charStandingRight[(int) ((elapsed % (frame * 16))/(frame * 4))], getDisplayPos().x, getDisplayPos().y);
      }
    }
    imageMode(CORNER);
    noTint();
  }

  private static final double orbAnimTime = frame * 4;
  private final PVector upOrb = new PVector(15, -65);
  private final PVector downOrb = new PVector(45, 0);
  
  public void drawOrbs() {
    if (lastFocus == -1) {
      orbPos = downOrb;
    }
    else if (focus) {
      int elapsed = millis() - lastFocus;
      if (elapsed < orbAnimTime) {
        double alpha = elapsed / orbAnimTime;
        PVector start = downOrb.copy();
        PVector end = upOrb.copy();
        orbPos = start.add(end.sub(start).mult((float) alpha));
      }
      else {
        orbPos = upOrb;
      }
    }
    else {
      int elapsed = millis() - lastFocusUp;
      if (elapsed < orbAnimTime) {
        double alpha = elapsed / orbAnimTime;
        PVector start = upOrb.copy();
        PVector end = downOrb.copy();
        orbPos = start.add(end.sub(start).mult((float) alpha));
      }
      else {
        orbPos = downOrb;
      }
    }
    int elapsed = millis() - stateStart;
    PVector pos = getDisplayPos();
    imageMode(CENTER);
    pushMatrix();
    translate(pos.x + orbPos.x, pos.y + orbPos.y);
    rotate(radians((elapsed % 1000) / (float) 1000 * 360));
    translate(-(pos.x + orbPos.x), -(pos.y + orbPos.y));
    image(charOrb[0], pos.x + orbPos.x, pos.y + orbPos.y);
    popMatrix();
    pushMatrix();
    translate(pos.x - orbPos.x, pos.y + orbPos.y);
    rotate(radians((elapsed % 1000) / (float) 1000 * -360));
    translate(-(pos.x - orbPos.x), -(pos.y + orbPos.y));
    image(charOrb[0], pos.x - orbPos.x, pos.y + orbPos.y);
    popMatrix();
    imageMode(CORNER);
  }
}
