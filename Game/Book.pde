public class Book extends Enemy {
  private static final float SIZE = 30;
  private static final int SCORE = 690;
  
  private boolean entering;
  private boolean leaving;
  private int delay;
  
  int shots;
  String direction;
  
  int shotsFired;
  int startLeaving;
  int lastFired;

  public Book(PVector targetPos, String direction, int hp, int delay, int shots) {
    super(targetPos, SIZE, hp, SCORE);
    this.targetPos = targetPos;
    this.delay = delay;
    
    this.shots = shots;
    this.direction = direction;
    
    startLeaving = -1;
    
    PVector p = targetPos.copy();
    if (direction == "left") {
      p.x = -size;
    }
    else {
      p.x = Game.WIDTH + size;
    }
    setPos(p);
  }
  
  public void display() {
    imageMode(CENTER);
    image(Game.book, getDisplayPos().x, getDisplayPos().y);
    imageMode(CORNER);
  }
  
  public void updateAttack() {
    int elapsed = millis() - birth;
    if (shotsFired >= shots && startLeaving != -1 && millis() - startLeaving > 1000) {//die after 1 second
      destroy();
      return;
    }
    if (shotsFired < shots) { //stop attacking after all shots
      if (elapsed < delay) {
        if (!entering) {
          entering = true;
          goTo(targetPos, delay);
        }
      }
      else {
        setVelocity(new PVector(0,0));
        if (millis() - lastFired >= 1000) { //shoot every 1 second
          //two circles
          lastFired = millis();
          shootSound();
          shotsFired++;
          for (int i = 0; i < 16; i++) {
            PVector bulletVel = new PVector(4, 0);
            bulletVel.rotate(radians(22.5) * i);
            new Bullet(this, getPos(), bulletVel, 10, new int[] {252, 186, 3});
            
            bulletVel = bulletVel.copy().normalize().mult(6);
            new Bullet(this, getPos(), bulletVel, 10, new int[] {252, 186, 3});
          }
        }
      }
    }
    else {
      if (!leaving) {
        leaving = true;
        startLeaving = millis();
        if (direction == "left") {
          targetPos = new PVector(Game.WIDTH + size, getPos().y);
        }
        else {
          targetPos = new PVector(-size, getPos().y);
        }
        goTo(targetPos, 1000);
      }
    }
  }
}
