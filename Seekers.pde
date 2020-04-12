static final int goalNum = 7;
static final int playerNum = 2;
static final int seekerNum = 5;

Goal[] goals = new Goal[goalNum];
Bot[] players = new Bot[playerNum];
int[] scores = new int[playerNum];

ArrayList<Splash> splashes = new ArrayList<Splash>();
private int countdown = 10000;


void setup() {
  size(600, 600);
  for (int i = 0; i < goalNum; i++) {
    goals[i] = new Goal(new PVector(random(0, 600), random(0, 600)));
  }
  players[0] = new Bot1(1, "a");
  players[1] = new Bot2(0, "b");
  for (int i = 0; i < playerNum; i++) {
    players[i].setValues();
    scores[i] = 0;
  }
}

void draw() {
  if (countdown <= 0) {
    for(Bot b : players){
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
    if (won) {
      fill(#1BF719);
      textAlign(CENTER, CENTER);
      text(players[ind].name + " hat gewonnen!", width/2, height/2);
    }
  } else {

    countdown--;
    background(0);

    for(Splash s : splashes){
      s.update();
    }
    for(int i = 0; i < splashes.size();i++){
      if(splashes.get(i).fertig){
        splashes.remove(i);
        i--;
      }
    }
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
      goals[i].show();
    }
  }
}
