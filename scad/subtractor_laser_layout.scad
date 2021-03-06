include <globs.scad>;
use <subtractor.scad>;



// Sample A3 sheet

//color([0.1,0.1,0.1]) translate([0,0,-5]) square([420,297]);

kerf = 0.08;

offset(delta = kerf, chamfer = true) {


  // Support plates
  translate([270,40]) rotate(-50) top_layer_2d();
  translate([270,120]) rotate(-50) io_support_layer_2d();
  translate([270,200]) rotate(-50) back_layer_2d();

  // Various toggles - the 'top set'. All the toggles are in here,
  // in case we want to make them out of a different colour.

  translate([10,230]) {
    for(i=[0:3]) {
      translate([10+35*i,30]) input_toggle_2d();
      translate([20+35*i,55]) rotate(180) input_toggle_2d();
    }
    for(i=[0:7]) translate([185+20*i,30]) input_guard_a_2d(i==0);
    for(i=[0:7]) translate([20+45*i,110]) input_guard_b_2d(i==7);
    for(i=[0:3]) {
      translate([330+15*i,30]) output_toggle_2d();
      translate([330+7.5+15*i,60]) rotate(180) output_toggle_2d();
    }
    for(i=[0:7]) translate([175+20*i,25]) rotate(-10)reset_toggle_2d();
  }

  for(i=[0:3]) {
    translate([390,31+45*i]) rotate(90) output_guard_a_2d();
    translate([360,35+45*i]) rotate(270) output_guard_a_2d();
  }

  {
    translate([70, 370]) rotate(90) input_guard_top_2d();
    translate([70+80, 370]) rotate(90) output_guard_top_2d();
  }

  for(i=[0:1]) translate([350+20*i,180]) rotate(-50) reset_lever_2d();

  translate([420,30]) rotate(-51-90) reset_bar_2d();
}


