class Player {
  private Camp ownCamp;
  color farbe;
  private int score;
  int index;
  Seeker[] seekers;
  Bot control;

  Player(int ind) {}

  Player(int ind,Bot b) {
    control = b;
    index = ind;
    PVector center = new PVector(300, 300);
    PVector CampPos = new PVector(sin(TWO_PI * index/playerNum)*300, -1*cos(TWO_PI*index/playerNum)*300);
    CampPos.mult(0.9);
    CampPos.add(center);
    farbe = color(random(255), random(255), random(255));
    ownCamp = new Camp(CampPos, 20, this);
    score = 0;
    seekers = new Seeker[seekerNum];

    for (int i = 0; i < seekerNum; i++) {
      PVector playerPos;
      if (playerNum == 1) {
        playerPos = new PVector(random(600), random(600));
      } else if (playerNum == 2) {
        playerPos = new PVector(random(600), random(300*index, 300+300*index));
      } else {
        float val = random(300);
        float alpha = TWO_PI/playerNum/2;
        float val2 = tan(alpha)*val;
        playerPos = new PVector(random(-val2, val2), -val);
        playerPos.rotate(TWO_PI*index/playerNum);
        playerPos.limit(300);
        playerPos.add(center);
      }
      seekers[i] = new Seeker(playerPos, this);
    }
  }

  void update() {
    ownCamp.update();
    
  }

  Camp getCamp() {
    return new Camp(ownCamp.getPosition(), ownCamp.getSize(), new Player(0));
  }

  void score() {
    score++;
    scores[index]++;
  }

  int getScore() {
    return score;
  }
}
