/*class BreatheFX {

  int briChange;

  FXlooP() {
    briChange = 1;
  }

  void FXloop() {
    for (int i = 0; i < boxels.size(); i++) {
      Boxel b = boxels.get(i);
      float curBri = brightness(b.currentC);
      if (((curBri + briChange) <= 0) || ((curBri + briChange) >= 100)) {
        briChange *= -1;
      }
      b.setC(color(hue(b.currentC), saturation(b.currentC), (curBri + briChange)));
    }
  }
}*/