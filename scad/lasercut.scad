/* Laser cutting layout for memory injector */

include <globs.scad>;
use <memory-injector.scad>;

$fn = 20;
kerf = 0.1;

module ejector_pair() {
  ejector_plate_2d();
  translate([35,15]) rotate(180) ejector_plate_2d();
}

offset(delta = kerf, chamfer = true) {

  for(y=[0:3]) {
    translate([-20*y,-70*y])
      for(x=[0:3]) {
	translate([x*105, x*30]) ejector_pair();
      }
  }

  for(x=[0:1]) {
    translate([x*130,200]) support_2d();
    translate([x*130+130,235]) rotate(180) support_2d();
  }

  translate([0,300]) base_plate_2d();
  translate([450,0]) comb_2d();
  translate([150,500]) pipe_holder_bar_2d();
  translate([150,530]) pipe_holder_bar_2d();
}
