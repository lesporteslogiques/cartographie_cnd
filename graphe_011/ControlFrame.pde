class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  List dossiers_data = Arrays.asList("18-19", "19-20", "20-21", "21-22", "22-23", "23-24");
  String dossier;
  
  // Passer les valeurs du sketch parent
  boolean lien_motcle_lab_active;
  boolean lien_motcle_motcle_active;
  boolean lien_motcle_personne_active;
  boolean lien_lab_personne_active;
  boolean lien_cnd_lab_active;
  boolean lien_cnd_motcle_active;
  boolean lien_cnd_personne_active;

  float text_size;
  float mc_lab_length;
  float mc_mc_length;
  float mc_pers_length;
  float lab_pers_length;
  float cnd_lab_length;
  float cnd_motcle_length;
  float cnd_personne_length;
  
  float spring_stiffness;
  float spring_damping;
  
  float node_radius;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name, 
                      float _ts, float _mll, float _mml, float _mpl, float _lpl, float _cll, float _cml, float _cpl,
                      boolean _lmla, boolean _lmma, boolean _lmpa, boolean _llpa, boolean _lcla, boolean _lcma, boolean _lcpa,
                      float _ss, float _sd,
                      float _nr) {
    super();
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    text_size = _ts;
    mc_lab_length       = _mll;
    mc_mc_length        = _mml;
    mc_pers_length      = _mpl;
    lab_pers_length     = _lpl;
    cnd_lab_length      = _cll;
    cnd_motcle_length   = _cml;
    cnd_personne_length = _cpl;
    
    lien_motcle_lab_active      = _lmla;
    lien_motcle_motcle_active   = _lmma;
    lien_motcle_personne_active = _lmpa;
    lien_lab_personne_active    = _llpa;
    lien_cnd_lab_active         = _lcla; 
    lien_cnd_motcle_active      = _lcma;
    lien_cnd_personne_active    = _lcpa;
    
    spring_stiffness    = _ss;
    spring_damping      = _sd;
    
    node_radius         = _nr;
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);
    
    println("text_size : " + text_size);

    Toggle t1 = cp5.addToggle("mc_lab_toggle")
      .plugTo(parent, "lien_motcle_lab_active")
      .setValue(lien_motcle_lab_active)
      .setPosition(10, 30)
      .setSize(15, 15);
   
    t1.getCaptionLabel().setVisible(false);

    cp5.addSlider("mc_lab_length")
      .plugTo(parent, "mc_lab_length")
      .setValue(mc_lab_length)
      .setRange(1, 2000)
      .setPosition(40, 30)
      .setSize(160, 15);

    Toggle t2 = cp5.addToggle("mc_mc_toggle")
      .plugTo(parent, "lien_motcle_motcle_active")
      .setValue(lien_motcle_motcle_active)
      .setPosition(10, 50)
      .setSize(15, 15);
      
    t2.getCaptionLabel().setVisible(false);

    cp5.addSlider("mc_mc_length")
      .plugTo(parent, "mc_mc_length")
      .setValue(mc_mc_length)
      .setRange(1, 2000)
      .setPosition(40, 50)
      .setSize(160, 15);
      
    Toggle t3 = cp5.addToggle("mc_pers_toggle")
      .plugTo(parent, "lien_motcle_personne_active")
      .setValue(lien_motcle_personne_active)
      .setPosition(10, 70)
      .setSize(15, 15);
      
    t3.getCaptionLabel().setVisible(false);

    cp5.addSlider("mc_pers_length")
      .plugTo(parent, "mc_pers_length")
      .setValue(mc_pers_length)
      .setRange(1, 2000)
      .setPosition(40, 70)
      .setSize(160, 15);
      
    Toggle t4 = cp5.addToggle("lab_pers_toggle")
      .plugTo(parent, "lien_lab_personne_active")
      .setValue(lien_lab_personne_active)
      .setPosition(10, 90)
      .setSize(15, 15);
      
    t4.getCaptionLabel().setVisible(false);

    cp5.addSlider("lab_pers_length")
      .plugTo(parent, "lab_pers_length")
      .setValue(lab_pers_length)
      .setRange(1, 2000)
      .setPosition(40, 90)
      .setSize(160, 15);

    Toggle t5 = cp5.addToggle("cnd_lab_toggle")
      .plugTo(parent, "lien_cnd_lab_active")
      .setValue(lien_cnd_lab_active)
      .setPosition(10, 110)
      .setSize(15, 15);
      
    t5.getCaptionLabel().setVisible(false);

    cp5.addSlider("cnd_lab_length")
      .plugTo(parent, "cnd_lab_length")
      .setValue(cnd_lab_length)
      .setRange(1, 2000)
      .setPosition(40, 110)
      .setSize(160, 15);
    
    Toggle t6 = cp5.addToggle("cnd_motcle_toggle")
      .plugTo(parent, "lien_cnd_motcle_active")
      .setValue(lien_cnd_motcle_active)
      .setPosition(10, 130)
      .setSize(15, 15);

    t6.getCaptionLabel().setVisible(false);

    cp5.addSlider("cnd_motcle_length")
      .plugTo(parent, "cnd_motcle_length")
      .setValue(cnd_motcle_length)
      .setRange(1, 2000)
      .setPosition(40, 130)
      .setSize(160, 15);
    
    Toggle t7 = cp5.addToggle("cnd_personne_toggle")
      .plugTo(parent, "lien_cnd_personne_active")
      .setValue(lien_cnd_personne_active)
      .setPosition(10, 150)
      .setSize(15, 15);

    t7.getCaptionLabel().setVisible(false);

    cp5.addSlider("cnd_personne_length")
      .plugTo(parent, "cnd_personne_length")
      .setValue(cnd_personne_length)
      .setRange(1, 2000)
      .setPosition(40, 150)
      .setSize(160, 15);

    cp5.addSlider("spring_damping")
      .plugTo(parent, "spring_damping")
      .setValue(spring_damping)
      .setRange(0, 1)
      .setPosition(40, 190)
      .setSize(160, 15);

    cp5.addSlider("spring_stiffness")
      .plugTo(parent, "spring_stiffness")
      .setValue(spring_stiffness)
      .setRange(0, 2)
      .setPosition(40, 210)
      .setSize(160, 15);

    cp5.addSlider("opacite_type1")
      .plugTo(parent, "opacite_type1")
      .setRange(0, 255)
      .setValue(255)
      .setPosition(40, 250)
      .setSize(160, 15);

    cp5.addSlider("opacite_type2")
      .plugTo(parent, "opacite_type2")
      .setRange(0, 255)
      .setValue(255)
      .setPosition(40, 270)
      .setSize(160, 15);

    cp5.addSlider("opacite_type3")
      .plugTo(parent, "opacite_type3")
      .setRange(0, 255)
      .setValue(255)
      .setPosition(40, 290)
      .setSize(160, 15);

    cp5.addSlider("opacite_type4")
      .plugTo(parent, "opacite_type4")
      .setRange(0, 255)
      .setValue(255)
      .setPosition(40, 310)
      .setSize(160, 15);

    cp5.addSlider("opacite_type5")
      .plugTo(parent, "opacite_type5")
      .setRange(0, 255)
      .setValue(255)
      .setPosition(40, 330)
      .setSize(160, 15);

    cp5.addSlider("opacite_type6")
      .plugTo(parent, "opacite_type6")
      .setRange(0, 255)
      .setValue(255)
      .setPosition(40, 350)
      .setSize(160, 15);

    cp5.addSlider("opacite_type7")
      .plugTo(parent, "opacite_type7")
      .setRange(0, 255)
      .setValue(255)
      .setPosition(40, 370)
      .setSize(160, 15);

    cp5.addSlider("node_damping")
      .plugTo(parent, "node_damping")
      .setRange(0, 1)
      .setValue(0.5)
      .setPosition(40, 430)
      .setSize(160, 15);

    cp5.addSlider("node_strength")
      .plugTo(parent, "node_strength")
      .setRange(1, 200)
      .setValue(10)
      .setPosition(40, 450)
      .setSize(160, 15);

    cp5.addSlider("node_ramp")
      .plugTo(parent, "node_ramp")
      .setRange(0, 1)
      .setValue(1.0)
      .setPosition(40, 470)
      .setSize(160, 15);

   cp5.addSlider("node_radius")
      .plugTo(parent, "node_radius")
      .setValue(node_radius)
      .setRange(10, 400)
      .setPosition(40, 490)
      .setSize(160, 15);
      
    cp5.addToggle("node_lab")
      .plugTo(parent, "node_lab")
      .setPosition(40, 520)
      .setSize(15, 15)
      .setValue(true);
    cp5.addToggle("node_cnd")
      .plugTo(parent, "node_cnd")
      .setPosition(40, 560)
      .setSize(15, 15)
      .setValue(true);
    cp5.addToggle("node_personne")
      .plugTo(parent, "node_personne")
      .setPosition(120, 520)
      .setSize(15, 15)
      .setValue(true);
    cp5.addToggle("node_motcle")
      .plugTo(parent, "node_motcle")
      .setPosition(120, 560)
      .setSize(15, 15)
      .setValue(true);

    cp5.addSlider("view_zoom")
      .plugTo(parent, "view_zoom")
      .setRange(0.2, 3)
      .setValue(1.0)
      .setPosition(40, 620)
      .setSize(160, 15);

    cp5.addSlider("font_size")
      .plugTo(parent, "text_size")
      .setValue(text_size)
      .setRange(6, 36)
      .setPosition(40, 640)
      .setSize(160, 15);
      
    cp5.addScrollableList("dropdown")
      .setPosition(40, 700)
      .setSize(200, 100)
      .setBarHeight(15)
      .setItemHeight(15)
      .addItems(dossiers_data)
      .setType(ScrollableList.DROPDOWN);
  }

  void draw() {
    background(120);
    fill(0);
    text("LIENS", 10, 20);
    text("NOEUDS", 10, 410);
    text("L-T", 270, 262);
    text("T-T", 270, 282);
    text("P-T", 270, 302);
    text("P-L", 270, 322);
    text("C-L", 270, 342);
    text("C-T", 270, 362);
    text("C-P", 270, 382);
  }


  void mc_lab_toggle(boolean value) {
    if (value) lien_motcle_lab_active = true;
    else lien_motcle_lab_active = false;
    println("mc_lab_toggle : " + value);
    resetSprings = true;
  }

  void mc_lab_length(float nb) {
    for (Spring s : springs) {
      if (s.nodetype == 1) {
        s.springlength = nb;
      }
    }
  }

  void mc_mc_toggle(boolean value) {
    if (value) lien_motcle_motcle_active = true;
    else lien_motcle_motcle_active = false;
    println("mc_mc_toggle : " + value);
    resetSprings = true;
  }

  void mc_mc_length(float nb) {
    for (Spring s : springs) {
      if (s.nodetype == 2) {
        s.springlength = nb;
      }
    }
  }

  void mc_pers_toggle(boolean value) {
    if (value) lien_motcle_personne_active = true;
    else lien_motcle_personne_active = false;
    println("mc_pers_toggle : " + value);
    resetSprings = true;
  }

  void mc_pers_length(float nb) {
    for (Spring s : springs) {
      if (s.nodetype == 3) {
        s.springlength = nb;
      }
    }
  }

  void lab_pers_toggle(boolean value) {
    if (value) lien_lab_personne_active = true;
    else lien_lab_personne_active = false;
    println("lab_pers_toggle : " + value);
    resetSprings = true;
  }

  void lab_pers_length(float nb) {
    for (Spring s : springs) {
      if (s.nodetype == 4) {
        s.springlength = nb;
      }
    }
  }

  void cnd_lab_toggle(boolean value) {
    if (value) lien_cnd_lab_active = true;
    else lien_cnd_lab_active = false;
    println("cnd_lab_toggle : " + value);
    resetSprings = true;
  }

  void cnd_lab_length(float nb) {
    for (Spring s : springs) {
      if (s.nodetype == 5) {
        s.springlength = nb;
      }
    }
  }

  void cnd_motcle_toggle(boolean value) {
    if (value) lien_cnd_motcle_active = true;
    else lien_cnd_motcle_active = false;
    println("cnd_motcle_toggle : " + value);
    resetSprings = true;
  }

  void cnd_motcle_length(float nb) {
    for (Spring s : springs) {
      if (s.nodetype == 6) {
        s.springlength = nb;
      }
    }
  }

  void cnd_personne_toggle(boolean value) {
    if (value) lien_cnd_personne_active = true;
    else lien_cnd_personne_active = false;
    println("cnd_personne_toggle : " + value);
    resetSprings = true;
  }

  void cnd_personne_length(float nb) {
    for (Spring s : springs) {
      if (s.nodetype == 7) {
        s.springlength = nb;
      }
    }
  }

  void opacite_type1(float nb) {  // lab tag
    for (Spring s : springs) {
      if (s.nodetype == 1) {
        s.opacite = nb;
      }
    }
  }

  void opacite_type2(float nb) { // tag tag
    for (Spring s : springs) {
      if (s.nodetype == 2) {
        s.opacite = nb;
      }
    }
  }

  void opacite_type3(float nb) { // tag personne
    for (Spring s : springs) {
      if (s.nodetype == 3) {
        s.opacite = nb;
      }
    }
  }

  void opacite_type4(float nb) { // lab personne
    for (Spring s : springs) {
      if (s.nodetype == 4) {
        s.opacite = nb;
      }
    }
  }

  void opacite_type5(float nb) { // cnd lab
    for (Spring s : springs) {
      if (s.nodetype == 5) {
        s.opacite = nb;
      }
    }
  }

  void opacite_type6(float nb) { // cnd mot clé
    for (Spring s : springs) {
      if (s.nodetype == 6) {
        s.opacite = nb;
      }
    }
  }

  void opacite_type7(float nb) { // lab personne
    for (Spring s : springs) {
      if (s.nodetype == 7) {
        s.opacite = nb;
      }
    }
  }


  void spring_damping(float nb) {
    for (Spring s : springs) {
      s.damping = nb;
    }
  }

  void spring_stiffness(float nb) {
    for (Spring s : springs) {
      s.stiffness = nb;
    }
  }

  void node_damping(float nb) {
    for (Node n : nodes) {
      n.damping = nb;
    }
  }

  void node_strength(float nb) {
    for (Node n : nodes) {
      n.strength = -nb;
    }
  }

  void node_ramp(float nb) {
    for (Node n : nodes) {
      n.ramp = nb;
    }
  }
  
  void node_radius(float nb) {
    for (Node n : nodes) {
      n.radius = nb;
    }
  }

  void node_lab(boolean value) {
    if (value) node_lab_active = true;
    else node_lab_active = false;
    println("node_lab : " + value);
    updateNodes = true;
    resetSprings = true;
  }

  void node_cnd(boolean value) {
    if (value) node_cnd_active = true;
    else node_cnd_active = false;
    println("node_cnd : " + value);
    updateNodes = true;
    resetSprings = true;
  }

  void node_personne(boolean value) {
    if (value) node_personne_active = true;
    else node_personne_active = false;
    println("node_personne : " + value);
    updateNodes = true;
    resetSprings = true;
  }

  void node_motcle(boolean value) {
    if (value) node_motcle_active = true;
    else node_motcle_active = false;
    println("node_motcle : " + value);
    updateNodes = true;
    resetSprings = true;
  }

  void view_zoom(float nb) {
    wo_z = nb;
  }
  
  void font_size(float nb) {
    text_size = int(nb);
  }

  void dropdown(int n) {
    dossier = cp5.get(ScrollableList.class, "dropdown").getItem(n).get("name").toString();
    println(dossier);
    resetDataFolder = true;
  }
  
  String getDataFolder() {
    return dossier;
  }
}
