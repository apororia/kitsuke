void drawPosition(SkeletonData _s) {
  noStroke();
  fill(0, 100, 255);
  String s1 = str(_s.dwTrackingID);
  text(s1, _s.position.x*width/2, _s.position.y*height);
}

void appearEvent(SkeletonData _s) {
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) {
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a) {
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}

//----------------------------------------------------------

void drawBody(KinectBody b) {
  //胴体
  drawBone(b.head, b.shoulderC);
  drawBone(b.shoulderC, b.shoulderL);
  drawBone(b.shoulderC, b.shoulderR);
  drawBone(b.shoulderC, b.spine);
  drawBone(b.shoulderL, b.spine);
  drawBone(b.shoulderR, b.spine);
  drawBone(b.spine, b.hipC);
  drawBone(b.hipC, b.hipL);
  drawBone(b.hipC, b.hipR);
  drawBone(b.hipL, b.hipR);

  //左腕
  drawBone(b.shoulderL, b.elbowL);
  drawBone(b.elbowL, b.wristL);
  drawBone(b.wristL, b.handL);

  //右腕
  drawBone(b.shoulderR, b.elbowR);
  drawBone(b.elbowR, b.wristR);
  drawBone(b.wristR, b.handR);

  //左脚
  drawBone(b.hipL, b.kneeL);
  drawBone(b.kneeL, b.ankleL);
  drawBone(b.ankleL, b.footL);

  //右脚
  drawBone(b.hipR, b.kneeR);
  drawBone(b.kneeR, b.ankleR);
  drawBone(b.ankleR, b.footR);
}

void drawBone(KinectJoint j1, KinectJoint j2) {
  noFill();
  stroke(255, 255, 0);
  if (j1.isTrackable() && j2.isTrackable()) {
    line(j1.x, j1.y, j2.x, j2.y);
  }
}