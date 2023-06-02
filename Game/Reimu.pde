public class Reimu extends Character {
  private static final float SPEED = 7.0;
  private static final float SIZE = 8;
  private static final int COOLDOWN = 100;
  private static final double DAMAGE = 10;
  private static final String NAME = "Reimu";
  
  public Reimu(PVector pos) {
    super(pos, SIZE, SPEED, NAME);
  }
 
  public void display() {
    int elapsed = millis() - birth;
    imageMode(CENTER);
    image(Game.reimuStanding[(elapsed % 400)/100], getDisplayPos().x, getDisplayPos().y);
    imageMode(CORNER);
  }
  
  public void updateAttack() {
    if (millis() - lastAttack > COOLDOWN) {
      PVector bulletVel = new PVector(0, -10);
      float bulletSize = 10;
      new Bullet(this, getPos(), bulletVel, bulletSize, DAMAGE);
      lastAttack = millis();
    }
  }
}
