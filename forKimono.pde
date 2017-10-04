
void juban() {
  initList();
  step.add("羽織る");
  step.add("衣紋");
  step.add("衿（右）");
  step.add("衿（左）");
  step.add("ひも");
  step.add("しわ取り");
  step.add("伊達締め");
}

void kimono() {
  initList();

  //ステップを用意
  step.add("羽織る");
  step.add("すそ");
  step.add("前合わせ（左）");
  step.add("前合わせ（右）");
  step.add("前合わせ（再度左）");
  step.add("腰ひも");
  step.add("おはしょり");
  step.add("衿（右）");
  step.add("衿（左）");
  step.add("胸ひも");
  step.add("しわ取り");
  step.add("伊達締め");

  //画像をリストに入れる
  for (int i=0; i<step.size(); i++) {
    PImage img = loadImage("kimono"+(i+1)+".png");
    stepImg.add(img);
  }
  //説明文をリストに入れる
  String [] str = loadStrings("kimono_howto.txt");
  prepareStr(str);
}

//----------------------------------------------

void prepareStr(String [] s) {
  //最初の1行は空行なのでi=1から
  for (int i=1; i<s.length; i++) {
    //スラッシュを改行に置換、リストに追加
    stepStr.add(s[i].replace("/", "\n"));
  }
}

//-----------------------------------------------

void initList() {
  step.clear();
  stepImg.clear();
  stepStr.clear();
}