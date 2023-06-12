public class Bullet extends Mob {
  Mob owner;
  double damage;
  int[] bulletColor;
  
  boolean alreadyHit;
  boolean alreadyGrazed;
  
  private final double LASER_TIME = 2000;
  
  String spec; //homing, gravity, laser
  
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
    spec = "";
    this.bulletColor = bulletColor;
    Game.addBullet(this);
  }
  
  public Bullet(Mob own, PVector pos, PVector vel, float siz, int[] bulletColor, String spec) {
    super(pos, siz);
    setVelocity(vel);
    type = "bullet";
    owner = own;
    this.bulletColor = bulletColor;
    this.spec = spec;
    Game.addBullet(this);
  }
  
  public Bullet(Mob own, PVector pos, PVector vel, float siz, int[] bulletColor, double dmg, String spec) {
    super(pos, siz);
    setVelocity(vel);
    type = "bullet";
    owner = own;
    damage = dmg;
    this.spec = spec;
    this.bulletColor = bulletColor;
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
    if (spec.equals("homing") && Game.enemyList.size() > 0) {
      PVector vel = getVelocity();
      float mag = vel.mag();
      PVector homingTarget = closestEnemy();
      vel.normalize().add((homingTarget.sub(getPos())).normalize().mult(0.3)).normalize().mult(mag);
      setVelocity(vel);
    }
    else if (spec.equals("gravity")) {
      setVelocity(getVelocity().add(new PVector(0, 0.1)));
    }
    if (spec.equals("laser")) {
      setVelocity(new PVector(0,0));
    }
    super.updatePos();
  }
  
  public void destroy() {
    super.destroy();
    Game.removeBullet(this);
    if (currentBoss.size() > 0) {
      currentBoss.get(0).removeBullet(this);
    }
  }
  
  public boolean deleteOffScreen() {
    PVector p = getPos();
    if (spec.equals("gravity")) {
      if (p.x < -size || p.x > Game.WIDTH+size || p.y > Game.HEIGHT+size) {
        destroy();
        return true;
      }
      else {
        return false;
      }
    }
    if (p.x < -size || p.x > Game.WIDTH+size || p.y < -size || p.y > Game.HEIGHT+size) {
      destroy();
      return true;
    }
    return false;
  }
  
  
  public void display() {
    ellipseMode(RADIUS);
    
    if (spec.equals("laser")) {
      int elapsed = millis() - birth;
      if (elapsed > LASER_TIME) {
        destroy();
        return;
      }
      float op = pow(1 - (elapsed) / (float) LASER_TIME, 5) * 255;
      stroke(bulletColor[0], bulletColor[1], bulletColor[2], op);
      fill(255, op);
      
      rectMode(CORNERS);
      PVector p = getDisplayPos();
      float s = getSize();
      rect(p.x - s, p.y, p.x + s, 0);
      rectMode(CORNER);
    }
    else {
      if (owner.type == "character") {
        stroke(bulletColor[0], bulletColor[1], bulletColor[2], 50);
        fill(255, 70);
      }
      else {
        stroke(bulletColor[0], bulletColor[1], bulletColor[2]);
      }
      circle(getDisplayPos().x, getDisplayPos().y, size);
    }
    
    stroke(0);
    fill(255);
  }
  
  public float pointToLine(PVector lineStart, PVector point) { //https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line#Line_defined_by_two_points
    float x0 = point.x;
    float y0 = point.y;
    float x1 = lineStart.x;
    float y1 = lineStart.x;
    
    float x2 = lineStart.x;
    float y2 = 0;
    
    return abs((x2 - x1) * (y1 - y0) - (x1 - x0) * (y2 - y1)) / (float) (sqrt(sq(x2 - x1) + sq(y2 - y1)));
  }
  
  public void registerHit() {
    if (owner.type == "character") {
      for (Enemy e : Game.enemyList) {
        if (spec.equals("laser")) {
          if (!alreadyHit && !e.invincible() && e.getPos().y - e.getSize() <= getPos().y && pointToLine(getPos(), e.getPos()) <= getSize() + e.getSize()) {
            e.takeDamage(damage);
            alreadyHit = true;
            lazerSound();
          }
        }
        else if (!e.invincible() && getPos().dist(e.getPos()) <= getSize() + e.getSize()) {
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
        if (!Game.graze.isPlaying()) {
          Game.graze.play();
        }
      }
      if (!Game.chr.invincible() && getPos().dist(Game.chr.getPos()) <= getSize() + Game.chr.getSize()) {
        Game.chr.takeDamage();
        destroy();
      }
    }
  }
}
