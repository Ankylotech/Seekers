class Seeker {
  private PVector position;
  private PVector velocity;
  private PVector acceleration;
  private PVector target;
  private float diameter = 10;
  private float[] diams = new float[3];
  private float maxAcceleration = 0.5;
  private float maxVelocity = 5;
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

  void update() {
    if (magnetStatus==0)acceleration.limit(maxAcceleration);
    else acceleration.limit(maxAcceleration/2);
    if (magnetStatus == 0)velocity.mult(0.9);
    else velocity.mult(0.8);
    if (!disabled)velocity.add(acceleration);
    if (magnetStatus == 0)velocity.limit(maxVelocity);
    else velocity.limit(maxVelocity/2);

    position.add(velocity);

    if (position.x < 0) position.x += width;
    if (position.x > 600) position.x -= 600;


    if (position.y < 0) position.y = height+position.y;
    if (position.y > 600) position.y -= 600;

    show();
    acceleration = PVector.sub(target, position);
    acceleration.setMag(maxAcceleration);


    if (magnetStatus != 0 && !disabled) {
      for (Goal b : goals) {
        PVector accVec = PVector.sub(b.position, position);
        accVec.mult(1/PVector.dist(b.position, position));
        accVec.mult(sq((b.diameter+diameter)/2)*magnetStatus*b.maxAcceleration/sq(PVector.dist(b.position, position)));
        b.accelerate(accVec);
      }
    }

    if (disabled) {
      disabledTime--;
      if (disabledTime <= 0) disabled = false;
    }
  }

  void show() {
    strokeWeight(2);
    stroke(farbe);
    if (!disabled)fill(farbe);
    else fill(16777215-farbe);
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

    float dx = b2.position.x - position.x;
    float dy = b2.position.y - position.y;
    float dist = sqrt(dx*dx+dy*dy);

    if (dist <= diameter/2 + b2.diameter/2) {
      
      PVector dir = PVector.sub(position,b2.position);
      dir.setMag((PVector.dist(b2.position,position)-(diameter + b2.diameter)/2)*-1+1);
      position.add(dir);
      acceleration.setMag(0);
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
    magnetStatus = 2;
  }

  void setMagnetDisabled() {
    magnetStatus = 0;
  }

  void setTarget(PVector p) {

    target = p;
  }
}
