/*  Fonctions graphiques */

void afficherGrille(float pas, float zoom, boolean voir_quadrillage) {

  // Afficher le quadrillage
  if (voir_quadrillage) {
    stroke(200);
    strokeWeight(1);
    for (float y = 0; y < height; y += 20 * pas * zoom) {
      line(0, y, width, y);
    }
    for (float x = 0; x < width; x += 20 * pas * zoom) {
      line(x, 0, x, height);
    }
  }


  // Afficher la grille de points
  for (float y = 0; y < height; y += pas * zoom) {
    for  (float x = 0; x < width; x += pas * zoom) {
      stroke(0);
      strokeWeight(psm);
      point(x, y);
    }
  }
  
  // Croix dans le coin
  stroke(0);
  strokeWeight(1 * zoom);
  line(0, 0, 10 * zoom, 10 * zoom);
  line(0, 10 * zoom, 10 * zoom, 0);
  
  // Afficher les bords
  float wmax = float(int(width / (20*pas*zoom) + 1));
  //println("wmax : " + wmax);
  boolean bascule = true;
  rectMode(CORNER);
  
  // Horizontale
  for (float x = 0; x < wmax; x ++) {
    stroke(0);
    if (bascule) fill(0);
    else fill(255);
    if (x == 0) {
      rect(10 * zoom, 0, (20 * pas - 10) * zoom, 10 * zoom);
    } else {
      rect(x * 20 * pas * zoom, 0, 20 * pas * zoom, 10 * zoom);
    }
    bascule = !bascule;
  }
  
  // Verticale
  bascule = false;
  for (float y = 0; y < wmax; y ++) {
    stroke(0);
    if (bascule) fill(0);
    else fill(255);
    if (y == 0) {
      // rect(10 * zoom, 0, (20 * pas - 10) * zoom, 10 * zoom);
      rect(0, 10 * zoom, 10 * zoom, (20 * pas - 10) * zoom);
    } else {
      // rect(y * 20 * pas * zoom, 0, 20 * pas * zoom, 10 * zoom);
      rect(0, y * 20 * pas * zoom, 10 * zoom, 20 * pas * zoom);
    }
    bascule = !bascule;
  }
}
