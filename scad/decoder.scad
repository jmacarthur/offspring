/* Binary 1-to-many decoder - decodes any number (n) of binary inputs
   into 1 of 2^n outputs, one of which is activated at once. For
   example, with 3 binary inputs, one of 8 binary outputs can be
   activated at once.
*/


include <globs.scad>;

// Various parameters
follower_spacing = 14; // Spacing between each input follower
$fn = 20;
explode = 30; // Moves parts apart for easier inspection
gap_adjust = 0.2; // In case of thicker than 3mm acrylic, make this positive to increase the width of the slots for the followers.


// Number of inputs. This was originally defined for 5 inputs;
// other numbers may work, but are in development.
n_inputs = 4;

// The position of the input rods for this rendering
input_data = [ 0, 1, 1, 1, 0 ];

// Enumerator supports still have to be manually placed when changing n_inputs.
// For n=5, we suggest [64,225].
enumerator_support_x1 = 64;
enumerator_support_x2 = 135;

// Calculated globals
n_positions = pow(2,n_inputs);

// Calculates the position of the fallen input follower and raised
// crank for this rendering.
raise_position = n_positions-1-(input_data[0] + input_data[1]*2+input_data[2]*4+
		     input_data[3]*8+input_data[4]*16);

// The spacing between internal plates (i.e. the gap between them plus one thickness)
x_internal_space = follower_spacing*n_positions;

thin = 0.1;

// Enumerator rod - one per input; follower rods drop into the gaps in these.

// Parameters:
// Value - the bit value, 0 for bit 0, 1 for bit 1 (2^1), 2 for bit 2 (2^2) etc.
// follower_spacing - the spacing between the rods intended to drop into this.
// stagger - alters the position of the input connector; use this to make some rods longer to stagger input.
// travel - the amount each rods travels. Rods travel inwards - 0 is out of the unit, 1 is in.
// rise_height - how much each bump is raised above the baseline.
module enumerator_rod(value, n_inputs, follower_spacing, stagger, travel, rise_height)
{
  actual_travel = (travel==0)?follower_spacing/2:travel;
  difference() {
    union() {
      square(size=[40+x_internal_space,10]);
      // End stops
      translate([0,0]) square(size=[15,15]);
      positions = pow(2,n_inputs);
      for(i=[0:positions-1]) {
	align = 1-(floor(i/pow(2,value)) % 2);
	translate([20+follower_spacing*i+actual_travel*align,10-thin]) square(size=[actual_travel+thin,rise_height+thin]);
      }
    }
    translate([7,5+stagger]) circle(d=3); // To attach to the input
  }
}

// Place enumeration rods on 3D diagram
for(s=[0:n_inputs-1]) {
  translate([-15+input_data[s]*5,5+10*s,0])
    rotate([90,0,0]) linear_extrude(height=3) {
    enumerator_rod(s, n_inputs, follower_spacing, 0, 5, 10);
  }
}

// The follower levers. These drop into the enumeration rods.
module lever_2d()
{
  difference() {
    union() {
      translate([-85.5,-5]) square(size=[85.5,10]);
      circle(d=10);
    }
    circle(d=3);
  }
}

module lever()
{
  rotate([90,0,0])
  rotate([0,90,0])
  linear_extrude(height=3) lever_2d();
}

color([0.5,0,0]) {
  for(i=[0:n_positions-1]) {
    rot = (i==raise_position?7.5:0);
    translate([10+follower_spacing*i+1,-18,20]) translate([0,85,5]) rotate([rot,0,0]) lever();
  }
}

module front_lifter_lever_2d() {
  len = 30;
  difference() {
    union() {
      square([len,10]);
      translate([0,5]) circle(r=5);
      translate([len,5]) circle(r=5);
    }
    translate([0,5]) circle(d=3);
    translate([len,5]) circle(d=3);
  }
}

module front_lifter_lever() {
  rotate([90,0,0])
    linear_extrude(height=3) {
    front_lifter_lever_2d();
  }
}

module back_lifter_lever_2d() {
  len = 30;
  leg_angle = 45;
  difference() {
    union() {
      square([len,10]);
      translate([len,0]) translate([0,5]) rotate(leg_angle) translate([0,-5]) square([50,10]);
      translate([0,5]) circle(r=5);
      translate([len,5]) circle(r=5);
    }
    translate([0,5]) circle(d=3);
    translate([len,5]) circle(d=3);
    translate([len,5]) rotate(leg_angle) translate([45,0]) circle(d=3);
  }
}

module back_lifter_lever() {
  rotate([90,0,0])
    linear_extrude(height=3) {
    back_lifter_lever_2d();
  }
}


// An xBar is one of the 'input combs' which accomodate the followers.
module xBar_2d(slotStart, slotHeight, height) {
  difference() {
    union() {
      translate([0,-10]) square([20+x_internal_space,height]);
    }
    for(i=[1:n_positions]) {
      // Slots for followers
      translate([i*follower_spacing-3-gap_adjust/2,5+slotStart]) square([3+gap_adjust,slotHeight]);
    }

    // Mounts for lifter bar
    translate([45,-5]) circle(d=3);
    translate([15+x_internal_space,-5]) circle(d=3);

    // Slots to allow enumerator support
    translate([enumerator_support_x1,-11]) square([3,6]);
    translate([enumerator_support_x2,-11]) square([3,6]);
  }
}

// An xBar is one of the 'input combs' which accomodate the followers.
module top_plate_2d() {
  slotStart = 5;
  slotHeight = 20;
  height = 90;
  difference() {
    union() {
      translate([0,-50]) square([20+x_internal_space,height]);
    }
    for(i=[1:n_positions]) {
      // Slots for followers
      translate([i*follower_spacing-3-gap_adjust/2,5+slotStart]) square([3+gap_adjust,slotHeight]);
    }

    // Mounts for lifter bar
    translate([45,-5]) circle(d=3);
    translate([15+x_internal_space,-5]) circle(d=3);

    // Slots to allow enumerator support
    translate([enumerator_support_x1,-11]) square([3,6]);
    translate([enumerator_support_x2,-11]) square([3,6]);
  }
}


// Fixed sections (chassis)
module xBar(slotStart, slotHeight, height) {
  color([0.5,0.5,0.5]) {
    translate([0,3,0])
    rotate([90,0,0])
    linear_extrude(height=3) {
      xBar_2d(slotStart, slotHeight, height);
    }
  }
}

module topPlate() {
  color([0.5,0.5,0.5]) {
    translate([0,3,0])
    rotate([90,0,0])
    linear_extrude(height=3) {
      top_plate_2d();
    }
  }
}

// A yComb holds all the input enumerator rods.
module yComb_2d()
{
  difference() {
    union() {
      square([65,10]);
      for(i=[0:4]) {
	translate([13+i*10,9])
	  square([7,11]);
      }
      translate([8,9])
	square([2,6]);
    }
    translate([5,5]) square([3,6]);
    translate([60,5]) square([3,6]);
  }
}

module yComb() {
  rotate([90,0,0]) rotate([0,90,0])
  linear_extrude(height=3) {
    yComb_2d();
  }
}

// Three bars which extend in the x dimension

translate([0,-3,0]) topPlate();
translate([0,52,0]) xBar(5,20,50); // Middle

translate([enumerator_support_x1,-8,-10]) yComb();
translate([enumerator_support_x2,-8,-10]) yComb();

module lifter_bar_2d()
{
  difference() {
    square([30+x_internal_space,10]);
    translate([17,5]) circle(d=3);
    translate([x_internal_space-13,5]) circle(d=3);
  }
}

// Lifting bars
module lifter_bar()
{
  rotate([90,0,0])
  linear_extrude(height=3) {
    lifter_bar_2d();
  }
}

translate([0,-3,0]) lifter_bar();
translate([15,-6,0]) rotate([0,17,0]) front_lifter_lever();
translate([x_internal_space-15,-6,0]) rotate([0,17,0]) back_lifter_lever();


// The piece of backing plate this is meant to clamp or bolt onto

color([0.5,0.3,0]) translate([0,0,-200]) cube([200,18,200]);
