public abstract class BossEnemy extends Enemy {
  int phase;
  int maxPhases;
  int phaseStart;
  double maxHealth;
  int timeOut;
  PVector spawn;
  
  ArrayList<Bullet> bullets;
  
  public BossEnemy(PVector pos, float siz, double hp, int points, int maxPhases) {
    super(pos, siz, hp, points);
    phase = 0;
    this.maxPhases = maxPhases;
    phaseStart = millis();
    
    bullets = new ArrayList<Bullet>();
    
    maxHealth = hp;
    timeOut = 40000;
    Game.addBoss(this);
  }
  
  public boolean removeBullet(Bullet b) {
    return bullets.remove(b);
  }
  
  public void destroy() {
    super.destroy();
    Game.removeBoss(this);
  }
  
  public void nextPhase(boolean givePoints) {
    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = bullets.get(i);
      b.destroy();
      i--;
    }
    enepSound();
    
    phase++;
    phaseStart = millis();
    setVelocity(new PVector(0,0));
    targetPos = spawn.copy();
    nextAttack = 0;
    health = maxHealth;
    
    if (givePoints) {
      Game.score += this.points;
      Game.phaseScore += this.points;
    }
    if (phase >= maxPhases) {
      Game.kills++;
      Game.removeMob(this);
    }
  }
  
  public void takeDamage(double dmg) {
    health -= dmg;
    Game.score += dmg;
    Game.damageScore += dmg;
    if (health <= 0) {
      nextPhase(true);
    }
  }
}
