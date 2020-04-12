static final int goalNum = 7;
static final int playerNum = 2;
static final int seekerNum = 5;

Goal[] goals = new Goal[goalNum];
Bot[] players = new Bot[playerNum];
int[] scores = new int[playerNum];


void setup() {
  size(600, 600);
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
  background(0);

  for (Bot p : players) {
    p.update();
  }
  for (int i = 0; i < goals.length; i++) {
    goals[i].update();
    for (int j = i+1; j < goals.length; j++) {
      goals[i].goalCollide(goals[j]);
      goals[j].goalCollide(goals[i]);
    }
    for(Bot b : players){
    for (Seeker s : b.seekers) {
      goals[i].seekerCollide(s);
    }
    }
    goals[i].show();
  }

}
