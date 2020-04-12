class Bot {
  protected Seeker[] seekers;
  protected Seeker[] enemySeekers;
  protected Camp ownCamp;
  protected Camp[] enemyCamps;
  protected Player player;
  int index;

  Bot(int ind) {
    index = ind;
    player = new Player(index,this);
    seekers = player.seekers;
  }

  void setValues() {
    enemySeekers = new Seeker[seekerNum*(playerNum-1)];
    int ind = 0;
    for (Bot b : players) {
      if (b != this) {
        for (Seeker s : b.seekers) {
          enemySeekers[ind] = s;
          ind++;
        }
      }
    }
    ownCamp = player.getCamp();
    int jump = 0;
    enemyCamps = new Camp[playerNum-1];
    for (int i = 0; i < enemyCamps.length; i++) {
      if (i == index) jump = 1;
      enemyCamps[i] = players[i+jump].player.getCamp();
    }
  }

  void update() {
    player.update();
    for (Seeker s : seekers) {
      s.update();
      for (Seeker s1 : seekers) {
        if (s != s1)
          s.seekerCollide(s1);
      }
      for (Seeker s1 : enemySeekers) {
        s.seekerCollide(s1);
      }
    }
  }
  
  void score(){
  
  }

  Goal closestGoal(PVector pos) {
    Goal ret = null;
    float minD = sq(600);
    for (Goal g : goals) {
      if (PVector.dist(g.position, pos) < minD) {
        ret = g;
        minD = PVector.dist(g.position, pos);
      }
    }

    return ret;
  }

  Seeker closestOwnSeeker(PVector pos) {
    Seeker ret = null;
    float minD = sq(600);
    for (Seeker g : seekers) {
      if (PVector.dist(g.position, pos) < minD) {
        ret = g;
        minD = PVector.dist(g.position, pos);
      }
    }

    return ret;
  }

  Seeker closestEnemySeeker(PVector pos) {
    Seeker ret = null;
    float minD = sq(600);
    for (Seeker g : enemySeekers) {
      if (PVector.dist(g.position, pos) < minD) {
        ret = g;
        minD = PVector.dist(g.position, pos);
      }
    }

    return ret;
  }

  float dist(Goal g, Seeker s) {
    return PVector.dist(g.position, s.position);
  }

  float dist(Seeker g, Seeker s) {
    return PVector.dist(g.position, s.position);
  }

  float dist(Goal g, Goal s) {
    return PVector.dist(g.position, s.position);
  }
  float dist(Seeker g, Goal s) {
    return PVector.dist(g.position, s.position);
  }
}
