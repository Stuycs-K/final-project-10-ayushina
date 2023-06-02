public abstract class Character extends Mob {
  float moveSpeed;
  float focusSpeed;
  int lastAttack;
  
  String name;
  
  
  public Character(PVector pos, float siz, float speed, float focus, String name) {
    super(pos, siz);
    moveSpeed = speed;
    focusSpeed = focus;
    birth = millis();
    type = "character";
    this.name = name;
    
    Game.lives = 3;
  }
  
  public abstract void display();
  public abstract void updateAttack();
  
  public String getName() {
    return name;
  }
  
  public void takeDamage() {
    Game.lives -= 1;
    if (Game.lives <= 0) {
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
