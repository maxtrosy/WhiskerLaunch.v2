PImage fondo, instruccionesFondo, simuladorFondo;
PFont font;
PImage acercadeFondo;

float transitionAlpha = 255;

int buttonWidth = 350;
int buttonHeight = 140;

int simuladorButtonX = 720;
int simuladorButtonY = 480;

int instruccionesButtonX =720;
int instruccionesButtonY = 260;

boolean instruccionesVisible = false;
boolean simuladorVisible = false;
boolean slidersVisible = false;
boolean acercaDeVisible = false;

float distortionRadius = 0;
float distortionMaxRadius = 50;
float distortionStrength = 5;

int slider1Value = 50;
int slider2Value = 40;
int slider3Value = 0;
int sliderWidth = 200;
int sliderHeight = 20;
float rectBottom;
ArrayList<PVector> positions = new ArrayList<PVector>();
float maxHeight = 0;
float totalTime = 0;
float totalDistanceX = 0;

PImage backgroundImage;
boolean button1Pressed = false;
boolean button2Pressed = false;
float buttonWidth1 = 60;
float buttonHeight1 = 30;
float buttonSpacing = 10;
float button1X, button1Y, button2X, button2Y;
float maxHeightReached = 0;

int acercaX = 1050;
int acercaY = 360;
int acercaSize = 200;
float slider1ButtonX;
float slider2ButtonX;
PImage hamsterImage;
float hamsterWidth = 50;
float hamsterHeight = 50;



public void setup() {

  frameRate(144);
  fondo = loadImage("foto1.png");
  instruccionesFondo = loadImage("instrucciones.png");
  simuladorFondo = loadImage("simulator.png");
  acercadeFondo = loadImage("acercade.png");
  slider1ButtonX = 50 + sliderWidth / 2;
  slider2ButtonX = 50 + sliderWidth / 2;
  noStroke();
  font = createFont("Arial", 24);
  textFont(font);
  fill(0);
  textAlign(LEFT);

  backgroundImage = loadImage("simulator.png");

  rectBottom = (2 * height) / 3;
  hamsterImage = loadImage("hamster1.png");


  font = createFont("Arial", 16);


  float buttonTop = rectBottom + 50;
  float sliderRight = 50 + sliderWidth;
  float spacing = 30;
  float buttonOffset = 50;
  button1X = sliderRight + spacing + buttonOffset + 100;
  button1Y = buttonTop;
  button2X = sliderRight + spacing + buttonOffset + 100;
  button2Y = button1Y + buttonHeight + buttonSpacing;

  myBall = new Ball(slider1Value, slider2Value);
  myBall.setupGUI();
}
public void draw() {
  background(255);

  if (acercaDeVisible) {

    image(acercadeFondo, 0, 0, width, height);
    drawButton(1100, 600, "Regresar");

    
  } else if (instruccionesVisible) {
  
    image(instruccionesFondo, 0, 0, width, height);
    drawButton(1000, 550, "Regresar");
  } else if (simuladorVisible) {

   
    image(simuladorFondo, 0, 0, width, height);


    if (slidersVisible) {
      if (myBall.isAtMaxHeight()) {
        float xAtMaxHeight = myBall.posX;
        float yAtMaxHeight = myBall.calculateYAtMaxHeight();
        fill(255, 0, 0);
        ellipse(xAtMaxHeight, yAtMaxHeight, 10, 10);
      }


      noFill();



      line(50, 50, 50, rectBottom - 50);
      line(50, rectBottom - 50, width - 50, rectBottom - 50);


      fill(0);
      textFont(font);
      textSize(16);
      textAlign(RIGHT);
      text("X (m)", width - 60, rectBottom - 60);
      textAlign(LEFT);
      text("Y (m)", 60, 60);


      float pixelSpacingY = 101.79f;


      float labelValue = 0;

      for (float yMark = rectBottom - 50; yMark >= 50; yMark -= pixelSpacingY) {
        stroke(0);
        line(45, yMark, 55, yMark);
        textAlign(RIGHT);
        fill(0);
        text(nf(labelValue, 0, 0), 45 - 5, yMark);
        labelValue += 100;
      }


      float pixelSpacing = 101.79f;
      float xPosition = 50;
      int distance = 0;

      while (xPosition <= width - 50) {

        line(xPosition, rectBottom - 45, xPosition, rectBottom - 55);
        textAlign(CENTER);
        fill(0);
        text(Integer.toString(distance), xPosition, rectBottom - 60);
        xPosition += pixelSpacing;
        distance += 100;
      }





      drawSlider(50, rectBottom + 50, slider1Value, "Velocidad m/s", 0, 100);
      drawSlider(50, rectBottom + 100, slider2Value, "Angulo", 0, 90);



      if (button1Pressed) {
        myBall.move();
      }


      myBall.display();
      PVector currentPos = new PVector(myBall.posX, myBall.posY);
      positions.add(currentPos);


      noFill();
      stroke(88, 56, 99);
      beginShape();
      for (PVector pos : positions) {
        vertex(pos.x, pos.y);
      }
      endShape();






      float propertiesX = 610;
      float propertiesY = 515;

      myBall.mostrarPropiedades(propertiesX, propertiesY);

      textAlign(LEFT);
      fill(0);

      if (maxHeight < 0) {
        maxHeight = 0;
      }

      text("Altura Actual: " + nf(maxHeight, 0, 2) + " m", propertiesX, propertiesY + 60);
      text("Tiempo Total: " + nf(totalTime, 0, 2) + " s", propertiesX, propertiesY + 100);

      text("Altura Max : " + nf(maxHeightReached, 0, 2) + " m", propertiesX, propertiesY + 80);


      text("Recorrido: " + nf(totalDistanceX, 0, 2) + " m", propertiesX, propertiesY + 120);


      float timeToMaxHeight = totalTime/2;
      fill(0);
      textAlign(LEFT);
      text("Tiempo Hmax  " + nf(timeToMaxHeight, 0, 2) + " s", propertiesX, propertiesY + 140);
    }
  } else {
   
    image(fondo, 0, 0);
    drawButton(instruccionesButtonX, instruccionesButtonY, "Instrucciones");
    drawButton(simuladorButtonX, simuladorButtonY, "Simulador");
    drawButtonn(acercaX, acercaY, "Acerca de");
  }

  if (distortionRadius > 0) {
    fill(0, 100);
    ellipse(mouseX, mouseY, distortionRadius * 2, distortionRadius * 2);
    distortionRadius += distortionStrength;

    if (distortionRadius > distortionMaxRadius) {
      distortionRadius = 0;
    }
  }
}


public void drawButton(int x, int y, String label) {
  fill(150, 0);
  rect(x - buttonWidth / 2, y - buttonHeight / 2, buttonWidth, buttonHeight);
  fill(0, 0);
  textAlign(CENTER, CENTER);
  text(label, x, y);
}

public void mousePressed() {
  int acercaDeButtonWidth = acercaSize * 4;
  int acercaDeButtonHeight = acercaSize * 4;
  
  if (!instruccionesVisible && !simuladorVisible && mouseX >= simuladorButtonX - buttonWidth / 2 &&
    mouseX <= simuladorButtonX + buttonWidth / 2 && mouseY >= simuladorButtonY - buttonHeight / 2 &&
    mouseY <= simuladorButtonY + buttonHeight / 2) {
    simuladorVisible = true;
    slidersVisible = true;
  }

  if (!instruccionesVisible && !simuladorVisible && mouseX >= instruccionesButtonX - buttonWidth / 2 &&
    mouseX <= instruccionesButtonX + buttonWidth / 2 && mouseY >= instruccionesButtonY - buttonHeight / 2 &&
    mouseY <= instruccionesButtonY + buttonHeight / 2) {
    instruccionesVisible = true;
    slidersVisible = false;
  }

  if (!acercaDeVisible && mouseX >= acercaX - acercaSize / 2 && mouseX <= acercaX + acercaSize / 2 &&
    mouseY >= acercaY - acercaSize / 2 && mouseY <= acercaY + acercaSize / 2) {
    acercaDeVisible = true;
  }

    if (instruccionesVisible &&  mouseX >= acercaX - acercaDeButtonWidth / 2 && mouseX <= acercaX + acercaDeButtonWidth / 2 &&
    mouseY >= acercaY - acercaDeButtonHeight / 2 && mouseY <= acercaY + acercaDeButtonHeight / 2) {
    instruccionesVisible = false;
    slidersVisible = false;
  }else if (simuladorVisible && mouseX >= 1100 - buttonWidth / 2 && mouseX <= 1100 + buttonWidth / 2 &&
    mouseY >= 600 - buttonHeight / 2 && mouseY <= 600 + buttonHeight / 2) {
    simuladorVisible = false;
    slidersVisible = false;
  } else if (acercaDeVisible && mouseX >= acercaX - acercaDeButtonWidth / 2 && mouseX <= acercaX + acercaDeButtonWidth / 2 &&
    mouseY >= acercaY - acercaDeButtonHeight / 2 && mouseY <= acercaY + acercaDeButtonHeight / 2) {
    acercaDeVisible = false;
  }


  if (mouseX >= 320 && mouseX <= 470 && mouseY >= 550 && mouseY <= 600) {

    button1Pressed = true;
    myBall.launch();
  }

  if (mouseX >= 320 && mouseX <= 470 && mouseY >= 630 && mouseY <= 680) {

    button1Pressed = false;
    myBall.resetPosition();


    maxHeight = 0;
    totalTime = 0;
    totalDistanceX = 0;
    maxHeightReached = 0;
  }


  if (instruccionesVisible && mouseX >= 900 - buttonWidth / 2 && mouseX <= 900 + buttonWidth / 2 &&
    mouseY >= 500 - buttonHeight / 2 && mouseY <= 500 + buttonHeight / 2) {
    instruccionesVisible = false;
    slidersVisible = false;
  } else if (simuladorVisible && mouseX >= 1100 - buttonWidth / 2 && mouseX <= 1100 + buttonWidth / 2 &&
    mouseY >= 600 - buttonHeight / 2 && mouseY <= 600 + buttonHeight / 2) {
    simuladorVisible = false;
    slidersVisible = false;
  } else if (mouseX >= instruccionesButtonX - buttonWidth / 2 && mouseX <= instruccionesButtonX + buttonWidth / 2 &&
    mouseY >= instruccionesButtonY - buttonHeight / 2 && mouseY <= instruccionesButtonY + buttonHeight / 2) {
    instruccionesVisible = true;
    slidersVisible = false;
  } else if (mouseX >= simuladorButtonX - buttonWidth / 2 && mouseX <= simuladorButtonX + buttonWidth / 2 &&
    mouseY >= simuladorButtonY - buttonHeight / 2 && mouseY <= simuladorButtonY + buttonHeight / 2) {

    simuladorVisible = true;
    slidersVisible = true;
    if (mouseX >= button1X && mouseX <= button1X + buttonWidth && mouseY >= button1Y && mouseY <= button1Y + buttonHeight) {

      button1Pressed = true;
      myBall.launch();
    }

    if (mouseX >= button2X && mouseX <= button2X + buttonWidth && mouseY >= button2Y && mouseY <= button2Y + buttonHeight) {

      button1Pressed = false;
      myBall.resetPosition();


      maxHeight = 0;
      totalTime = 0;
      totalDistanceX = 0;
      maxHeightReached = 0;
    }
  } else if (mouseX >= acercaX - acercaSize / 2 && mouseX <= acercaX + acercaSize / 2 &&
    mouseY >= acercaY - acercaSize / 2 && mouseY <= acercaY + acercaSize / 2) {
    acercaDeVisible = true;
  }
  if (acercaDeVisible && mouseX >= buttonWidth / 2 && mouseX <= buttonWidth / 2 + buttonWidth && mouseY >= height - 100 && mouseY <= height - 50) {
    acercaDeVisible = false;
  }
  if (acercaDeVisible) {
    if (mouseX >= width - buttonWidth / 2 && mouseX <= width - buttonWidth / 2 + buttonWidth && mouseY >= height - 100 && mouseY <= height - 50) {
      acercaDeVisible = false;
    }
  }
}


Ball myBall;

class Ball {
  float vel1X;
  float vel1Y;
  float gravity = 9.81f;
  float angle;
  float initialX;
  float initialY;
  float posX;
  float posY;
  float time;
  float v1 = 50;
  float ang = 40;

  Ball(float v1, float ang) {
    vel1X = v1 * cos(radians(ang));
    vel1Y = v1 * sin(radians(ang));
    angle = ang;
    initialX = 50;
    initialY = 416;
    posX = initialX;
    posY = initialY;
    time = 0;
  }

  public void setupGUI() {
  }

  public void mostrarPropiedades(float x, float y) {
    textSize(16);
    fill(255);
    textAlign(LEFT);
    fill(0);
    text("Voₓ: " + nf(vel1X, 0, 2) + " m/s", 970, 70);
    text("Voγ " + nf(vel1Y, 0, 2) + " m/s", 970, 160);
  }

  public void resetPosition() {
    posX = 50;
    posY = 416;
    time = 0;
    isMoving = true;
    positions.clear();
  }

  public void launch() {
    time = 0;
  }
  public boolean reachedMaxHeight() {
    for (int i = 1; i < positions.size(); i++) {
      if (positions.get(i).y > positions.get(i - 1).y) {
        return false;
      }
    }
    return true;
  }
  boolean isMoving = true;

  public void move() {
    if (isMoving) {
      time += 1.0f / frameRate;

      float delta_x = vel1X * time;
      float delta_y = (vel1Y * time) - (0.5f * gravity * pow(time, 2));
      posX = initialX + delta_x;
      posY = initialY - delta_y;

      if (angle == 90) {
        totalDistanceX = 0;
      } else {
        totalDistanceX = (posX - initialX)-0.1996f;
      }

      if (reachedMaxHeight()) {
        fill(255, 0, 0);
        ellipse(posX, posY, 10, 10);


        if (initialY - posY > maxHeightReached) {
          maxHeightReached = initialY - posY;
        }
      }

      maxHeight = round((initialY - posY) * 100000.0f) / 100000.0f;

      totalTime = (round(time * 100000.0f) / 100000.0f) - 0.05764f+0.0554f;

      if (posY >= rectBottom - 50) {
        isMoving = false;
        posY = rectBottom - 50;
      }
    }
  }



  public void resumeMovement() {
    isMoving = true;
    time = 0;
  }

  public void updateVelocity(int newVelocity) {
    vel1X = newVelocity * cos(radians(angle));
    vel1Y = newVelocity * sin(radians(angle));
  }

  public void updateHeight(int newHeight) {
    initialY = rectBottom - newHeight;
  }

  public void updateAngle(int newAngle) {
    angle = newAngle;
    updateVelocity(slider1Value);
  }

  public void display() {

    float imageX = posX - hamsterWidth / 2;
    float imageY = posY - hamsterHeight / 2;


    image(hamsterImage, imageX, imageY, hamsterWidth, hamsterHeight);
  }

  public boolean isAtMaxHeight() {
    if (posY >= rectBottom - 50) {
      for (int i = 0; i < positions.size(); i++) {
        if (i > 0 && positions.get(i).y > positions.get(i - 1).y) {
          return true;
        }
      }
    }
    return false;
  }

  public float calculateYAtMaxHeight() {
    return max(positions.get(0).y, positions.get(1).y);
  }
}




public void mouseDragged() {
  if (slidersVisible) {
    if (mouseX >= 50 && mouseX <= 50 + sliderWidth) {
      if (mouseY >= rectBottom + 90 && mouseY <= rectBottom + 100 + sliderHeight) {
        slider1Value = PApplet.parseInt(map(constrain(mouseX, 50, 50 + sliderWidth), 50, 50 + sliderWidth, 0, 100));
        int newV1 = slider1Value;
        myBall.updateVelocity(constrain(newV1, 0, 100));


        slider1ButtonX = constrain(mouseX, 50, 50 + sliderWidth - 20);
      }
      if (mouseY >= rectBottom + 120 && mouseY <= rectBottom + 150 + sliderHeight) {
        slider2Value = PApplet.parseInt(map(constrain(mouseX, 50, 50 + sliderWidth), 50, 50 + sliderWidth, 0, 90));
        int newAng = slider2Value;
        myBall.updateAngle(constrain(newAng, 0, 90));


        slider2ButtonX = constrain(mouseX, 50, 50 + sliderWidth - 20);
      }
    }
  }
}




public void mousePressedbtn() {
  if (mouseX >= button1X && mouseX <= button1X + buttonWidth && mouseY >= button1Y && mouseY <= button1Y + buttonHeight) {

    button1Pressed = true;
    myBall.launch();
  }

  if (mouseX >= button2X && mouseX <= button2X + buttonWidth && mouseY >= button2Y && mouseY <= button2Y + buttonHeight) {

    button1Pressed = false;
    myBall.resetPosition();


    maxHeight = 0;
    totalTime = 0;
    totalDistanceX = 0;
    maxHeightReached = 0;
  }
}

public void drawSlider(float x, float y, int value, String label, int minVal, int maxVal) {
  y += 50;


  fill(0);
  textFont(font);
  textAlign(CENTER, CENTER);
  textSize(16);
  text(label + ": " + value, x + sliderWidth / 2, y - 20);


  fill(88, 56, 99);
  rect(x, y, sliderWidth, sliderHeight);


  float buttonX = map(value, minVal, maxVal, x, x + sliderWidth - 20);
  fill(150, 150, 200);
  float buttonWidth = 20;
  float buttonHeight = sliderHeight;
  rect(buttonX, y, buttonWidth, buttonHeight);
}



public void drawButtonn(int x, int y, String label) {
  noStroke();
  fill(150, 0);
  rect(x - buttonWidth / 2, y - buttonHeight / 2, buttonWidth, buttonHeight);
  fill(0, 0);
  textAlign(CENTER, CENTER);
  text(label, x, y);
}


public void settings() {
  size(1200, 700);
}
public void drawSliderButton(float x, float y) {
  fill(150, 150, 200);
  float buttonWidth = 20;
  float buttonHeight = sliderHeight;
  rect(x, y, buttonWidth, buttonHeight);
}
