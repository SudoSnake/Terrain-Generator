int cols, rows;//number of columns and rows
int scl = 20;//scale of perlin noise default is 20
int w = 2000;//width of display
int h = 1600;//height of display
int seed =0;//sets the noise seed. 0 is random
int colorScheme=0;//color shading default is 0
float scale = 0.2;//default is 0.2
float th = 100;//terrain height default is 100
float flyingSpeed = 0.1;
float speed =0;
float[][] terrain;
float [] [] n;
float dzdx =0;
float dzdy =0;
float aspect=0;
float brightness=255;
boolean flying= true;//default
boolean singleRun = false;
boolean customNoise = false;
boolean visibleStroke= true;

void setup() {
  size(1200, 1200, P3D);
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];//sets the number of columns and rows
  n=new float[cols][rows];//sets the number of columns and rows
}
void draw(){
  drawTerrain();
}
void drawTerrain() {
  if (seed!=0){
    noiseSeed(seed);
  }
  if (flying&&!(singleRun)){
    speed-= flyingSpeed;//this section will add flying motion to the scene
  }
  float yoff = speed;//offset for y movement. for no movement set line above to comment
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      if (!(customNoise)){
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -th, th);
      }
      else{
        terrain[x][y] =map((noise(xoff, yoff)+noise(-xoff,xoff)+noise(-yoff,yoff))/3, 0, 1, -th, th);
      }
      if (singleRun){
        //print(x,y,terrain[x][y]);
      }
      xoff +=scale;// 0.2;
    }
    yoff += scale;//0.2;
  }
  
  background(200);
  if (visibleStroke==true){
    stroke(0);
  }
  else{
    noStroke();
  }
  //noFill();
  fill(128);
  //fill(255,128,255);
  translate(width/2, height/2+50);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);//triangular mesh with vertex height as terrain[x][y]
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);//triangular mesh with vertex height as terrain[x][y]
      //rect(x*scl, y*scl, scl, scl);//test grid
      //if ((!(x+1<=int(w/scl)||y+1<=int(h/scl)))&&x>1&&y>1){
        
      
     
      if ((x>=1&&y>=1)&&(!(x<2||y<2))&&x+1<cols&&y+1<rows){
        dzdx=((terrain[x+1][y+1]+2*terrain[x+1][y]+terrain[x+1][y-1])-(terrain[x-1][y+1]+2*terrain[x-1][y]+terrain[x-1][y-1]))/8;
        dzdy=((terrain[x-1][y-1]+2*terrain[x][y-1]+terrain[x+1][y-1])-(terrain[x-1][y+1]+2*terrain[x][y+1]+terrain[x+1][y+1]))/8;
      }
      
      //print(dzdx,dzdy);
      
      /*
      dzdx=map(dzdx,0,255,0,255);
      dzdy=map(dzdy,0,255,0,255);
      */

      if (colorScheme==0){//no color scheme
        
      }
      if (colorScheme==1){//color scheme 1
        dzdx=map(dzdx,0,30,0,255);
        dzdy=map(dzdy,0,30,0,255);
        fill(dzdx,dzdy,dzdx);
      }
      if (colorScheme==2){
      fill(map(terrain[x][y],0,1,-th,th));
      }
      if (colorScheme==3){
       fill(map(sqrt(dzdx*dzdx+dzdy*dzdy),0,50,0,255)); 
      }
      if (colorScheme==4){
        aspect = 180/PI* atan2(dzdx,- dzdy);
        if (aspect<0){
          aspect=90-aspect;
        }
        else if (aspect>90){
          aspect=360-aspect+90;
        }
        else{
            aspect=90-aspect;
        }
        fill(aspect);
      }
      if (colorScheme==5){
       colorMode(HSB);
       fill(map(sqrt(dzdx*dzdx+dzdy*dzdy),0,50,0,255),brightness,brightness);
       colorMode(RGB);
      }
    }
    endShape();
  }
  if (singleRun){
    noLoop();
  }
}