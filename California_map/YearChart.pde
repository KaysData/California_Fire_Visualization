class YearChart extends PApplet{ // 'Year Chart' view

  // Attributes/Fields/Properties
  String title = "Fires by Year and Cause";
  int cause;
  int ySpace = 30;
  int yStart = 200;
  float[] clickLocation = new float[2];
  int yearSelected = 18; //default year is 2018
  String[] yAxis = {"20", "40", "60", "80", "100"};
  String[] years = {"2000", "2001", "2002", "2003", "2004", "2005", 
                    "2006", "2007", "2008", "2009", "2010", "2011",
                    "2012", "2013", "2014", "2015", "2016", "2017", 
                    "2018" };
                    
  int[] firesByYearForGivenCause = {30, 10, 10, 10, 10, 10, 
                       10, 10, 10, 10, 10, 10,
                       10, 10, 10, 10, 10, 10, 
                       10};
   String[] causes = {"Lightning", "Equipment Use", "Smoking",
                    "Campfires", "Debris", "Railroads", "Arson",
                    "Playing with Fire", "Miscellaneous", "Vehicles", 
                    "Power Lines", "Firefighter Training", 
                    "Non-Firefighter Training", "Unknown Source", 
                    "Structures", "Aircraft", "Volcanic Activity", 
                    "Escaped Prescribed Burns", "Illegal Alien Campfires", "All Sources"};
  
  // Constructors
  // Default Contructor
  YearChart(){
    cause = 1;
    setFiresForGivenCause(firesByYearForGivenCause, cause);
    redraw();
  }
  
  // Accessors/Mutators/Getters/Setters
  
  int getYearSelected(){
    return yearSelected;
  }
  
  void updateYAxis() {
    int maxValue=round20(getMax(firesByYearForGivenCause));
    int minValue = 20;
    if(maxValue==0){
      maxValue = 10;
      minValue = 2;
    }
    for(int i = 0; i<5; i++){
      int k = (int)(map(i,0,4, minValue, maxValue));
      yAxis[i] = String.format("%d",k);
   }
  }
  
  void updateTitleCause(String cause){
    title = String.format("CA Fires Caused by %s by Year", cause);
  }
  
  void updateTitleForAllCauses(){
    title = String.format("CA Fires by Year");
  }
  
  void setFiresForGivenCause(int[] newfiresByYearForGivenCause, int cause){
    firesByYearForGivenCause = newfiresByYearForGivenCause;
    updateYAxis();
    if(!(cause==19)){
    updateTitleCause(causes[cause]);
    } else {updateTitleForAllCauses();}
    redraw();
  }
  
  // Methods
  public void settings() {
   size(580,320);
   noLoop();
  }
  
  void draw(){
    background(255); 
    drawXTitle(); //draws x axis title
    drawXAxisAndData(); // draws x axis and boxplot bars
    drawYAxisTitle(); //y axis title 
    drawYAxis(); //draws y axis 
    drawTitle(); //draws title

  }
  
  void drawTitle(){
    // Title text
    textSize(18);
    fill(0, 102, 153);
    textAlign(CENTER);
    text(title, 300, 60);
  }
  
  void drawYAxis(){
    //draws y axis 
    for(int i = 0; i<5; i++){
      stroke(180);
      line(100, yStart-ySpace*i, 500, yStart-ySpace*i);
      //stroke(0);
      //line(100, yStart-ySpace*i, 110, yStart-ySpace*i);
      textSize(12);
      fill(0, 102, 153);
      textAlign(RIGHT);
      text(yAxis[i], 92, yStart-ySpace*i+5);
    }
  }
  
  void drawXTitle(){
    // x axis title
    pushMatrix();
      translate(50,145);
      rotate(-PI/2);
      textAlign(CENTER);
      textSize(14);
      fill(0, 102, 153);
      text("Number of Fires",0,0);
    popMatrix();
  }
  
  void drawXAxisAndData(){
    // draws x axis and boxplot bars
    stroke(0);
    line(100, 230, 500, 230);
    int maxValue = round20(getMax(firesByYearForGivenCause));
    if(maxValue == 0){
      maxValue = 10;
    }
    
    for(int i = 0; i<19; i++){
      float j = map(i, 0, 18, 130, 475); 
      float k = map(firesByYearForGivenCause[i], 0, maxValue, 230, 80);  
      
      pushMatrix(); // allow for translation and rotation to be removed later
        translate(j-6, 254); // move text to starting location
        rotate(315*PI/180); // rotation text
        textSize(12);
        fill(0, 102, 153);
        text(years[i], 0, 0); // writes year the character
      popMatrix(); // remove translation and rotation
      
      
      if(i==yearSelected){
        fill(100,150,255,150);
      } else{ fill(0, 102, 153, 150); }
      if(yearSelected == 19){
        fill(100,150,255,150);
      }
      noStroke();
      rectMode(CORNERS);
      rect(j-6, k, j+6, 230);
    }
  }
  
  void drawYAxisTitle(){
    //y axis title 
    textSize(14);
    fill(0, 102, 153);
    textAlign(CENTER);
    text("Years",300,290);
  }

  public int getMax(int[] list){
    int max = -100;
    for(int i=0; i<list.length; i++){
        if(list[i] > max){
            max = list[i];
        }
    }
    return max;
  }
   
  int round20(int i){
    return round((float)(i)/20) * 20;
  } 
  
  void mouseClicked() {
    this.clickLocation[0] = pmouseX;
    this.clickLocation[1] = pmouseY;
    userSelectYear();
    controller.respondToUserInputInYearChart(yearSelected);//takes 0 through 18 (ie. 2000->2018)
  }// end of mouseClicked
  
  void userSelectYear(){

    if(clickLocation[1]>64 && clickLocation[1]<230){
      if(clickLocation[0]>101 && clickLocation[0]<490){
        
        //finds which year selected
        int loc0=120;
        for(int i=0; i<19; i++){
          if(clickLocation[0]>(loc0+(19*i)) && clickLocation[0]<(loc0+(19*(i+1))) ){
            yearSelected = i;
          }
        }
        
      } 
    } 
    
  } //end of userSelectYear
  
  
}//  End of Object/EOF
