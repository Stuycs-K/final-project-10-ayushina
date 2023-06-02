public class Teacher extends BossEnemy{
  private static final float SIZE = 30;
  private static final int SCORE = 1000;
  private static final int PHASES = 2;
  private static final double HP = 500;
  
  private int delay;
  private boolean entering;
  
  private int lastMove;

  public Teacher() {
    super(new PVector(0, 0), SIZE, HP, SCORE, PHASES);
    
    this.spawn = new PVector(WIDTH/2, 100);
    targetPos = spawn.copy();    
    delay = 2000;
    lastMove = -1;
  }
  
  public void display() {
    imageMode(CENTER);
    image(Game.book, getDisplayPos().x, getDisplayPos().y);
    imageMode(CORNER);
  }
  
  public void updateAttack() {
    int elapsed = millis() - phaseStart;
    if (elapsed > timeOut) {
      nextPhase();
    }
    
    if (phase >= maxPhases) {
      destroy();
      return;
    }
    
    if (phase == 0) {
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
        if (elapsed >= 0 && elapsed < 1000 && nextAttack == 0) {
          //laser beam
          nextAttack = (nextAttack + 1) % 2;
          
          for (int spd = 0; spd < 4; spd++) {
            for (int a = 0; a < 17; a++) {
              PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(6 + spd * 1.4);
              bulletVel.rotate(radians(-48 + a * 6));
              if(random(3) < 2) {
                new Bullet(this, getPos(), bulletVel, 12, new int[] {90, 112, 224});
              }
            }
          }
        }
        if (elapsed >= 1000 && elapsed < 2000 && nextAttack == 1) {
          //circle
          for (int i = 0; i < 12; i++) {
            PVector bulletVel = new PVector(1, 0);
            bulletVel.rotate(radians(30) * i);
            for (int spd = 2; spd <= 8; spd += 2) {
              new Bullet(this, getPos(), bulletVel.normalize().mult(spd), 10, new int[] {90, 112, 224});
            }
          }
          nextAttack = (nextAttack + 1) % 2;
        }
      }
    }
    else if (phase == 1) {
      setVelocity(new PVector(0,0));

      
      int elapsedA = (elapsed) % 600; //every 0.6 seconds
      for (int i = 0; i < 4; i++) {
        if (elapsedA >= 0 + i * 100 && elapsedA < 400 && nextAttack == i) {
          //laser beam
          PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(9);
          new Bullet(this, getPos(), bulletVel, 8, new int[] {200, 200, 20});
          nextAttack++;
        }
        if (elapsedA >= 400 && elapsedA < 600 && nextAttack == 4) {
          nextAttack = 0;
        }
      }
      int elapsedB = (elapsed) & 2000; //every 2 seconds
      for (int a = 0; a < 10; a++) {
        if (elapsedB >= 0 + a * 100 && elapsedB < 1000 && nextAttackB == a) {
          nextAttackB++;
          //circle
          a = a * 10 + 10;
          for (int b = 0; b < 5; b++) {
            PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(10);
            bulletVel.rotate(radians(a + b * 10));
            new Bullet(this, getPos(), bulletVel, 10, new int[] {180, 10, 10});
            bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(10);
            bulletVel.rotate(radians(-(a + b * 10)));
            new Bullet(this, getPos(), bulletVel, 10, new int[] {180, 10, 10});
          }
        }
        else if (elapsedB >= 1000 + a * 100 && elapsedB < 2000 && nextAttackB == a + 10) {
          nextAttackB = (nextAttackB + 1) % 20;
          //circle
          a = 9 - a;
          a = a * 10 + 10;
          for (int b = 0; b < 5; b++) {
            PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(10);
            bulletVel.rotate(radians(a + b * 10));
            new Bullet(this, getPos(), bulletVel, 10, new int[] {180, 10, 10});
            bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(10);
            bulletVel.rotate(radians(-(a + b * 10)));
            new Bullet(this, getPos(), bulletVel, 10, new int[] {180, 10, 10});
          }
        }
      }
    }
  }
}
