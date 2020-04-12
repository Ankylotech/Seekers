class Bot {
  protected Seeker[] seekers;
  protected Seeker[] enemySeekers;
  protected Camp ownCamp;
  protected Camp[] enemyCamps;
  protected Player player;
  int index;
  
  String name;

  Bot(int ind, String name) {
    this.name = name;
    index = ind;
    player = new Player(index, this);
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
      for (Seeker s1 : seekers) {
        if (s != s1)
          s.seekerCollide(s1);
      }
      for (Seeker s1 : enemySeekers) {
        s.seekerCollide(s1);
      }
    }
    for (Seeker s : seekers) {
      s.update();
    }
  }

  void score() {
  }

  
  Object closest(PVector pos,Object[] list){
    Object ret = null;
    float minD = sq(600);
    for (Object g : list) {
      if (PVector.dist(g.position, pos) < minD) {
        ret = g;
        minD = PVector.dist(g.position, pos);
      }
    }

    return ret;
  }


  float dist(Object a, Object b) {
    return dist(a.getPosition(), b.getPosition());
  }

  float dist(PVector p1, PVector p2) {
    PVector connect = PVector.sub(p1,p2);
    
    if((connect.x) > 300) connect.x -= 600;
    if((connect.y) > 300) connect.y -= 600;
    if((connect.x) <-300) connect.x += 600;
    if((connect.y) <-300) connect.y += 600;
    return connect.mag();
  }
}
