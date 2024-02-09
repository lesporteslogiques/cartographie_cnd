class Spring {
  Node from;
  Node to;

  int nodetype = 0;
  /*
  type = 0 : non attribué
   type = 1 : Lab - Tag
   type = 2 : Tag - Tag
   type = 3 : Personne - Tag
   type = 4 : Personne - Lab
   type = 5 : CND - Lab
   type = 6 : CND - Mot clé
   type = 7 : CND - Personne
   */
  float springlength = 300;
  float stiffness = 0.6;
  float damping = 0.9;
  float weight;
  float opacite;
  boolean active = true;

  Spring(Node from, Node to, float _weight, float _length, float _damping, float _stiffness, int _nodetype) {
    this.from = from;
    this.to = to;
    weight = _weight;
    springlength= _length;
    damping = _damping;
    stiffness = _stiffness;
    opacite = 255;
    nodetype = _nodetype;
    //println("nodetype : " + nodetype);
  }

  void update() {
    PVector diff = PVector.sub(to.pos, from.pos);
    diff.normalize();
    diff.mult(springlength);
    PVector target = PVector.add(from.pos, diff);

    PVector force = PVector.sub(target, to.pos);
    force.mult(0.5);
    force.mult(stiffness);
    force.mult(1 - damping);

    to.velocity.add(force);
    from.velocity.add(PVector.mult(force, -1));
  }

  void render(float wo_x, float wo_y, float wo_z) {
    if (nodetype == 0) {
      stroke(0, 130, 164);
      strokeWeight(weight * psm);
    }
    if (nodetype == 1) {                 // Lab - Tag
      stroke(  red(col_lab), green(col_lab), blue(col_lab), opacite);
      strokeWeight(weight * psm);
    }
    if (nodetype == 2) {                 // Tag - Tag
      stroke(  red(col_tag), green(col_tag), blue(col_tag), opacite);
      strokeWeight(weight * psm);
    }
    if (nodetype == 3) {                 // Personne - Tag
      stroke(  red(col_per), green(col_per), blue(col_per), opacite);
      strokeWeight(weight * psm);
    }
    if (nodetype == 4) {                 //  Personne - Lab
      stroke(  red(col_per), green(col_per), blue(col_per), opacite);
      strokeWeight(weight * psm);
    }
    if (nodetype == 5) {                 //  CND - Lab
      stroke(  red(col_cnd), green(col_cnd), blue(col_cnd), opacite);
      strokeWeight(weight * psm);
    }
    if (nodetype == 6) {                 //  CND - Mot clé
      stroke(  red(col_cnd), green(col_cnd), blue(col_cnd), opacite);
      strokeWeight(weight * psm);
    }
    if (nodetype == 7) {                 //  CND - Personne
      stroke(  red(col_per), green(col_per), blue(col_per), opacite);
      strokeWeight(weight * psm);
    }

    line( (from.pos.x + wo_x) * wo_z, 
          (from.pos.y + wo_y) * wo_z, 
          (to.pos.x + wo_x) * wo_z, 
          (to.pos.y + wo_y) * wo_z);
  }
}
