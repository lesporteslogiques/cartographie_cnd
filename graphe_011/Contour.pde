/*
  Algo. de Jarvis pour trouver les enveloppes convexes
  source : https://www.geeksforgeeks.org/convex-hull-using-jarvis-algorithm-or-wrapping/
*/


class Contour {

  IntList tous_les_id;
  ArrayList<Point> points = new ArrayList<Point>();
  Vector<Point> hull = new Vector<Point>();
  color contour_color;

  Contour(IntList _ids, color _c) {
    tous_les_id = _ids;
    contour_color = _c;
  }
  
  public void updateAndRender(float wo_x, float wo_y, float wo_z) {
    this.clean();
    this.make(nodes);
    this.hull();
    this.render(wo_x, wo_y, wo_z);
  }
  
  public void clean() {
    for (int i = points.size() - 1; i >= 0; i--) {
      Point p = points.get(i);
      points.remove(i);
    }
  }

  public void make(ArrayList<Node> nodes) {
    for (Node n : nodes) {
      if (n.type == 2 && tous_les_id.hasValue(n.id)) {
        //println("point added");
        points.add(new Point(int(n.pos.x), int(n.pos.y)));
      }
    }
  };

  public void hull() {
    int n = points.size();
    convexHull(points, n);
  }

  public void render(float wo_x, float wo_y, float wo_z) {
    int segs = hull.size();
    //println("c0 render, segs : " + segs);
    beginShape();
    fill(contour_color, 64);
    for ( int i = 0; i < segs; i++) {  
      float x1 = (hull.get(i).x*zoom + wo_x) * wo_z;
      float y1 = (hull.get(i).y*zoom + wo_y) * wo_z;
      int j = i+1;
      if ( j == segs ) j = 0;
      float x2 = (hull.get(j).x*zoom + wo_x) * wo_z;
      float y2 = (hull.get(j).y*zoom + wo_y) * wo_z;
      stroke(contour_color);
      strokeWeight(3);
      line(x1, y1, x2, y2);
      vertex(x1, y1);
    }
    endShape(CLOSE);
  }

    // To find orientation of ordered triplet (p, q, r).
    // The function returns following values
    // 0 --> p, q and r are colinear
    // 1 --> Clockwise
    // 2 --> Counterclockwise
    public int orientation(Point p, Point q, Point r) {
      int val = (q.y - p.y) * (r.x - q.x) -
        (q.x - p.x) * (r.y - q.y);

      if (val == 0) return 0; // collinear
      return (val > 0)? 1: 2; // clock or counterclock wise
    };




    // Prints convex hull of a set of n points.
    public void convexHull(ArrayList<Point> points, int n) {
      hull.clear();
      // There must be at least 3 points
      if (n < 3) return;

      // Initialize Result
      //Vector<Point> hull = new Vector<Point>();

      // Find the leftmost point
      int l = 0;
      for (int i = 1; i < n; i++)
        if (points.get(i).x < points.get(l).x)
          l = i;

      // Start from leftmost point, keep moving
      // counterclockwise until reach the start point
      // again. This loop runs O(h) times where h is
      // number of points in result or output.
      int p = l, q;
      do
      {
        // Add current point to result
        hull.add(points.get(p));

        // Search for a point 'q' such that
        // orientation(p, x, q) is counterclockwise
        // for all points 'x'. The idea is to keep
        // track of last visited most counterclock-
        // wise point in q. If any point 'i' is more
        // counterclock-wise than q, then update q.
        q = (p + 1) % n;

        for (int i = 0; i < n; i++) {
          // If i is more counterclockwise than
          // current q, then update q
          if (orientation(points.get(p), points.get(i), points.get(q))
            == 2)
            q = i;
        }

        // Now q is the most counterclockwise with
        // respect to p. Set p as q for next iteration,
        // so that q is added to result 'hull'
        p = q;
      }
      while (p != l); // While we don't come to first  // point

      // Print Result
      /*
    for (Point temp : hull)
       println("(" + temp.x + ", " + temp.y + ")");
       */
    };
  };
