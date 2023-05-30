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
      p.set(size, position.y);
    if (p.x > width-size)
      p.set(width-size, position.y);
    if (p.y < size)
      p.set(position.x, size);
    if (p.y > height-size)
      p.set(position.x, height - size);
    setPos(p);
  }
}
