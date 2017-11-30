import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

int maxW=16;
int maxH=24;
int page=5;
int maxScore = 24;



int bcount;
float w, h;
int[][][] st = new int[page][maxW][maxH];
int[][][] stbk = new int[page][maxW][maxH];
int[] stbkLock =new int[page];
color[][][] c = new color[page][maxW][maxH];

//circle of fifths
//int[] chord5 = {0,4,5,7,11};      //琉球音階
//int[] chord5 = {9,11,12,16,17};   //ヨナ抜き短音階
//int[] chord5 = {0,3,5,7,10};      //
//int[] chord5 = {0,1,3,6,8};       //ガムラン
//int[] chord5 = {0,2,4,7,9};       //スコットランド民謡、ボヘミア民謡
int[] chord5 = {0, 2, 5, 7, 9};     //レミソラシ
int[] chord = new int[maxH];

int p=0;
color[] pColor = {color(255, 255, 0), color(255, 0, 255), color(0, 255, 255), color(255, 255, 255), color(255, 100, 0)};

int transpose = 0;
float[][][] bright = new float[page][maxW][maxH];
float b=0;

Flake[][][] f = new Flake[page][maxW][maxH];


int[] score = new int[maxScore];
int autoScore;
int autoCount;
int baseTime;
long clock;



void setup() {
  size(800, 600);
  //fullScreen();
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 4559);
  w = width/float(maxW);
  h = height/float(maxH);
  for (int a=0; a<page; a++) {
    for (int i=0; i<maxW; i++) {
      for (int j=0; j<maxH; j++) {
        f[a][i][j] = new Flake(a, i*w+w/2, j*h+h/2);
      }
    }
  }
  for (int i=0; i<maxH; i++) {
    chord[i] = chord5[i%5]+(i/5)*12;
  }

  float n = 0;
  for (int i=0; i<maxScore; i++) {
    n+=0.5;
    score[i] =int(noise(n)*24);
    //println(score[i]);
  }
}


void draw() {

  clockCount();

  background(0);
  for (int i=0; i<height/4; i++) {
    colorMode(HSB, height/4, height/4, height/4);  
    strokeWeight(5);
    stroke(i, i/2, i/2);
    line(0, i*4, width, i*4);
  }


  colorMode(RGB);  
  noFill();
  strokeWeight(10);
  stroke(pColor[p], 100);
  rectMode(CORNER);
  rect(0, 0, width, height, 10);


  for (int a=0; a<page; a++) {
    for (int i=0; i<maxW; i++) {
      for (int j=0; j<maxH; j++) {
        f[a][i][j].update();
        pushMatrix();
        translate(i*w+w/2, j*h+h/2);
        if (st[a][i][j]==1) {
          noStroke();
          if (a==p) {
            fill(pColor[a], 50+200*bright[a][i][j]);
            ellipse(0, 0, 20, 20);
          } else {
            fill(pColor[a], 50+100*bright[a][i][j]);
            ellipse(0, 0, 10, 10);
          }
        } else {
          noFill();
          strokeWeight(2);
          stroke(pColor[p], 20*b);
          rotate(radians(45));
          rectMode(CENTER);
          rect(0, 0, 10, 10);
        }
        popMatrix();

        if (i==bcount%(maxW)) {
          bright[a][i][j]=1.0;
        } else {
          bright[a][i][j]*=0.9;
        }
      }
    }
  }

  noStroke();
  fill(255, 255, 255, 50*b);
  rect(bcount%(maxW) * w+w/2, height/2, 4, height);

  b*=0.99;
}

//SendSonicPi
void makeCode(int x) {
  int i= x;
  for (int a=0; a<page; a++) {
    for (int j=0; j<maxH; j++) {
      if (st[a][i][j]==1) {
        OscMessage myMessage = new OscMessage("/trigger/page"+a);
        myMessage.add((int)38+chord[(maxH-1)-j]);
        myMessage.add((int)transpose);
        oscP5.send(myMessage, myRemoteLocation);

        f[a][i][j].hit();
      }
    }
  }
}


void mouseMoved() {
  b+=0.1;
  if (b>1.0) {
    b=1.0;
  }
}

void mousePressed() {
  for (int i=0; i<maxW; i++) {
    for (int j=0; j<maxH; j++) {
      if (overRect(i*w, j*h, w, h)) {
        if (st[p][i][j]==0) {
          st[p][i][j]=1;
        } else {
          st[p][i][j]=0;
        }
      }
    }
  }
}


void keyPressed() {
  //クリア
  if (key==' ') {
    for (int i=0; i<maxW; i++) {
      for (int j=0; j<maxH; j++) {
        st[p][i][j]=0;
      }
    }
  }

  //トラックの音を消す
  if (key=='z') {
    if (stbkLock[p]==0) {
      stbkLock[p]=1;
      for (int i=0; i<maxW; i++) {
        for (int j=0; j<maxH; j++) {
          stbk[p][i][j]=st[p][i][j];
          st[p][i][j]=0;
        }
      }
    }
  }
  //トラックの音を元にもどす
  if (key=='x') {
    stbkLock[p]=0;
    for (int i=0; i<maxW; i++) {
      for (int j=0; j<maxH; j++) {
        st[p][i][j]=stbk[p][i][j];
      }
    }
  }

  //転調アップ
  if (key=='1') {
    transpose++;
    if (transpose>12) {
      transpose=12;
    }
  }
  //転調ダウン
  if (key=='2') {
    transpose--;
    if (transpose<-12) {
      transpose=-12;
    }
  }

  //ページ切り替え
  if (keyCode==LEFT) {
    p--;
    if (p<0) {
      p=page-1;
    }
  }
  //ページ切り替え
  if (keyCode==RIGHT) {
    p++;
    if (p>page-1) {
      p=0;
    }
  }
}



void clockCount() {
  int elapsedTime = millis() - baseTime;

  if (elapsedTime>(1000/6)) {
    baseTime = millis();

    bcount++;
    makeCode(bcount%maxW);
    if (bcount%maxW==0) {
      autoCount++;
      if (autoCount%4==0) {
        transpose = score[autoScore];
        autoScore++;
        if (autoScore>=maxScore)autoScore=0;
      }
    }
  }
}

