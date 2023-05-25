public abstract class Mob {
  PVector position, velocity;
  float size;
  
  int birth;
  
  public Mob(PVector pos, float siz) {
    position = pos;
    velocity = new PVector(0, 0);
    size = siz;
    birth = millis();
    Game.addMob(this);
  }
  
  public void destroy() {
    Game.removeMob(this);
  }
  
  public abstract void display();
  
  public void updatePos() {
    position.add(velocity);
  }
  
  public PVector getPos() {
    return position;
  }
  public void setPos(PVector pos) {
    position = pos;
  }
  
  public void setVelocity(PVector vel) {
    velocity = vel;
  }
}
