/* Coimbination regenerator & splitter unit for atachment below memory. */

include <globs.scad>;
include <diverter-parts.scad>;
include <regenerator.scad>;

$fn=20;
explode = 0;

diverter_y = [50,100,270];

support_tab_x = [ 10, 200];
pusher_support_x = [ 30,170];

channel0_pos_x = 30+7.5;

centre_line_x = channel0_pos_x +pitch*3.5;


module baseplate_2d()
{
  difference() {
    square([220, 297]);
    for(y=diverter_y) {
      translate([centre_line_x,y]) diverter_cutout();
      for(x=support_tab_x) translate([x,y]) square([3,30]);
    }
  }
}

module top_plate_2d()
{
  difference() {
    square([220, 310]);
    for(y=diverter_y) {
      translate([centre_line_x,y]) diverter_cutout();
      for(x=support_tab_x) translate([x,y]) square([3,30]);
    }
  }
}

module diverter_support_2d() {
  difference() {
    union() {
      translate([-2,0]) square([15,30]);
      translate([3,-3]) square([5,36]);
    }
    translate([7,20]) circle(d=3);
  }
}


module 3d_assembly() {
  translate([0,0,0]) linear_extrude(height=3) baseplate_2d();
  translate([0,0,10]) linear_extrude(height=3) top_plate_2d();
  for(y=diverter_y) {
    for(x=support_tab_x) {
      color([1.0,0.4,0.5]) translate([x+3,y,10]) rotate([0,-90,0]) linear_extrude(height=3) diverter_support_2d();
    }
    translate([centre_line_x,y+20,17]) rotate([0,180,0]) centred_diverter_assembly();
  }
  for(y=diverter_y) {
    translate([0,y+20,17]) rotate([0,90,0]) cylinder(d=3,h=250);
  }

}

3d_assembly();



// Illustrate centre lines
color([1.0,0,0]) translate([channel0_pos_x,0,0]) rotate([90,0,0]) cylinder(d=0.5,h=100);
color([1.0,0,0]) translate([centre_line_x,0,0]) rotate([90,0,0]) cylinder(d=0.5,h=100);
