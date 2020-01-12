include <globs.scad>;
use <subtractor-input.scad>;

slope = atan2(subtractor_pitch_y, subtractor_pitch_x);


kerf = 0.1;

offset(r=kerf) {

  translate([30,15]) rotate(-slope) input_adaptor_2d();
  translate([30,40]) rotate(-slope)  input_adaptor_2d();
}

