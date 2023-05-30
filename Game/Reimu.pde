public class Reimu extends Character {
  private static final float SPEED = 8.0;
  private static final float SIZE = 5;
  private static final int COOLDOWN = 100;
  private static final double DAMAGE = 10;
  
  public Reimu(PVector pos) {
    super(pos, SIZE, SPEED);
  }
 
  public void display() {
    ellipseMode(RADIUS);
    circle(getPos().x, getPos().y, size);
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
