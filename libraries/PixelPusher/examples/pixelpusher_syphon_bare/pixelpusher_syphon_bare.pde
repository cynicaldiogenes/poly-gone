// Syphon client for PixelPusher
// by jas@heroicrobot.com
//
// refactored by Matt Stone
// evil@heroicrobot.com
//
// then universally remonstered by jas again
//
// vaguely based on
//
// Fancy FFT of the song
// Erin K 09/20/08
// RobotGrrl.com
// ------------------------
// Based off the code by Tom Gerhardt
// thomas-gerhardt.com
import codeanticode.syphon.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

int stride = 240;
boolean use_weighted_get = true;

SyphonClient client;
PGraphics canvas;

boolean ready_to_go = true;
int lastPosition;
int canvasW = 320;
int canvasH = 240;
TestObserver testObserver;

int radius = 5;
float theta = 3.0;

void setup() {
  size(canvasW, canvasH, P3D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  background(0);
  client = new SyphonClient(this, "Modul8", "Main View");
}




void draw() {
  if (client.available()) {
    canvas = client.getGraphics(canvas);
    image(canvas, 0, 0, width, height);
  }  
  scrape();
}

void stop()
{
  super.stop();
}

