import java.io.*;
class Model{
  
  // Attributes/Fields/Properties
  PImage vhiImg;  
  PImage finalMap;
  int imgHeight = 285*2*2;
  int imgWidth = 263*2*2;
  HashMap<Integer,PImage> firesHashmap = new HashMap<Integer,PImage>();
  int[][] numFiresByYearCause = new int[19][19];
  float[][] numFiresByYearPercentCause= new float[19][19];
  String[] causes = {"Lightning", "Equipment Use", "Smoking",
                    "Campfire", "Debris", "Railroad", "Arson",
                    "Playing_with_Fire", "Miscellaneous", "Vehicle", 
                    "Power Line", "Firefighter Training", 
                    "Non-Firefighter Training", "Unidentified", 
                    "Structure", "Aircraft", "Volcanic", 
                    "Escaped Prescribed Burn", "Illegal_Alien_Campfire", "all"};
  
  // Constructors
  //default
  Model(){
    this.vhiImg = vhiImageGenerate();
    this.finalMap = vhiImg;
    populateHashmap();
    loadNumFiresByYearCause();
    loadNumFiresByYearPercentCause(); 
  }

  // Accessors/Mutators/Getters/Setters
  // getters 
  float[] getFiresByPercentCauseForGivenYear(int year){
    float[] firesByPercentCauseForYear = new float[19];
    for(int i =0; i<19; i++){
      firesByPercentCauseForYear[i] = numFiresByYearPercentCause[year][i];
    }
    return firesByPercentCauseForYear;
  }
  
  int[] getFiresByYearForGivenCause(int cause){
    int[] firesByYearForGivenCause = new int[19];
    for(int i =0; i<19; i++){
      firesByYearForGivenCause[i] = numFiresByYearCause[i][cause];
    }
    return firesByYearForGivenCause;
  }
  
  PImage getMap(int highlightCauseNum, int year) {
    
    PImage[] layers = new PImage[2];
    PImage map;  
    layers[0] = this.firesHashmap.get(yearCause(highlightCauseNum,  year));
    //return layers[0];
    layers[1] = this.firesHashmap.get(yearCause(19, year));
    //return layers[1];
    map = mergeLayers(layers);
    return map;
  }

  // Methods
  int yearCause(int causeNum, int year){
    String strYearCause = String.format("%d%d", causeNum,  year);
    int yearCause = Integer.parseInt(strYearCause);
    return yearCause;
  }
  
  //fills hashmap with firelayers by cause and year
  void populateHashmap(){
    PImage firelayer;
    
    for(int year=2000; year<2019; year++){
      for(int causeNum=0; causeNum<20; causeNum++){
        
        String filename = String.format("Fire_CSVs/%d/%d_%s_fires.csv", year, year, causes[causeNum]);
        firelayer = getAFiremap(filename);
        this.firesHashmap.put(yearCause(causeNum, year), firelayer);
      }
      
    }
  }
  
  PImage mergeLayers(PImage[] newlayers) {
    //PImage aMap = vhiImg;
    PImage aMap = createImage(imgHeight,imgWidth,ARGB);
    for( int i=0; i<(newlayers[0].height*newlayers[0].width); i++) {  
      aMap.pixels[i] = vhiImg.pixels[i];
      if(newlayers[1].pixels[i] <= color(30)){
        aMap.pixels[i] = color(200,90,20);//color(129,63,11);
      }
      if(newlayers[0].pixels[i] <= color(30)){
        aMap.pixels[i] = color(100,150,255);//color(129,63,11);
      }
    }
    return aMap;
  }
  

  PImage getAFiremap(String filename) {
    Table fireTable;
    //vhiImg.loadPixels();
    PImage fireImg = createImage(284,264, ARGB);
    //fireTable = loadTable("Fire_CSVs/2000/2000_Lightning_fires.csv");
    //fireTable = loadTable("Fire_CSVs/all_fires.csv"); //works
    fireTable = loadTable(filename);
    TableRow row = fireTable.addRow();
    //println(fireTable.getRowCount() + " total rows in table");
    //println(fireTable.getColumnCount() + " total columns in table");
    int indexPixels = 0;
    
    for (int i =0; i<264; i++) { //fireTable.getRowCount()
      row = fireTable.getRow(i);
      for(int j=0; j<284; j++){//fireTable.getColumnCount()
        
        int value = row.getInt(j);
        if(value!=0){
          fireImg.pixels[indexPixels] = color(1);//color(100-value,value+75,value+50); 
        }
        else{
          fireImg.pixels[indexPixels] = color(0,0,0,0); 
        }
        indexPixels++;
      }
    }
    fireImg.resize(imgHeight,imgWidth);
    return fireImg;
  }

  PImage vhiImageGenerate() {
    Table vhi_table;
    PImage vhiImg = createImage(285,264, ARGB);
    
    vhi_table = loadTable("vegitation_health_index_4km_2019_01_8.csv");
    TableRow row = vhi_table.addRow();
    //println(vhi_table.getRowCount() + " total rows in table");
    //println(vhi_table.getColumnCount() + " total columns in table");
    int indexPixels = 0;
    
    for (int i =0; i<vhi_table.getRowCount(); i++) {
      row = vhi_table.getRow(i);
      for(int j=0; j<285; j++){//vhi_table.getColumnCount()
        int value = row.getInt(j);
        if(value!=-9){
          vhiImg.pixels[indexPixels] = color(75-(int)((float)(value*0.75)), 81-(int)((float)(value*0.38)), 0);
        }
        else{
          vhiImg.pixels[indexPixels] = color(255); 
        }
        indexPixels++;
      }
    }
    for(int i =75240-285; i<75240;i++){
    vhiImg.pixels[i] = color(250);
    }
    

    vhiImg.resize(imgHeight,imgWidth);
    return vhiImg;
  }
  
  void loadNumFiresByYearCause(){
    Table yearCauseTable1;
    yearCauseTable1 = loadTable("Fire_CSVs/number_of_fires_per_year_by_cause.csv");
    TableRow row = yearCauseTable1.addRow();
    //println(yearCauseTable.getRowCount());
    //println(yearCauseTable.getColumnCount());
    for (int i =0; i<yearCauseTable1.getRowCount()-1; i++) {
      row = yearCauseTable1.getRow(i);
      for(int j=0; j<yearCauseTable1.getColumnCount(); j++){//
        numFiresByYearCause[i][j] = row.getInt(j);
      }
    }
  }
  
  void loadNumFiresByYearPercentCause(){
    Table yearCauseTablePercent;
    yearCauseTablePercent = loadTable("Fire_CSVs/percent_of_fires_per_year_by_cause.csv");
    TableRow row = yearCauseTablePercent.addRow();
    //println(yearCauseTable.getRowCount());
    //println(yearCauseTable.getColumnCount());
    for (int i =0; i<yearCauseTablePercent.getRowCount()-1; i++) {
      row = yearCauseTablePercent.getRow(i);
      for(int j=0; j<yearCauseTablePercent.getColumnCount(); j++){//
        numFiresByYearPercentCause[i][j] = row.getFloat(j);
      }
    }
  }
  
 
}
