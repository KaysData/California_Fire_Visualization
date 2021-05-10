class FireMap extends PApplet{ // 'Firemap' view

  //Attributes/Fields/Properties
  //Controller controller;
  PImage map;
  int year = 18;
  int cause = 10;
  String title;
  float[] imgStartPoint = new float[2];
  String[] years = {"2000", "2001", "2002", "2003", "2004", "2005", 
                    "2006", "2007", "2008", "2009", "2010", "2011",
                    "2012", "2013", "2014", "2015", "2016", "2017", 
                    "2018" };
   String[] causes = {"Lightning", "Equipment Use", "Smoking",
                  "Campfires", "Debris", "Railroads", "Arson",
                  "Playing with Fire", "Miscellaneous", "Vehicles", 
                  "Power Lines", "Firefighter Training", 
                  "Non-Firefighter Training", "Unknown Source", 
                  "Structures", "Aircraft", "Volcanic Activity", 
                  "Escaped Prescribed Burns", "Illegal Alien Campfires", "All Sources"};
  
  //Constructors
  //default
  FireMap(){
    //controller = newController;
      imgStartPoint[0]=30;
      imgStartPoint[1]=-140;
  }
  //Accessors/Mutators/setters/getters
  void updateFireMap(PImage newMap, int newYear, int newCause){
    setMap(newMap);
    setYear(newYear);
    setCause(newCause);
    setTitle();
  }
  
  void setMap(PImage newMap){
    map = newMap;
  }
  
  void setYear(int newYear){
    year = newYear;
    //setTitle();
  }  
  
  void setCause(int newCause){
    cause = newCause;
    //setTitle();
  } 
  
  void setTitle(){
    title = String.format("Center Points of California Fires caused by %s in %s", causes[cause], years[year]);
  }
  
  //Methods
  
  public void settings() {
    size(676,622);//size(263*2+150,286*2+50);
    //this.map = model.getMap();//model.getMap();
  }
  
  void draw(){
    background(255);
    move_map();
    image(this.map, imgStartPoint[0], imgStartPoint[1]);
    drawTitle();
    drawLegend();
    
  }
  
  void move_map(){
    if(mousePressed){
      imgStartPoint = dragMap(imgStartPoint[0],imgStartPoint[1]);
    }
  }
  
  float[] dragMap(float xmin, float ymin){
    float[] points = new float[2];
    points[0] = xmin + mouseX - pmouseX;
    points[1] = ymin + mouseY - pmouseY;
  
    return points;
  }
  
   void drawTitle(){
    // Title text and background box
    fill(255);
    rectMode(CENTER);
    noStroke();
    rect(338,15,678,30);
    textSize(18);
    fill(0, 102, 153);
    textAlign(CENTER);
    text(title, 338, 22);
  }
  
  void drawLegend(){
    //white legend background
    noStroke();
    fill(255);
    rectMode(CORNER);
    rect(0,height-30, width,30);
    
    //legend part 1
    fill(100,150,255);
    rect(10,height-20,10,10);
    textSize(12);
    fill(0, 102, 153);
    textAlign(LEFT,CENTER);
    text(causes[cause], 25, height-15);
    
    //legend part 2 
    fill(200, 90, 20);
    rect((width/2)+10-150,height-20,10,10);
    textSize(12);
    fill(0, 102, 153);
    textAlign(LEFT,CENTER);
    String legend2 = String.format(" All other fires in %s", years[year]);
    text(legend2, (width/2)+25-150, height-15);
    
    
  }
  
}
