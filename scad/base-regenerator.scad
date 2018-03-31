/* Regenerator unit for atachment below subtractor. */

include <globs.scad>;
include <regenerator.scad>;

$fn=20;
explode = 0;

support_tab_x = [ 10, 200];
pusher_support_x = [ 30,170];

regen_start_y = 100;

module generic_plate_2d()
{
  difference() {
    square([220, 150]);

    // cutouts for ribs
    for(c=[0:7]) {
      top_y = 40;
      bottom_y = -10;
      for(y=[top_y,bottom_y]) {
	slot_size = (y==top_y) ? 20:10;
	translate([ejector_xpos(c)-channel_width/2-3,regen_start_y+y]) square([3,slot_size]);
	translate([ejector_xpos(c)+channel_width/2,regen_start_y+y]) square([3,slot_size]);
      }
    }
  }
}

module baseplate_2d()
{
  difference() {
    generic_plate_2d();
    // cutouts for actuator arms
    for(c=[0:7]) {
      clearance = 0.5;
      translate([ejector_xpos(c)-1.5-clearance,regen_start_y+3]) square([3+clearance*2,20]);
    }
  }
}

module top_plate_2d()
{
  difference() {
    generic_plate_2d();

    // Cutout for regen
    translate([15,regen_start_y+5]) square([190,30]);

    // Cutout for pusher supports
    for(x=support_tab_x) translate([x,regen_start_y-80]) square([3,30]);

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

module 3d_assembly() {
  translate([0,0,0]) linear_extrude(height=3) baseplate_2d();
  translate([0,0,10]) color([0.5,0.5,0]) linear_extrude(height=3) top_plate_2d();

  for(x=support_tab_x) {
    color([1.0,0.4,0.5]) translate([x+3,regen_start_y-80,10]) rotate([0,-90,0]) linear_extrude(height=3) pusher_support_2d();
  }
  for(c=[0:7]) translate([ejector_xpos(c)-1.5, regen_start_y-25,-15]) rotate([0,90,0]) color([0,1.0,1.0]) linear_extrude(height=3) rotate(-$t*10) actuator_arm_2d();
  translate([20,regen_start_y+10,10+channel_width/2]) rotate([90,0,0]) linear_extrude(height=3) regen_pusher_2d(0);
  translate([20,regen_start_y+13,10+channel_width/2]) rotate([90,0,0]) linear_extrude(height=3) regen_pusher_2d(2);

  for(x=pusher_support_x) translate([x+20,regen_start_y-60-3,28]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) regen_swing_arm_2d();

  for(c=[0:7]) {
    translate([ejector_xpos(c)-channel_width/2,regen_start_y+50,3]) rotate([90,0,0]) rotate([0,-90,0]) linear_extrude(height=3) regen_rib_2d();
    translate([ejector_xpos(c)+channel_width/2+3,regen_start_y+50,3]) rotate([90,0,0]) rotate([0,-90,0]) linear_extrude(height=3) regen_rib_2d();
  }

  // Axles
  translate([0,regen_start_y-60-3,28]) rotate([0,90,0]) cylinder(d=3,h=250);

}

3d_assembly();


// Example data

translate([ejector_xpos(0), regen_start_y+8,13]) sphere(d=ball_bearing_diameter);
