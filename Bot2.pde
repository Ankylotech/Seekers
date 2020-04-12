class Bot2 extends Bot{
  Bot2(int ind,String name){
    super(ind,name);
  }
  @Override
  void update(){
    super.update();
    for(int i = 0; i < seekers.length; i++){
      Seeker s = seekers[i];
      if(dist(goals[i],s) < 20){
        s.setMagnetActive();
        s.setTarget(ownCamp.position);
      }else{
        s.setTarget(goals[i].position);
        s.setMagnetDisabled();
      }
    }
  }
}
