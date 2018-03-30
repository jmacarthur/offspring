/* common parts used by the diverter */

include <globs.scad>;

diverter_y = 15;
diverter_width = (columns_per_block-1)*pitch+channel_width;

module diverter_cutout() {
    clearance = 1;
    translate([ejector_xpos(0)-channel_width/2-clearance, diverter_y-clearance]) square([diverter_width+clearance*2,31+clearance*2]);
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
