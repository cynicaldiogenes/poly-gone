import com.heroicrobot.dropbit.devices.*;
import com.heroicrobot.dropbit.common.*;
import com.heroicrobot.dropbit.discovery.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.*;
import java.util.*;
/*
To do list:
  -Change chaser to periodically shift selectedC to a new value (use a list of vivid colors, derive their complements)
  -Add a new effect (checkerboard - every other pixel with color + complement, and a 3-step animation)
  -Add mechanism to switch which effect is running, and UI to select between them
  -Change HSB color wheel to a grid of good solid colors (too many bad colors in the color hweel)
  -Abstract pixel mapping for 8 physical strips of pixels but N logical
  -Add a new effect (row-by-row shift or update)
  -Add a new effect (color random pixel, then color 2 random pixels, then 3, until all are colored)
  -Full lighting breathe pattern (change brightness on all lights simultaneously, using sine wave style algorithm)
  -Add ability to make chase run in reverse
  -Build as an android package and run on n7
  -Make a list of 'good' colors that will display well on LEDs
  -Implement a 'reset' that changes all pixels back to their original state
*/

//set global list of rows to simulate varying strip lengths
//int[] rowList = {10, 10, 8, 12, 8, 13, 10, 10, 11, 12 , 7, 10, 10, 10};


int[] rowList = {24, 24, 24, 24, 24, 24, 24, 24};
ArrayList<Boxel> boxels;
PImage palette;
int frameIndex;
color selectedC; //User selected color that effects use as a base
TestObserver testObserver;
DeviceRegistry registry;

/*----------------- Effects listed here ---------------*/
ChaseFX chase;
CheckerFX checker;
CrossFX cross;

/*----------------- Color palettes here ---------------*/

class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
        println("Registry changed!");
        if (updatedDevice != null) {
          println("Device change: " + updatedDevice);
        }
        this.hasStrips = true;
    }
};


void setup() {
  size(800, 1000); //change this to 800 x 1200 for nexus 7
  palette = loadImage("palette.jpg");
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  background(255);
  colorMode(HSB);//, 360, 255, 255);
  boxels = new ArrayList<Boxel>();
  for (int i = 0; i < rowList.length; i++) {
    for (int j = 0; j < rowList[i]; j++) {
      Boxel newBoxel = new Boxel(j, i, rowList[i], rowList.length);
      boxels.add(newBoxel);
    }
  }
  chase = new ChaseFX();
  checker = new CheckerFX();
  cross = new CrossFX();
  noStroke();
  noSmooth();
}

void draw(){
  image(palette, 0, height/2, width/2, height/2);
  frameIndex = (frameCount % boxels.size());
  if (testObserver.hasStrips) { 
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    doEffect();
    for (int i = 0; i < boxels.size(); i++) {
      Boxel b = boxels.get(i);
      Strip s = strips.get(b.ypos);
      render(b, s);
    }
  }
}

void mousePressed() {
  selectedC = get(mouseX, mouseY);
}

void render(Boxel b, Strip s) {
  if (b.currentC != b.lastC) {
    fill(b.currentC);
    s.setPixel(b.currentC, b.xpos);
    println("Setting pixel number " + str(b.xpos) + " to color " + str(b.currentC));
    b.setC(b.currentC);
    float ysize = (height/rowList.length)/2;
    float xsize = width/rowList[b.ypos];
    rect((xsize * b.xpos), (ysize * b.ypos), xsize, ysize);
  }
}

void doEffect() {
  cross.FXloop();
  //checker.FXloop();
  //chase.FXloop();
}

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

class CheckerFX 
{  color color1;
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

class Boxel {
  color currentC;
  color lastC;
  int xpos;
  int ypos;
  float xvirt;
  float yvirt;
  int numX;
  int numY;

  Boxel(int tempXpos, int tempYpos, int tempnumx, int tempnumy) {
    currentC = color(0,0,1);
    lastC = color(0,0,0);
    xpos = tempXpos;
    ypos = tempYpos;
    numX=tempnumx;
    numY=tempnumy;
    xvirt = float(xpos+1)/float(numX);
    yvirt = float(ypos+1)/float(numY);
    println("setting xv " + xvirt + " yv " + yvirt);
  }

  void setC(color newC) {
    lastC = currentC;
    currentC = newC;
  }
}
