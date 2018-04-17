/* Regenerator unit for atachment below subtractor. */

include <globs.scad>;
include <regenerator.scad>;

$fn=20;
explode = 0;

support_tab_x = [ 10, 200];
lower_support_tab_x = [ 30, 100, 170];
pusher_support_x = [ ejector_xpos(0)+pitch/2+1.5,ejector_xpos(4)+pitch/2+1.5];

regen_start_y = 85;

module generic_plate_2d()
{
  difference() {
    square([210, 135]);

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

    // Support bolts
    for(x=support_tab_x) {
      translate([x,10]) circle(d=3);
      translate([x,125]) circle(d=3);
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
    // Cutout for output supports
    for(x=support_tab_x) translate([x,regen_start_y-42]) square([3,30]);

    // Support for a very basic bias mechanism (rubber bands)
    translate([-1,regen_start_y-5]) square([4,5]);
    translate([-1,regen_start_y+5]) square([4,5]);
    translate([217,regen_start_y-5]) square([4,5]);
    translate([217,regen_start_y+5]) square([4,5]);

    // Slots to attach the actuator
    translate([ejector_xpos(3)+pitch/2-1.5,regen_start_y]) square([3,20]);
  }
}

clearance = 0.5; // For pusher stops


module top_plate_2d()
{
  difference() {
    generic_plate_2d();

    // Cutout for regen
    translate([15,regen_start_y+5]) square([180,30]);

    // Cutout for pusher supports
    for(x=lower_support_tab_x) translate([x,regen_start_y-75]) square([3,20]);

    // Cutout for pusher limiters
    for(x=pusher_support_x) {
      translate([x+10,regen_start_y-50]) square([10-clearance,3]);
      translate([x+23+clearance,regen_start_y-50]) square([10-clearance,3]);
      translate([x+10+3,regen_start_y-20]) square([3,5]);
    }
  }
}

module pusher_support_2d() {
  difference() {
    union() {
      translate([-7,5]) square([11,20]);
      translate([0,0]) polygon([[3,-3], [25,15], [25,20], [3,33]]);
    }
    translate([18,17]) circle(d=3);
  }
}


module output_support_2d() {
  difference() {
    union() {
      translate([-2,0]) square([6,30]);
      polygon([[3,-3], [25,15], [25,25], [3,33]]);
    }
    translate([18,17]) circle(d=3);
    translate([3,19]) square([10,3]);
  }
}

module stop_plate_2d() {
  difference() {
    union() {
      translate([0,-3]) square([10-clearance,30]);
      translate([-3,0]) square([16,3]);
      translate([10+3+clearance,-3]) square([10-clearance,30]);
      translate([10+clearance,0]) square([16,3]);
      translate([0,22.5]) square([20,4.5]);
      translate([5,25]) square([10+3,5]);
    }
    translate([3,15]) square([3,5]);
  }
}


module triagonal_support_2d() {
  union() {
    polygon([[0,0], [32,0], [32,20]]);
    translate([0,-3]) square([5,5]);
    translate([25,15]) square([10,5]);
  }
}


module regen_actuator_2d() {
  difference() {
    union() {
      square([30,30]);
      translate([0,5]) square([33,20]);
    }
    translate([5,10]) square([33,10]);
  }
}

module pusher_assembly() {
  translate([0,73,10+channel_width/2-28]) rotate([90,0,0]) linear_extrude(height=3) regen_pusher_2d(0);
  translate([0,76,10+channel_width/2-28]) rotate([90,0,0]) linear_extrude(height=3) regen_pusher_2d(2);
  for(x=pusher_support_x) translate([x,0,0]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) regen_swing_arm_2d();
}

module 3d_assembly() {
  translate([0,0,0]) color([0.5,0.5,0.5])linear_extrude(height=3) baseplate_2d();
  translate([0,0,10]) color([0.5,0.5,0]) linear_extrude(height=3) top_plate_2d();

  for(x=lower_support_tab_x) {
    color([1.0,0.4,0.5]) translate([x+3,regen_start_y-80,10]) rotate([0,-90,0]) linear_extrude(height=3) pusher_support_2d();
  }
  for(x=support_tab_x) {
    color([1.0,0.4,0.5]) translate([x,regen_start_y-42,3]) rotate([0,90,0]) linear_extrude(height=3) output_support_2d();
  }
  for(c=[0:7]) translate([ejector_xpos(c)-1.5, regen_start_y-25,-15]) rotate([0,90,0]) color([0,1.0,1.0]) linear_extrude(height=3) rotate(-$t*10) actuator_arm_2d();

  translate([20,regen_start_y-63,28]) rotate([-5*$t,0,0]) pusher_assembly();
  for(c=[0:7]) {
    translate([ejector_xpos(c)-channel_width/2,regen_start_y+50,3]) rotate([90,0,0]) rotate([0,-90,0]) linear_extrude(height=3) regen_rib_2d();
    translate([ejector_xpos(c)+channel_width/2+3,regen_start_y+50,3]) rotate([90,0,0]) rotate([0,-90,0]) linear_extrude(height=3) regen_rib_2d();
  }

  for(x=pusher_support_x) {
    translate([x+10,regen_start_y-50+3,13]) rotate([90,0,0]) linear_extrude(height=3) stop_plate_2d();
    translate([x+16,regen_start_y-50+35,13]) rotate([90,0,0]) rotate([0,-90,0]) linear_extrude(height=3) triagonal_support_2d();
  }

  // Axles
  translate([0,regen_start_y-60-3,28]) rotate([0,90,0]) cylinder(d=3,h=250);


  translate([0,regen_start_y-20,-30]) rotate([90,0,0]) linear_extrude(height=3) regen_output_comb_2d();

  translate([ejector_xpos(3)+pitch/2+1.5,regen_start_y-5,-30]) rotate([0,-90,0]) linear_extrude(height=3) regen_actuator_2d();
}

3d_assembly();


// Example data

translate([ejector_xpos(0), regen_start_y+8,13]) sphere(d=ball_bearing_diameter);
