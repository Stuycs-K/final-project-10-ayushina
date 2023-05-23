public class Reimu {
  private static float SPEED = 25;
  
  public Reimu(PVector pos, PVector siz) {
    super(pos, siz, SPEED);
  }
 
  public void display() {
    ellipseMode(RADIUS);
    circle(position.x, position.y, size);
  }
}
