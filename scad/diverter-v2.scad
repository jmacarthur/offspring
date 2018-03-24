// Super-simple 8-way chainable diverter using electrical conduit

include <globs.scad>;
use <interconnect.scad>;

$fn=20;
columns = 8;

support_positions = [16,(columns-2)*pitch+16];
conduit_width = 16;

drill_positions = [ pitch + conduit_width + (pitch-conduit_width)/2,
		    pitch*5 + conduit_width + (pitch-conduit_width)/2 ];

module diversion_plate_2d()
{
  square([columns*pitch,40]);
}

module support_2d() {
  difference() {
    union() {
      translate([0,-5]) square([15,10]);
      circle(d=10);

      polygon(points=[[10,1.5], [40,1.5], [10,21.5]]);
      // Control arms
      translate([5+2,-5]) square([8,40]);
      translate([5,20]) square([8,15]);
    }
    circle(d=3);
    translate([10,30]) circle(d=3);
    translate([5,-1.5]) square([10,3]);
  }
}

module axle_mounting_bracket_2d() {
  difference() {
    union() {
      polygon(points = [[5,0], [-5,0], [-5,-3], [-15,-3],[-15,0],[-25,0], [-25,-15], [5,-15]]);
      circle(d=10);
    }
    circle(d=3);
  }
}

module back_mounting_plate_2d()
{
  difference() {
    square([columns*pitch,30]);
    for(x=support_positions) translate([x+3,10]) square([3,10]);
      for(x=drill_positions) {
	translate([x,20]) circle(d=3);
      }
  }
}


/* -------------------- 3D assembly -------------------- */

module diverter_assembly()
{
  diverter_rotate = 0;
  translate([0,0,55])
    rotate([diverter_rotate,0,0]) {
    translate([0,1.5,-45]) 	rotate([90,0,0]) linear_extrude(height=3) diversion_plate_2d();

    //moving conduit
    color([1.0,1.0,1.0]) for(i=[0:columns-1]) translate([i*pitch, -12,-55]) cube([16,10,50]);
    for(x=support_positions) translate([x,0,0]) 	rotate([0,90,0]) linear_extrude(height=3) support_2d();
  }

  back_mounting_plate = false;
  if(back_mounting_plate) {
    for(x=support_positions) translate([x+3,0,55]) rotate([0,90,0]) linear_extrude(height=3) axle_mounting_bracket_2d();
    translate([0,0,60]) rotate([90,0,0]) linear_extrude(height=3) back_mounting_plate_2d();
  }
}

translate([0,0,0]) diverter_assembly();

// Wooden plate above
translate([-100,0,60]) color([1.0,0.5,0.0]) cube([600,18,100]);
// Wooden plate below
translate([-100,0,-100]) color([1.0,0.5,0.0]) cube([600,18,100]);

// fixed conduit (above)
for(i=[0:columns-1]) translate([i*pitch, -14, 60]) cube([conduit_width,10,50]);

// fixed conduit (below, on back)
for(i=[0:columns-1]) translate([i*pitch, 18,-50]) cube([conduit_width,10,50]);
