class Goal extends Frame{
  private PVector velocity = new PVector(0,0);
  private PVector acceleration = new PVector(0,0);

  private float maxVelocity = 3;
  private float maxAcceleration = 0.4;
  private float diameter = 4;

  private int counter = 50;

  Goal(PVector pos) {
    position = pos;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  void update() {
    acceleration.limit(maxAcceleration);
    velocity.mult(0.99);
    velocity.add(acceleration);
    velocity.limit(maxVelocity);

    position.add(velocity);

    if (position.x < 0) position.x = width;
    if (position.x > 600) position.x = 0;


    if (position.y < 0) position.y = height;
    if (position.y > 600) position.y = 0;

    acceleration.setMag(0);
  }

  void show() {
    strokeWeight(1);
    stroke(#FF00D5);
    fill(#FF00D5);
    ellipse(position.x, position.y, diameter, diameter);
  }

  void goalCollide(Goal b2) {
    
    float dx = b2.position.x - position.x;
    float dy = b2.position.y - position.y;
    float dist = sqrt(dx*dx+dy*dy);

    if (dist < diameter/2 + b2.diameter/2) {
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
      dir.setMag((dist(b2.position, position)-diameter)/2);
      if(v <= 0.01) dir.mult(1.01);
      position.add(dir);
      dir.mult(-1);
      b2.position.add(dir);
      acceleration.setMag(0);
    }
  }
  
  void seekerCollide(Seeker seek){
    if(dist(seek.position,position) <= (diameter + seek.diameter)/2){
      PVector zwischen = sub(position, seek.position);
      float angle1 = PVector.angleBetween(zwischen, velocity);
      velocity.rotate(angle1);
      float angle2 = PVector.angleBetween(zwischen, seek.velocity);
      seek.velocity.rotate(angle2);
      float v = velocity.y;
      velocity.y = seek.velocity.y*4;
      velocity.rotate(-angle1);

      seek.velocity.y = v/4;
      seek.velocity.rotate(-angle2);

      PVector dir = sub(seek.position, position);
      dir.setMag(dist(seek.position, position)-(diameter+seek.diameter)/2);
      if(v <= 0.01) dir.mult(1.01);
      position.add(dir);
      acceleration.setMag(0);
    }
  }


  PVector getPosition() {
    return position.copy();
  }

  PVector getVelocity() {
    return new PVector(velocity.x, velocity.y);
  }

  PVector getAcceleration() {
    return new PVector(acceleration.x, acceleration.y);
  }
  
  void accelerate(PVector acc){
    acceleration.add(acc);
  }

  float getMaxV() {
    return maxVelocity;
  }

  void count() {
    if (counter > 0)counter--;
  }

  boolean gooal() {
    return counter == 0;
  }

  void relocate() {
    counter = 50;
    PVector newPos;
    boolean close = false;
    do {
      close = false;
      newPos = new PVector(random(0, width), random(0, height));
      for (Bot p : players) {
        if (dist(newPos.x, newPos.y, p.player.getCamp().position.x, p.player.getCamp().position.y) < 2*(diameter+p.player.getCamp().size)) close = true;
      }
    } while (close);
    position = newPos;
  }
}
