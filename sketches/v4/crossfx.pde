class CrossFX {
  float x=0.0;
  float y=0.0;
  float wid=0.2;
  
  CrossFX() {
  } 
  void FXloop() {
    x+=0.01;
    if(x >= 1.0) {
      x -= 1.0;
    }
    y += 0.01;
    if(y >= 1.0) {
      y -= 1.0;
    }
    for (int i=0; i<boxels.size(); i++) {
      Boxel b=boxels.get(i);
      if((b.xvirt >= x && b.xvirt < (x+wid)) || (b.yvirt >= y && b.yvirt < (y+wid))) {
        b.setC(selectedC);
      } else {
        b.setC(color(0,0,0));
      }
    }
  } 
}