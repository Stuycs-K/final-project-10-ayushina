public class Bullet extends Mob {
  Mob owner;
  
  public Bullet(Mob own) {
    super(new PVector(0, 0), 10);
    type = "bullet";
    owner = own;
    Game.addBullet(this);
  }
  
  public Bullet(Mob own, PVector pos, PVector vel, float siz) {
    super(pos, siz);
    setVelocity(vel);
    type = "bullet";
    owner = own;
    Game.addBullet(this);
  }
  
  public void destroy() {
    super.destroy();
    Game.removeBullet(this);
  }
  
  public boolean deleteOffScreen() {
    PVector p = getPos();
    if (p.x < -size || p.x > width+size || p.y < -size || p.y > height+size) {
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
    if (owner.type == "character") {
      for (Enemy e : Game.enemyList) {
        if (getPos().dist(e.getPos()) <= getSize() + e.getSize()) {
          e.takeDamage();
          Game.removeMob(this);
        }
      }
    }
  }
}
