include <globs.scad>;
use <subtractor.scad>;



// Sample A3 sheet

//color([0.1,0.1,0.1]) translate([0,0,-5]) square([420,297]);

kerf = 0.1;

offset(delta = kerf, chamfer = true) {
  // Support plates
  translate([270,40]) rotate(-51) top_layer_2d();
  translate([270,110]) rotate(-51) io_support_layer_2d();
  translate([270,180]) rotate(-51) back_layer_2d();

  // Various toggles - the 'top set'. All the toggles are in here,
  // in case we want to make them out of a different colour.

  translate([10,200]) {
    for(i=[0:7]) translate([30+45*i,45]) rotate(90) input_guard_a_2d();
    for(i=[0:7]) translate([20+45*i,70]) input_guard_b_2d();
  }

  for(i=[0:3]) {
    translate([360,30+45*i]) rotate(90) output_guard_a_2d();
    translate([340,30+45*i]) rotate(270) output_guard_a_2d();
  }
}


include <memory-sender.scad>;
3d_assembly = false;

offset(delta=kerf, chamfer=true) {

  translate([390,0]) {

    for(bit=[0:4]) {
      translate([25*bit,0]) {
	translate([0,0]) hook_plate_2d();
	translate([0,60]) hook_plate_2d();
	// and the joining piece
	translate([3,115]) hook_joiner_2d();
	translate([0,160]) intake_slope_2d();
	translate([0,180]) intake_slope_2d();
      }
    }
    translate([5,210]) drive_lever_2d();

    for(bit=[0:3]) {
      translate([50,230+15*bit]) {
	short_sender_drive_lever_2d();
      }
    }

    translate([190,85]) rotate(-90) long_sender_drive_lever_2d();



    translate([150,80]) bowden_cable_outer_2d();


    translate([130,0]) {
      translate([0,0]) hanger_plate_2d();
      translate([0,20]) hanger_plate_2d();
      for(y=[0:3]) {
	translate([0,40+y*10]) hanger_side_plate_2d();
      }
      translate([0,80]) drive_lever_support_2d();
    }

    translate([-80,190]) lever_coupler_2d();
  }

  translate([50,280])  {
    translate([0,0]) sender_triangle_bracket_2d();
    translate([100,0]) sender_triangle_bracket_2d();
  }

  translate([240,230])  {
    translate([0,50]) sender_base_plate_2d();
    translate([24,58]) bowden_cable_support_2d();
    translate([24,80]) bowden_cable_outer_2d();
  }

  translate([380,290]) {
    translate([0,15]) inner_intake_plate_2d();
    translate([70,0]) outer_intake_plate_2d();
  }
}

// example acrylic

color([0.5,0.5,0.7,0.5]) translate([0,0,-6]) cube([600,400,3]);
