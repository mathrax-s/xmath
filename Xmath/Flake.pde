class Flake {
  float bright;
  float x, y;
  float s;
  float r;
  int type;
  float n;

  Flake(int t, float xx, float yy) {
    bright = 1.0;
    x=xx;
    y=yy;
    s = 0;
    r = 0;
    type = t;
    n = noise(xx)*2;
  }


  void hit() {
    bright = 1.0;
    s = 1.0*abs(n);
    r = random(360);
  }

  void update() {
    bright -=0.05;
    if (bright < 0) {
      bright = 0;
    } else {
      r += n*4;
      s *= 1.02;

      pushMatrix();
      translate( x, y );
      scale(s);

      rotate(radians(r));
      noStroke();
      if (type ==0) {
        fill(n*200+150, 255, 200, 250*(bright));
        ellipse(10*n, 0, 100, 100);
      }

      if (type==1) {
        fill(255*bright, 50*bright, 200, 250*(bright));
        rect(50*n, 100*n, 10, 400);
      }

      if (type==2) {
        fill(100, 250, 250, 250*(bright));
        rect(5*n, -10*n, 40*n, 40*n);
      }

      if (type==3) { 
        float b = this.n * sqrt(3) / 4.0;
        float c = 60.0 / 4.0;
        float d = c * tan(radians(30));

        float x1 = 0;
        float y1 = -(b + d);

        float r = radians(120);
        float x2 = x1*cos(r) - y1*sin(r);
        float y2 = x1*sin(r) + y1*cos(r);

        float x3 = x1*cos(r*2) - y1*sin(r*2);
        float y3 = x1*sin(r*2) + y1*cos(r*2);
        
        fill(255, 255, 255, 250*(bright));
        triangle(x1*10, y1*10, x2*10, y2*10, x3*10, y3*10);
      }

      if (type ==4) {
        fill(n*200+150, 150, 100, 250*(bright));
        ellipse(10*n, 0, 100, 100);
      }
      popMatrix();
    }
  }
}