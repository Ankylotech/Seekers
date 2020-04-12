class Camp {
  private PVector position;
  private int size;
  private Player player;

  Camp(PVector pos, int s, Player p) {
    position = pos;
    size = s;
    player = p;
  }

  void update() {
    for (Goal b : goals) {
      if (b.getPosition().x > position.x - size/2.0 && b.getPosition().x < position.x + size/2.0 && b.getPosition().y > position.y - size/2.0 && b.getPosition().y < position.y + size/2.0) {
        b.count();
        if (b.gooal()) {
          splashes.add(new Splash(b.position,3,player.farbe,10,5,30));
          b.relocate();
          player.score();
        }
      }
    }

    show();
  }

  void show() {
    strokeWeight(2);
    noFill();
    stroke(player.farbe);
    rect(position.x-size/2.0, position.y-size/2.0, size, size,5,5,5,5);
    textAlign(CENTER,CENTER);
    fill(player.farbe);
    text(player.score,position.x,position.y);
  }

  PVector getPosition() {
    return position;
  }

  int getSize() {
    return size;
  }

  Player getPlayer() {
    return player;
  }
}
