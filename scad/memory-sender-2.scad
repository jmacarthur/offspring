// Memory address sender, v2. This version does not pull down the memory
// decoder rods, but relies on them falling through gravity.
// This only works if there is an external rod raiser on the decoder.

include <globs.scad>;
use <generic_conrods.scad>;
memory_rod_spacing = 10;

$fn=20;

function channel_centre_ypos(i) = i*memory_rod_spacing+10;
function separator_centre_ypos(i) = i*memory_rod_spacing+10-5;

top_tab_pos = [channel_centre_ypos(0), channel_centre_ypos(4)];
// If at zero, the toggle with rest straight up, which is unstable
toggle_axis_offset = 2;
// Intake grid

// -20 engaged, 5 idle
toggle_rotation = 5;

module intake_grid_2d() {  
  adjust = 0.5;
  hole_diameter = pipe_outer_diameter+adjust;
  difference() {
    square([60,50]);
    for(i=[0:4]) {
      translate([channel_centre_ypos(i), 20+hole_diameter/2+8*(i%2)]) circle(d=hole_diameter);
      translate([channel_centre_ypos(i)-1.5,10]) square([3,10]);
    }
    for(x=top_tab_pos) translate([x-2.5,40]) square([5,3]);
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
      square([channel_width,40]);
      translate([0,-10]) square([60,20]);
      translate([50,-13]) square([10,4]);
    }
    translate([35+toggle_axis_offset,-5]) circle(d=3);
    translate([channel_width, 25]) square([3,5+1]);
  }
}

module sender_input_comb_2d() {
  difference() {
    union() {
      square([60,20]);
      for(x=top_tab_pos) translate([x-2.5,20-1]) square([5,4]);
    }
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
    translate([-10,10]) circle(d=15);
  }
}

module sender_rod_2d() {
  union() {
    translate([3,0]) square([7,70]);
    polygon([[0,28],[3,26], [10,30], [10,70], [0,70]]);
  }
}

module sender_lower_output_comb_2d()
{
  clearance = 0.5;
  difference() {
    square([20,70]);
    offset(clearance) for(i=[0:4]) translate([8, channel_centre_ypos(i)-1.5]) square([7,3]); 
    for(i=[0:5]) translate([5, separator_centre_ypos(i)-1.5]) square([10,3]);
  }
}

module sender_top_plate_2d()
{
  clearance = 0.5;
  difference() {
    union() {
      square([70,60]);
      for(x=top_tab_pos) translate([-3,x-2.5]) square([4,5]);
    }
    for(x=top_tab_pos) translate([channel_width,x-2.5]) square([3,5]);
    offset(clearance) for(i=[0:4]) translate([50,channel_centre_ypos(i)-1.5]) square([10,3]);
  }
}

module sender_reset_arm_2d() {
  conrod(length=24);
}

module 3d_sender_assembly() {
  vertical_plate_y() intake_grid_2d();
  for(i=[0:4]) color([1.0,0,0]) translate([3,channel_centre_ypos(i)-1.5+3,0]) vertical_plate_x() sender_slope_2d();
  translate([3,0,0]) { // Account for thickness of first plate
    translate([channel_width,0,20]) vertical_plate_y() sender_input_comb_2d();
    //for(i=[0:5]) color([0,1.0,0]) translate([0,separator_centre_ypos(i)-1.5+3,0]) vertical_plate_x() sender_separator_2d();
    for(i=[0:4]) color([1.0,1.0,0]) translate([35+toggle_axis_offset,channel_centre_ypos(i)-1.5+3,-5]) vertical_plate_x() rotate(toggle_rotation) sender_toggle_2d();
    for(i=[0:4]) color([1.0,0,1.0]) translate([50,channel_centre_ypos(i)-1.5+3,-5]) vertical_plate_x() sender_rod_2d();
    translate([45,0,-13]) horizontal_plate() sender_lower_output_comb_2d();
    translate([0,0,40]) color([0.5,0.5,1.0]) horizontal_plate() sender_top_plate_2d();
    for(i=[-1,5]) color([1.0,1.0,0]) translate([35+toggle_axis_offset,channel_centre_ypos(i),-5]) vertical_plate_x() rotate(90-35) sender_reset_arm_2d();
    
  }
}

3d_sender_assembly();


translate([30+3+ball_bearing_radius,channel_centre_ypos(0),10]) sphere(d=ball_bearing_diameter);
