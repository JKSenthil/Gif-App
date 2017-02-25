import processing.video.*;

//video variables
Capture video;

//graphics variables
PGraphics barLines;
PGraphics finalImage;
PImage firstFrame;

//pixel variables for the original image
color originalColor;
float r2;
float g2;
float b2;

//arrayList declarations
ArrayList<Integer> pixelLocationsX = new ArrayList<Integer>();
ArrayList<Integer> pixelLocationsY = new ArrayList<Integer>();
ArrayList<Float> redthing = new ArrayList<Float>();
ArrayList<Float> greenthing = new ArrayList<Float>();
ArrayList<Float> bluething = new ArrayList<Float>();

//boolean for capturing the first image from the camera
boolean firstImageTaken = false;

//--------------------------------------------------------------------------------------------//
void setup(){
  size(640,480);
  firstFrame = createImage(640, 480, RGB);
  finalImage = createGraphics(width, height);
  barLines = createGraphics(width, height);
  drawBarLines();
  video = new Capture(this, 640, 480, 30);
  video.start();
}

void draw(){
  video.loadPixels();
  checkColorChange();
  drawFinalImage();
  image(finalImage,0,0);
  destroy();
}
//--------------------------------------------------------------------------------------------//

void drawFinalImage(){
  finalImage.beginDraw();
  finalImage.image(video,0,0);
  finalImage.image(barLines,0,0);
  finalImage(pixelLocationsX, pixelLocationsY, redthing, greenthing, bluething);
  finalImage.endDraw();
}

void checkColorChange(){
    firstFrame.loadPixels();
    for(int x = width/3; x <= width/3+10; x++){
      for(int y = 0; y < height; y++){
        int loc = x + y * video.width;
        color videoColor = video.pixels[loc];
        float r1 = red(videoColor);
        float g1 = green(videoColor);
        float b1 = blue(videoColor);
        originalColor = firstFrame.pixels[loc];
        r2 = red(originalColor);
        g2 = green(originalColor);
        b2 = blue(originalColor);
        float d = distSq(r1,r2,g1,g2,b1,b2);
        if(d>50*50){
          pixelLocationsX.add(x);
          pixelLocationsY.add(y);
          redthing.add(r1);
          greenthing.add(g1);
          bluething.add(b1);
        }
      }
    }
}

void destroy(){
  pixelLocationsX.clear();
  pixelLocationsY.clear();
  bluething.clear();
  greenthing.clear();
  redthing.clear();
}

void drawBarLines(){
  barLines.beginDraw();
  barLines.fill(255);
  barLines.rect(width/3, 0, 10, height);
  barLines.rect(2*width/3, 0, 10, height);
  barLines.endDraw();
}

void finalImage(ArrayList<Integer> locX, ArrayList<Integer> locY, ArrayList<Float> r, ArrayList<Float> g,ArrayList<Float> b){
  for(int i = 0; i < locX.size(); i++){
    color test = color(r.get(i), g.get(i), b.get(i));
    finalImage.set(locX.get(i), locY.get(i), test);
  }
}

float distSq(float r1, float r2, float g1, float g2, float b1, float b2){
  return((r2-r1) * (r2-r1) + (g2-g1) * (g2-g1) + (b2-b1) * (b2-b1));
}

void captureEvent(Capture video){
  video.read();
  //capture the first image
  if(!firstImageTaken){
    firstFrame.copy(video, 0, 0, video.width, video.height, 0, 0, firstFrame.width, firstFrame.height);
    firstFrame.updatePixels();
  }
  firstImageTaken = true;
}

//from previous version
void trashCode(){
  PGraphics img2 = createGraphics(width, height);
  img2.beginDraw();
  img2.image(video,0,0);
  img2.image(barLines,0,0);
  img2.endDraw();
  finalImage(pixelLocationsX, pixelLocationsY, redthing, greenthing, bluething);
  image(img2,0,0);
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);

      // Using euclidean distance^2 to compare colors
      float d = distSq(r1,r2,g1,g2,b1,b2);
      float worldRecord = 50;
      // If current color is more similar to tracked color than
      if (d > worldRecord*worldRecord) {
        pixelLocationsX.add(x);
        pixelLocationsY.add(y);
        redthing.add(r1);
        greenthing.add(g1);
        bluething.add(b1);
      }
    }
  }
}