public class Enemy extends Mob {
  double health;
  int lastAttack;
  int nextAttack;
  
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
  
  public void display() {
    ellipseMode(RADIUS);
    circle(getPos().x, getPos().y, size);
  }
  public void takeDamage(double dmg) {
    health -= dmg;
    if (health <= 0) {
      Game.removeMob(this);
    }
  }
  public void updateAttack() {
    
  }
}
