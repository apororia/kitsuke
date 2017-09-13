class DummyJoint{
  float x, y;
  DummyJoint(float _x, float _y){
    x = _x;
    y = _y;
  }
  
  void setPos(float _x, float _y){
    x = _x;
    y = _y;
  }
  
  void move(float dx, float dy){
    x += dx;
    y += dy;
  }
}