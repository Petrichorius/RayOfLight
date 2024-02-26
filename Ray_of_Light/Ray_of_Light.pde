 //
//You can change these values
//
float ellipseWidth = 50;    //width of the ellipse (original: 50)
float fontSizeCircle = 20;   //font size of the text around the sun (original: 20)
int amountOfWordsPerRay = 1;  //amount of words per array. Has to be a whole number. (original: 5)


//necessary variables
StringList[] wordLists = new StringList[12];
int currentListIndex = 0;
int wordCounter = 0;

String newWord = "";
int time = 0;
int blinkColour = 255;
float blinkMove = 0;

//line stuff
int numLines = 12;    //number should be the same as amount of wordLists
float[] distances;
float[] speeds;

//necessary variables that can be changed to change the looks
float bg = 0;               //colour of the background
float textColour = 255;     //colour if the text

//Font stuff
PFont overUsedGrotesk;
PFont overUsedGroteskItalic;

//for the .txt file
PrintWriter output;
int day = day();
int month = month();
int year = year();
int hour = hour();     //just in case we have to restart within the same day the file name will be different


void setup() {
  //size(800, 800);
  fullScreen(SPAN);   //full screen over 2 screens, beamer screen should be on the left
  //overUsedGrotesk = createFont("OverusedGrotesk-Medium.ttf", 20);
  //overUsedGroteskItalic = createFont("OverusedGrotesk-MediumItalic.ttf", 20);
  overUsedGrotesk = createFont("Arial", 20);
  overUsedGroteskItalic = createFont("Arial", 20);

  textFont(overUsedGrotesk);

  colorMode(RGB);
  frameRate(45);

  // Initialize the StringLists
  for (int i = 0; i < wordLists.length; i++) {
    wordLists[i] = new StringList();
  }

  //the first word in the array (can be slashed out)
  //words.append("What is your light?");
  background(bg);
  stroke(textColour);
  fill(textColour);

  //line stuff
  distances = new float[numLines];
  speeds = new float[numLines];

  for (int i = 0; i < numLines; i++) {  //every line gets its own speed
    distances[i] = 0;
    speeds[i] = random(0.10, 0.35);  // Adjust the range for different speeds
    //println(speeds[i]);
  }

  String d = str(day);
  String m = str(month);
  String y = str(year);
  String h = str(hour);
  String date = d+"-"+m+"-"+y+"-"+h;

  output = createWriter(date + ".txt");

  //println(date);
}


void draw() {
  //background(bg);
  fill(bg);
  stroke(bg);
  rect(0, 0, width/2 + 100, height);


  //for every list put every word in one longer string
  for (int i = 0; i < wordLists.length; i++) {
    pushMatrix();
    String item = "";
    for (int j = 0; j < wordLists[i].size(); j++) {
      item += wordLists[i].get(j) + "   ";
    }
    //text settings
    textFont(overUsedGrotesk);
    textSize(fontSizeCircle);
    fill(textColour);
    textAlign(LEFT);
    popMatrix();


    for (int k = 0; k < numLines; k++) {
      // Calculate line endpoint based on distance
      float x2 = cos(radians(k * 360.0 / numLines)+6) * distances[k];
      float y2 = sin(radians(k * 360.0 / numLines)+6) * distances[k];

      pushMatrix();
      stroke(255);
      translate(width/4, height/2);
      line(0, 0, x2, y2);
      popMatrix();

      // Update distance based on speed
      distances[k] += speeds[k];
      //println(distances[0]);
      // Check if the line has moved out of the screen
      if (distances[k] >  height/2 ) {
        // Reset the distance to make the lines reappear from the center
        distances[k] = 0;
      }
    }

    //the speed with which the words move
    float x2 = sin(radians(2 * 360.0 / numLines)+6) * distances[i];
    //displaying the text in a circular formation
    pushMatrix(); //check if this can be deleted
    translate(width/4, height/2);
    rotate(radians(360/12*i));
    translate(0, 5);
    fill(textColour);
    text(item, ellipseWidth + x2*2.2, 0);
    popMatrix();
  }

  //drawing the circles last so they are on top
  pushMatrix();
  translate(width/4, height/2);
  stroke(0);
  fill(0);
  ellipse(0, 0, ellipseWidth + 50, ellipseWidth + 50);  //black circle to make good
  stroke(textColour);
  fill(textColour);
  ellipse(0, 0, ellipseWidth, ellipseWidth);            //white circle
  popMatrix();


  //the question and the answer
  pushMatrix();
  fill(bg);
  noStroke();
  rect(width/2, 0, width, height);
  //What is your ligth settings
  stroke(textColour);
  fill(textColour);
  textAlign(CENTER);
  textSize(120);
  text("What is your light?", (width/4) * 3 + 0, height/3);
  textFont(overUsedGroteskItalic);
  textSize(50);
  text("Describe it in one word", (width/4) * 3 + 0, height/3 + 100);
  stroke(textColour);
  fill(textColour);
  textFont(overUsedGrotesk);
  textAlign(CENTER);
  textSize(80);
  text(newWord, (width/4) * 3, height/3 + 250);
  popMatrix();

  pushMatrix();
  int passedSeconds = second() - time; // calculates passed seconds
  time = second();
    if (passedSeconds >= 1) {
    blinkColour *= -1;
    if(time == 0){
      blinkColour = 255;
      
    }
    println(time + " " + blinkColour);
  }
  fill(blinkColour, blinkColour);
  textSize(80);
  textAlign(CENTER);
  blinkMove = textWidth(newWord);
  text("|", ((width/4) * 3) + (blinkMove/2)+5, height/3 + 245);
  popMatrix();
}

void keyPressed() {

  //on pressing enter(windows)/return(mac) put word in list, unless it is empty. Then clear the writing field
  if (key == ENTER || key == RETURN) {
    if (newWord != "") {
      //words1.append(newWord);
      wordLists[currentListIndex].append(newWord);

      output.println(newWord);
      output.flush(); // Writes the words to the .txt file

      if ((wordCounter + 1) % amountOfWordsPerRay == 0) {
        currentListIndex = (currentListIndex + 1) % wordLists.length;

        // Reset to the first array after each set of amountOfWordsPerRay words
        if (currentListIndex == 0) {
          currentListIndex = 0;
        }
      }
    }
    newWord = "";    //empty the writing field
    wordCounter++;   //increase the word count by 1 after submitting a word
  } else if (key == BACKSPACE) {    //backspace deletes last typed letter
    if (newWord.length() > 0) {
      newWord = newWord.substring(0, newWord.length()-1);
    }
  } else if ( key == CODED) {   //if shift, alt, control or arrows get pressed
    //dont type that character
    time = second();
  } else {
    newWord += key;
    newWord = newWord.toUpperCase();
  }
}



void stop() {
  output.close(); // Finishes the file
}
