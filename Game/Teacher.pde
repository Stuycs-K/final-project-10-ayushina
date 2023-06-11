public class Teacher extends BossEnemy{
  private static final float SIZE = 30;
  private static final int SCORE = 3000;
  private static final int PHASES = 4;
  private static final double HP = 500;
  
  private PVector offset;
  private int lastMove;
  
  private int lastBeep;

  public Teacher() {
    super(new PVector(0, 0), SIZE, HP, SCORE, PHASES);
    
    this.spawn = new PVector(WIDTH/2, 100);
    targetPos = spawn.copy();    
    lastMove = -1;
    offset = new PVector();
    lastBeep = -1;
  }
  
  public void display() {
    imageMode(CENTER);
    image(Game.teacher, getDisplayPos().x, getDisplayPos().y);
    imageMode(CORNER);
  }
  
  public void updateAttack() {
    int elapsed = millis() - phaseStart;
    if (elapsed > timeOut) {
      nextPhase(false);
      elapsed = millis() - phaseStart;
    }
    
    if (phase >= maxPhases) {
      destroy();
      return;
    }
    
    if (timeOut - elapsed < 6000) {
      if (lastBeep == -1 || millis() - lastBeep >= 1000) {
        Game.timeout.play();
        lastBeep = millis();
      }
    }
    
    if (phase == 0 || phase == 3) {
      bg = Game.DEFAULT_BG;
    }
    else if (phase == 1) {
      bg = new int[] {74, 3, 3};
    }
    else if (phase == 2) {
      bg = new int[] {0, 87, 97};
    }
    
    int delay;
    if (phase == 0) {
      delay = 6000;
    }
    else {
      delay = 1000;
    }
    
    if (elapsed < delay) {
      if (!entering) {
        entering = true;
        goTo(targetPos, delay);
      }
    }
    else {

      if (phase == 0 || phase == 3) {
        if (lastMove == -1 || millis() - lastMove >= 1200) { //move every 1.2 seconds
          lastMove = millis();
          targetPos = new PVector(constrain(getPos().x -50 + random(100), 0, Game.WIDTH), constrain(getPos().y - 10 + random(20), 0, Game.HEIGHT));
          goTo(targetPos, 1200);
        }
  
        elapsed = (elapsed - delay) % 2000; //every 2 seconds
        if (elapsed >= 0 && elapsed < 1000 && nextAttack == 0) {
          //laser beam
          nextAttack = (nextAttack + 1) % 2;
          shootSound();
          
          for (int spd = 0; spd < 4; spd++) {
            for (int a = 0; a < 17; a++) {
              PVector bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(6 + spd * 1.4);
              bulletVel.rotate(radians(-48 + a * 6));
              if(random(3) < 2) {
                bullets.add(new Bullet(this, getPos(), bulletVel, 10, new int[] {90, 112, 224}));
              }
            }
          }
        }
        if (elapsed >= 1000 && elapsed < 2000 && nextAttack == 1) {
          //circle
          for (int a = 0; a < 4; a++) {
            for (int i = 0; i < 12; i++) {
              PVector bulletVel = new PVector(1, 0);
              bulletVel.rotate(radians(30 * i + (-7.5 + a * 5)));
              for (int spd = 2; spd <= 8; spd += 2) {
                bullets.add(new Bullet(this, getPos(), bulletVel.normalize().mult(spd), 12, new int[] {90, 112, 224}));
              }
            }
          }
          shootSound();
          nextAttack = (nextAttack + 1) % 2;
        }
      }
      else if (phase == 1) {
        elapsed = elapsed - delay;
        
        if (lastMove == -1 || millis() - lastMove >= 1200) { //move every 1.2 seconds
          lastMove = millis();
          targetPos = new PVector(constrain(getPos().x -50 + random(100), 300, Game.WIDTH - 300), constrain(getPos().y - 10 + random(20), 0, 400));
          goTo(targetPos, 1200);
        }
        
        int elapsedA = (elapsed) % 300; //every 0.3 seconds
        for (int i = 0; i < 8; i++) {
          if (elapsedA >= 0 + i * 25 && elapsedA < 200 && nextAttack == i) {
            //laser beam
            if (nextAttack == 0) {
              shootSound();
              attackPos = chr.getPos();
              offset = new PVector(-50 + random(100), 0);
            }
            PVector bulletVel = PVector.sub(attackPos, getPos().add(offset)).normalize().mult(12);
            bullets.add(new Bullet(this, getPos().add(offset), bulletVel, 8, new int[] {200, 200, 20}));
            nextAttack++;
          }
          if (elapsedA >= 200 && nextAttack == 8) {
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
              bullets.add(new Bullet(this, getPos(), bulletVel, 10, new int[] {180, 10, 10}));
              bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(10);
              bulletVel.rotate(radians(-(a + b * 10)));
              bullets.add(new Bullet(this, getPos(), bulletVel, 10, new int[] {180, 10, 10}));
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
              bullets.add(new Bullet(this, getPos(), bulletVel, 10, new int[] {180, 10, 10}));
              bulletVel = Game.chr.getPos().sub(getPos()).normalize().mult(10);
              bulletVel.rotate(radians(-(a + b * 10)));
              bullets.add(new Bullet(this, getPos(), bulletVel, 10, new int[] {180, 10, 10}));
            }
          }
        }
      }
      else if (phase == 2) {
        int wait;
        if (health > maxHealth * 2 / (double) 3) {
          wait = 2000;
        }
        else if (health > maxHealth / (double) 2) {
          wait = 1000;
        }
        else if (health > maxHealth / (double) 4) {
          wait = 600;
        }
        else if (health > maxHealth / (double) 5) {
          wait = 500;
        }
        else {
          wait = 450;
        }
        elapsed = (elapsed - delay) % wait;
        if (elapsed >= nextAttack * wait / (double) 200 && elapsed < wait / (double) 4) {
          
          if (nextAttack == 0) {
            setPos(new PVector(50, 150));
            targetPos = new PVector(Game.WIDTH - 50, 150);
            goTo(targetPos, wait / (float) 4);
            shootSound();
          }
          
          PVector bulletPos = new PVector(50, 150).lerp(targetPos, elapsed / (wait / (float) 4));
          bulletPos.add(new PVector(-20 + random(40), -40 + random(80)));
          PVector bulletVel = new PVector(0, -3 - random(4));
          bullets.add(new Bullet(this, bulletPos, bulletVel, 10, new int[] {3, 248, 252}, "gravity"));
          
          nextAttack++;
        }
        else if (elapsed >= wait / (double) 4 && nextAttack != 0) {
          nextAttack = 0;
          
          goTo(new PVector(50, 150), wait * 3 / (float) 4);
        }
      }
    }
  }
}
