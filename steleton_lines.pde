
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;
ArrayList <SkeletonData> bodies;

int num = 0;
int mode = 3;
ArrayList<String> step;
ArrayList<PImage> stepImg;
ArrayList<String> stepStr;
PFont myFont;

//-----------------------------------------

void setup() {
  size(1280, 480);
  background(0);

  kinect = new Kinect(this);
  smooth();
  bodies = new ArrayList<SkeletonData>();

  myFont = createFont("Meiryo", 10);
  textFont(myFont);

  step = new ArrayList<String>();
  stepImg = new ArrayList<PImage>();
  stepStr = new ArrayList<String>();
  kimono();
}

//-------------------------------------------

void draw() {

  background(255);
  //Kinect不使用のとき左半分はグレーに
  fill(240);
  rect(0, 0, 640, 480);

  strokeWeight(1);
  noFill();
  //Kinectの映像と骨格を表示
  image(kinect.GetImage(), 0, 0, 640, 480);

  ArrayList<KinectBody> kBodies = new ArrayList<KinectBody>();
  for (int i=0; i<bodies.size(); i++) {
    KinectBody b = new KinectBody(bodies.get(i));
    kBodies.add(b);
    drawBody(b);
    //drawPosition(bodies.get(i));
  }

  //ステップを表示
  if (mode>0) {
    fill(0);
    noStroke();
    textSize(20);
    text("Step"+(num+1)+": "+step.get(num), width/2+30, 50);
    image(stepImg.get(num), width-300, 0);
    text(stepStr.get(num), width/2+30, 100, 330, height);
  }

  switch(num) {    
  case 1:
    //裾
    for (int i=0; i<kBodies.size(); i++) {
      drawHemLine(kBodies.get(i));
    }
    break;

  case 5:
    //腰紐
    for (int i=0; i<kBodies.size(); i++) {
      drawBandLine(kBodies.get(i));
    }
    break;

  case 6:
    //おはしょり
    PImage ohashori = loadImage("ohashori.png");
    subImg(ohashori);
    break;

  case 7:
    //衿（右）
    for (int i=0; i<kBodies.size(); i++) {
      drawCollarR(kBodies.get(i));
    }
    break;

  case 8:
    //衿（左）
    for (int i=0; i<kBodies.size(); i++) {
      drawCollarL(kBodies.get(i));
    }
    break;

  case 9:
    //胸紐
    for (int i=0; i<kBodies.size(); i++) {
      drawUpperBandLine(kBodies.get(i));
    }
    break;

  case 11:
    //伊達締め
    PImage datejime = loadImage("datejime.png");
    subImg(datejime);
    for (int i=0; i<kBodies.size(); i++) {
      imageDatejime(kBodies.get(i));
    }
    break;
  }
}

//-----------------------------------------

//左右キーでステップ移動
void keyPressed() {
  if (mode>0) {
    if (keyCode == RIGHT) {
      num++;
    } else if (keyCode == LEFT) {
      num--;
    }
  }
  if (num<0) {
    num=0;
  }
  if (num>=step.size()) {
    num=step.size()-1;
  }
}

//--------------------------------------------

//衿のライン右
void drawCollarR(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  line(body.shoulderC.x+(body.shoulderC.x-body.shoulderL.x)/3, 
    body.shoulderC.y, 
    body.shoulderC.x+(body.shoulderC.x-body.shoulderR.x)/3, 
    body.shoulderC.y+(body.spine.y-body.shoulderC.y)/3);
}

//衿のライン左
void drawCollarL(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  line(body.shoulderC.x+(body.shoulderC.x-body.shoulderR.x)/3, 
    body.shoulderC.y, 
    body.shoulderC.x+(body.shoulderC.x-body.shoulderL.x)/3, 
    body.shoulderC.y+(body.spine.y-body.shoulderC.y)/3);
}

//腰ひも（胸）
void drawUpperBandLine(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  line(body.shoulderR.x, body.spine.y*3/4+body.shoulderC.y/4, 
    body.shoulderL.x, body.spine.y*3/4+body.shoulderC.y/4);
}

//腰ひも
void drawBandLine(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  line(body.shoulderR.x, (body.hipR.y+body.hipC.y)/2, 
    body.shoulderL.x, (body.hipL.y+body.hipC.y)/2);
}

//裾のライン
void drawHemLine(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  line((body.ankleR.x+body.footR.x)/2, 
    (body.ankleR.y+body.footR.y)/2, 
    (body.ankleL.x+body.footL.x)/2, 
    (body.ankleL.y+body.footL.y)/2);
}

//------------------------------------

//サブイラスト表示
void subImg(PImage img) {
  image(img, width/2, height-img.height);
}

//伊達締めイラスト反転半透明
void imageDatejime(KinectBody body) {
  PImage d = stepImg.get(num).get(0, 180, stepImg.get(num).width, 80);
  float dh = (body.spine.y-body.shoulderC.y)*3/5;
  float dw = d.width*(dh/d.height);
  scale(-1, 1);
  tint(255, 160);
  image(d, 
    -body.shoulderC.x+dw/2, 
    body.spine.y*3/4+body.shoulderC.y/4-dh/2, 
    -dw, dh);
  scale(-1, 1);
  tint(255, 255);
}