public class Zygarde extends Enemy {
  private static final float SIZE = 6;
  private static final int SCORE = 400;
  
  private boolean entering;
  private boolean leaving;
  private int delay;
  private int lifespan;

  public Zygarde(PVector targetPos, int hp, int delay, int lifespan) {
    super(targetPos, SIZE, hp, SCORE);
    this.targetPos = targetPos;
    this.delay = delay;
    this.lifespan = lifespan;
    
    PVector p = targetPos.copy();
    p.y = -size;
    setPos(p);
  }
  
  public Zygarde(PVector targetPos, int hp, int attacks) {
    this(targetPos, hp, 1000, 2000 + attacks * 2000);
  }
  
  public void display() {
    imageMode(CENTER);
    image(Game.zygarde, getDisplayPos().x, getDisplayPos().y);
    imageMode(CORNER);
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
          float rate = targetPos.dist(getPos())/(60 * delay / (float) 1000); //breaks when delay = 0
          setVelocity(targetPos.sub(getPos()).normalize().mult(rate));
        }
      }
      else {
        setVelocity(new PVector(0,0));
        elapsed = (elapsed - delay) % 2000; //every 2 seconds
        if (elapsed >= nextAttack * 50 && elapsed < 400) {
          //laser beam
          int i = nextAttack;
          PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(2 + i * 1.2);
          new Bullet(this, getPos(), bulletVel, 9, new int[] {94, 12, 94});

          if (nextAttack == 0) {
            shootSound();
          }
          nextAttack++;
        }
        if (elapsed >= 1000 && elapsed < 2000 && nextAttack == 8) {
          //circle
          for (int i = 0; i < 4; i++) {
            PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(6);
            bulletVel.rotate(radians(-4.5 + i * 3));
            new Bullet(this, getPos(), bulletVel, 5, new int[] {94, 12, 94});
          }
          nextAttack = 0;
          shootSound();
        }
      }
    }
    else {
      if (!leaving) {
        leaving = true;
        targetPos = new PVector(getPos().x, Game.HEIGHT + size);
        float rate = targetPos.dist(getPos())/60;
        setVelocity(targetPos.sub(getPos()).normalize().mult(rate));
      }
    }
  }
}
