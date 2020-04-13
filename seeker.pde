class Seeker extends Frame {
  private PVector velocity;
  private PVector acceleration;
  private PVector target;
  private float diameter = 10;
  private float[] diams = new float[3];
  private float maxAcceleration = 0.3;
  private float maxVelocity = 3;
  private float magnetStatus = 0;
  private boolean disabled = false;
  private int disabledTime = 0;
  color farbe;
  private Player player;

  Seeker(PVector pos, Player p) {
    position = pos;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    target = pos;
    player = p;
    farbe = player.farbe;
    for (int i = 0; i < diams.length; i++) {
      diams[i] =diameter +  2*i*diameter/diams.length;
    }
  }

  void velocitys() {
    farbe = player.farbe;
    acceleration.limit(maxAcceleration);
    if (magnetStatus == 0)velocity.mult(0.99);
    else velocity.mult(0.9);
    if (!disabled)velocity.add(acceleration);
    if (magnetStatus == 0)velocity.limit(maxVelocity);
    else velocity.limit(maxVelocity/2);
  }
  
  
  void update() {
    position.add(velocity);

    while (position.x < 0) position.x += width;
    while (position.x > width) position.x -= width;


    while (position.y < 0) position.y = height+position.y;
    while (position.y > height) position.y -= height;


    acceleration = sub(target, position);
    if ((acceleration.x) > 300) acceleration.x -= 600;
    if ((acceleration.y) > 300) acceleration.y -= 600;
    if ((acceleration.x) <-300) acceleration.x += 600;
    if ((acceleration.y) <-300) acceleration.y += 600;
    acceleration.setMag(maxAcceleration);


    if (magnetStatus != 0 && !disabled) {
      for (Goal b : goals) {
        PVector accVec = sub(b.position, position);
        if ((accVec.x) > 300) accVec.x -= 600;
        if ((accVec.y) > 300) accVec.y -= 600;
        if ((accVec.x) <-300) accVec.x += 600;
        if ((accVec.y) <-300) accVec.y += 600;
        accVec.mult(1/dist(b.position, position));
        accVec.mult(sq((b.diameter+diameter)/2)*magnetStatus*b.maxAcceleration/sq(dist(b.position, position)));
        b.accelerate(accVec);
      }
    }

    if (disabled) {
      disabledTime--;
      if (disabledTime <= 0) disabled = false;
    }
  }

  void show() {
    stroke(255);
    PVector schwanz = velocity.copy();
    schwanz.setMag(diameter/2).mult(-1).add(position);
    PVector end = PVector.add(schwanz, velocity.copy().mult(-2));
    line(schwanz.x, schwanz.y, end.x, end.y);
    strokeWeight(2);
    stroke(farbe);
    if (!disabled)fill(farbe);
    else noFill();
    ellipse(position.x, position.y, diameter, diameter);
    if (magnetStatus != 0 && !disabled) {
      noFill();
      strokeWeight(0.5);
      for (int i = 0; i < diams.length; i++) {
        ellipse(position.x, position.y, diams[i], diams[i]);
        diams[i] += magnetStatus*0.2;
        if (diams[i] > 3*diameter) diams[i] = diameter;
        if (diams[i] < diameter) diams[i] = 3*diameter;
      }
      strokeWeight(1);
    }
  }

  void seekerCollide(Seeker b2) {
    if (dist(position, b2.position) <= diameter/2 + b2.diameter/2) {
      if (magnetStatus == b2.magnetStatus) {
        disabled = true;
        b2.disabled = true;
        magnetStatus = 0;
        b2.magnetStatus = 0;
        disabledTime = 60;
        b2.disabledTime = 60;
      } else {
        if (magnetStatus == 0) {
          b2.disabled = true;
          b2.magnetStatus = 0;
          b2.disabledTime = 120;
        } else if (b2.magnetStatus == 0) {
          disabled = true;
          magnetStatus = 0;
          disabledTime = 120;
        } else {
          disabled = true;
          b2.disabled = true;
          magnetStatus = 0;
          b2.magnetStatus = 0;
          disabledTime = 90;
          b2.disabledTime = 90;
        }
      }

      PVector zwischen = sub(position, b2.position);
      float angle1 = PVector.angleBetween(zwischen, velocity);
      velocity.rotate(angle1);
      float angle2 = PVector.angleBetween(zwischen, b2.velocity);
      b2.velocity.rotate(angle2);
      float v = velocity.y;
      velocity.y = b2.velocity.y;
      velocity.rotate(-angle1);

      b2.velocity.y = v;
      b2.velocity.rotate(-angle2);

      PVector dir = sub(b2.position, position);
      dir.setMag(dist(b2.position, position)-diameter);
      if(v <= 0.01)dir.mult(1.01);
      position.add(dir);
      acceleration.setMag(0);
    }
  }

  PVector getPosition() {
    return position.copy();
  }

  PVector getVelocity() {
    return velocity.copy();
  }

  PVector getAcceleration() {
    return acceleration.copy();
  }

  PVector getTarget() {
    return target.copy();
  }

  boolean isDisabled() {
    return disabled;
  }

  float getMagnetStatus() {
    return magnetStatus;
  }

  float getDiameter() {
    return diameter;
  }

  void setMagnetActive() {
    magnetStatus = -1;
  }

  void setMagnetRepulsive() {
    magnetStatus = 1.5;
  }

  void setMagnetDisabled() {
    magnetStatus = 0;
  }

  void setTarget(PVector p, Player pl) {
    if (pl.equals(player)) {
      target = p;
    }
  }
}
