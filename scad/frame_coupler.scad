// Simple plate to join perforated angle iron to openbeam

xcoords = [0, 27];
ycoords = [0, 20];

module coupler_2d() {
  difference() {
    hull() {
      for(y=ycoords) {
	translate([xcoords[0], y]) circle(d=15);
	translate([xcoords[1], y]) circle(d=10);
      }
    }
    for(y=ycoords) {
      translate([xcoords[0], y]) circle(d=6.4);
      translate([xcoords[1], y]) circle(d=3.2);
    }
  }
}
$fn=20;
linear_extrude(height=5) coupler_2d();
