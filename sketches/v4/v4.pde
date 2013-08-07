import com.heroicrobot.dropbit.devices.*;
import com.heroicrobot.dropbit.common.*;
import com.heroicrobot.dropbit.discovery.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.*;
import java.util.*;
import controlP5.*;
import java.awt.Color;

/*
To do list:
  -Change chaser to periodically shift selectedC to a new value (use a list of vivid colors, derive their complements)
  -Add a new effect (checkerboard - every other pixel with color + complement, and a 3-step animation)
  -Add mechanism to switch which effect is running, and UI to select between them
  -Add a new effect (row-by-row shift or update)
  -Add a new effect (color random pixel, then color 2 random pixels, then 3, until all are colored)
  -Full lighting breathe pattern (change brightness on all lights simultaneously, using sine wave style algorithm)
  -Add ability to make chase run in reverse
  -Build as an android package and run on n7
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
PixelMap pMap;
int currentEffect = 0;
int lastEffect = 0;
int fxFrameCount = 0;
boolean cycleColors = false;

/*----------------- Effects listed here ---------------*/
ChaseFX chase;
CheckerFX checker;
CrossFX cross;

/*----------------- ControlP5 stuff here --------------*/
ControlP5 cp5;
public int myColorRect = 200;
public int myColorBackground = 100;

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
  pMap = new PixelMap();
  cp5 = new ControlP5(this);
  cp5.addButton("cross")
    .setValue(1)
    .setPosition((width/2), (height/2))
    .setSize((width/4), (height/10))
    .setId(1);
    ;
  cp5.addButton("checker")
    .setValue(2)
    .setPosition((width/2), ((height/2) + ((height/10) * 2)))
    .setSize((width/4), (height/10))
    .setId(2);
    ;
  cp5.addButton("chase")
    .setValue(3)
    .setPosition((width/2), ((height/2) + ((height/10) * 3)))
    .setSize((width/4), (height/10))
    .setId(3)
    ;
  cp5.addToggle("cycleColors")
    .setPosition(((width/4) * 3), ((height/10) * 9))
    .setSize((width/4), (height/10))
    .setId(0);
    ;
  background(255);
  colorMode(HSB);//, 360, 255, 255);
  boxels = new ArrayList<Boxel>();
  for (int i = 0; i < pMap.numStrips; i++) {
    for (int j = 0; j < pMap.stripLengths[i]; j++) {
      if (pMap.csv[i][j].length() != 0) {
        Boxel newBoxel = new Boxel(j, i, pMap.stripLengths[i], pMap.numStrips);
        boxels.add(newBoxel);
      }
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
  frameIndex = (fxFrameCount % boxels.size());
  doEffect();
  if (testObserver.hasStrips) { 
    registry.startPushing();
  }
    for (int j = 0; j < boxels.size(); j++) {
      Boxel b = boxels.get(j);
      fill(b.currentC);
      List<Strip> strips = registry.getStrips();
      int[][]pList = pMap.pixels(b.ypos, b.xpos); //Get the list of physical pixels for this logical one
      if(testObserver.hasStrips) {
        for (int i = 0; i < pList.length; i++) {
          Strip myStrip = strips.get(pList[i][0]);
          myStrip.setPixel(b.currentC, pList[i][1]); //Render this color to each physical pixel
        }
      }
      println("Setting pixel number " + str(b.xpos) + " to color " + str(b.currentC));
      float ysize = (height/pMap.numStrips)/2;
      float xsize = width/pMap.stripLengths[b.ypos];
      rect((xsize * b.xpos), (ysize * b.ypos), xsize, ysize);
    }
  fxFrameCount++;
  if (cycleColors == true) {
    startCycling();
  }
}

void startCycling() {
  if ((frameCount % 150) == 0) {
    selectedC = randomizeColor(selectedC);
  }
}

int randomizeColor(int oldColor) {
  float newHue = random(360);
  float newSat = random(100);
  float newBri = random(75,100);
  color newColor = Color.HSBtoRGB(newHue, newSat, newBri);
  return color(newColor);
}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.getId() != 0) {
    currentEffect = theEvent.getId();
  } 
}

void mousePressed() {
  selectedC = get(mouseX, mouseY);
}

void resetPixels() {
  for (int i = 0; i < boxels.size(); i++) {
    Boxel b = boxels.get(i);
    b.setC(color(0, 0, 0));
  }
}

void doEffect() {
  if (currentEffect != lastEffect) {
    resetPixels();
    fxFrameCount = 0;
    frameIndex = 0;
    lastEffect = currentEffect;
  }
  switch(currentEffect) {
    case 1:
      cross.FXloop();
      break;
    case 2:
      checker.FXloop();
      break;
    case 3:
      chase.FXloop();
      break;
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
