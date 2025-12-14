float angle = 0;
int colorScheme = 0; // Start mit 0
int saveCount = 1;

// Array mit Farbschemata: [Basis-Hue, Saturation-Bereich, Helligkeit-Variation]
float[][] schemes = {
  {40, 80, 100},   // 0: Goldgelb (warm)
  {200, 60, 100},  // 1: Hellblau/Weiß (himmlisch)
  {300, 90, 100},  // 2: Pink/Lila Neon
  {20, 90, 100},   // 3: Rot-Orange Feuer
  {120, 70, 100},  // 4: Grün-Frisch (Hoffnung)
  {0, 0, 100}      // 5: Reines Weiß (klassisch)
};

void setup() {
  size(800, 800);
  background(0);
  colorMode(HSB, 360, 100, 100, 100); // HSB für einfache Farbwechsel
}

void draw() {
  // Leichter Fade für Trails
  fill(0, 40);
  rect(0, 0, width, height);
  
  translate(width/2, height/2);
  rotate(angle);
  angle += 0.002; // Sanfte Rotation
  
  float baseHue = schemes[colorScheme][0];
  float baseSat = schemes[colorScheme][1];
  float baseBri = schemes[colorScheme][2];
  
  // 1. Mehrere zufällige Glow-Layer
  int numGlowLayers = int(random(5, 12));
  for (int i = 0; i < numGlowLayers; i++) {
    float thick = random(10, 60);
    float alpha = random(10, 60);
    float hueShift = random(-20, 20);
    
    strokeWeight(thick);
    stroke((baseHue + hueShift) % 360, baseSat * random(0.8, 1), baseBri, alpha);
    noFill();
    
    line(0, -160, 0, 160);   // Vertikal
    line(-90, 0, 90, 0);     // Horizontal
  }
  
  // 2. Lichtstrahlen mit zufälligen Variationen
  int numRays = 36;
  for (int i = 0; i < numRays; i++) {
    float rad = radians(i * 10 + random(-5, 5) + frameCount * 0.3);
    float len = 200 + random(100, 300);
    float hue = (baseHue + random(-40, 40)) % 360;
    float alpha = random(20, 80);
    
    strokeWeight(random(1, 4));
    stroke(hue, baseSat * random(0.7, 1), baseBri, alpha);
    line(0, 0, len * cos(rad), len * sin(rad));
  }
  
  // 3. Kern-Kreuz mit Farbverlauf
  float timeHue = baseHue + sin(frameCount * 0.02) * 15;
  
  for (int j = 0; j < 10; j++) {
    float offset = map(j, 0, 9, 0, 1);
    float thickCore = 12 - j;
    float bright = baseBri - j * 5;
    float alphaCore = 80 + j * 10;
    
    strokeWeight(thickCore);
    stroke((timeHue + j*3) % 360, baseSat * 0.8, bright, alphaCore);
    
    line(0, -150 + offset*20, 0, 150 - offset*20);
    line(-80 + offset*10, 0, 80 - offset*10, 0);
  }
  
  // Heller Kern
  strokeWeight(6);
  stroke(baseHue, baseSat * 0.6, baseBri, 100);
  line(0, -140, 0, 140);
  line(-70, 0, 70, 0);
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    colorScheme = (colorScheme + 1) % schemes.length; // Nächstes Schema
    println("Farbschema gewechselt zu: " + colorScheme);
  }
  
  if (key == 's' || key == 'S') {
    String filename = "kreuz_" + nf(saveCount, 3) + ".png";
    save(filename);
    println("Bild gespeichert als: " + filename);
    saveCount++;
  }
}
