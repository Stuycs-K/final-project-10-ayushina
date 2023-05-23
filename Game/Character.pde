public abstract class Character {
  PVector position, velocity;
  float size, moveSpeed;
  int cooldown;
  Bullet[] bullets;
  
  public Character(PVector pos, float siz, float speed, int cd) {
    position = pos;
    velocity = new PVector(0, 0);
    size = siz;
    moveSpeed = speed;
    cooldown = cd;
  }
  
  public abstract void display();
  public abstract void updateAttack();
  
  public void updatePos() {
    position.add(velocity);
    stayOnScreen();
  }
  
  public PVector getPos() {
    return position;
  }
  
  public void setVelocity(PVector vel) {
    velocity = vel;
  }
  
  private void stayOnScreen() {
    if (position.x < size)
      position.set(size, position.y);
    if (position.x > width-size)
      position.set(width-size, position.y);
    if (position.y < size)
      position.set(position.x, size);
    if (position.y > height-size)
      position.set(position.x, height - size);
  }
}
