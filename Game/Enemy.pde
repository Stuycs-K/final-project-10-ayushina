public class Enemy {
  PVector position, velocity;
  float size;
  double health;
  int birth;
  int lastAttack;
  int nextAttack;
  
  public Enemy(PVector pos, float siz, double hp) {
    position = pos;
    velocity = new PVector(0, 0);
    size = siz;
    health = hp;
    birth = millis();
  }
}
