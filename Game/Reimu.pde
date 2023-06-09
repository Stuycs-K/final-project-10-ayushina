public class Reimu extends Character {
  private static final float SPEED = 8.0;
  private static final float FOCUS_SPEED = 5.0;
  private static final float SIZE = 7;
  private static final int COOLDOWN = 100;
  private static final double DAMAGE = 1;
  private static final String NAME = "Player";
  
  public Reimu(PVector pos) {
    super(pos, SIZE, SPEED, FOCUS_SPEED, NAME);
  }
  
  private static final double frame = 1000/30; //for reference
  private static final double animTime = frame * 8;
  
  private void drawMoving(String direction) { //lastUp < animTime
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
      image(Game.reimuStanding[(int) ((elapsed % (frame * 16))/(frame * 4))], getDisplayPos().x, getDisplayPos().y);
    }
    imageMode(CORNER);
    noTint();
  }
 
  public void display() {
    drawChar();
    
    if (Game.focus == true) {
      ellipseMode(RADIUS);
      stroke(255,0,0);
      circle(getDisplayPos().x, getDisplayPos().y, size);
      stroke(0);
    }
  }
  
  public void updateAttack() {
    if (millis() - lastAttack > COOLDOWN) {
      float bulletSize = 20;
      int[] bulletColor = new int[] {245, 167, 66};
      int[] homingColor = new int[] {66, 135, 245};
      
      for (int i = 0; i < 3; i++) {
        PVector bulletPos = getPos();
        bulletPos.y -= 10;
        PVector bulletVel = new PVector(0, -20);
        if (focus) {
          bulletVel.rotate(radians(-1 + i * 1));
          bulletPos.x = getPos().x - 10 + i * 5;
        }
        else {
          bulletVel.rotate(radians(-6 + i * 6));
          bulletPos.x = getPos().x - 20 + i * 10;
        }
        new Bullet(this, bulletPos, bulletVel, bulletSize, bulletColor, false, DAMAGE);
      }
      //new Bullet(this, bulletPos, bulletVel, bulletSize, homingColor, true, DAMAGE);
      
      lastAttack = millis();
    }
  }
}
