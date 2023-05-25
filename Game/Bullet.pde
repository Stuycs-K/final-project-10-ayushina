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
  
  public void updatePos() {
    super.updatePos();
    deleteOffScreen();
  }
  
  private void deleteOffScreen() {
    PVector p = getPos();
    if (p.x < -size || p.x > width+size || p.y < -size || p.y > height+size) {
      
    }
  }
  
  public void display() {
    ellipseMode(RADIUS);
    circle(getPos().x, getPos().y, size);
  }
  
  public void registerHit() {
    
  }
}
