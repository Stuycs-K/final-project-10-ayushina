public class Reimu extends Character {
  private static final float SPEED = 8.0;
  private static final float FOCUS_SPEED = 5.0;
  private static final float SIZE = 7;
  private static final int COOLDOWN = 100;
  private static final double DAMAGE = 1;
  private static final String NAME = "Reimu";
  
  public Reimu(PVector pos) {
    super(pos, SIZE, SPEED, FOCUS_SPEED, NAME);
  }
  
  public void loadSprites() {
    charLeft = Game.reimuLeft;
    charRight = Game.reimuRight;
    charStandingLeft = Game.reimuStandingLeft;
    charStandingRight = Game.reimuStandingRight;
    charOrb = Game.reimuOrb;
    charDialogue = Game.reimuDialogue;
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
          bulletPos.x = getPos().x - 5 + i * 5;
        }
        else {
          bulletVel.rotate(radians(-6 + i * 6));
          bulletPos.x = getPos().x - 10 + i * 10;
        }
        new Bullet(this, bulletPos, bulletVel, bulletSize, bulletColor, DAMAGE, "");
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
      new Bullet(this, new PVector(getPos().x + orbPos.x, getPos().y + orbPos.y), leftVel, bulletSize, homingColor, DAMAGE / 2, "homing");
      new Bullet(this, new PVector(getPos().x - orbPos.x, getPos().y + orbPos.y), rightVel, bulletSize, homingColor, DAMAGE / 2, "homing");
      
      lastAttack = millis();
    }
  }
}
