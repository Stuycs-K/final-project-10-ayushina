public abstract class Character extends Mob {
  float moveSpeed;
  int lastAttack;
  
  int lives;
  
  public Character(PVector pos, float siz, float speed) {
    super(pos, siz);
    moveSpeed = speed;
    birth = millis();
    type = "character";
    
    lives = 3;
  }
  
  public abstract void display();
  public abstract void updateAttack();
  
  public void takeDamage() {
    lives -= 1;
    if (lives <= 0) {
      Game.gameOver = true;
    }
  }
  
  public void updatePos() {
    super.updatePos();
    stayOnScreen();
  }
  
  private void stayOnScreen() {
    PVector p = getPos();
    if (p.x < size)
      p.set(size, p.y);
    if (p.x > Game.WIDTH-size)
      p.set(Game.WIDTH-size, p.y);
    if (p.y < size)
      p.set(p.x, size);
    if (p.y > Game.HEIGHT-size)
      p.set(p.x, Game.HEIGHT - size);
    setPos(p);
  }
}
