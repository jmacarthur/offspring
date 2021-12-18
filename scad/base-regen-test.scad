use <base-regen.scad>;
$fn=50;

offset(r=0.05) {
  regen_input_coupler_2d();
  translate([20,0]) rotate(90) input_coupler_2d();
  translate([20,50]) input_arc_2d();

}
