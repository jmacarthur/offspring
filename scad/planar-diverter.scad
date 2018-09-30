// This is a planar diverter, which is meant to be "More 2D" than previous attempts.
// It's based on the version used in the Box2D simulation.

// This also includes the regenerator.

include <globs.scad>;
include <generic_conrods.scad>;

diverter_rotate = -10+20*$t;

module diverter_tab_2d(len) {
  difference() {
    union() {
      intersection() {
	translate([0,-5]) square([len+10,10]);
	translate([0,0]) circle(r=len+5);
      }
      polygon([[0,0], [len+5,0], [len+4,-5-3]]);
      translate([0,0]) circle(d=10);
    }
    translate([0,0]) circle(d=3);
    translate([len,0]) circle(d=3);
  }
}

module diverter_array_2d() {
  for(i=[0:7]) {
    translate([0,i*pitch])
      rotate(diverter_rotate) diverter_tab_2d(30);
  }
}

module base_plate_2d()
{
  difference() {
    square([200,200]);
    for(i=[0:7]) {
      // Diverter axle
      translate([10,10+pitch*i]) circle(d=3);
      // Output holes
      translate([42,15+pitch*i]) circle(d=8);
    }
  }
}

module exit_plate_2d()
{
  difference() {
    square([20,200]);
    for(i=[0:7]) {
      translate([15,26+pitch*i]) circle(d=8);
      translate([15,26+pitch*i-4]) square([8,8]);
    }
  }
}


module planar_diverter_assembly()
{  
  linear_extrude(height=3) diverter_array_2d();
  color([0.5,0.5,0.5]) translate([-10,-10,-5]) linear_extrude(height=3) base_plate_2d();
  translate([36,-10,20]) rotate([0,90,0]) linear_extrude(height=3) exit_plate_2d();
}

planar_diverter_assembly();

