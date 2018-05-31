// Memory address sender, v2. This version does not pull down the memory
// decoder rods, but relies on them falling through gravity.
// This only works if there is an external rod raiser on the decoder.

include <globs.scad>;

memory_rod_spacing = 10;

$fn=20;

function channel_centre_ypos(i) = i*memory_rod_spacing+10;
function separator_centre_ypos(i) = i*memory_rod_spacing+10-5;
// If at zero, the toggle with rest straight up, which is unstable
toggle_axis_offset = 2;
// Intake grid

module intake_grid_2d() {  
  adjust = 0.5;
  hole_diameter = pipe_outer_diameter+adjust;
  difference() {
    square([60,50]);
    for(i=[0:4]) {
      translate([channel_centre_ypos(i), 20+hole_diameter/2+8*(i%2)]) circle(d=hole_diameter);
      translate([channel_centre_ypos(i)-1.5,10]) square([3,10]);
    }
  }
}

// Slope in

module sender_slope_2d()
{
  difference() {
    union() {
      polygon([[0,0], [20,0], [30,10], [0,10]]);
      square([10,20]);
      translate([-3,10]) square([4,10]);
    }
    translate([10,20]) circle(d=20);
  }
}


module sender_separator_2d() {
  difference() {
    union() {
      square([30,30]);
      translate([0,-10]) square([60,20]);
      translate([50,9]) square([10,4]);
    }
    translate([35+toggle_axis_offset,-5]) circle(d=3);
    translate([channel_width, 25]) square([3,5+1]);
  }
}

module sender_input_comb_2d() {
  difference() {
    square([60,20]);
    for(i=[0:4]) {
      translate([separator_centre_ypos(i)-1.5, -1]) square([3,5+1]);
    }
  }
}

module sender_toggle_2d() {
  difference() {
    union() {
      circle(d=10);
      translate([-5,0]) square([10,30]);
    }
    circle(d=3);
  }
}

module 3d_sender_assembly() {
  vertical_plate_y() intake_grid_2d();
  for(i=[0:4]) color([1.0,0,0]) translate([3,channel_centre_ypos(i)-1.5+3,0]) vertical_plate_x() sender_slope_2d();
  for(i=[0:5]) color([0,1.0,0]) translate([3,separator_centre_ypos(i)-1.5+3,0]) vertical_plate_x() sender_separator_2d();
  translate([3+channel_width,0,20]) vertical_plate_y() sender_input_comb_2d();
  for(i=[0:4]) color([1.0,1.0,0]) translate([35+3+toggle_axis_offset,channel_centre_ypos(i)-1.5+3,-5]) vertical_plate_x() sender_toggle_2d();
}

3d_sender_assembly();
