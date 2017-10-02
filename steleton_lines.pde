

import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;
ArrayList <SkeletonData> bodies;
ArrayList<KinectBody> kBodies;

int num = 0;
int mode = 3;
ArrayList<String> step;
ArrayList<PImage> stepImg;
ArrayList<String> stepStr;
PFont myFont;

int cutFrame = 40;
int startFrame = 0;

//-----------------------------------------

void setup() {
  size(1280, 480);
  background(0);

  kinect = new Kinect(this);
  smooth();
  bodies = new ArrayList<SkeletonData>();
  kBodies = new ArrayList<KinectBody>();

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
  for (int i=0; i<kBodies.size(); i++) {
    KinectBody body = kBodies.get(i);
    body.position();
    body.drawBody();
  }

  //ステップを表示
  if (mode>0) {
    fill(0);
    noStroke();
    textSize(20);
    text("Step"+(num+1)+": "+step.get(num), width/2+30, 50);
    image(stepImg.get(num), width-300, 0);
    text(stepStr.get(num), width/2+30, 100, 330, height);
    fill(255);
    rect(20, height-50, 400, 25);
    fill(0);
    text("鏡像です。左右がイラストと逆になります", 30, height-30);
  }

  int time = (frameCount-startFrame)/cutFrame;
  switch(num) {
  case 1:
    //裾
    for (int i=0; i<kBodies.size(); i++) {
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyHem(dummy, time);
    }
    break;

  case 2:
    for (int i=0; i<kBodies.size(); i++) {
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyFrontL1(dummy, time);
    }
    break;

  case 3:
    for (int i=0; i<kBodies.size(); i++) {
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyFrontR(dummy, time);
    }
    break;

  case 4:
    for (int i=0; i<kBodies.size(); i++) {
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyFrontL2(dummy, time);
    }
    break;


  case 5:
    //腰紐
    for (int i=0; i<kBodies.size(); i++) {
      //drawBandLine(kBodies.get(i));
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyBand(dummy, time);
    }
    break;

  case 6:
    //おはしょり
    PImage ohashori = loadImage("ohashori.png");
    subImg(ohashori);
    for (int i=0; i<kBodies.size(); i++) {
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyOhashori(dummy, time);
    }
    break;

  case 7:
    //衿（右）
    for (int i=0; i<kBodies.size(); i++) {
      drawCollarR(kBodies.get(i));
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyCollarR(dummy, time);
    }
    break;

  case 8:
    //衿（左）
    for (int i=0; i<kBodies.size(); i++) {
      drawCollarL(kBodies.get(i));
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyCollarL(dummy, time);
    }
    break;

  case 9:
    //胸紐
    for (int i=0; i<kBodies.size(); i++) {
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyUpperBand(dummy, time);
    }
    break;

  case 10:
    for (int i=0; i<kBodies.size(); i++) {
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyWrinkle(dummy, time);
    }
    break;

  case 11:
    //伊達締め
    PImage datejime = loadImage("datejime.png");
    subImg(datejime);
    for (int i=0; i<kBodies.size(); i++) {
      //drawDatejimeLine(kBodies.get(i));
      DummyArm dummy = new DummyArm(kBodies.get(i));
      dummyDatejime(dummy, time);
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
      startFrame = frameCount;
    } else if (keyCode == LEFT) {
      num--;
      startFrame = frameCount;
    }
    if (key == 's') {
      save("kitsuke_"+frameCount+".png");
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

//ガイド線

//衿のライン右
void drawCollarR(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  line(body.shoulderC.x+(body.shoulderC.x-body.shoulderL.x)/4, 
    body.shoulderC.y, 
    (body.shoulderL.x+body.spine.x)/2, 
    (body.shoulderL.y+body.spine.y)/2);
  /*line(body.shoulderC.x+(body.shoulderC.x-body.shoulderL.x)/4, 
   body.shoulderC.y, 
   body.shoulderC.x+(body.shoulderC.x-body.shoulderR.x)/4, 
   body.shoulderC.y+(body.spine.y-body.shoulderC.y)/4);*/
}

//衿のライン左
void drawCollarL(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  line(body.shoulderC.x+(body.shoulderC.x-body.shoulderR.x)/4, 
    body.shoulderC.y, 
    (body.shoulderR.x+body.spine.x)/2, 
    (body.shoulderR.y+body.spine.y)/2);
  /*line(body.shoulderC.x+(body.shoulderC.x-body.shoulderR.x)/4, 
   body.shoulderC.y, 
   body.shoulderC.x+(body.shoulderC.x-body.shoulderL.x)/4, 
   body.shoulderC.y+(body.spine.y-body.shoulderC.y)/4);*/
}

//腰ひも（胸）
void drawUpperBandLine(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  line(body.shoulderR.x, body.spine.y*3/4+body.shoulderC.y/4+(body.shoulderR.y-body.shoulderL.y), 
    body.shoulderL.x, body.spine.y*3/4+body.shoulderC.y/4+(body.shoulderL.y-body.shoulderR.y));
  /*line(body.shoulderR.x, body.spine.y/3+body.shoulderR.y*2/3, 
   body.shoulderL.x, body.spine.y/3+body.shoulderL.y*2/3);*/
}

//伊達締め
void drawDatejimeLine(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  //上線は胸紐と同じ
  drawUpperBandLine(body);
  line(body.shoulderR.x, body.spine.y+(body.shoulderR.y-body.shoulderL.y), 
    body.shoulderL.x, body.spine.y+(body.shoulderL.y-body.shoulderR.y));
}

//腰ひも
void drawBandLine(KinectBody body) {
  stroke(0, 255, 255);
  strokeWeight(3);

  /*line(body.shoulderR.x, (body.hipR.y+body.hipC.y)/2, 
   body.shoulderL.x, (body.hipL.y+body.hipC.y)/2);*/
  line(body.shoulderR.x, body.hipC.y+(body.hipR.y-body.hipL.y), 
    body.shoulderL.x, body.hipC.y+(body.hipL.y-body.hipR.y));
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

//--------------------------------------

//ダミーアーム用関数

//裾合わせ
void dummyHem(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%5) {
  case 0:
    arm.initPos();
    arm.drawArm();
    break;

  case 1:
    //裾つかむ
    arm.wristL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x), body.hipL.y);
    arm.handL.setPos(arm.wristL.x-(body.hipC.x-body.hipL.x), arm.wristL.y+(body.hipL.y-body.hipC.y));
    arm.wristR.setPos(body.shoulderR.x-(body.hipC.x-body.hipR.x), body.hipR.y);
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipR.x), arm.wristR.y+(body.hipR.y-body.hipC.y));
    arm.drawArm();
    break;

  case 2:
    //持ち上げる
    arm.wristL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x), arm.elbowL.y-(body.hipC.y-body.spine.y));
    arm.handL.setPos(arm.wristL.x-(body.hipC.x-body.hipL.x), arm.wristL.y-(body.hipR.y-body.hipC.y)/2);
    arm.wristR.setPos(body.shoulderR.x-(body.hipC.x-body.hipR.x), arm.elbowR.y-(body.hipC.y-body.spine.y));
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipR.x), arm.wristR.y-(body.hipR.y-body.hipC.y)/2);
    arm.drawArm();
    break;

  case 3:
    //おろす
    arm.wristL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x), arm.elbowL.y+(body.hipL.y-body.hipC.y));
    arm.handL.setPos(arm.wristL.x-(body.hipC.x-body.hipL.x), arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.wristR.setPos(body.shoulderR.x-(body.hipC.x-body.hipR.x), arm.elbowR.y+(body.hipR.y-body.hipC.y));
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipR.x), arm.wristR.y+(body.hipR.y-body.hipC.y)/2);
    arm.drawArm();
    break;
  }
}

//前合わせ（左）
void dummyFrontL1(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%3) {
  case 0:
    dummyHem(arm, 3);  //前ステップの最後の位置から
    break;

  case 1:
    //上前合わせる
    arm.wristL.setPos(body.hipR.x-(body.hipC.x-body.hipL.x)/2, arm.elbowL.y+(body.hipL.y-body.hipC.y));
    arm.handL.setPos(arm.wristL.x+(body.hipC.x-body.hipL.x), arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.wristR.setPos(body.shoulderR.x-(body.hipC.x-body.hipR.x), arm.elbowR.y+(body.hipR.y-body.hipC.y));
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipR.x), arm.wristR.y+(body.hipR.y-body.hipC.y)/2);
    arm.drawArm();
    break;
  }
}

//前合わせ（右）
void dummyFrontR(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%4) {
  case 0:
    dummyFrontL1(arm, 1);  //前ステップの最後の位置から
    break;

  case 1:
    //一度開く
    dummyHem(arm, 3);
    break;

  case 2:
    //下前合わせる
    arm.wristL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x), arm.elbowL.y+(body.hipL.y-body.hipC.y));
    arm.handL.setPos(arm.wristL.x-(body.hipC.x-body.hipL.x), arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.wristR.setPos(body.hipL.x-(body.hipC.x-body.hipL.x)/2, arm.elbowR.y+(body.hipR.y-body.hipC.y));
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipL.x), arm.wristR.y+(body.hipR.y-body.hipC.y)/2);
    arm.drawArm();
    break;
  }
}

//前合わせ（再度左）
void dummyFrontL2(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%4) {
  case 0:
    dummyFrontR(arm, 2);  //前ステップの最後の位置から
    break;

  case 1:
    //右手そのまま上前とじる
    arm.wristL.setPos(body.hipR.x-(body.hipC.x-body.hipL.x)/2, arm.elbowL.y+(body.hipL.y-body.hipC.y));
    arm.handL.setPos(arm.wristL.x+(body.hipC.x-body.hipL.x), arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.wristR.setPos(body.hipL.x-(body.hipC.x-body.hipL.x)/2, arm.elbowR.y+(body.hipR.y-body.hipC.y));
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipL.x), arm.wristR.y+(body.hipR.y-body.hipC.y)/2);
    arm.drawArm();
    break;

  case 2:
    //右手抜く
    arm.wristL.setPos(body.hipR.x-(body.hipC.x-body.hipL.x)/2, arm.elbowL.y+(body.hipL.y-body.hipC.y));
    arm.handL.setPos(arm.wristL.x+(body.hipC.x-body.hipL.x), arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.wristR.setPos(body.shoulderR.x-(body.hipC.x-body.hipR.x), arm.elbowR.y-(body.hipC.y-body.spine.y));
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipR.x), arm.wristR.y-(body.hipR.y-body.hipC.y)/2);
    arm.drawArm();
    break;
  }
}

//腰紐
void dummyBand(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%6) {
  case 0:
    //紐を取ってもう片方の手に渡す
    arm.wristL.setPos(body.hipR.x-(body.hipR.x-body.hipC.x)/2, arm.elbowL.y+(body.hipL.y-body.hipC.y));
    arm.handL.setPos(arm.wristL.x+(body.hipR.x-body.hipC.x), arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.hipR.x+(body.hipC.x-body.hipL.x), body.hipC.y);
    arm.handR.setPos(arm.wristR.x-(body.hipR.x-body.hipC.x), arm.wristR.y);
    arm.drawArm();
    break;

  case 1:
    //前に当てる
    drawBandLine(body);
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x), body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.hipL.x-(body.hipC.x-body.hipL.x), body.hipC.y-(body.hipL.y-body.hipC.y)/3);
    arm.handL.setPos(arm.wristL.x, body.hipC.y+(body.hipL.y-body.hipC.y)/3);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.hipR.x+(body.hipR.x-body.hipC.x), body.hipC.y-(body.hipR.y-body.hipC.y)/3);
    arm.handR.setPos(arm.wristR.x, body.hipC.y+(body.hipR.y-body.hipC.y)/3);
    arm.drawArm();
    break;

  case 2:
    //後ろで交差
    arm.elbowL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.hipC.x-(body.hipC.x-body.hipL.x)/2, body.hipC.y);
    arm.handL.setPos(arm.wristL.x+(body.hipC.x-body.hipL.x)/2, arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.hipC.x+(body.hipR.x-body.hipC.x)/2, body.hipC.y);
    arm.handR.setPos(arm.wristR.x-(body.hipR.x-body.hipC.x)/2, arm.wristR.y+(body.hipR.y-body.hipC.y)/2);
    arm.drawArm();
    drawBandLine(body);
    break;

  case 3:
    //締める
    drawBandLine(body);
    arm.elbowL.setPos(body.shoulderL.x, body.spine.y);
    arm.wristL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x), body.hipC.y);
    arm.handL.setPos(arm.wristL.x-(body.hipC.x-body.hipL.x), arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.elbowR.setPos(body.shoulderR.x, body.spine.y);
    arm.wristR.setPos(body.shoulderR.x-(body.hipC.x-body.hipR.x), body.hipC.y);
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipR.x), arm.wristR.y+(body.hipR.y-body.hipC.y)/2);
    arm.drawArm();
    break;

  case 4:
    //前で結ぶ（少し右寄り）
    drawBandLine(body);
    arm.elbowL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.hipR.x-(body.hipR.x-body.hipC.x), arm.elbowL.y+(body.hipL.y-body.hipC.y));
    arm.handL.setPos(arm.wristL.x+(body.hipR.x-body.hipC.x), arm.wristL.y+(body.hipL.y-body.hipC.y)/2);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.hipR.x+(body.hipC.x-body.hipL.x), body.hipC.y);
    arm.handR.setPos(arm.wristR.x-(body.hipR.x-body.hipC.x), arm.wristR.y);
    arm.drawArm();
    break;
  }
}

//おはしょり
void dummyOhashori(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%3) {
  case 0:
    //真ん中へんから
    arm.elbowL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x), body.spine.y-(body.hipL.y-body.spine.y)/3);
    arm.wristL.setPos(body.hipL.x, body.hipC.y);
    arm.handL.setPos(body.hipC.x-(body.hipC.x-body.hipL.x)/3, arm.wristL.y);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipR.x-body.hipC.x), body.spine.y-(body.hipR.y-body.spine.y)/3);
    arm.wristR.setPos(body.hipR.x, body.hipC.y);
    arm.handR.setPos(body.hipC.x+(body.hipR.x-body.hipC.x)/3, arm.wristR.y);
    arm.drawArm();
    break;

  case 1:
    //外側へ
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x), body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.hipL.x-(body.hipC.x-body.hipL.x), body.hipC.y);
    arm.handL.setPos(body.hipL.x, arm.wristL.y);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.hipR.x+(body.hipR.x-body.hipC.x), body.hipC.y);
    arm.handR.setPos(body.hipR.x, arm.wristR.y);
    arm.drawArm();
    break;
  }
}

//衿（右）
void dummyCollarR(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%3) {
  case 0:
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x), body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.hipL.x-(body.hipC.x-body.hipL.x), body.hipC.y+(body.hipL.y-body.hipC.y)/3);
    arm.handL.setPos(body.hipL.x, arm.wristL.y);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipR.y-body.hipC.y));
    arm.wristR.setPos(body.shoulderC.x+(body.shoulderR.x-body.shoulderC.x)/4, body.shoulderR.y);
    arm.handR.setPos(body.shoulderC.x, (body.shoulderR.y+body.shoulderC.y)/2);
    arm.drawArm();
    break;

  case 1:
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x), body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.hipL.x-(body.hipC.x-body.hipL.x), body.hipC.y+(body.hipL.y-body.hipC.y)/3);
    arm.handL.setPos(body.hipL.x, arm.wristL.y);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipR.y-body.hipC.y));
    arm.wristR.setPos(body.shoulderC.x, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.handR.setPos((body.shoulderL.x+body.shoulderC.x)/2, (body.shoulderL.y+body.spine.y)/2);
    arm.drawArm();
    break;
  }
}

//衿（左）
void dummyCollarL(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%3) {
  case 0:
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipL.y-body.hipC.y));
    arm.wristL.setPos(body.shoulderC.x-(body.shoulderC.x-body.shoulderL.x)/4, body.shoulderL.y);
    arm.handL.setPos(body.shoulderC.x, (body.shoulderC.y+body.shoulderL.y)/2);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.shoulderR.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handR.setPos((body.shoulderR.x+body.shoulderC.x)/2, (body.shoulderR.y+body.spine.y)/2);
    arm.drawArm();
    break;

  case 1:
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipL.y-body.hipC.y));
    arm.wristL.setPos(body.shoulderC.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handL.setPos((body.shoulderR.x+body.shoulderC.x)/2, (body.shoulderR.y+body.spine.y)/2);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.hipR.x+(body.hipR.x-body.hipC.x), body.hipC.y);
    arm.handR.setPos(body.hipR.x, arm.wristR.y);
    arm.drawArm();
    break;
  }
}

//胸紐
void dummyUpperBand(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%6) {
  case 0:
    //紐を取ってもう片方の手に渡す
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipL.y-body.hipC.y));
    arm.wristL.setPos(body.shoulderC.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handL.setPos((body.shoulderR.x+body.shoulderC.x)/2, arm.wristL.y);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.shoulderR.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handR.setPos(body.shoulderR.x-(body.shoulderR.x-body.shoulderC.x)/3, (body.shoulderR.y+body.spine.y)/2);
    arm.drawArm();
    break;

  case 1:
    //前に当てる
    drawUpperBandLine(body);
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x), body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.shoulderL.x, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.handL.setPos(body.shoulderL.x+(body.shoulderC.x-body.shoulderL.x)/3, (body.shoulderL.y+body.spine.y)/2);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.shoulderR.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handR.setPos(body.shoulderR.x-(body.shoulderR.x-body.shoulderC.x)/3, (body.shoulderR.y+body.spine.y)/2);
    arm.drawArm();
    break;

  case 2:
    //後ろで交差
    arm.elbowL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipL.y-body.spine.y)/3);
    arm.wristL.setPos(body.hipC.x-(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.handL.setPos(arm.wristL.x+(body.hipR.x-body.hipL.x)/3, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipR.y-body.spine.y)/3);
    arm.wristR.setPos(body.hipC.x+(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.handR.setPos(arm.wristR.x-(body.hipR.x-body.hipL.x)/3, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.drawArm();
    drawUpperBandLine(body);
    break;

  case 3:
    //締める
    drawUpperBandLine(body);
    arm.elbowL.setPos(body.shoulderL.x, body.spine.y);
    arm.wristL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x), body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.handL.setPos(arm.wristL.x-(body.hipC.x-body.hipL.x), arm.wristL.y+(body.shoulderL.y-body.shoulderC.y)/3);
    arm.elbowR.setPos(body.shoulderR.x, body.spine.y);
    arm.wristR.setPos(body.shoulderR.x-(body.hipC.x-body.hipR.x), body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipR.x), arm.wristR.y+(body.shoulderR.y-body.shoulderC.y)/3);
    arm.drawArm();
    break;

  case 4:
    //前で結ぶ（少し右寄り）
    drawUpperBandLine(body);
    arm.elbowL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.hipR.x-(body.hipR.x-body.hipC.x), arm.elbowL.y-(body.shoulderL.y-body.shoulderC.y)/2);
    arm.handL.setPos(arm.wristL.x+(body.hipR.x-body.hipC.x), arm.wristL.y+(body.shoulderL.y-body.shoulderC.y)/3);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.hipR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handR.setPos(arm.wristR.x-(body.hipR.x-body.hipC.x), arm.wristR.y);
    arm.drawArm();
    break;
  }
}

void dummyWrinkle(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%3) {
  case 0:
    //真ん中へんから
    arm.elbowL.setPos(body.shoulderL.x-(body.shoulderC.x-body.shoulderL.x)/3, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.wristL.setPos(body.hipC.x-(body.shoulderC.x-body.shoulderL.x)/2, body.spine.y-(body.hipL.y-body.spine.y)/3);
    arm.handL.setPos(arm.wristL.x, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.elbowR.setPos(body.shoulderR.x+(body.shoulderR.x-body.shoulderC.x)/3, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.wristR.setPos(body.hipC.x+(body.shoulderR.x-body.shoulderC.x)/3, body.spine.y-(body.hipR.y-body.spine.y)/3);
    arm.handR.setPos(arm.wristR.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.drawArm();
    drawUpperBandLine(body);
    break;

  case 1:
    //外側へ
    arm.elbowL.setPos(body.shoulderL.x-(body.shoulderR.x-body.shoulderL.x)/3, body.spine.y-(body.spine.y-body.shoulderL.y)/2);
    arm.wristL.setPos(body.shoulderL.x, body.spine.y-(body.hipL.y-body.spine.y)/3);
    arm.handL.setPos(body.shoulderL.x+(body.hipC.x-body.hipL.x)/3, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.elbowR.setPos(body.shoulderR.x+(body.shoulderR.x-body.shoulderL.x)/3, body.spine.y-(body.spine.y-body.shoulderR.y)/2);
    arm.wristR.setPos(body.shoulderR.x, body.spine.y-(body.hipR.y-body.spine.y)/3);
    arm.handR.setPos(body.shoulderR.x-(body.hipR.x-body.hipC.x)/3, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.drawArm();
    drawUpperBandLine(body);
    break;
  }
}

void dummyDatejime(DummyArm arm, int n) {
  KinectBody body = arm.body;
  switch(n%6) {
  case 0:
    //伊達締めを取ってもう片方の手に渡す
    arm.elbowL.setPos(body.shoulderL.x, body.spine.y-(body.hipL.y-body.hipC.y));
    arm.wristL.setPos(body.shoulderC.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handL.setPos((body.shoulderR.x+body.shoulderC.x)/2, arm.wristL.y+(body.shoulderL.y-body.shoulderC.y)/4);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.shoulderR.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handR.setPos(body.shoulderR.x-(body.shoulderR.x-body.shoulderC.x)/3, arm.wristR.y+(body.shoulderR.y-body.shoulderC.y)/3);
    arm.drawArm();
    break;

  case 1:
    //前に当てる
    drawDatejimeLine(body);
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x), body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.shoulderL.x, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.handL.setPos(body.shoulderL.x+(body.shoulderC.x-body.shoulderL.x)/3, arm.wristL.y+(body.shoulderL.y-body.shoulderC.y)/3);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipC.x-body.hipL.x), body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.shoulderR.x, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.handR.setPos(body.shoulderR.x-(body.shoulderR.x-body.shoulderC.x)/3, arm.wristR.y+(body.shoulderR.y-body.shoulderC.y)/3);
    arm.drawArm();
    break;

  case 2:
    //後ろで交差
    arm.elbowL.setPos(body.shoulderL.x-(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipL.y-body.spine.y)/3);
    arm.wristL.setPos(body.hipC.x-(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.hipR.y-body.spine.y)/3);
    arm.handL.setPos(arm.wristL.x+(body.hipC.x-body.hipL.x)/2, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.elbowR.setPos(body.shoulderR.x+(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipR.y-body.spine.y)/3);
    arm.wristR.setPos(body.hipC.x+(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipR.y-body.spine.y)/3);
    arm.handR.setPos(arm.wristR.x-(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.spine.y-body.shoulderR.y)/3);
    arm.drawArm();
    drawDatejimeLine(body);
    break;

  case 3:
    //締める
    dummyUpperBand(arm, 3);
    drawDatejimeLine(body);
    break;

  case 4:
    //前で結ぶ（少し左寄り）
    drawDatejimeLine(body);
    arm.elbowL.setPos(body.shoulderL.x-(body.hipR.x-body.hipC.x), body.spine.y-(body.hipL.y-body.spine.y)/2);
    arm.wristL.setPos(body.shoulderL.x, body.spine.y-(body.spine.y-body.shoulderL.y)/3);
    arm.handL.setPos(body.shoulderL.x+(body.shoulderC.x-body.shoulderL.x)/3, arm.wristL.y+(body.shoulderL.y-body.shoulderC.y)/3);
    arm.elbowR.setPos(body.shoulderR.x-(body.hipR.x-body.hipC.x)/2, body.spine.y-(body.hipR.y-body.spine.y)/2);
    arm.wristR.setPos(body.hipL.x+(body.hipC.x-body.hipL.x), arm.elbowR.y-(body.shoulderR.y-body.shoulderC.y)/3);
    arm.handR.setPos(arm.wristR.x-(body.hipC.x-body.hipL.x), arm.wristR.y+(body.shoulderR.y-body.shoulderC.y)/3);
    arm.drawArm();
    break;
  }
}