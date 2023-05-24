public class Bullet extends Mob {
  
  public Bullet() {
    super(new PVector(0, 0), 10);
    Game.addBullet(this);
  }
  
  public Bullet(PVector pos, PVector vel, float siz) {
    super(pos, siz);
    setVelocity(vel);
    Game.addBullet(this);
  }
  
  public void display() {
    ellipseMode(RADIUS);
    circle(getPos().x, getPos().y, size);
  }
}
