public abstract class Enemy extends Mob {
  double health;
  int points;
  int nextAttack;
  int nextAttackB;
  PVector targetPos;

  
  public Enemy(PVector pos, float siz, double hp, int points) {
    super(pos, siz);
    health = hp;
    type = "enemy";
    this.points = points;
    Game.addEnemy(this);
  }
  
  public void destroy() {
    super.destroy();
    Game.removeEnemy(this);
  }
  
  public abstract void display();
  
  public void goTo(PVector targetPos, float time) {
    float rate = targetPos.dist(getPos())/(60*(time/1000)); //in t milliseconds
    setVelocity(PVector.sub(targetPos, getPos()).normalize().mult(rate));
  }
  
  public void takeDamage(double dmg) {
    health -= dmg;
    Game.score += dmg;
    Game.damageScore += dmg;
    if (health <= 0) {
      Game.kills++;
      Game.score += this.points;
      Game.killScore += this.points;
      Game.removeMob(this);
    }
  }
  public boolean invincible() {
    return health <= 0;
  }
  public abstract void updateAttack();
}
