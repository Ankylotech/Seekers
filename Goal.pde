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
      float angle = atan2(dy, dx);
      float sin = sin(angle), cos = cos(angle);

      float x1 = 0, y1 = 0;
      float x2 = dx*cos+dy*sin;

      float vx1 = velocity.x*cos+velocity.y*sin;
      float vy1 = velocity.y*cos-velocity.x*sin;
      float vx2 = b2.velocity.x*cos+b2.velocity.y*sin;


      float absV = abs(vx1)+abs(vx2);
      float overlap = (diameter/2+b2.diameter/2)-abs(x1-x2);
      x1 += vx1/absV*overlap;
      x2 += vx2/absV*overlap;

      float x1final = x1*cos-y1*sin;
      float y1final = y1*cos+x1*sin;


      position.x = position.x + x1final;
      position.y = position.y + y1final;

      velocity.x = vx1*cos-vy1*sin;
      velocity.y = vy1*cos+vx1*sin;
    }
  }
  
  void seekerCollide(Seeker seek){
    if(PVector.dist(seek.position,position) <= (diameter + seek.diameter)/2){
      PVector dir = PVector.sub(position,seek.position);
      dir.setMag((PVector.dist(seek.position,position)-(diameter + seek.diameter)/2)*-1.1);
      position.add(dir);
      velocity.setMag(0);
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
