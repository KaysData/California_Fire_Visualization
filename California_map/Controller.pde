class Controller{

  // Attributes/Fields/Properties
  int cause = 10; 
  int year = 18; //defaults to 2018
  int yearForModel = 2018; //defaults to 2000
  PImage map;
  Model model = new Model();
  
  FireMap firemap = new FireMap();
  String[] firemapName = {"Fire Center Points Map"};
  
  CausesChart causesChart = new CausesChart();
  String[] causesChartName = {"Causes of Fires"};
  
  YearChart yearChart = new YearChart();
  String[] yearChartName = {"Fires per year by cause"};
  
  // Constructors
  Controller() {
    setYearForModel();
    map = model.getMap(cause, yearForModel); // getMap(int causeNum, int year)
    firemap.setMap(map);
    firemap.setYear(year);
    PApplet.runSketch(firemapName, firemap);
    
    float[] firesByPercentCauseInGivenYear = model.getFiresByPercentCauseForGivenYear(year);
    causesChart.updateCausesChart(firesByPercentCauseInGivenYear, year);
    PApplet.runSketch(causesChartName, causesChart);

    respondToUserInputInYearChart(year);
    PApplet.runSketch(yearChartName, yearChart);
  }
  
  // Accessors/Mutators/Getters/Setters
    void setYearForModel(){
      yearForModel = 2000+ year;
  }
  
  // Methods
  
  //if user interacts with year chart update fire map and causes chart
  void respondToUserInputInYearChart(int newYear){ //takes 0 through 18 (ie. 2000->2018)
    year = newYear;
    int[] newfiresByGivenCause = model.getFiresByYearForGivenCause(cause);
    yearChart.setFiresForGivenCause(newfiresByGivenCause, cause);
    setYearForModel();
    map = model.getMap(cause, yearForModel);
    //firemap.setMap(map);
    //firemap.setYear(year);
    firemap.updateFireMap(map, year, cause);
    float[] firesByPercentCauseInGivenYear = model.getFiresByPercentCauseForGivenYear(year);
    causesChart.updateCausesChart(firesByPercentCauseInGivenYear, year);
  }
  
  void respondToUserInputInCausesChart(int newCause){
    cause=newCause;
    int[] newfiresByGivenCause = model.getFiresByYearForGivenCause(cause);
    yearChart.setFiresForGivenCause( newfiresByGivenCause, cause);
    map = model.getMap(cause, yearForModel);
    //firemap.setMap(map);
    firemap.updateFireMap(map, year, cause);
  }




}
