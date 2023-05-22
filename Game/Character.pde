public class Character {
  PVector position, velocity;
  float size;
  
  public Character(PVector pos) {
    position = pos;
    velocity = new PVector(0, -10);
    size = 20;
  }
  
  public void updatePos() {
    position.add(velocity);
    stayOnScreen();
  }
  
  public void display() {
    ellipseMode(RADIUS);
    circle(position.x, position.y, size);
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
