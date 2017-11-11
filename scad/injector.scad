/* Ball bearing injector, mk 2 */

include <globs.scad>;

ball_bearing_diameter = 6.35; // Overrides globs.

// Max wire diameter is 1.59mm for 6.35mm ball bearings.
wire_diameter = 1.45; // Equivalent to AWG 15 / SWG 17.
$fn = 20;


// Distance between raiser slots
slot_distance = ball_bearing_diameter * 30;

module input_riser()
{
  difference() {
    square([ball_bearing_diameter * 32, 10]);
    for(x=[0,slot_distance]) {
      translate([x+5,5]) circle(d=3);
    }
  }
}

module channel_wall()
{
  difference() {
    translate([-20,0]) square([ball_bearing_diameter * 32 + 20, 20]);
    for(x=[0,slot_distance]) {
      translate([x+5,5]) circle(d=3);
      translate([x+5,15]) circle(d=3);
      translate([x+5-1.5,5]) square([3,10]);

      // Axle hole for raiser crank
      translate([x-15,10]) circle(d=3);
    }

  }
}

module raiser_crank() {
  difference() {
    translate([-5,-5])
    union() {
      square([35,10]);
      translate([0,-20]) square([10,30]);
    }
    translate([0,0]) circle(d=3);
    translate([0,-20]) circle(d=3);
    translate([25,0]) circle(d=3);
    translate([15,0]) circle(d=3);
    translate([15,-1.5]) square([10,3]);
  }
}


/* -------------------- 3D Assembly -------------------- */

rotate([90,0,0]) linear_extrude(height=3) input_riser();

translate([0,-5,0]) rotate([90,0,0]) linear_extrude(height=3) channel_wall();
translate([0,5,0]) rotate([90,0,0]) linear_extrude(height=3) channel_wall();

for(x=[0,slot_distance]) {
  translate([x-15,10,10]) rotate([0,13,0]) rotate([90,0,0]) linear_extrude(height=3) raiser_crank();
  translate([x-15,-10,10]) rotate([0,13,0]) rotate([90,0,0]) linear_extrude(height=3) raiser_crank();
 }
