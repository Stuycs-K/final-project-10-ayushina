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
  
  public void destroy() {
    super.destroy();
    Game.removeBullet(this);
  }
  
  public boolean deleteOffScreen() {
    PVector p = getPos();
    if (p.x < -size || p.x > width+size || p.y < -size || p.y > 500) {
      destroy();
      return true;
    }
    return false;
  }
  
  public void display() {
    ellipseMode(RADIUS);
    circle(getPos().x, getPos().y, size);
  }
  
  public void registerHit() {
    
  }
}
