Controller controller;

void setup(){
  size(400,400);
  controller = new Controller();
  noLoop();
}

void draw(){
  background(255);
  textSize(12);
  fill(0, 102, 153);
  textAlign(CENTER,CENTER);
  text("California", width/2, height/2-30);
  text("Fires", width/2, height/2-15);
  text("Visualization", width/2, height/2);
  text("by", width/2, height/2+15);
  text("Kay Ayala", width/2, height/2+30);
}
