public class Nerd extends Enemy {
  private static final float SIZE = 20;
  private static final double HP = 30;
  
  private PVector targetPos;
  private PVector startPos;
  private int delay;
  private int lifespan;
  private int nextAttack;

  public Nerd(PVector pos, PVector targetPos, int delay, int lifespan) {
    super(pos, SIZE, HP);
    this.targetPos = targetPos.copy();
    this.delay = delay;
    this.lifespan = lifespan;
  }
  
  public void display() {
    fill(200, 50, 50);
    ellipseMode(RADIUS);
    circle(getDisplayPos().x, getDisplayPos().y, size);
    fill(255);
  }
  
  public void updateAttack() {
    int elapsed = millis() - birth;
    if (elapsed >= lifespan) {
      destroy();
      return;
    }
    if (elapsed < lifespan - 1000) { //stop attacking 1 second before dying
      if (elapsed > delay) {
        elapsed = (elapsed - delay) % 2000; //every 2 seconds
        if (elapsed >= 0 && elapsed < 800 && nextAttack == 0) {
          for (int i = 0; i < 5; i++) {
            PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(6 + i * 2);
            new Bullet(this, getPos(), bulletVel, 15, new int[] {94, 12, 94});
          }
          nextAttack = (nextAttack + 1) % 2;
        }
        if (elapsed >= 800 && elapsed < 2000 && nextAttack == 1) {
          nextAttack = (nextAttack + 1) % 2;
        }
      }
    }
    else {
      if (getPos().x < Game.WIDTH / 2) {
        targetPos = new PVector(-size, Game.HEIGHT + size);
      }
      else {
        targetPos = new PVector(Game.WIDTH + size, Game.HEIGHT + size);
      }
      setVelocity(targetPos.sub(getPos()).normalize().mult(8));
    }
  }
}
