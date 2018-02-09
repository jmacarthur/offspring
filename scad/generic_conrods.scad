// Generic conrods

module conrod(length) {
  difference() {
    union() {
      translate([0,-5]) square([length,10]);
      circle(d=10);
      translate([length,0]) circle(d=10);
    }
    circle(d=3);
    translate([length,0]) circle(d=3);
  }
}
