int numOfTowers = 15;
int groupCount = 3;
int[] towers = new int[numOfTowers];
int[] towerCount = new int[groupCount];
int pmove = -1;
int moves;
int repeat = 1;
float timeTaken=-1;

void setup(){
  frameRate(400);
  size(1080,720);
  rectMode(CENTER);
  colorMode(HSB);
  for(int t: towers){
    t=0;
  }
}

void draw(){
  //saveFrame("frames/####.tif");
  repeat = floor((frameCount+1)/((millis()+1.0)/1000));
  //repeat=1;
  for(int r=0;r<repeat;r++){
  for(int i=0;i<towerCount.length;i++){
    towerCount[i]=0;
  }
  background(#87CEEB);
  //moves
  fill(255);
  text(moves,20,20);
  fill(200);
  for(int i=0;i<groupCount;i++){
    float pinX = width*(float(i) +0.5)/groupCount;
    rect(pinX,height*0.9,width/(groupCount+1),30);
    line(pinX,height*0.1,pinX,height*0.9-15);
  }
  for(int i=towers.length-1;i>-1;i--){
    fill((1-(float(i)+1)/numOfTowers)*255,200,230);
    rect(width*(towers[i] +0.5)/groupCount,height*0.9-30*(towerCount[towers[i]]+1),width/(groupCount+1)/numOfTowers*(float(i)+0.5),30);
    towerCount[towers[i]]++;
  }
  //check win
  boolean win=true;
  for(int i=0;i<towers.length;i++){
    win&= towers[i]==groupCount-1;
  }
  //AI
  int[] fpicks = new int[groupCount];
  int fpick=0;
  for(int i=0;i<groupCount;i++){
    //print("\n",i);
    fpicks[i]= int(i!=pmove);
    //print(" ",fpicks[i]);
    fpicks[i]-= int(towerCount[i]==0);
    //print(" ",fpicks[i]);
    boolean goodDes=false;
    for(int j=1;j<groupCount;j++){
      goodDes|= destinationSum(i,(i+j)%groupCount)==2;
    }
    fpicks[i]+= int(goodDes);
    //print(" ",fpicks[i]);
    if(fpicks[i]>fpicks[fpick]) fpick=i;
  }
  int[] fmoves = new int[groupCount];
  int fmove=groupCount-1;
  for(int i=0;i<groupCount;i++){
    fmoves[i] = destinationSum(fpick,i);
    if(fmoves[i]>fmoves[fmove]) fmove=i;
  }
  if(!win && frameCount%1==0) move(fpick,fmove);
  if(win){
    if(timeTaken<0) timeTaken=millis()/1000.0;
    fill(255);
    text("Time taken: "+nf(timeTaken,0,3)+" seconds",20,40);
  }
  }
}

void move(int place,int des){
  int[] towerPlace = getTowers(place);
  int desTower = getTower(des);
  //move tower
  if(towerPlace.length==0) print("\n ERROR- Place "+place+" is empty"); 
  else {
    int placeTower = min(towerPlace);
    if(desTower<placeTower){
      print("\n ERROR- Place "+place+" is larger than Destination "+des);
    }
    else{
      towers[placeTower]=des;
      pmove = des;
      moves++;
      //print("\n MOVING- ",place," to ",des);
    }
  }
}

int[] getTowers(int place){
  int[] towerPlace = {};
  for(int i=0;i<towers.length;i++){
    if(towers[i]==place) towerPlace = append(towerPlace,i);
  }
  return towerPlace;
}

int getTower(int place){
  int[] towerPlace = getTowers(place);
  if(towerPlace.length==0) towerPlace = append(towerPlace,numOfTowers+place);
  return min(towerPlace);
}

int destinationSum(int place,int des){
  int sum = 0;
  sum+= int(getTower(place)%(groupCount-1) != getTower(des)%(groupCount-1));
  sum+= int(getTower(place)<getTower(des));
  //print("\n",place," to ",des," gets ", sum);
  return sum;
}