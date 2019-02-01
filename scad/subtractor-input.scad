// This is an input adaptor for the subtractor. This is designed for the older model subtractor (with sharp corners) but should work on the new one as well.

include <globs.scad>;

$fn = 20;

slope = atan2(subtractor_pitch_y, subtractor_pitch_x);
echo(slope);
module input_holes() {
  for(i=[0:7]) {
    translate([pitch*i, i*subtractor_pitch_y]) circle(d=pipe_outer_diameter);
  }
}

module divider_slots() {
  for(i=[0:8]) {
    translate([-pitch/2 + pitch*i, i*subtractor_pitch_y-subtractor_pitch_y/2]) rotate(30) square([3,10],center=true);
  }
}

module divider_2d() {
  union() {
    square([10,20],center=true);
    translate([0,-3.5]) {
      square([20,7],center=true);
    }
  }
}


module input_adaptor_2d() {
  difference() {
    offset(r=5) {
      hull() {
	input_holes();
	divider_slots();
      }
    }
    input_holes();
    divider_slots();
  }
}


module central_plate_2d() {
  difference() {
    offset(r=5) {
      hull() {
	divider_slots();
      }
    }
    divider_slots();
  }
}

linear_extrude(height=3) input_adaptor_2d();
translate([0,0,10]) linear_extrude(height=3) central_plate_2d();
for(i=[0:7]) {
  translate([pitch*i, subtractor_pitch_y*i, 0]) {
    translate([-pitch/2, -subtractor_pitch_y/2,10]) rotate([0,0,-60]) translate([0,1.5,0]) rotate([90,0,0]) color([1.0,0,0]) linear_extrude(height=3) divider_2d();
  }
 }

