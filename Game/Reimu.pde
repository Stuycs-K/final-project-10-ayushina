public class Reimu extends Character {
  private static final float SPEED = 8.0;
  private static final float FOCUS_SPEED = 5.0;
  private static final float SIZE = 7;
  private static final int COOLDOWN = 100;
  private static final double DAMAGE = 1;
  private static final String NAME = "Player";
  
  PVector orbPos;
  
  public Reimu(PVector pos) {
    super(pos, SIZE, SPEED, FOCUS_SPEED, NAME);
    orbPos = downOrb;
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
      sprites = Game.reimuLeft;
      lastDown = Game.lastLeft;
      lastUp = Game.lastLeftUp;
    }
    else {
      sprites = Game.reimuRight;
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
  
  private void drawChar() {
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
        image(Game.reimuStandingLeft[(int) ((elapsed % (frame * 16))/(frame * 4))], getDisplayPos().x, getDisplayPos().y);
      }
      else {
        image(Game.reimuStandingRight[(int) ((elapsed % (frame * 16))/(frame * 4))], getDisplayPos().x, getDisplayPos().y);
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
    image(reimuOrb[0], pos.x + orbPos.x, pos.y + orbPos.y);
    popMatrix();
    pushMatrix();
    translate(pos.x - orbPos.x, pos.y + orbPos.y);
    rotate(radians((elapsed % 1000) / (float) 1000 * -360));
    translate(-(pos.x - orbPos.x), -(pos.y + orbPos.y));
    image(reimuOrb[0], pos.x - orbPos.x, pos.y + orbPos.y);
    popMatrix();
    imageMode(CORNER);
  }
 
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
  
  public void updateAttack() {
    if (millis() - lastAttack > COOLDOWN) {
      float bulletSize = 15;
      int[] bulletColor = new int[] {245, 167, 66};
      int[] homingColor = new int[] {66, 135, 245};
      
      for (int i = 0; i < 3; i++) {
        PVector bulletPos = getPos();
        bulletPos.y -= 10;
        PVector bulletVel = new PVector(0, -30);
        if (focus) {
          bulletVel.rotate(radians(-4 + i * 4));
          bulletPos.x = getPos().x - 10 + i * 5;
        }
        else {
          bulletVel.rotate(radians(-6 + i * 6));
          bulletPos.x = getPos().x - 20 + i * 10;
        }
        new Bullet(this, bulletPos, bulletVel, bulletSize, bulletColor, false, DAMAGE);
      }
      
      PVector leftVel = new PVector(0, -20);
      PVector rightVel = new PVector(0, -20);
      if (focus) {
        leftVel.rotate(radians(15));
        rightVel.rotate(radians(-15));
      }
      else {
        leftVel.rotate(radians(30));
        rightVel.rotate(radians(-30));
      }
      new Bullet(this, new PVector(getPos().x + orbPos.x, getPos().y + orbPos.y), leftVel, bulletSize, homingColor, true, DAMAGE / 2);
      new Bullet(this, new PVector(getPos().x - orbPos.x, getPos().y + orbPos.y), rightVel, bulletSize, homingColor, true, DAMAGE / 2);
      
      lastAttack = millis();
    }
  }
}
