class KinectBody {
  KinectJoint head, shoulderC, shoulderL, shoulderR;
  KinectJoint spine, hipC, hipL, hipR;
  KinectJoint elbowL, elbowR, wristL, wristR, handL, handR;
  KinectJoint kneeL, kneeR, ankleL, ankleR, footL, footR;
  SkeletonData sk;

  KinectBody(SkeletonData _s) {
    head = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_HEAD);
    shoulderC = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER);
    shoulderL = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT);
    shoulderR = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT);
    spine = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_SPINE);
    hipC = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_HIP_CENTER);
    hipL = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_HIP_LEFT);
    hipR = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);
    elbowL = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT);
    elbowR = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT);
    wristL = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_WRIST_LEFT);
    wristR = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT);
    handL = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_HAND_LEFT);
    handR = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);
    kneeL = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_KNEE_LEFT);
    kneeR = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT);
    ankleL = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT);
    ankleR = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT);
    footL = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_FOOT_LEFT);
    footR = new KinectJoint(_s, Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT);
    sk = _s;
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