class CausesChart extends PApplet{ // 'Causes Chart' View

  // Attributes/Fields/Properties
  String title = "Fires by Year and Cause";
  int year;
  int[] red = new int[19];
  int[] green = new int[19];
  int[] blue = new int[19];
  float[] clickLocation = new float[2];
  int causeSelected = 18; //default cause is 10 // this is powerline
  float[] thetas= new float[20];
  String[] causeTitles = new String[19];
  java.awt.Polygon[] polygons = new java.awt.Polygon[19];
  String[] years = {"2000", "2001", "2002", "2003", "2004", "2005", 
                    "2006", "2007", "2008", "2009", "2010", "2011",
                    "2012", "2013", "2014", "2015", "2016", "2017", 
                    "2018" };
                    
  float[] firesbyPercentCauseForGivenYear = {0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895, 
                       0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895,
                       0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895, 0.05263157895, 
                       0.05263157895};
                       
   String[] causes = {"Lightning", "Equipment Use", "Smoking",
                    "Campfires", "Debris", "Railroads", "Arson",
                    "Playing with Fire", "Miscellaneous", "Vehicles", 
                    "Power Lines", "Firefighter Training", 
                    "Non-Firefighter Training", "Unknown Source", 
                    "Structures", "Aircraft", "Volcanic Activity", 
                    "Escaped Prescribed Burns", "Illegal Alien Campfires", "All Sources"};
  
  // Constructors
  // Default Contructor
  CausesChart(){
    causeSelected = 10;
    year = 18;
    setFiresForGivenYear(firesbyPercentCauseForGivenYear);
    if(!(year==19)){
      updateTitleYear(year);
    } else {updateTitleForAllYears();}
    makeColorGradient();
    makeThetas();
    makePolygons();
    makeCauseTitles();
  }
  
  // Accessors/Mutators/Getters/Setters
  
  void updateCausesChart(float[] newFiresByCauseForGivenYear, int newYear){
    setFiresForGivenYear(newFiresByCauseForGivenYear);
    year = newYear;
    if(!(year==19)){
      updateTitleYear(year);
    } else {updateTitleForAllYears();}
    makeThetas();
    makeCauseTitles();
    drawCausesChart();
  }
  
  int getCauseSelected(){
    return causeSelected;
  }
  
  void updateTitleYear(int year){
    title = String.format("CA Fires in %s by Percent Cause", years[year]);
  }
  
  void updateTitleForAllYears(){
    title = String.format("CA Fires for All Years by Percent Cause");
  }
  
  void setFiresForGivenYear(float[] newPercentCauseForGivenYear){
    firesbyPercentCauseForGivenYear = newPercentCauseForGivenYear;
  }
  
  // Methods
  public void settings() {
   size(700,700);
   noLoop();
  }
  
  void draw(){
    background(255); 
    drawDataCircleAndLabels(); 
    drawTitle();
  }
  
  void drawCausesChart(){
    redraw();
  }
  
  void drawTitle(){
    // Title text
    textSize(18);
    fill(0, 102, 153);
    textAlign(CENTER);
    text(title, width/2, 60);
  }
  
  void drawDataCircleAndLabels(){
    makePolygons();
    float currentArcStartRadians; 
    float currentArc;
    float circleRadius = 200;
    int previousValidI = -1;
    int secondPreviousValidI = -1;
    int thirdPreviousValidI = -1;
    for(int i = 0; i<19; i++){
      if(firesbyPercentCauseForGivenYear[i] != 0){
        
        currentArc = percentToRadians(firesbyPercentCauseForGivenYear[i]); 
        currentArcStartRadians = thetas[i];

        pushMatrix();
          translate(width/2, (height/2));
          rotate(currentArcStartRadians);
          
          if(i==causeSelected){
            fill(100,150,255,100);
            noStroke();
            arc(0, 0, 220, 220, 0, currentArc);
          } else{ fill(red[i],green[i],blue[i],200); }
          
          noStroke();
          arc(0, 0, circleRadius, circleRadius, 0, currentArc);
          drawLabels(i, previousValidI, secondPreviousValidI, thirdPreviousValidI);
        popMatrix();
        thirdPreviousValidI = secondPreviousValidI;
        secondPreviousValidI = previousValidI;
        previousValidI = i;
      }
    }
    fill(255,255,255);
    circle(width/2, (height/2), 125);
      
    /*

      */
  }
  
  void drawLabels(int i, int previousI, int secondPreviousI, int thirdPreviousI){
    
      float sectionStartAngle = thetas[i];
      float sectionSize = percentToRadians(firesbyPercentCauseForGivenYear[i]);
      float currentLabelPosition = sectionStartAngle + sectionSize/2;
      float radians = -currentLabelPosition;
      int textJusification = CENTER;
      float x1= 115;
      float y1= 0;
      float x2 =20;
      float y2 = 0;
      
      rotate(sectionSize/2);
      pushMatrix();
      
        translate(x1,y1);
        if(firesbyPercentCauseForGivenYear[i]<0.04){
            if( previousI != -1 &&
               firesbyPercentCauseForGivenYear[previousI]<0.01 && 
               firesbyPercentCauseForGivenYear[i]<0.3 
               ){
               y2 = 10;
               if(firesbyPercentCauseForGivenYear[secondPreviousI]<0.03 && secondPreviousI != -1){
                 y2 = 20;
                 if(firesbyPercentCauseForGivenYear[thirdPreviousI]<0.03 && thirdPreviousI != -1 ){
                   y2 = 30;
                }
              }
            }
          stroke(40);
          line(0,0,10,0);
          noStroke();
          translate(x2,y2);
        }
  
        textSize(12);
        fill(0, 102, 153);
        if( currentLabelPosition >= 0 && currentLabelPosition<(PI/2) ){
          radians = radians+(currentLabelPosition);
          textJusification=LEFT;
        } else if( currentLabelPosition >= (PI/2) && currentLabelPosition<(PI) ){
          radians = radians+ (currentLabelPosition-PI);
          textJusification=RIGHT;
        } else if( currentLabelPosition >= (PI) && currentLabelPosition<(3*PI/2) ){
          radians = radians+(currentLabelPosition-PI);
          textJusification=RIGHT;
        } else if( currentLabelPosition >= (3*PI/2)){
          radians = radians+(currentLabelPosition-2*PI);
          textJusification=LEFT;
        }
        rotate(radians);
        textAlign(textJusification);
        text(causeTitles[i], 0,0);
      popMatrix();
    
  }
  
  void makeCauseTitles(){
    float percentFloat;
    for(int i=0; i<19; i++){
      percentFloat = firesbyPercentCauseForGivenYear[i]*100;
      causeTitles[i] = String.format("%s %.1f%%",causes[i],percentFloat);
    }
  
  }
  
  void makeColorGradient(){
    for(int i=0; i<19; i++){
      if(i<9) { // tan gradient
        red[i] = (int) (map(i,0,8,144,220)); 
        green[i] = (int)(map(i,0,8,71,220)); 
        blue[i] = (int) (map(i,0,8,0, 220)); 
      }
      else{ // teal gradient
        red[i] = (int)(map(i,9,18,240,0));
        green[i] = (int)(map(i,9,18,240,96));
        blue[i] = (int)(map(i,9,18,240,85)); 
      }
    }
  }
  
  void makeThetas(){
    float cumulativeAngle=0;
    thetas[0]=0;
    for(int i =0; i<19; i++){
      cumulativeAngle += percentToRadians(firesbyPercentCauseForGivenYear[i]);
      thetas[i+1] = cumulativeAngle;
    }
  }
  
  void makePolygons(){
    int y1, x1, y2, x2, r;
    float theta1, theta2;
    r = 300;
    for(int i=0; i<19; i++){
      
      theta1= thetas[i]; 
      theta2= thetas[i+1];
      
      x1 = (int)(r*cos(theta1)) + width/2;
      y1 = (int)(r*sin(theta1)) + height/2;
      x2 = (int)(r*cos(theta2)) + width/2;
      y2 = (int)(r*sin(theta2)) + height/2;
      if(theta2-theta1>PI/4){
        float halfDistance = (theta2-theta1)/2;
        float theta3 = theta1+halfDistance;
        int x3=(int)(r*cos(theta3)) + width/2;
        int y3=(int)(r*sin(theta3)) + height/2;
        polygons[i] = aPolygon(x1,y1,x2,y2,x3,y3);
      }
      else{
      polygons[i] = aPolygon(x1,y1,x2,y2);
      }
      
    }
  }//end makePolygons
  
  java.awt.Polygon aPolygon(int pointX1, int pointY1, int pointX2, int pointY2){
    java.awt.Polygon p = new java.awt.Polygon();
    p.addPoint(width/2, height/2);
    p.addPoint(pointX1, pointY1);
    p.addPoint(pointX2, pointY2);
    //fill(0,100,200,200);
    //triangle(pointX1, pointY1,pointX2, pointY2,width/2, height/2);
    return p;
    
  }//end aPolygon
  
    java.awt.Polygon aPolygon(int pointX1, int pointY1, int pointX2, int pointY2,
                              int pointX3, int pointY3){
    java.awt.Polygon p = new java.awt.Polygon();
    p.addPoint(width/2, height/2);
    p.addPoint(pointX1, pointY1);
    p.addPoint(pointX3, pointY3);
    p.addPoint(pointX2, pointY2);
    //fill(0,100,200,200);
    //quad(pointX1, pointY1, pointX3, pointY3, pointX2, pointY2,width/2, height/2);
    return p;
    
  }//end aPolygon
  
  float percentToRadians(float percent){
      //float percent = 0.25;
      float radians;
      radians = map(percent, 0,1, 0, 2*PI);
      return radians;
   }
  
  void mouseClicked() {
    this.clickLocation[0] = pmouseX;
    this.clickLocation[1] = pmouseY;
    //println(pmouseX,pmouseY);
    userSelectYear(); //<>//
    //controller.respondToUserInputInYearChart(causeSelected);//takes 0 through 18 (ie. 2000->2018)
  }// end of mouseClicked
  
  void userSelectYear(){
    
    for(int i =0; i<19;i++){
      // check if point is inside
      //println("polygon", i, "contains point", polygons[i].contains(clickLocation[0], clickLocation[1]));
      if(polygons[i].contains(clickLocation[0], clickLocation[1])){
        causeSelected=i;
        //println("Cause Selected", causeSelected);
        redraw(); 
        controller.respondToUserInputInCausesChart(causeSelected);
      }
    }
    
  } //end of userSelectYear
  
  
}//  End of Object/EOF
