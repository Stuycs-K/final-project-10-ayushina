public class Bullet extends Mob {
  Mob owner;
  double damage;
  int[] bulletColor;
  
  public Bullet(Mob own) {
    super(new PVector(0, 0), 10);
    type = "bullet";
    owner = own;
    Game.addBullet(this);
  }
  
  public Bullet(Mob own, PVector pos, PVector vel, float siz, int[] bulletColor) {
    super(pos, siz);
    setVelocity(vel);
    type = "bullet";
    owner = own;
    this.bulletColor = bulletColor;
    Game.addBullet(this);
  }
  
  public Bullet(Mob own, PVector pos, PVector vel, float siz, int[] bulletColor, double dmg) {
    super(pos, siz);
    setVelocity(vel);
    type = "bullet";
    owner = own;
    damage = dmg;
    this.bulletColor = bulletColor;
    Game.addBullet(this);
  }
  
  public void destroy() {
    super.destroy();
    Game.removeBullet(this);
  }
  
  public boolean deleteOffScreen() {
    PVector p = getPos();
    if (p.x < -size || p.x > Game.WIDTH+size || p.y < -size || p.y > Game.HEIGHT+size) {
      destroy();
      return true;
    }
    return false;
  }
  
  public void display() {
    ellipseMode(RADIUS);
    if (owner.type == "character") {
      stroke(0, 0);
      fill(bulletColor[0], bulletColor[1], bulletColor[2], 50);
    }
    else {
      stroke(bulletColor[0], bulletColor[1], bulletColor[2]);
    }
    circle(getDisplayPos().x, getDisplayPos().y, size);
    stroke(0);
    fill(255);
  }
  
  public void registerHit() {
    if (owner.type == "character") {
      for (Enemy e : Game.enemyList) {
        if (!e.invincible() && getPos().dist(e.getPos()) <= getSize() + e.getSize()) {
          e.takeDamage(damage);
          destroy();
        }
      }
    }
    else {
      if (!Game.chr.invincible() && getPos().dist(Game.chr.getPos()) <= getSize() + Game.chr.getSize()) {
        Game.chr.takeDamage();
        destroy();
      }
    }
  }
}
