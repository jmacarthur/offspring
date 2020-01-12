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

module mounting_holes() {
  for(i=[1,7]) {
    translate([-pitch/2 + pitch*i, i*subtractor_pitch_y-subtractor_pitch_y/2]) circle(d=3);
  }
}


module input_adaptor_2d() {
  difference() {
    offset(r=5) {
      hull() {
	input_holes();
      }
    }
    input_holes();
    mounting_holes();
  }
}

linear_extrude(height=3) input_adaptor_2d();
translate([0,0,10]) linear_extrude(height=3) input_adaptor_2d();
