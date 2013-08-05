class CheckerFX {  
  color color1;
  color c1complement;
  int checkerSwitch = 1;
  
  CheckerFX(){
    color1 = selectedC;
  }

  void FXloop() {
    if ((frameCount % 30) == 0) {
      color1 = selectedC;
      c1complement = color(0,0,0); // Currently setting this to black, because I don't know how to derive a color's complement and am on an airplane and can't look it up...
      checkerSwitch *= -1;
    }
    for (int i = 0; i < boxels.size(); i++) {
      Boxel b = boxels.get(i);
      if (checkerSwitch == -1) {
        if ((i % 2) != 0) {
          b.setC(color1);
        } else {
          b.setC(c1complement);
        }
      } else if (checkerSwitch == 1) {
        if ((i % 2) == 0) {
          b.setC(color1);
        } else {
          b.setC(c1complement);
        }
      }
    }
  }

}