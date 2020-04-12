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
      s.velocitys();
    }
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
      s.show();
    }
  }

  void score() {
  }
  
  Seeker closest(PVector pos,Seeker[] list){
    Seeker ret = null;
    float minD = sq(600);
    for (Seeker g : list) {
      if (dist(g.position, pos) < minD) {
        ret = g;
        minD = dist(g.position, pos);
      }
    }

    return ret;
  }
  Seeker closest(PVector pos,ArrayList<Seeker> list){
    Seeker ret = null;
    float minD = sq(600);
    for (Seeker g : list) {
      if (dist(g.position, pos) < minD) {
        ret = g;
        minD = dist(g.position, pos);
      }
    }

    return ret;
  }
  
  Goal closest(PVector pos,Goal[] list){
    Goal ret = null;
    float minD = sq(600);
    for (Goal g : list) {
      if (dist(g.position, pos) < minD) {
        ret = g;
        minD = dist(g.position, pos);
      }
    }

    return ret;
  }
  
  Camp closest(PVector pos,Camp[] list){
    Camp ret = null;
    float minD = sq(600);
    for (Camp g : list) {
      if (dist(g.position, pos) < minD) {
        ret = g;
        minD = dist(g.position, pos);
      }
    }

    return ret;
  }
  
  void setTarget(Seeker s,PVector p){
    s.setTarget(p,player);
  }
}
