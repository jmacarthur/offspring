include <memory-sender.scad>;
3d_assembly = false;

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

translate([160,0])  {
  translate([0,140]) sender_triangle_bracket_2d();
  translate([0,210]) sender_triangle_bracket_2d();
}

translate([200,0])  {
  translate([0,15]) inner_intake_plate_2d();
  translate([70,0]) outer_intake_plate_2d();
  translate([0,50]) sender_base_plate_2d();

  translate([24,58]) bowden_cable_support_2d();
  translate([24,80]) bowden_cable_outer_2d();

}

translate([150,80]) bowden_cable_outer_2d();


translate([130,0]) {
  translate([0,0]) hanger_plate_2d();
  translate([0,20]) hanger_plate_2d();
  for(y=[0:3]) {
    translate([0,40+y*10]) hanger_side_plate_2d();
  }
  translate([0,80]) drive_lever_support_2d();
}
