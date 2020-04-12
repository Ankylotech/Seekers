class Bot1 extends Bot{
  Bot1(int ind,String name){
    super(ind,name);
  }
  @Override
  void update(){
    super.update();
    for(int i = 1; i < seekers.length; i++){
      Seeker s = seekers[i];
      if(dist(goals[i],s) < 20){
        s.setMagnetActive();
        s.setTarget(ownCamp.position);
      }else{
        s.setTarget(goals[i].position);
        s.setMagnetDisabled();
      }
    }
    seekers[0].setTarget(enemySeekers[1].position);
  }
}