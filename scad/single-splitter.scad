/* Coimbination regenerator & splitter unit for atachment below memory. */

include <globs.scad>;
include <diverter-parts.scad>;

$fn=20;
explode = 0;

diverter_y = [10];
support_tab_x = [20, 210];
pusher_support_x = [30, 170];

channel0_pos_x = 30+7.5;

centre_line_x = channel0_pos_x +pitch*3.5;
rail_centre_x = [7.5, 7.5+support_rail_separation];

double_splitter_height = 55;
double_splitter_width = support_rail_separation+15;

diverted_output_slope = 10;
diverted_support_slots = [25, 25+195];

module generic_splitter_cutouts() {
  for(y=diverter_y) {
    for(x=support_tab_x) translate([x,y]) square([3,30]);
    translate([centre_line_x,y]) diverter_cutout();
  }
}

module baseplate_2d()
{
  difference() {
    translate([0,-5]) square([double_splitter_width, double_splitter_height]);
    generic_splitter_cutouts();
    for(y=diverter_y) {
      for(x=rail_centre_x) translate([x,y+15]) circle(d=3);
      for(x=diverted_support_slots) translate([x-2,y-10]) square([3,20]);
    }
  }
}

module top_plate_2d()
{
  difference() {
    translate([0,-5]) square([double_splitter_width, double_splitter_height]);
    generic_splitter_cutouts();
    for(y=diverter_y) {
      for(x=rail_centre_x) translate([x,y+15]) circle(d=6);
    }
  }
}

module diverter_support_2d() {
  difference() {
    union() {
      translate([0,0]) square([22,30]);
      translate([3,-3]) square([7,36]);
    }
    translate([17,20]) circle(d=3);
  }
}


module 3d_assembly() {
  translate([0,0,0]) linear_extrude(height=3) baseplate_2d();
  translate([0,0,10]) linear_extrude(height=3) top_plate_2d();
  for(y=diverter_y) {
    for(x=support_tab_x) {
      color([1.0,0.4,0.5]) translate([x+3,y,0]) rotate([0,-90,0]) linear_extrude(height=3) diverter_support_2d();
    }
    translate([centre_line_x,y+20,17]) rotate([0,180,0]) centred_diverter_assembly();
  }
  for(y=diverter_y) {
    translate([0,y+20,17]) rotate([0,90,0]) cylinder(d=3,h=250);
  }

}

translate([-2,0,0]) rotate([-90,0,0]) 3d_diverted_assembly();

3d_assembly();



// Illustrate centre lines
color([1.0,0,0]) translate([channel0_pos_x,0,0]) rotate([90,0,0]) cylinder(d=0.5,h=100);
color([1.0,0,0]) translate([centre_line_x,0,0]) rotate([90,0,0]) cylinder(d=0.5,h=100);


// Support rails

color([0.5,0.5,0.5]) translate([0,0,-15]) cube([15,200,15]);
color([0.5,0.5,0.5]) translate([250,0,-15]) cube([15,200,15]);
