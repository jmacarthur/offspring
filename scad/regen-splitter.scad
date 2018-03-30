/* Regenerator & splitter unit for atachment below memory. */

include <globs.scad>;
include <diverter-parts.scad>;
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

    // cutouts for actuator arms
    for(c=[0:7]) {
      clearance = 0.5;
      translate([ejector_xpos(c)-1.5-clearance,220+3]) square([3+clearance*2,20]);
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
    // Cutout for regen
    translate([15,220]) square([190,30]);

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



module regen_pusher_2d(extra_clearance) {
  difference() {
    square([180,20]);
    for(c=[0:7]) {
      translate([ejector_xpos(c)-20,0]) circle(d=channel_width+extra_clearance);
    }
    for(x=pusher_support_x) {
      translate([x, 10]) square([3,20]);
    }
  }
}


module regen_swing_arm_2d() {
  difference() {
    translate([-10,-7.5]) square([100,15]);
    translate([70,-8.5]) square([6,4]);
    circle(d=3);
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


module actuator_arm_2d() {
  difference() {
    union() {
      translate([-5,-5]) square([50,10]);
      translate([-5,-5]) square([10,35]);
      translate([-25,25]) polygon([[1,5], [10,5], [30,-10], [30,10], [10,20], [0,10]]);
    }
    circle(d=3);
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
  for(c=[0:7]) translate([ejector_xpos(c)-1.5, 195,-15]) rotate([0,90,0]) color([0,1.0,1.0]) linear_extrude(height=3) rotate(-$t*10) actuator_arm_2d();
  translate([20,230,10+channel_width/2]) rotate([90,0,0]) linear_extrude(height=3) regen_pusher_2d(0);
  translate([20,233,10+channel_width/2]) rotate([90,0,0]) linear_extrude(height=3) regen_pusher_2d(2);

  for(x=pusher_support_x) translate([x+20,160-3,28]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) regen_swing_arm_2d();

  for(y=diverter_y) {
    translate([0,y+20,17]) rotate([0,90,0]) cylinder(d=3,h=250);
  }
  translate([0,160-3,28]) rotate([0,90,0]) cylinder(d=3,h=250);

}

3d_assembly();
