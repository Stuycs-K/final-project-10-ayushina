public class Animation {
  int startTime;
  int duration;
  int[] keyframes;
  private int nextKeyframe;
  
  public Animation(int startTime, int duration, int[] keyFrames) {
    this.startTime = startTime;
    this.duration = duration;
    this.keyframes = keyFrames;
    
    this.nextKeyframe = 0;
  }
  
  public int getKeyframe() {
    int elapsed = (millis() - startTime) % duration;
    int result = 0;
    if (elapsed >= keyframes[nextKeyframe]) {
      result = nextKeyframe;
    }
    return result;
  }
}
