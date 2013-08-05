class PixelMap {
  
  String[][] csv;
  int[] stripLengths;
  int numStrips;

  PixelMap() {
    String lines[] = loadStrings("mapping.csv");
    numStrips = lines.length;
    stripLengths = new int[lines.length];

    int csvWidth = 0;
    for (int i=0; i < lines.length; i++) {
      String[] chars=split(lines[i],',');
      if (chars.length>csvWidth){
        csvWidth=chars.length;
      }
    }

    //create csv array based on # of rows and columns in csv file
    csv = new String [lines.length][csvWidth];

    //parse values into 2d array
    for (int i=0; i < lines.length; i++) {
      int myStripLength = 0;
      String [] temp = new String [lines.length];
      temp= split(lines[i], ',');
      for (int j=0; j < temp.length; j++){
        if (temp[j].length() != 0) {
         int sl = temp[j].length();
         String unquoted = temp[j].substring(1, (sl-1));
         csv[i][j]=unquoted;
         myStripLength++;
        }
      }
      stripLengths[i] = myStripLength;
    }
  }

  int[][] pixels(int ypos, int xpos) {
    String pString = csv[ypos][xpos];
    String[] pArray = split(pString,':');
    int[][] myPixels = new int[pArray.length][2];
    for (int i = 0; i < pArray.length; i++) {
      String[] cStrings = split(pArray[i],'.');
      int tempStrip = Integer.parseInt(cStrings[0]);
      int tempPixel = Integer.parseInt(cStrings[1]);
      myPixels[i][0] = tempStrip - 1;
      myPixels[i][1] = tempPixel - 1;
    }
    return myPixels;
  }

}