class KinectBody {
  KinectJoint head, shoulderC, shoulderL, shoulderR;
  KinectJoint spine, hipC, hipL, hipR;
  KinectJoint elbowL, elbowR, wristL, wristR, handL, handR;
  KinectJoint kneeL, kneeR, ankleL, ankleR, footL, footR;
  SkeletonData sk;

  KinectBody(SkeletonData _s) {
    sk = _s;
    position();
  }

  void position() {
    head = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_HEAD);
    shoulderC = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER);
    shoulderL = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT);
    shoulderR = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT);
    spine = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_SPINE);
    hipC = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_HIP_CENTER);
    hipL = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_HIP_LEFT);
    hipR = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);
    elbowL = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT);
    elbowR = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT);
    wristL = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_WRIST_LEFT);
    wristR = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT);
    handL = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_HAND_LEFT);
    handR = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);
    kneeL = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_KNEE_LEFT);
    kneeR = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT);
    ankleL = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT);
    ankleR = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT);
    footL = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_FOOT_LEFT);
    footR = new KinectJoint(sk, Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT);
  }

  void drawBody() {
    //胴体
    drawBone(head, shoulderC);
    drawBone(shoulderC, shoulderL);
    drawBone(shoulderC, shoulderR);
    drawBone(shoulderC, spine);
    drawBone(shoulderL, spine);
    drawBone(shoulderR, spine);
    drawBone(spine, hipC);
    drawBone(hipC, hipL);
    drawBone(hipC, hipR);
    drawBone(hipL, hipR);

    /* //左腕
     drawBone(shoulderL, elbowL);
     drawBone(elbowL, wristL);
     drawBone(wristL, handL);
     
     //右腕
     drawBone(shoulderR, elbowR);
     drawBone(elbowR, wristR);
     drawBone(wristR, handR);*/

    //左脚
    drawBone(hipL, kneeL);
    drawBone(kneeL, ankleL);
    drawBone(ankleL, footL);

    //右脚
    drawBone(hipR, kneeR);
    drawBone(kneeR, ankleR);
    drawBone(ankleR, footR);
  }

  void drawBone(KinectJoint j1, KinectJoint j2) {
    noFill();
    stroke(255, 255, 0);
    if (j1.isTrackable() && j2.isTrackable()) {
      line(j1.x, j1.y, j2.x, j2.y);
    }
  }
}

class KinectJoint {
  int pos;
  float x, y;
  SkeletonData skd;
  KinectJoint(SkeletonData sk, int _j) {
    pos = _j;
    x = sk.skeletonPositions[_j].x*width/2;
    y = sk.skeletonPositions[_j].y*height;
    skd = sk;
  }

  boolean isTrackable() {
    if (skd.skeletonPositionTrackingState[pos] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
      return true;
    }
    return false;
  }
}