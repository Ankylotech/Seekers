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
        setTarget(s,ownCamp.position);
      }else{
        setTarget(s,goals[i].position);
        s.setMagnetDisabled();
      }
    }
    setTarget(seekers[0],enemyCamps[0].position);
    if(dist(seekers[0],enemyCamps[0]) < 20) seekers[0].setMagnetRepulsive();
    else seekers[0].setMagnetDisabled();
  }
}
