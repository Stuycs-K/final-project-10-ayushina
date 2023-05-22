public class Character {
  PVector position, velocity;
  
  public Character(PVector pos) {
    position = pos;
    velocity = new PVector(0, 10);
  }
  
  public void updatePos() {
    position.add(velocity);
  }
  
  public void display() {
    circle(position.x, position.y, 50.0);
  }
}
