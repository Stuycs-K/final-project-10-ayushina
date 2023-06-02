public class Nerd extends Enemy {
  private static final float SIZE = 20;
  private static final int SCORE = 5000;
  
  private boolean entering;
  private boolean leaving;
  private int delay;
  private int lifespan;

  public Nerd(PVector targetPos, int hp, int delay, int lifespan) {
    super(targetPos, SIZE, hp, SCORE);
    this.targetPos = targetPos;
    this.delay = delay;
    this.lifespan = lifespan;
    
    PVector p = targetPos.copy();
    p.y = -size;
    setPos(p);
  }
  
  public void display() {
    imageMode(CENTER);
    image(Game.nerd, getDisplayPos().x, getDisplayPos().y);
    imageMode(CORNER);
    //fill(200, 50, 50);
    //stroke(255);
    //ellipseMode(RADIUS);
    //circle(getDisplayPos().x, getDisplayPos().y, size);
    //fill(255);
  }
  
  public void updateAttack() {
    int elapsed = millis() - birth;
    if (elapsed >= lifespan) {
      destroy();
      return;
    }
    if (elapsed < lifespan - 1000) { //stop attacking 1 second before dying
      if (elapsed < delay) {
        if (!entering) {
          entering = true;
          float rate = targetPos.dist(getPos())/(60 * (delay/1000));
          setVelocity(targetPos.sub(getPos()).normalize().mult(rate));
        }
      }
      else {
        setVelocity(new PVector(0,0));
        elapsed = (elapsed - delay) % 2000; //every 2 seconds
        if (elapsed >= 0 && elapsed < 800 && nextAttack == 0) {
          //laser beam
          for (int i = 0; i < 5; i++) {
            PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(4 + i * 1.2);
            new Bullet(this, getPos(), bulletVel, 15, new int[] {94, 12, 94});
          }
          nextAttack = (nextAttack + 1) % 2;
        }
        if (elapsed >= 800 && elapsed < 2000 && nextAttack == 1) {
          //circle
          for (int i = 0; i < 12; i++) {
            PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(6);
            bulletVel.rotate(radians(30) * i);
            new Bullet(this, getPos(), bulletVel, 10, new int[] {94, 12, 94});
          }
          nextAttack = (nextAttack + 1) % 2;
        }
      }
    }
    else {
      if (!leaving) {
        leaving = true;
        if (getPos().x < Game.WIDTH / 2) {
          targetPos = new PVector(-size, Game.HEIGHT + size);
        }
        else {
          targetPos = new PVector(Game.WIDTH + size, Game.HEIGHT + size);
        }
        float rate = targetPos.dist(getPos())/60;
        setVelocity(targetPos.sub(getPos()).normalize().mult(rate));
      }
    }
  }
}
