class ChaseFX {
  int chaseFlip;

  ChaseFX() {
    chaseFlip = 1;
  }

  void FXloop() {
    int gradientWidth = 25;

    for (int i = 0; i < boxels.size(); i++) {
      if ((i >= (frameIndex - gradientWidth)) && ((i + 1) <= frameIndex)) {
        changeBri(i, (frameIndex - i));
      }
      if ((frameIndex <= gradientWidth) && (frameCount > gradientWidth)) { //skip the wrap case the first frames to create gradient
        int diff = gradientWidth - frameIndex;
        if (i >= (boxels.size() - diff)) {
          changeBri(i, (boxels.size() - i + frameIndex));
        }
      }
    }
  }

  void changeBri(int bIndex, int briChange) {
    Boxel b = boxels.get(bIndex);
    float bri = brightness(b.currentC);
    int increment = 2;
    if (brightness(b.currentC) > brightness(b.lastC)) {
      chaseFlip = 1;
    } else if (brightness(b.currentC) < brightness(b.lastC)) {
      chaseFlip = -1;
    }
    if ((bri + chaseFlip) > 100) {
      bri = 101;
      chaseFlip *= -1;
    } else if ((bri + chaseFlip) < 0) {
      bri = -1;
      chaseFlip *= -1;
    }
    color newC = color(hue(selectedC), saturation(selectedC), (bri + chaseFlip));
    b.setC(newC);
  }
}