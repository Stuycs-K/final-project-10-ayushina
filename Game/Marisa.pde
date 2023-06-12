public class Marisa extends Character {
  private static final float SPEED = 9.0;
  private static final float FOCUS_SPEED = 6.0;
  private static final float SIZE = 7.5;
  private static final int COOLDOWN = 100;
  private static final double DAMAGE = 1.2;
  private static final String NAME = "Marisa";
  
  private static final int LASER_COOLDOWN = 2000;
  
  private int lastLaser;
  
  public Marisa(PVector pos) {
    super(pos, SIZE, SPEED, FOCUS_SPEED, NAME);
    lastLaser = -1;
  }
  
  public void loadSprites() {
    charLeft = Game.marisaLeft;
    charRight = Game.marisaRight;
    charStandingLeft = Game.marisaStandingLeft;
    charStandingRight = Game.marisaStandingRight;
    charOrb = Game.marisaOrb;
    charDialogue = Game.marisaDialogue;
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
          bulletPos.x = getPos().x - 15 + i * 15;
        }
        else {
          bulletPos.x = getPos().x - 25 + i * 25;
        }
        new Bullet(this, bulletPos, bulletVel, bulletSize, bulletColor, DAMAGE, "");
      }
      
      if (lastLaser == -1 || millis() - lastLaser > LASER_COOLDOWN) {
        new Bullet(this, new PVector(getPos().x + orbPos.x, getPos().y + orbPos.y), new PVector(0,0), bulletSize, homingColor, DAMAGE * 10, "laser");
        new Bullet(this, new PVector(getPos().x - orbPos.x, getPos().y + orbPos.y), new PVector(0,0), bulletSize, homingColor, DAMAGE * 10, "laser");
        
        lastLaser = millis();
      }
      
      lastAttack = millis();
    }
  }
}
