/* common parts used by the diverter */

include <globs.scad>;

diverter_width = (columns_per_block-1)*pitch+channel_width;
diverted_support_slots = [25, 25+195];

// diverter_cutout and centred_diverter_assemble are centred in the X axis so 0 is the
// central division between bits 4 and 5.

module diverter_cutout() {
    clearance = 1;
    cutout_width = diverter_width+clearance*2;
    translate([-cutout_width/2, -clearance]) square([cutout_width,31+clearance*2]);
}

module diverter_2d() {
  difference() {
    translate([20,0]) square([diverter_width,30]);
    for(c=[0:columns_per_block-1]) {
      translate([ejector_xpos(c) + channel_width/2,5]) square([3,20]);
      translate([ejector_xpos(c+1) - channel_width/2-3,5]) square([3,20]);
    }
  }
}

module diverter_rotate_arm_2d() {
  translate([-10,-15]) {
    difference() {
      union() {
	translate([10,10]) square([30,10]);
	square([15,20]);
	translate([0,-3]) polygon([[0,3], [3,1], [3,26], [0,23]]);
      }
      translate([10,15]) circle(d=3); // Axle hole
      translate([20,10]) circle(d=3); // Notch for spring return
      translate([35,15]) circle(d=3); // Notch for drive
    }
  }
}

module diverter_rib_2d() {
  union() {
    square([20,4]);
    polygon([[-2,3], [5,10], [15,10], [23,3]]);
  }
}

module centred_diverter_assembly() {
  columns = columns_per_block;
  translate([-20-diverter_width/2,0,0]) {
    translate([0, -20, 4]) color([0.7,0.7,0.7]) linear_extrude(height=3) diverter_2d();
    translate([ejector_xpos(0)+channel_width/2,0,0]) rotate([0,90,0]) linear_extrude(height=3) diverter_rotate_arm_2d();
    translate([ejector_xpos(7)-channel_width/2-3,0,0]) rotate([0,90,0]) linear_extrude(height=3) diverter_rotate_arm_2d();
    for(c=[1:columns-1]) {
      if(c<columns-1) color([0,1,0]) translate([ejector_xpos(c)-channel_width/2-3,-0,7]) rotate([0,90,0]) rotate([0,0,90])  translate([-15,-3,0]) linear_extrude(height=3) diverter_rib_2d();
      if(c>1) color([0,1,0]) translate([ejector_xpos(c-1)+channel_width/2,-0,7]) rotate([0,90,0]) rotate([0,0,90])  translate([-15,-3,0]) linear_extrude(height=3) diverter_rib_2d();
    }
  }
}


// Output supports which can be used to take output out into plastic pipes

module diverted_output_support_2d() {
  difference() {
    union() {
      translate([0,-5]) square([20,30]);
      translate([-3,0]) square([23,20]);
      translate([0,20]) square([30,5]);
    }
    translate([20,8]) rotate(180-10) translate([-3,0]) square([13,3]);
  }
}

module diverted_output_slope_2d() {
  difference() {
    union() {
      square([210,20]);
      translate([20,0]) square([168,25]);
    }
    for(x=diverted_support_slots) {
      translate([x-20,13]) square([3,10]);
    }
    for(i=[0:7]) {
      translate([ejector_xpos(i)+6,20]) rotate(180-20) translate([0,5]) square([3,10]);
    }
  }
}

module diverted_output_pipeplate_2d() {
  difference() {
    translate([0,-5]) square([210,25]);
    for(i=[0:7]) {
      translate([ejector_xpos(i)-12,pipe_inner_diameter/2-1]) circle(d=pipe_outer_diameter);
    }
    for(x=diverted_support_slots) {
      translate([x-20,12]) square([3,5]);
    }
  }
}

module diverted_separator_plate_2d() {
  union() {
    square([10,10]);
    translate([-8,3]) square([22,10]);
  }
}

module 3d_diverted_assembly() {
  for(x=diverted_support_slots) {
    translate([x,0,0]) vertical_plate_y() diverted_output_support_2d();
  }
  for(i=[1:8]) translate([ejector_xpos(i),0,0]) rotate([-10,0,0]) rotate([0,0,20]) translate([0,5,8]) vertical_plate_y() diverted_separator_plate_2d();
  color([0.4,0.4,0.4]) translate([20,20,8]) rotate([170,0,0]) translate([0,-3,0]) horizontal_plate() diverted_output_slope_2d();

  translate([20,26,8]) vertical_plate_x() diverted_output_pipeplate_2d();
}
