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
  
  public void takeDamage(double dmg) {
    health -= dmg;
    if (health <= 0) {
      Game.kills++;
      Game.score += this.points;
      Game.removeMob(this);
    }
  }
  public boolean invincible() {
    return health <= 0;
  }
  public abstract void updateAttack();
}
