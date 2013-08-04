/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/103506*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */

PFont myFontType;
hsbColorPicker colorPicker;
int colorPickerTop = 10, 
colorPickerLeft = 10;
float MAX_BRIGHTNESS = 1;
float MAX_SATURATION = 1;
float MAX_HUE = TWO_PI;
float MAX_ALPHA = 1;

PGraphics mainWin;

void setup() {
  size(500, 500);
  colorMode(HSB, MAX_HUE, MAX_SATURATION, MAX_BRIGHTNESS, MAX_ALPHA);
  background(0);
  mainWin = createGraphics(width, height);

  colorPicker = new hsbColorPicker(150, colorPickerLeft, colorPickerTop); //radio, left, top

  myFontType = createFont("arial", 20);
  textFont(myFontType);
}

//void mouseClicked(){
//  colorPicker.checkMousePressed(mouseX, mouseY);
//}


void draw() {

  background(0);

  if(mousePressed){
    colorPicker.checkMousePressed(mouseX, mouseY);
  }
  
  
  mainWin.beginDraw();
    //* 
     
    //INFORMATION
    //*/
    mainWin.background(1, 1, 1, 0);
    mainWin.stroke(1,1,1);
    mainWin.fill(255);
    mainWin.textFont(myFontType);
    mainWin.text("R: "+ colorPicker.getRed(), 350, 50);
    mainWin.text("G: "+ colorPicker.getGreen(), 350, 70);
    mainWin.text("B: "+ colorPicker.getBlue(), 350, 90);
    mainWin.fill(colorPicker.pickedColor); 
    mainWin.rect(420,330,40,40);
    
  mainWin.endDraw();
  colorPicker.show(mainWin);
  
  image(mainWin, 0, 0);
  //text("TEEEEEEST", 50, 50);
}
