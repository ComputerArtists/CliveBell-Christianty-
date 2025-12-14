float angle = 0;
int colorScheme = 0;
int saveCount = 1;

float[][] schemes = {
  {0, 90, 100},    // 0: Rot-Neon (Leiden/B lut)
  {40, 95, 100},   // 1: Goldgelb-Neon
  {300, 100, 100}, // 2: Pink/Magenta-Neon
  {200, 90, 100},  // 3: Cyan-Neon
  {120, 90, 100},  // 4: Grün-Neon
  {0, 0, 100}      // 5: Reines Weiß-Neon (ultra hell)
};

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {
  // Dunkler Fade für Glow-Kontrast
  fill(0, 50);
  rect(0, 0, width, height);
  
  translate(width/2, height/2);
  rotate(angle);
  angle += 0.005; // Langsame Rotation
  
  float baseHue = schemes[colorScheme][0];
  float baseSat = schemes[colorScheme][1];
  float baseBri = schemes[colorScheme][2];
  
  // Ultra-Glow-Layer für die Krone
  int numGlow = int(random(10, 22));
  for (int i = 0; i < numGlow; i++) {
    float thick = random(10, 70);
    float alpha = random(30, 100);
    float hueShift = random(-30, 30);
    strokeWeight(thick);
    stroke((baseHue + hueShift) % 360, baseSat, baseBri, alpha);
    noFill();
    drawCrown();
  }
  
  // Pulsierende Lichtstrahlen
  for (int i = 0; i < 36; i++) {
    float rad = radians(i * 10 + frameCount * 0.5);
    float len = 150 + sin(frameCount * 0.07 + i) * 300;
    float alpha = 40 + sin(frameCount * 0.04 + i) * 60;
    strokeWeight(random(3, 10));
    stroke((baseHue + 20) % 360, baseSat * 0.9, baseBri, alpha);
    line(0, 0, len * cos(rad), len * sin(rad));
  }
  
  // Kern-Dornenkrone mit Gradient
  for (int j = 0; j < 12; j++) {
    float bright = baseBri + (12 - j) * 10;
    pushMatrix();
    scale(1 - j * 0.02);
    strokeWeight(8 - j * 0.5);
    stroke((baseHue + j*5) % 360, baseSat * 0.9, min(bright, 100));
    noFill();
    drawCrown();
    popMatrix();
  }
  
  // Heller Bloom-Kern + zentrales Kreuz
  fill(0, 0, 100, 120);
  ellipse(0, 0, 120, 120);
  
  strokeWeight(10);
  stroke(baseHue, baseSat * 0.7, baseBri);
  line(0, -60, 0, 60);     // Vertikales Kreuz
  line(-40, 0, 40, 0);     // Horizontales Kreuz
}

void drawCrown() {
  // Kreis der Krone
  ellipse(0, 0, 200, 200);
  
  // Dornen (mehr und detaillierter)
  for (int i = 0; i < 360; i += 15) {
    float rad = radians(i);
    float x1 = 100 * cos(rad);
    float y1 = 100 * sin(rad);
    float x2 = 130 * cos(rad);
    float y2 = 130 * sin(rad);
    line(x1, y1, x2, y2);
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    colorScheme = (colorScheme + 1) % schemes.length;
  }
  if (key == 's' || key == 'S') {
    String filename = "corona_spinarum_" + nf(saveCount, 3) + ".png";
    save(filename);
    println("Gespeichert: " + filename);
    saveCount++;
  }
}
