class DummyArm {
  DummyJoint shoulderL, elbowL, wristL, handL;
  DummyJoint shoulderR, elbowR, wristR, handR;
  KinectBody body;
  
  DummyArm(KinectBody _body) {
    body = _body;
    shoulderL = new DummyJoint(body.shoulderL.x, body.shoulderL.y);
    shoulderR = new DummyJoint(body.shoulderR.x, body.shoulderR.y);
    elbowL = new DummyJoint(0, 0);
    elbowR = new DummyJoint(0, 0);
    wristL = new DummyJoint(0, 0);
    wristR = new DummyJoint(0, 0);
    handL = new DummyJoint(0, 0);
    handR = new DummyJoint(0, 0);
  }

  void drawArm() {
    //左腕
    drawBone(shoulderL, elbowL);
    drawBone(elbowL, wristL);
    drawBone(wristL, handL);

    //右腕
    drawBone(shoulderR, elbowR);
    drawBone(elbowR, wristR);
    drawBone(wristR, handR);
  }

  void drawBone(DummyJoint j1, DummyJoint j2) {
    noFill();
    stroke(255, 0, 255);
    strokeWeight(2);
    line(j1.x, j1.y, j2.x, j2.y);
  }

  void sample() {
    elbowL.setPos(body.spine.x-(body.shoulderC.x-body.shoulderL.x), body.spine.y);
    wristL.setPos(body.hipL.x-(body.hipC.x-body.hipL.x), body.hipL.y);
    handL.setPos(wristL.x, wristL.y+(body.hipR.y-body.hipC.y));
    elbowR.setPos(body.spine.x-(body.shoulderC.x-body.shoulderR.x), body.spine.y);
    wristR.setPos(body.hipR.x-(body.hipC.x-body.hipR.x), body.hipR.y);
    handR.setPos(wristR.x, wristR.y+(body.hipR.y-body.hipC.y));
  }
}