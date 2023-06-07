public abstract class BossEnemy extends Enemy {
  int phase;
  int maxPhases;
  int phaseStart;
  double maxHealth;
  int timeOut;
  PVector spawn;
  
  public BossEnemy(PVector pos, float siz, double hp, int points, int maxPhases) {
    super(pos, siz, hp, points);
    phase = 0;
    this.maxPhases = maxPhases;
    phaseStart = millis();
    
    maxHealth = hp;
    timeOut = 100000;
    Game.addBoss(this);
  }
  
  public void destroy() {
    super.destroy();
    Game.removeBoss(this);
  }
  
  public void nextPhase(boolean givePoints) {
    phase++;
    phaseStart = millis();
    setVelocity(new PVector(0,0));
    setPos(spawn);
    nextAttack = 0;
    health = maxHealth;
    
    if (givePoints) {
      Game.score += this.points;
    }
    if (phase >= maxPhases) {
      Game.kills++;
      Game.removeMob(this);
    }
  }
  
  public void takeDamage(double dmg) {
    health -= dmg;
    Game.score += dmg;
    if (health <= 0) {
      nextPhase(true);
    }
  }
}
