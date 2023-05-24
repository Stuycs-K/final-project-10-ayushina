public class Bullet {
  PVector position, velocity;
  float size;
  
  public Bullet() {
    position = new PVector(0, 0);
    velocity = new PVector(0, 0);
    size = 50;
  }
  
  public Bullet(PVector pos, PVector vel, float siz) {
    position = pos;
    velocity = vel;
    size = siz;
  }
  
  public void updatePos() {
    position.add(velocity);
  }
  
  public void display() {
    
  }
}
