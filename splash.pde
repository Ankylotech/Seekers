class Splash {
  PVector pos;
  float[] diams;
  color farbe;
  boolean fertig = false;
  float finish;

  Splash(PVector pos, int zahl, color c, float dist, float start, float fin) {
    diams = new float[zahl];
    farbe = c;
    for (int i = 0; i < zahl; i++) {
      diams[i] = start + i*dist;
    }
    finish = fin;
    this.pos = pos;
  }

  void update() {
    if (!fertig) {
      stroke(farbe);
      noFill();
      strokeWeight(1);
      for (int i = 0; i < diams.length; i++) {
        if (diams[i] < finish) {
          ellipse(pos.x, pos.y, diams[i], diams[i]);
        }
        diams[i]+=0.5;
      }
      if (diams[0] > finish)fertig = true;
    }
  }
}
