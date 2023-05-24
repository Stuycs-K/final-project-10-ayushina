public abstract class Character extends Mob {
  float moveSpeed;
  int lastAttack;
  
  public Character(PVector pos, float siz, float speed) {
    super(pos, siz);
    moveSpeed = speed;
    birth = millis();
  }
  
  public abstract void display();
  public abstract void updateAttack();
  
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
