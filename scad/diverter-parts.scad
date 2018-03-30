/* common parts used by the diverter */

include <globs.scad>;

diverter_width = (columns_per_block-1)*pitch+channel_width;

module diverter_cutout() {
    clearance = 1;
    translate([ejector_xpos(0)-channel_width/2-clearance, -clearance]) square([diverter_width+clearance*2,31+clearance*2]);
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
  translate([0, -20, 4]) color([0.7,0.7,0.7]) linear_extrude(height=3) diverter_2d();
  translate([ejector_xpos(0)+channel_width/2,0,0]) rotate([0,90,0]) linear_extrude(height=3) diverter_rotate_arm_2d();
  translate([ejector_xpos(7)-channel_width/2-3,0,0]) rotate([0,90,0]) linear_extrude(height=3) diverter_rotate_arm_2d();
  for(c=[1:columns-1]) {
    if(c<columns-1) color([0,1,0]) translate([ejector_xpos(c)-channel_width/2-3,-0,7]) rotate([0,90,0]) rotate([0,0,90])  translate([-15,-3,0]) linear_extrude(height=3) diverter_rib_2d();
    if(c>1) color([0,1,0]) translate([ejector_xpos(c-1)+channel_width/2,-0,7]) rotate([0,90,0]) rotate([0,0,90])  translate([-15,-3,0]) linear_extrude(height=3) diverter_rib_2d();
  }
}
