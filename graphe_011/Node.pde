class Node {
  int id;
  String label = "";
  float rad;
  float scaling = 1;
  int type = 0;
  boolean lockedMode = false;
  boolean active = true;
  /*
    type = 0 : non attribué
   type = 1 : lab
   type = 2 : tag
   type = 3 : personne
   type = 4 : CND
   */

  float minX, maxX, minY, maxY;

  PVector pos;
  PVector velocity = new PVector(0, 0);
  float maxVelocity = 10;

  float damping = 0.5;
  float radius = 150;
  float strength = -10; // Negative ensures repulsion
  float ramp = 1.0;

  Node(int _id, float x, float y, int rad, int _type, String _label, float _radius) {
    id = _id;
    pos = new PVector(x, y);
    pos = new PVector(x, y);
    this.rad = rad;
    radius = _radius;
    minX = rad;
    maxX = width - rad;
    minY = rad;
    maxY = height - rad;
    type = _type;
    label = _label;
    println("node, type : " + type + " / label : " + label);
    //radius = rad;
    //int index = int(random(words.length));  // same as int(random(10))
    //label = words[index];  // prints one of the six words // but now a few :(
  }

  void attract(ArrayList<Node> nodes) {
    for (Node n : nodes) {
      if (n == null) break; // stop when empty
      if (n == this) continue; // not with itself
      float d = PVector.dist(pos, n.pos);
      if (d > 0 && d < radius) {
        float s = pow(d / radius, 1 / ramp);
        float f = s * 9 * strength * (1 / (s + 1) + ((s - 3) / 4)) / d;
        PVector df = PVector.sub(pos, n.pos);
        df.mult(f);
        n.velocity.add(df);
      }
    }
  }

  void update() {
    velocity.limit(maxVelocity);
    pos.add(velocity);
    if (lockedMode) {
      pos.x = mouseX;
      pos.y = mouseY;
    }
    velocity.mult(1 - damping);
    if (fishEyeView) {
      screenPos();
    } else {
      scaling = 1;
    }
  }

  void render(float wo_x, float wo_y, float wo_z) {
    /*
    type = 0 : non attribué
     type = 1 : lab
     type = 2 : tag
     type = 3 : personne
     type = 4 : CND
     */
    pushMatrix();
    translate((pos.x + wo_x) * wo_z, (pos.y + wo_y) * wo_z);
    noStroke();
    
    textFont(param_font);
    textSize(text_size * psm);

    if (type == 0) fill(30);

    if (type == 1) {             // lab
      stroke(col_lab);
      strokeWeight(psm);
      noFill();
      float size = 10;
      float max = (5 * rad + 8) * scaling;
      float etapes = ((5 * rad + 8) * scaling) / size;
      for (int i = 0; i < etapes; i ++) {
        ellipse(0, 0, size * i, size * i);
      }
      float lt = textWidth(label);
      noStroke();
      fill(col_lab);
      rectMode(CENTER);
      rect(0, 0, lt * 1.2, text_size * psm * 1.3);
      fill(col_lab_cnt);
      textAlign(CENTER, CENTER);
      text(label, 0, - (text_size * psm * 1.3 - text_size * psm) / 2);
    }

    if (type == 4) {             // CND
      fill(col_cnd);
      noStroke();
      //croix(8, 24);
      //etoile(9, 18, 5);
      //ellipse(0, 0, 20, 20);
      float lt = textWidth( nfs(int(label), 2) );
      rect(0, 0, lt * 1.2, text_size * psm * 1.3);
      fill(col_cnd_cnt);
      textAlign(CENTER, CENTER);
      textSize(text_size * 0.8 * psm);
      text(nfs(int(label), 2), - text_size * psm / 6, - (text_size * psm * 1.3 - text_size * psm) / 2);
    }

    if (type == 2) {             // tag
      fill(col_tag);
      float lt = textWidth(label);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, lt * 1.2, text_size * 1.3 * psm);
      fill(col_tag_cnt);
      textAlign(CENTER, CENTER);
      text(label, 0, - (text_size * psm * 1.3 - text_size * psm) / 2);
    }

    if (type == 3) {             // personne
      fill(col_per);
      float lt = textWidth(label);
      noStroke();
      fill(col_per);
      rectMode(CENTER);
      rect(0, 0, lt * 1.2, text_size * psm * 1.3);
      fill(col_per_cnt);
      textAlign(CENTER, CENTER);
      text(label, 0, - (text_size * psm * 1.3 - text_size * psm) / 2);
    }

    popMatrix();
  }

  void croix(float c1, float c2) {
    rectMode(CENTER);
    rotate(radians(45));
    rect(0, 0, c2, c1);
    rect(0, 0, c1, c2);
    rotate(radians(-45));
  }

  void etoile(float rayon1, float rayon2, int branches) {
    float inc = 360 / (float(branches) * 2);
    beginShape();
    int c = 0;
    for (float i = 0; i <= 360; i+=inc) {
      c++;
      float a = radians(i);
      float d;
      if (c%2 == 0) d = rayon1 * psm;
      else d = rayon2 * psm;
      float x = d * cos(a);
      float y = d * sin(a);
      vertex(x, y);
    }
    endShape(CLOSE);
  }

  void screenPos() {
    PVector centerToPos = PVector.sub(pos, center);
    float distanceToCenter = centerToPos.mag();
    float viewingAngle = atan(distanceToCenter / observerRadius);
    float newDistanceToCenter = viewingAngle * observerRadius;
    centerToPos.normalize();
    centerToPos.mult(newDistanceToCenter);
    scaling = map(viewingAngle, 0, HALF_PI, 1, 0.2);
    pos = PVector.add(center, centerToPos);
  }
}
