Character chr;

void setup() {
  size(1200, 900);
  chr = new Character(new PVector(600,800));
}

void draw() {
  background(255);
  chr.updatePos();
  chr.display();
}
