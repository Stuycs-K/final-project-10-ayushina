public class Reimu extends Character {
  private static final float SPEED = 15.0;
  private static final int COOLDOWN = 100;
  
  public Reimu(PVector pos, float siz) {
    super(pos, siz, SPEED, COOLDOWN);
  }
 
  public void display() {
    ellipseMode(RADIUS);
    circle(getPos().x, getPos().y, size);
  }
  
  public void updateAttack() {
    
  }
}
