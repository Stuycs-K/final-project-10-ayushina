public class Bullet extends Mob {
  Mob owner;
  double damage;
  int[] bulletColor;
  
  boolean alreadyGrazed;
  
  boolean homing;
  
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
  
  public Bullet(Mob own, PVector pos, PVector vel, float siz, int[] bulletColor, boolean homing, double dmg) {
    super(pos, siz);
    setVelocity(vel);
    type = "bullet";
    owner = own;
    damage = dmg;
    this.bulletColor = bulletColor;
    this.homing = homing;
    Game.addBullet(this);
  }
  
  public PVector closestEnemy() {
    Enemy first = Game.enemyList.get(0);
    float minDist = first.getPos().dist(Game.chr.getPos());
    PVector closest = first.getPos();
    for (int i = 1; i < Game.enemyList.size(); i++) {
      Enemy e = Game.enemyList.get(i);
      float dist = e.getPos().dist(Game.chr.getPos());
      if (dist <= minDist) {
        minDist = dist;
        closest = e.getPos();
      }
    }
    return closest;
  }
  
  public void updatePos() {
    if (homing && Game.enemyList.size() > 0) {
      PVector vel = getVelocity();
      float mag = vel.mag();
      PVector homingTarget = closestEnemy();
      vel.normalize().add((homingTarget.sub(getPos())).normalize().mult(0.3)).normalize().mult(mag);
      setVelocity(vel);
    }
    super.updatePos();
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
      stroke(bulletColor[0], bulletColor[1], bulletColor[2], 50);
      fill(255, 70);
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
      if (!alreadyGrazed && !Game.chr.invincible() && getPos().dist(Game.chr.getPos()) <= getSize() + Game.GRAZE_RADIUS) {
        alreadyGrazed = true;
        score += Game.GRAZE_SCORE;
        grazeScore += Game.GRAZE_SCORE;
        grazes++;
        Game.graze.play();
      }
      if (!Game.chr.invincible() && getPos().dist(Game.chr.getPos()) <= getSize() + Game.chr.getSize()) {
        Game.chr.takeDamage();
        destroy();
      }
    }
  }
}
