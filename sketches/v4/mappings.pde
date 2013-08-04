class Mappings {
  
  String[][] csv;

  Mappings() {
    String lines[] = loadStrings("mapping.csv");
    
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
      String [] temp = new String [lines.length];
      temp= split(lines[i], ',');
        for (int j=0; j < temp.length; j++){
         csv[i][j]=temp[j];
      }
    }
  }

  int[][] pixels(int ypos, int xpos) {
    String pString = csv[ypos][xpos];
    String[] pArray = split(pString,':');
    int[][] myPixels = new int[pArray.length][2];
    for (int i = 0; i < pArray.length; i++) {
      String[] cStrings = split(pArray[i],'.');
      myPixels[i][0] = Integer.parseInt(cStrings[0]);
      myPixels[i][1] = Integer.parseInt(cStrings[1]);
    }
    return myPixels;
  }

}