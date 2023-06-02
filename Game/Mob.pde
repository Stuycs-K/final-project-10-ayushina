public abstract class Mob {
  PVector position, velocity;
  float size;
  String type;
  
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
    position.add(getVelocity().mult(deltaTime * 60 / (float) 1000));
  }
  
  public PVector getPos() {
    return position.copy();
  }
  public PVector getDisplayPos() {
    return position.copy().add(Game.windowPos);
  }
  public void setPos(PVector pos) {
    position = pos;
  }
  public PVector getVelocity() {
    return velocity.copy();
  }
  public void setVelocity(PVector vel) {
    velocity = vel;
  }
  public float getSize() {
    return size;
  }
  public boolean invincible() {
    return false;
  }
}
