ArrayList<Particle> particles = new ArrayList<Particle>();
int colorScheme = 0;
int saveCount = 1;

float[][] schemes = {
  {40, 95, 100},   // 0: Goldgelb-Neon
  {200, 90, 100},  // 1: Cyan-Neon
  {300, 100, 100}, // 2: Pink/Magenta-Neon
  {0, 90, 100},    // 3: Rot-Neon
  {120, 90, 100},  // 4: Grün-Neon
  {0, 0, 100}      // 5: Reines Weiß-Neon
};

class Particle {
  float x, y, vx, vy, alpha, size;
  Particle(float startX, float startY) {
    x = startX;
    y = startY;
    vx = random(-0.8, 0.8);
    vy = random(-4, -1.5); // Stark aufwärts
    alpha = 255;
    size = random(5, 15);
  }
  void update() {
    x += vx;
    y += vy;
    vy -= 0.08; // Leichte Beschleunigung nach oben
    alpha -= 5;
  }
  boolean isDead() {
    return alpha <= 0 || y < -height/2 - 100;
  }
  void display(float hue, float sat, float bri) {
    noStroke();
    fill(hue, sat * 0.8, bri, alpha);
    ellipse(x, y, size, size);
  }
}

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {
  fill(0, 50);
  rect(0, 0, width, height);
  
  translate(width/2, height/2);
  
  float baseHue = schemes[colorScheme][0];
  float baseSat = schemes[colorScheme][1];
  float baseBri = schemes[colorScheme][2];
  
  // Ultra-Glow für das Kreuz
  int numGlow = int(random(12, 25));
  for (int i = 0; i < numGlow; i++) {
    float thick = random(20, 100);
    float alpha = random(30, 100);
    float hueShift = random(-30, 30);
    strokeWeight(thick);
    stroke((baseHue + hueShift) % 360, baseSat, baseBri, alpha);
    line(0, -200, 0, 200);
    line(-100, 0, 100, 0);
  }
  
  // Pulsierende Lichtstrahlen
  for (int i = 0; i < 48; i++) {
    float rad = radians(i * 7.5 + frameCount * 0.7);
    float len = 200 + sin(frameCount * 0.06 + i) * 400;
    float alpha = 50 + sin(frameCount * 0.05 + i) * 70;
    strokeWeight(random(4, 12));
    stroke((baseHue + 20) % 360, baseSat * 0.9, baseBri, alpha);
    line(0, 0, len * cos(rad), len * sin(rad));
  }
  
  // Kern-Kreuz mit Gradient und Bloom
  for (int j = 0; j < 15; j++) {
    float bright = baseBri + (15 - j) * 10;
    strokeWeight(15 - j);
    stroke((baseHue + j*4) % 360, baseSat * 0.8, min(bright, 100));
    line(0, -180, 0, 180);
    line(-90, 0, 90, 0);
  }
  fill(0, 0, 100, 200);
  ellipse(0, 0, 150, 150);
  
  // Partikel direkt VOM KREUZ aus erzeugen
  if (frameCount % 2 == 0) {
    for (int i = 0; i < 6; i++) {
      // Zufälliger Startpunkt entlang des Kreuzes
      boolean onVertical = random(1) < 0.7; // Mehr auf vertikalem Balken
      float pos;
      if (onVertical) {
        pos = random(-180, 180);
        particles.add(new Particle(0 + random(-10,10), pos));
      } else {
        pos = random(-90, 90);
        particles.add(new Particle(pos, 0 + random(-10,10)));
      }
    }
  }
  
  // Partikel aktualisieren und zeichnen
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display(baseHue, baseSat, baseBri);
    if (p.isDead()) particles.remove(i);
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    colorScheme = (colorScheme + 1) % schemes.length;
  }
  if (key == 's' || key == 'S') {
    String filename = "resurrectio_" + nf(saveCount, 3) + ".png";
    save(filename);
    println("Gespeichert: " + filename);
    saveCount++;
  }
}
