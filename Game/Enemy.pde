public abstract class Enemy extends Mob {
  double health;
  
  public Enemy(PVector pos, float siz, double hp) {
    super(pos, siz);
    health = hp;
    type = "enemy";
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
      Game.removeMob(this);
    }
  }
  public abstract void updateAttack();
}
