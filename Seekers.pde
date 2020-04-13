static final int goalNum = 7;
static final int playerNum = 2;
static final int seekerNum = 5;

Goal[] goals = new Goal[goalNum];
Bot[] players = new Bot[playerNum];
int[] scores = new int[playerNum];

ArrayList<Splash> splashes = new ArrayList<Splash>();
private int startCountdown = 60*60;
private int countdown = startCountdown;
int seed = 0;
int bestOf = 1;


void setup() {
  size(600, 600);
  frameRate(60);
  


  initial();

  int[] seeds = new int[bestOf];
  int[][] IScores = new int[bestOf][playerNum];
  for (int k = 0; k < bestOf; k++) {
    int rSeed = floor(random(100000));
    seeds[k] = rSeed;
    randomSeed(rSeed);
    initial();
    while (countdown > 0) {
      for (Bot p : players) {
        p.update();
      }
      for (int i = 0; i < goals.length; i++) {
        goals[i].update();
        for (int j = i+1; j < goals.length; j++) {
          goals[i].goalCollide(goals[j]);
          goals[j].goalCollide(goals[i]);
        }
        for (Bot b : players) {
          for (Seeker s : b.seekers) {
            goals[i].seekerCollide(s);
          }
        }
      }
      countdown--;
    }

    countdown = startCountdown;
    IScores[k] = scores;
    scores = new int[playerNum];
  }

  float[] AVGScores = new float[playerNum];
  for (int i = 0; i < bestOf; i++) {
    for (int j = 0; j < playerNum; j++) {
      AVGScores[j] += IScores[i][j];
    }
  }
  for (int j = 0; j < playerNum; j++) {
    AVGScores[j] /= bestOf + 0.0;
  }

  float minD = (IScores[0][0]-AVGScores[0]) + (IScores[0][1]-AVGScores[1]);
  int index = 0;
  int total = 0;
  for (int i = 1; i < bestOf; i++) {
    int mins = min(IScores[i][0], IScores[i][1]);
    float d = (IScores[i][0]-AVGScores[0]-mins) + (IScores[i][1]-AVGScores[1]-mins);
    if (abs(minD) > abs(d) || (abs(minD) == abs(d) && IScores[i][0] + IScores[i][1] > total)) {
      index = i;
      minD = d;
      total = IScores[i][0] + IScores[i][1];
    }
  }


  seed = seeds[index];
  randomSeed(seed);
  initial();
}

void initial() {
  for (int i = 0; i < goalNum; i++) {
    goals[i] = new Goal(new PVector(random(0, 600), random(0, 600)));
  }
  players[0] = new Bot1(0);
  players[1] = new Bot2(1);
  for (int i = 0; i < playerNum; i++) {
    players[i].setValues();
    scores[i] = 0;
  }
}

void draw() {
  if (countdown <= 0) {
    for (Bot b : players) {
      b.player.checkScore();
    }
    background(0);
    int ind = -1;
    int max = -1;
    boolean won = false;
    for (int i = 0; i < playerNum; i++) {
      if (scores[i] > max) {
        ind = i;
        max = scores[i];
        won = true;
      } else if (scores[i] == max) {
        won =false;
      }
    }
    String spielstand = "" + scores[0];
    for (int i = 1; i < playerNum; i++) {
      spielstand += "-" + scores[i];
    }
    if (won) {
      fill(players[ind].player.farbe);
      textAlign(CENTER, CENTER);
      textSize(30);
      text(players[ind].name + " hat gewonnen! Spielstand: " + spielstand, width/2, height/2);
    } else {
      fill(255, 0, 0);

      textAlign(CENTER, CENTER);
      textSize(35);
      text("Unentschieden! Spielstand: " + spielstand, width/2, height/2);
    }
  } else {

    countdown--;
    background(0);

    for (Splash s : splashes) {
      s.update();
    }
    for (int i = 0; i < splashes.size(); i++) {
      if (splashes.get(i).fertig) {
        splashes.remove(i);
        i--;
      }
    }

    for (int i = 0; i < playerNum; i++) {
      textSize(20);
      fill(players[i].player.farbe);
      textAlign(LEFT, TOP);
      text(players[i].name + ": " + scores[i], 0, i*21);
    }
    for (Bot p : players) {
      p.update();
      p.show();
    }
    for (int i = 0; i < goals.length; i++) {
      goals[i].update();
      for (int j = i+1; j < goals.length; j++) {
        goals[i].goalCollide(goals[j]);
        goals[j].goalCollide(goals[i]);
      }
      for (Bot b : players) {
        for (Seeker s : b.seekers) {
          goals[i].seekerCollide(s);
        }
      }
      goals[i].show();
    }
  }
}


float dist(PVector p1, PVector p2) {
  PVector connect = sub(p1, p2);

  if ((connect.x) > 300) connect.x -= 600;
  if ((connect.y) > 300) connect.y -= 600;
  if ((connect.x) <-300) connect.x += 600;
  if ((connect.y) <-300) connect.y += 600;
  return abs(connect.mag());
}

PVector sub(PVector v1, PVector v2) {
  return new PVector(v1.x-v2.x, v1.y-v2.y);
}
