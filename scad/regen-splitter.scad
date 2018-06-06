/* Coimbination regenerator & splitter unit for atachment below memory. */

include <globs.scad>;
include <diverter-parts.scad>;
include <regenerator.scad>;

$fn=20;
explode = 0;

diverter_y = [50,100,270];

support_tab_x = [ 10, 200];
pusher_support_x = [ 30,170];
module baseplate_2d()
{
  difference() {
    square([220, 310]);
    for(y=diverter_y) {
      translate([0,y]) diverter_cutout();
      for(x=support_tab_x) translate([x,y]) square([3,30]);
    }

  }
}

module top_plate_2d()
{
  difference() {
    square([220, 310]);
    for(y=diverter_y) {
      translate([0,y]) diverter_cutout();
      for(x=support_tab_x) translate([x,y]) square([3,30]);
    }

    // Cutout for pusher supports
    for(x=support_tab_x) translate([x,140]) square([3,30]);

  }
}

module pusher_support_2d() {
  difference() {
    union() {
      translate([-2,0]) square([25,30]);
      translate([3,-3]) square([5,36]);
    }
    translate([18,17]) circle(d=3);
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
    translate([208,y+20,17]) rotate([0,180,0]) centred_diverter_assembly();
  }
  for(x=support_tab_x) {
    color([1.0,0.4,0.5]) translate([x+3,140,10]) rotate([0,-90,0]) linear_extrude(height=3) pusher_support_2d();
  }

  for(y=diverter_y) {
    translate([0,y+20,17]) rotate([0,90,0]) cylinder(d=3,h=250);
  }
  translate([0,160-3,28]) rotate([0,90,0]) cylinder(d=3,h=250);

}

3d_assembly();
