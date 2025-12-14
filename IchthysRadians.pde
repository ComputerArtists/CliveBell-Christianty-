ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
float fishX, fishY;
int colorScheme = 0;
int saveCount = 1;

float[][] schemes = {
  {200, 90, 100},  // 0: Cyan-Neon (ultra hell)
  {40, 95, 100},   // 1: Goldgelb-Neon
  {300, 100, 100}, // 2: Pink/Magenta-Neon
  {20, 100, 100},  // 3: Orange-Feuer-Neon
  {120, 90, 100},  // 4: Grün-Neon
  {0, 0, 100}      // 5: Reines Weiß-Neon (maximal hell)
};

class Bubble {
  float x, y, size, speed;
  Bubble(float px, float py) {
    x = px;
    y = py;
    size = random(4, 12);
    speed = random(0.3, 1.2);
  }
  void update() {
    y -= speed;
    x += sin(frameCount * 0.03 + y) * 0.4;
    if (y < -20) y = height + 20;
  }
  void display() {
    noStroke();
    fill(200 + random(-20,40), 30, 100, random(20,60)); // Immer noch dezent pastell
    ellipse(x, y, size, size);
  }
}

void setup() {
  size(800, 600);
  fishX = -150;
  fishY = height / 2;
  for (int i = 0; i < 40; i++) {
    bubbles.add(new Bubble(random(width), random(height)));
  }
}

void draw() {
  // Dunkler Fade, aber etwas stärker für Kontrast zum hellen Fisch
  fill(5, 10, 30, 50);
  rect(0, 0, width, height);
  
  float baseHue = schemes[colorScheme][0];
  float baseSat = schemes[colorScheme][1];
  float baseBri = schemes[colorScheme][2];
  
  fishX = (fishX + 2.5) % (width + 300);
  fishY = height/2 + sin(frameCount * 0.04) * 60;
  
  pushMatrix();
  translate(fishX, fishY);
  if (fishX > width + 100) fishX = -150;
  
  // Ultra-starke Glow-Layer (mehr, dicker, heller)
  int numGlow = int(random(10, 20)); // Mehr Layer
  for (int i = 0; i < numGlow; i++) {
    float thick = random(15, 80);      // Dicker
    float alpha = random(30, 100);     // Höhere Transparenz = stärkerer Glow
    float hueShift = random(-30, 30);
    strokeWeight(thick);
    stroke((baseHue + hueShift) % 360, baseSat, baseBri, alpha);
    noFill();
    drawFish();
  }
  
  // Intensivere, pulsierende Lichtstrahlen
  for (int i = 0; i < 30; i++) { // Mehr Strahlen
    float rad = radians(i * 12 + frameCount * 0.6);
    float len = 100 + sin(frameCount * 0.08 + i) * 250; // Länger & pulsierend
    float alpha = 50 + sin(frameCount * 0.05 + i) * 50; // Pulsierende Helligkeit
    strokeWeight(random(3, 8)); // Dicker
    stroke((baseHue + 15) % 360, baseSat * 0.9, baseBri, alpha);
    line(0, 0, len * cos(rad), len * sin(rad));
  }
  
  // Heller Kern mit mehr Gradient-Schichten
  for (int j = 0; j < 12; j++) { // Mehr Schichten
    float bright = baseBri + (12 - j) * 8; // Über 100 für extra Hell (HSB erlaubt es)
    float sat = baseSat * (1 - j * 0.05);
    fill((baseHue + j*5) % 360, sat, min(bright, 100), 255);
    pushMatrix();
    scale(1 - j*0.025);
    drawFish();
    popMatrix();
  }
  
  // Extra Bloom: Weißer heißer Kern in der Mitte
  fill(0, 0, 100, 150);
  ellipse(0, 0, 80, 40);
  
  popMatrix();
  
  // Dezente Blasen
  if (frameCount % 4 == 0) {
    bubbles.add(new Bubble(fishX - 60, fishY + random(-20,20)));
  }
  for (Bubble b : bubbles) {
    b.update();
    b.display();
  }
}

void drawFish() {
  ellipse(0, 0, 140, 70);
  triangle(-70, 0, -120, -50, -120, 50);
  ellipse(45, -20, 25, 40);
  ellipse(45, 20, 20, 35);
  fill(0, 100);
  ellipse(50, -12, 12, 12);
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    colorScheme = (colorScheme + 1) % schemes.length;
  }
  if (key == 's' || key == 'S') {
    String filename = "ichthys_ultra_" + nf(saveCount, 3) + ".png";
    save(filename);
    println("Gespeichert: " + filename);
    saveCount++;
  }
}
