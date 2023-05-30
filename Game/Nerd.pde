public class Nerd extends Enemy {
  private static final float SIZE = 20;
  private static final double HP = 100;
  
  private PVector targetPos;

  public Nerd(PVector pos, PVector to) {
    super(pos, SIZE, HP);
    targetPos = to.copy();
  }
  
  public void display() {
    fill(200, 50, 50);
    ellipseMode(RADIUS);
    circle(getPos().x, getPos().y, size);
    fill(255);
  }
  
  public void updateAttack() {
    
  }
}
