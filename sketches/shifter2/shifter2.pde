
//set global list of rows to simulate varying strip lengths
int[] rowList = {10, 10, 8, 12, 8, 13, 10, 10, 11, 12 , 7, 10, 10, 10};

ArrayList<Boxel> boxels;
Effects effect = new Effects;

class Boxel {
	color currentC;
	color lastC;
	int xpos;
	int ypos;


	Boxel(int tempXpos, int tempYpos) {
		currentC = color(0,0,0);
		lastC = color(0,0,0);
		xpos = tempXpos;
		ypos = tempYpos;
	}
}

void setup() {
	size(400, 600);
  background(255);
  //noStroke();
  boxels = new ArrayList<Boxel>();
  for (int i = 0; i < rowList.length; i++) {
  	for (int j = 0; j < rowList[i]; j++) {
  		Boxel newBoxel = new Boxel(j, i);
  		boxels.add(newBoxel);
  	}
  }
}

void draw() {
	for (Boxel b : boxels) {
		b.currentC = effect.doEffect();
		if (b.lastC != b.currentC) {
			render(b);
		}
	}
}

class Effects{
	//Effects class
	int curEffect; //index of currently running effect
	int lastEffect; //index of previous effect
	int bIndex;
	color currentC;
	color lastC;
	Boxel b;

	Effects(color tempLastC, color tempCurrentC) {
		curEffect = 0;
		lastEffect = 0;
		pIndex = 0;
		lastC = tempLastC;
		currentC = tempCurrentC;
	}

	void effectsChooser() {
		//maps number keys to individual effects
		//logic... checks for keypress; lastEffect = curEffect; curEffect = new keypress;
		curEffect = 0;
	}

	void doEffect() {
		effectsChooser();
		switch(curEffect) {
			case 0:
				effect0();
				break;
			case 1:
				effect1();
				break;
		}
	}

	void effect0() {
		if (frameCount % 30) {
			if (red(currentC) <= 254) {
				currentC = color((red(currentC) + 1), green(lastC), blue(lastC));
			} else if (red(currentC == 255)) {
				currentC = color(red(0), green(lastC), blue(lastC));
			}
		}
	}

	void effect1() {
		//asdfaedfa
	}
}

/*
void doSomeEffect(Boxel b) {
	if ((red(b.lastC) > 0) && (red(b.lastC)) < 255) {
		b.currentC = color((red(b.lastC) + 1), 0, 0);
	} else if ((green(b.lastC) > 0) && (green(b.lastC) < 255)) {
		b.currentC = color(0, (green(b.lastC) + 1), 0);
	} else if ((blue(b.lastC) > 0) && ((blue(b.lastC)) <  255)) {
		b.currentC = color(0, 0, (blue(b.lastC) + 1 ));
	} else {
		b.currentC = color(1, 0, 0);
	}
}
*/
void render(Boxel b) {
	fill(b.currentC);
	float ysize = height/rowList.length;
	float xsize = width/rowList[b.ypos];
	rect((xsize * b.xpos), (ysize * b.ypos), xsize, ysize);
	b.lastC = b.currentC;
}