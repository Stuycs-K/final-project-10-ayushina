public class Nerd extends Enemy {
  private static final float SIZE = 20;
  private static final double HP = 100;
  
  private PVector targetPos;
  private int delay;
  private int lifespan;

  public Nerd(PVector pos, PVector targetPos, int delay, int lifespan) {
    super(pos, SIZE, HP);
    this.targetPos = targetPos.copy();
    this.delay = delay;
    this.lifespan = lifespan;
  }
  
  public void display() {
    fill(200, 50, 50);
    ellipseMode(RADIUS);
    circle(getPos().x, getPos().y, size);
    fill(255);
  }
  
  public void updateAttack() {
    int elapsed = millis() - birth;
    if (elapsed < lifespan - 1) { //stop attacking 1 second before dying
      if (elapsed > delay) {
        elapsed = (elapsed - delay) % 2; //every 2 seconds
      }
    }
  }
}
