/*
    Graphe / carto des curiosités numériques digestes
 20231129 - 202401xx
 
 D'après https://forum.processing.org/one/topic/fish-eye-view-of-a-force-directed-graph.html
 
 Usage :
 * cliquer sur un noeud pour le déplacer
 * click+drag pour déplacer la vue
 * 'espace' pour tout rassembler au milieu (obsolète!)
 * 'c' contour visible ou pas
 * 'g' sauvegarde en SVG
 * 's' sauver l'image
 * 'p' afficher ou pas les paramètres
 * 'v' sauvegarde en PDF
 * gauche, droite, haut, bas pour déplacer la légende
 * interface pour choisir les éléments à afficher et les caractéristiques du graphe
 * zoom accessible dans l'interface
 
 Versions
 * 005 : fonctionnelle / incomplète : tout ce qui concerne les CND n'est pas implémenté
 * 007 : fonctionnelle avec les CND et les enveloppes, la suite sera pour le traitement graphique
 * 008 : fonctionnelle avec zoom et déplacement + tous les éléments
 * 009 : paramètres visibles, sauvegardes vectorielles (PDF et SVG)
 * 010 : recherches graphiques
 * 011 : recherches graphiques abouties
 
 TODO
 * OK 002 qualifier les 3 types d'entités et les 4 types de liens
 * OK 002 essayer l'algo de convex hull
 * OK 003 structurer les données et importer
 * OK 005 ajouter les liens CND (jaune)
 * OK 005 ajouter une propriété active aux liens pour les activer par type
 * OK 006 opacité des liens CND
 * OK 006 activer / désactiver chaque type de noeuds / augmenter leur poids
 * OK 007 appliquer l'algo d'envellope aux *labs -> réécrire la classe GFG
 * OK 004 ajouter des controles avec ControlP5frame
 * OK 007 comment colorier un polygone ? beginShape
 * OK 008 eviter que ça sorte du cadre! -> zoom,
 * OK 008 décalage/offset à la souris/clavier
 * vision séparée : chaque personne entourée de ses mots clés, chaque lab entouré de ses curiosités, etc
 lab/pers, lab/mc, lab/cnd, pers/mc, pers/cnd
 * bug de démarrage : erreur remonte parfois quand controlp5 fait des accès concurrents
 * OK 009 : chargement des différentes années de CND
 * OK 009 export pdf / svg ?
 * OK 009 visibilité on/off des enveloppes (au clavier)
 * OK 010 modifier ordre d'affichage
 * OK 010 ajouter placement au clavier pour la légende
 * OK 010 remplacer les croix par des étoiles
 * OK 010 adapter la couleur des liens : vert L-T, T-T / bleu P-T, P-L, C-P / orange C-L, C-T
 * OK 010 quand on change d'années, conserver les réglages
 * OK 010 le slider font_size ne fonctionne pas, pourquoi ?
 * OK 010 refaire l'export 19-20 car il contient toutes les données des différentes années....
 */

import processing.pdf.*;
import processing.svg.*;
import java.util.*;

// fonctions de dates pour l'export d'images
import java.util.Date;
import java.text.SimpleDateFormat;

String SKETCH_NAME = getClass().getSimpleName();

// Interface
import controlP5.*;
ControlFrame cf;

// Charger les données
String dossier = "22-23";
Table index_occ_mot_cle;    //  "index_occ_mot_cle.csv"    :  index , mot clé  , occurrences
Table index_occ_personne;   //  "index_occ_personne.csv"   :  index , personne , occurrences
Table index_occ_lab;        //  "index_occ_lab.csv"        :  index , lab      , occurrences
Table index_cnd;            //  "index_cnd.csv"            :  index , titre CND
Table lien_motcle_lab;      //  "lien_motcle_lab.csv"      :  index mot clé , index lab      , occurrences
Table lien_motcle_motcle;   //  "lien_motcle_motcle.csv"   :  index mot clé , index mot clé  , occurrences
Table lien_motcle_personne; //  "lien_motcle_personne.csv" :  index mot clé , index personne , occurrences
Table lien_lab_personne;    //  "lien_lab_personne.csv"    :  index lab     , index personne , occurrences
Table lien_cnd_lab;         //  "lien_cnd_lab.csv"         :  index cnd , index lab , occurrences
Table lien_cnd_motcle;      //  "lien_cnd_motcle.csv"      :  index cnd , index mot clé , occurrences
Table lien_cnd_personne;    //  "lien_cnd_personne.csv"    :  index cnd, index personne , occurrences

// Liens activables ou non
boolean lien_motcle_lab_active      = true;
boolean lien_motcle_motcle_active   = true;
boolean lien_motcle_personne_active = true;
boolean lien_lab_personne_active    = true;
boolean lien_cnd_lab_active         = true;
boolean lien_cnd_motcle_active      = true;
boolean lien_cnd_personne_active    = true;

// Nodes visibles ou pas
boolean node_lab_active             = true;
boolean node_cnd_active             = true;
boolean node_personne_active        = true;
boolean node_motcle_active          = true;

// Longueurs des liens
float mc_lab_length       = 150;
float mc_mc_length        = 150;
float mc_pers_length      = 200;
float lab_pers_length     = 450;
float cnd_lab_length      = 300;
float cnd_motcle_length   = 1;
float cnd_personne_length = 1;

boolean resetSprings    = false;            // recréer les liens si nécessaire
boolean updateNodes     = false;            // dés/activer les noeuds
boolean resetDataFolder = true;             // recharger les fichiers de données

// Springs
float spring_stiffness = 0.3;
float spring_damping   = 0.9;

// Nodes
float node_radius      = 160;

ArrayList<Node> nodes = new ArrayList();
ArrayList<Spring> springs = new ArrayList();
int[] ordre_affichage = { 0, 1, 4, 3, 2 };    // Types des Nodes (cf. classe node)
/*
 type = 0 : non attribué
 type = 1 : lab
 type = 2 : tag
 type = 3 : personne
 type = 4 : CND
 */

// Créer les enveloppes en fonction du nombre de labs
int total_labs = 0;
IntList mclab0, mclab1, mclab2, mclab3, mclab4, mclab5, mclab6, mclab7, mclab8, mclab9;
Contour c0, c1, c2, c3, c4, c5, c6, c7, c8, c9;
boolean contour_visible = false;

color[] contour_color = { #FF0000, #FFC000, #E0FF00, #7EFF00, #21FF00,
  #00FF41, #00FF9F, #00FDFF, #009FFF, #003DFF  };

// Graphique
float text_size = 12;               // taille de police pour : lab, cnd, tag, personne, etc.
float text_size_param = 10;         // taille de police pour les paramètres
float psm = 1;                      // COEFFICIENT DE TAILLE POUR LES FORMATS PRINT : PDF, SVG
PFont param_font;
float leg_x = 40;                   // Coordonnées de départ pour la légende
float leg_y = 400;

// Couleurs des nodes et des liens
color col_lab = color(220, 102, 218);   // (255,  44, 185);
color col_tag = color( 66, 225, 109);   // (  0, 255, 0);
color col_per = color(  0,   0, 255);
color col_cnd = color(255, 167,   2);   // (250, 160, 50);

// Couleurs de contraste
color col_lab_cnt = color(  0,   0,   0);
color col_tag_cnt = color(  0,   0,   0);
color col_per_cnt = color(255, 255, 255);
color col_cnd_cnt = color(  0,   0,   0);

// Interface
boolean parametres_visibles = false;

// Variables pour les sauvegardes (déclenchées au clavier)
boolean export_pdf = false;
boolean export_svg = false;

// Interactions avec la fenêtre
boolean nodeMoveMode = false;
boolean windowOffsetMode = false;
float wo_x = 0;                      // offset de la fenêtre
float wo_y = 0;
float wo_last_x = 0;                 // dernière position de la souris quand bouton cliqué
float wo_last_y = 0;
float wo_z = 1;                      // zoom de la fenêtre

// Vue (issue du sketch original)
boolean fishEyeView = false;
float observerRadius;
PVector center;
boolean lockedmode;



float zoom=1; // pour convex hull



void setup() {
  size(1188, 840);
  cf = new ControlFrame(this, 320, 840, "Controls", text_size, 
                        mc_lab_length, mc_mc_length, mc_pers_length, lab_pers_length, cnd_lab_length, cnd_motcle_length, cnd_personne_length,
                        lien_motcle_lab_active, lien_motcle_motcle_active, lien_motcle_personne_active, lien_lab_personne_active,
                        lien_cnd_lab_active, lien_cnd_motcle_active, lien_cnd_personne_active,
                        spring_stiffness, spring_damping,
                        node_radius);
  surface.setLocation(340, 10);
  //param_font = loadFont("BitstreamVeraSansMono-Bold-24.vlw");
  param_font = createFont("VeraMoBd.ttf", 24);
  center = new PVector(width/2, height/2);
  observerRadius = min(width, height) / 2;
  background(255);
  cursor(CROSS);
  smooth();

  if (resetDataFolder) {
    dispatchData(dossier);
    resetDataFolder = false;
  }
}

void draw() {
  
  psm = 1;

  if (export_pdf) {
    psm = 0.5;
    Date now = new Date();
    SimpleDateFormat formater = new SimpleDateFormat("yyyyMMdd_HHmmss");
    System.out.println(formater.format(now));
    String fichier_pdf = SKETCH_NAME + "_" + "CND_" + dossier + "_" + formater.format(now) + ".pdf";
    beginRecord(PDF, fichier_pdf);
  }

  if (export_svg) {
    psm = 0.5;
    Date now = new Date();
    SimpleDateFormat formater = new SimpleDateFormat("yyyyMMdd_HHmmss");
    System.out.println(formater.format(now));
    String fichier_svg = SKETCH_NAME + "_" + "CND_" + dossier + "_" + formater.format(now) + ".svg";
    beginRecord(SVG, fichier_svg);
  }
  
  background(255);
  afficherGrille(10, wo_z, true);
  textSize(text_size);

  if (resetDataFolder) {
    dossier = cf.getDataFolder();
    dispatchData(dossier);
    resetDataFolder = false;
  }

  if (updateNodes) {
    for (Node n : nodes) {
      if (n.type == 1) n.active = node_lab_active;
      if (n.type == 2) n.active = node_motcle_active;
      if (n.type == 3) n.active = node_personne_active;
      if (n.type == 4) n.active = node_cnd_active;
    }
  }

  if (resetSprings) {
    createSprings();
    resetSprings = false;
  }

  // Affichage des enveloppes (convex hulls)
  if (contour_visible) {
    c0.updateAndRender(wo_x, wo_y, wo_z);
    c1.updateAndRender(wo_x, wo_y, wo_z);
    c2.updateAndRender(wo_x, wo_y, wo_z);
    c3.updateAndRender(wo_x, wo_y, wo_z);
    c4.updateAndRender(wo_x, wo_y, wo_z);
    c5.updateAndRender(wo_x, wo_y, wo_z);
    c6.updateAndRender(wo_x, wo_y, wo_z);
    c7.updateAndRender(wo_x, wo_y, wo_z);
    c8.updateAndRender(wo_x, wo_y, wo_z);
    c9.updateAndRender(wo_x, wo_y, wo_z);
  }

  for (Spring s : springs) {
    s.update();
    s.render(wo_x, wo_y, wo_z);
  }

  // Afficher les nodes par ordre
  for (int i = 0; i < ordre_affichage.length; i++) {
    for (Node n : nodes) {
      if (n.active && n.type == ordre_affichage[i]) {
        n.attract(nodes);
        n.update();
        n.render(wo_x, wo_y, wo_z);
      }
    }
  }

  textSize(24);
  textAlign(LEFT, BOTTOM);
  fill(0);
  text("CND " + dossier, 40, 60);

  if (parametres_visibles) afficherParametres(40, 80);

  afficherLegende(leg_x, leg_y);

  if (export_pdf) {
    endRecord();
    export_pdf = false;
  }

  if (export_svg) {
    endRecord();
    export_svg = false;
  }
}

void dispatchData(String dossier) {
  mclab0 = new IntList();
  mclab1 = new IntList();
  mclab2 = new IntList();
  mclab3 = new IntList();
  mclab4 = new IntList();
  mclab5 = new IntList();
  mclab6 = new IntList();
  mclab7 = new IntList();
  mclab8 = new IntList();
  mclab9 = new IntList();

  index_occ_mot_cle    = loadTable(dossier + "/index_occ_mot_cle.csv");    // index , mot clé  , occurrences
  index_occ_personne   = loadTable(dossier + "/index_occ_personne.csv");   // index , personne , occurrences
  index_occ_lab        = loadTable(dossier + "/index_occ_lab.csv");        // index , lab      , occurrences
  index_cnd            = loadTable(dossier + "/index_cnd.csv");            // index , titre CND
  lien_motcle_lab      = loadTable(dossier + "/lien_motcle_lab.csv");      // index mot clé , index lab      , occurrences
  lien_motcle_motcle   = loadTable(dossier + "/lien_motcle_motcle.csv");   // index mot clé , index mot clé  , occurrences
  lien_motcle_personne = loadTable(dossier + "/lien_motcle_personne.csv"); // index mot clé , index personne , occurrences
  lien_lab_personne    = loadTable(dossier + "/lien_lab_personne.csv");    // index lab     , index personne , occurrences;
  lien_cnd_lab         = loadTable(dossier + "/lien_cnd_lab.csv");         // index cnd , index lab , occurrences
  lien_cnd_motcle      = loadTable(dossier + "/lien_cnd_motcle.csv");      // index cnd , index mot clé , occurrences
  lien_cnd_personne    = loadTable(dossier + "/lien_cnd_personne.csv");    // index cnd , index personne , occurrences

  createNodes();
  createSprings();
  createHulls();

  c0 = new Contour(mclab0, contour_color[0]);
  c1 = new Contour(mclab1, contour_color[1]);
  c2 = new Contour(mclab2, contour_color[2]);
  c3 = new Contour(mclab3, contour_color[3]);
  c4 = new Contour(mclab4, contour_color[4]);
  c5 = new Contour(mclab5, contour_color[5]);
  c6 = new Contour(mclab6, contour_color[6]);
  c7 = new Contour(mclab7, contour_color[7]);
  c8 = new Contour(mclab8, contour_color[8]);
  c9 = new Contour(mclab9, contour_color[9]);

  total_labs = index_occ_lab.getRowCount();
}

void createNodes() {

  nodes.clear();

  for (TableRow row : index_occ_mot_cle.rows()) {
    int idx   = row.getInt(0);
    String mc = row.getString(1);
    int occ   = row.getInt(2);
    nodes.add(new Node(idx, width/2 + random(-200, 200), height/2 + random(-200, 200), 8 * occ, 2, mc, node_radius));
  }

  for (TableRow row : index_occ_personne.rows()) {
    int idx     = row.getInt(0);
    String pers = row.getString(1);
    int occ     = row.getInt(2);
    nodes.add(new Node(idx, width/2 + random(-200, 200), height/2 + random(-200, 200), 10, 3, pers, node_radius));
  }

  for (TableRow row : index_occ_lab.rows()) {
    int idx     = row.getInt(0);
    String lab  = row.getString(1);
    int occ     = row.getInt(2);
    nodes.add(new Node(idx, width/2 + random(-200, 200), height/2 + random(-200, 200), 3 * occ, 1, lab, node_radius));
  }

  for (TableRow row : index_cnd.rows()) {
    int idx     = row.getInt(0);
    String cnd  = row.getString(1);
    nodes.add(new Node(idx, width/2 + random(-200, 200), height/2 + random(-200, 200), 10, 4, str(idx), node_radius));
  }
}

void createHulls() {
  // Créer une intList pour chacun des labs contenant les id des mot clés
  for (TableRow row : lien_motcle_lab.rows()) {
    int idxmc   = row.getInt(0);
    int idxlab  = row.getInt(1);
    if (idxlab == 0) mclab0.append(idxmc);
    if (idxlab == 1) mclab1.append(idxmc);
    if (idxlab == 2) mclab2.append(idxmc);
    if (idxlab == 3) mclab3.append(idxmc);
    if (idxlab == 4) mclab4.append(idxmc);
    if (idxlab == 5) mclab5.append(idxmc);
    if (idxlab == 6) mclab6.append(idxmc);
    if (idxlab == 7) mclab7.append(idxmc);
    if (idxlab == 8) mclab8.append(idxmc);
    if (idxlab == 9) mclab9.append(idxmc);
  }
}

void createSprings() {

  springs.clear(); // Vider l'arraylist

  // Liens mot-clé / lab
  if (lien_motcle_lab_active && node_motcle_active && node_lab_active) {
    for (TableRow row : lien_motcle_lab.rows()) {
      int idxmc   = row.getInt(0);
      int idxlab  = row.getInt(1);
      int occ     = row.getInt(2);
      // Chercher le mot clé
      for (Node nfrom : nodes) {
        if (nfrom.type == 2 && nfrom.id == idxmc) {
          for (Node nto : nodes) {
            if (nto.type == 1 && nto.id == idxlab) {
              Spring newSpring = new Spring( nfrom, nto, occ, mc_lab_length, spring_damping, spring_stiffness, 1 );
              springs.add(newSpring);
            }
          }
        }
      }
    }
  }

  // Liens mot-clé / motcle
  if (lien_motcle_motcle_active && node_motcle_active) {
    for (TableRow row : lien_motcle_motcle.rows()) {
      int idxmc1  = row.getInt(0);
      int idxmc2  = row.getInt(1);
      int occ     = row.getInt(2);
      // Chercher le mot clé
      for (Node nfrom : nodes) {
        if (nfrom.type == 2 && nfrom.id == idxmc1) {
          for (Node nto : nodes) {
            if (nto.type == 2 && nto.id == idxmc2) {
              if (nto.active && nfrom.active) {
                Spring newSpring = new Spring( nfrom, nto, occ, mc_mc_length, spring_damping, spring_stiffness, 2 );
                springs.add(newSpring);
              }
            }
          }
        }
      }
    }
  }

  // Liens mot-clé / personne
  if (lien_motcle_personne_active && node_motcle_active && node_personne_active) {
    for (TableRow row : lien_motcle_personne.rows()) {
      int idxmc   = row.getInt(0);
      int idxpers = row.getInt(1);
      int occ     = row.getInt(2);
      // Chercher le mot clé
      for (Node nfrom : nodes) {
        if (nfrom.type == 2 && nfrom.id == idxmc) {
          for (Node nto : nodes) {
            if (nto.type == 3 && nto.id == idxpers) {
              if (nto.active && nfrom.active) {
                Spring newSpring = new Spring( nfrom, nto, occ, mc_pers_length, spring_damping, spring_stiffness, 3 );
                springs.add(newSpring);
              }
            }
          }
        }
      }
    }
  }

  // Liens lab / personne
  if (lien_lab_personne_active && node_lab_active && node_personne_active) {
    for (TableRow row : lien_lab_personne.rows()) {
      int idxlab  = row.getInt(0);
      int idxpers = row.getInt(1);
      int occ     = row.getInt(2);
      // Chercher le mot clé
      for (Node nfrom : nodes) {
        if (nfrom.type == 1 && nfrom.id == idxlab) {
          for (Node nto : nodes) {
            if (nto.type == 3 && nto.id == idxpers) {
              if (nto.active && nfrom.active) {
                Spring newSpring = new Spring( nfrom, nto, occ, lab_pers_length, spring_damping, spring_stiffness, 4 );
                springs.add(newSpring);
              }
            }
          }
        }
      }
    }
  }

  // Liens CND / lab
  if (lien_cnd_lab_active && node_cnd_active && node_lab_active) {
    for (TableRow row : lien_cnd_lab.rows()) {
      int idxcnd  = row.getInt(0);
      int idxlab = row.getInt(1);
      int occ     = row.getInt(2);
      // Chercher le mot clé
      for (Node nfrom : nodes) {
        if (nfrom.type == 4 && nfrom.id == idxcnd) {
          for (Node nto : nodes) {
            if (nto.type == 1 && nto.id == idxlab) {
              if (nto.active && nfrom.active) {
                Spring newSpring = new Spring( nfrom, nto, occ, cnd_lab_length, spring_damping, spring_stiffness, 5 );
                springs.add(newSpring);
              }
            }
          }
        }
      }
    }
  }

  // Liens CND / mot clé
  if (lien_cnd_motcle_active && node_cnd_active && node_motcle_active) {
    for (TableRow row : lien_cnd_motcle.rows()) {
      int idxcnd  = row.getInt(0);
      int idxmc   = row.getInt(1);
      int occ     = row.getInt(2);
      // Chercher le mot clé
      for (Node nfrom : nodes) {
        if (nfrom.type == 4 && nfrom.id == idxcnd) {
          for (Node nto : nodes) {
            if (nto.type == 2 && nto.id == idxmc) {
              if (nto.active && nfrom.active) {
                Spring newSpring = new Spring( nfrom, nto, occ, cnd_motcle_length, spring_damping, spring_stiffness, 6 );
                springs.add(newSpring);
              }
            }
          }
        }
      }
    }
  }

  // Liens CND / personne
  if (lien_cnd_personne_active && node_cnd_active && node_personne_active) {
    for (TableRow row : lien_cnd_personne.rows()) {
      int idxcnd  = row.getInt(0);
      int idxpers = row.getInt(1);
      int occ     = row.getInt(2);
      // Chercher le mot clé
      for (Node nfrom : nodes) {
        if (nfrom.type == 4 && nfrom.id == idxcnd) {
          for (Node nto : nodes) {
            if (nto.type == 3 && nto.id == idxpers) {
              if (nto.active && nfrom.active) {
                Spring newSpring = new Spring( nfrom, nto, occ, cnd_personne_length, spring_damping, spring_stiffness, 7 );
                springs.add(newSpring);
              }
            }
          }
        }
      }
    }
  }
}

void afficherParametres(float sx, float sy) {
  float lng_ml=0, lng_mm=0, lng_mp=0, lng_lp=0, lng_cl=0, lng_cm=0, lng_cp=0;
  float opa_ml=0, opa_mm=0, opa_mp=0, opa_lp=0, opa_cl=0, opa_cm=0, opa_cp=0;
  String act_ml, act_mm, act_mp, act_lp, act_cl, act_cm, act_cp;
  String act_nlab, act_ncnd, act_nper, act_nmot;

  textFont(param_font);
  textSize(text_size_param);
  textAlign(LEFT, BOTTOM);
  fill(0);

  for (Spring s : springs) {
    if (s.nodetype == 1) {
      lng_ml = s.springlength;
      opa_ml = s.opacite;
    }
    if (s.nodetype == 2) {
      lng_mm = s.springlength;
      opa_mm = s.opacite;
    }
    if (s.nodetype == 3) {
      lng_mp = s.springlength;
      opa_mp = s.opacite;
    }
    if (s.nodetype == 4) {
      lng_lp = s.springlength;
      opa_lp = s.opacite;
    }
    if (s.nodetype == 5) {
      lng_cl = s.springlength;
      opa_cl = s.opacite;
    }
    if (s.nodetype == 6) {
      lng_cm = s.springlength;
      opa_cm = s.opacite;
    }
    if (s.nodetype == 7) {
      lng_cp = s.springlength;
      opa_cp = s.opacite;
    }
  }

  act_ml = (lien_motcle_lab_active)      ? " on" : "off";
  act_mm = (lien_motcle_motcle_active)   ? " on" : "off";
  act_mp = (lien_motcle_personne_active) ? " on" : "off";
  act_lp = (lien_lab_personne_active)    ? " on" : "off";
  act_cl = (lien_cnd_lab_active)         ? " on" : "off";
  act_cm = (lien_cnd_motcle_active)      ? " on" : "off";
  act_cp = (lien_cnd_personne_active)    ? " on" : "off";

  text("motcle_lab    : " + act_ml + " | l: " + nfs(int(lng_ml), 4) + " | o: " + nfs(int(opa_ml), 3), sx, sy + 1 * text_size_param);
  text("motcle_motcle : " + act_mm + " | l: " + nfs(int(lng_mm), 4) + " | o: " + nfs(int(opa_mm), 3), sx, sy + 2 * text_size_param);
  text("motcle_pers   : " + act_mp + " | l: " + nfs(int(lng_mp), 4) + " | o: " + nfs(int(opa_mp), 3), sx, sy + 3 * text_size_param);
  text("lab_pers      : " + act_lp + " | l: " + nfs(int(lng_mp), 4) + " | o: " + nfs(int(opa_mp), 3), sx, sy + 4 * text_size_param);
  text("cnd_lab       : " + act_cl + " | l: " + nfs(int(lng_cl), 4) + " | o: " + nfs(int(opa_cl), 3), sx, sy + 5 * text_size_param);
  text("cnd_motcle    : " + act_cm + " | l: " + nfs(int(lng_cm), 4) + " | o: " + nfs(int(opa_cm), 3), sx, sy + 6 * text_size_param);
  text("cnd_pers      : " + act_cp + " | l: " + nfs(int(lng_cp), 4) + " | o: " + nfs(int(opa_cp), 3), sx, sy + 7 * text_size_param);

  act_nlab = (node_lab_active)      ? " on" : "off";
  act_ncnd = (node_cnd_active)      ? " on" : "off";
  act_nper = (node_personne_active) ? " on" : "off";
  act_nmot = (node_motcle_active)   ? " on" : "off";

  text("spring damping   : " + springs.get(0).damping, sx, sy +  9 * text_size_param);
  text("spring stiffness : " + springs.get(0).stiffness, sx, sy + 10 * text_size_param);
  text("node damping     : " + nodes.get(0).damping, sx, sy + 11 * text_size_param);
  text("node strength    : " + nodes.get(0).strength, sx, sy + 12 * text_size_param);
  text("node ramp        : " + nodes.get(0).ramp, sx, sy + 13 * text_size_param);
  text("node radius      : " + nodes.get(0).radius, sx, sy + 14 * text_size_param);

  text("node lab         : " + act_nlab, sx, sy + 16 * text_size_param);
  text("node cnd         : " + act_ncnd, sx, sy + 17 * text_size_param);
  text("node personne    : " + act_nper, sx, sy + 18 * text_size_param);
  text("node mot cle     : " + act_nmot, sx, sy + 19 * text_size_param);

  text("view zoom        : " + wo_z, sx, sy + 21 * text_size_param);
  text("font_size        : " + text_size, sx, sy + 22 * text_size_param);
  text("offset_x         : " + wo_x, sx, sy + 23 * text_size_param);
  text("offset_y         : " + wo_y, sx, sy + 24 * text_size_param);
}

void afficherLegende(float sx, float sy) {
  int cmpt = 0;
  textFont(param_font);
  textSize(text_size_param * psm);
  textAlign(LEFT, BOTTOM);
  fill(0);

  for (TableRow row : index_cnd.rows()) {
    int idx     = row.getInt(0);
    String cnd  = row.getString(1);
    //println(idx + " : " + cnd);
    text(nfs(idx, 2) + " : " + cnd, sx, sy + (cmpt * text_size_param));
    cmpt ++;
  }
}


void keyPressed() {
  if (key == ' ') fishEyeView = !fishEyeView;
  if (key == 'c') contour_visible = !contour_visible;
  if (key == 'p') parametres_visibles = !parametres_visibles;
  if (key == 'v') export_pdf = true;
  if (key == 'g') export_svg = true;
  if (key == 's') {
    Date now = new Date();
    SimpleDateFormat formater = new SimpleDateFormat("yyyyMMdd_HHmmss");
    System.out.println(formater.format(now));
    saveFrame(SKETCH_NAME + "_" + "CND_" + dossier + "_" + formater.format(now) + ".png");
  }
  if (key == CODED) {
    if (keyCode == UP)    leg_y --;
    if (keyCode == DOWN)  leg_y ++;
    if (keyCode == LEFT)  leg_x --;
    if (keyCode == RIGHT) leg_x ++;
  }
}

void mousePressed() {
  nodeMoveMode = false;
  windowOffsetMode = false;
  for (int i = 0; i < this.nodes.size(); i++) {
    Node node = this.nodes.get(i);
    // ((pos.x + wo_x) * wo_z, (pos.y + wo_y) * wo_z);
    if ( dist(mouseX, mouseY, (node.pos.x + wo_x) * wo_z, (node.pos.y + wo_y) * wo_z) < 10) {
      node.lockedMode = true;
      nodeMoveMode = true;
    }
  }
  if (!nodeMoveMode) {
    windowOffsetMode = true;
    wo_last_x = mouseX;
    wo_last_y = mouseY;
  }
}

void mouseReleased() {
  for (int i = 0; i < this.nodes.size(); i++) {
    Node node = this.nodes.get(i);
    node.lockedMode = false;
  }
  if (windowOffsetMode) {
    windowOffsetMode = false;
    // Mettre à jour les coordonnées d'offset
    wo_x += mouseX - wo_last_x;
    wo_y += mouseY - wo_last_y;
    println("offset : x : " + wo_x + " : y : " + wo_y);
  }
}
