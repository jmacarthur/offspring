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
memory_travel = 14;

// Mid-section gap - allows a gap in between two sets of follower rods
gap = memory_unit_gap;
gap_position = 8;


// The position of the input rods for this rendering
input_data = [ 0, 1, 1, 1, 0 ];


render_inputs = 4; // Render this many inputs

// Enumerator are chosen manually for various n_inputs.
function enumerator_support_positions(num_inputs) = (num_inputs == 5 ? [64, 135, 230] :
						     num_inputs == 4 ? [64, 135, 230] : [64]);

// Calculated globals
render_positions = pow(2,render_inputs);

// Calculates the position of the fallen input follower and raised
// crank for this rendering.
raise_position = render_positions-1-(input_data[0] + input_data[1]*2+input_data[2]*4+
		     input_data[3]*8+input_data[4]*16);

// The spacing between internal plates (i.e. the gap between them plus one thickness)
function x_internal_space(n_positions) = follower_spacing*n_positions+(n_positions>gap_position?gap:0);

thin = 0.1;

// Extend_back moves the follower axis backwards, reducing the load on the enumerator rod, but making the output higher.
extend_back = 50;

// How much does the single dropped lever rotate from orthogonal?
drop_angle = atan2(10,85-18+extend_back+12);

// Attachment distance is the distance from the axis of the follower to the point we should
// attach to get the correct travel.
attachment_distance = memory_travel / sin(drop_angle);

distance_between_xbars = 55;

function xbar_length(n_positions) = x_internal_space(n_positions) + 20;

function mounting_holes_x(n_positions) = [ 20, xbar_length(n_positions)-20, floor(xbar_length(n_positions)/2) ];
mounting_screw_diameter = 10;





// Enumerator rod - one per input; follower rods drop into the gaps in these.
// Parameters:
// Value - the bit value, 0 for bit 0, 1 for bit 1 (2^1), 2 for bit 2 (2^2) etc.
// follower_spacing - the spacing between the rods intended to drop into this.
// travel - the amount each rods travels. Rods travel inwards - 0 is out of the unit, 1 is in.
// rise_height - how much each bump is raised above the baseline.
module enumerator_rod(value, n_inputs, follower_spacing, travel, rise_height)
{
  n_positions = pow(2,n_inputs);
  actual_travel = (travel==0)?follower_spacing/2:travel;
  extend_above = 10;
  difference() {
    union() {
      translate([-extend_above, 0])
	square(size=[50+x_internal_space(n_positions)+extend_above,10+rise_height]);

      // Stops which prevent the rod travelling too far
      translate([2,-2]) square([5,24]);
    }
    positions = pow(2,n_inputs);
    for(i=[0:positions-1]) {
      align = (floor(i/pow(2,value)) % 2);
      top_chamfer = 1;
      bottom_chamfer = 2;
      translate([15+follower_spacing*i+actual_travel*align+(i>=gap_position?gap:0),10]) polygon(points = [[0,bottom_chamfer], [bottom_chamfer,0], [actual_travel+thin-bottom_chamfer,0], [actual_travel+thin,bottom_chamfer], [actual_travel+thin,rise_height+thin-top_chamfer], [actual_travel+thin+top_chamfer,rise_height+thin], [0-top_chamfer, rise_height+thin], [0, rise_height+thin-top_chamfer]]);
    }
    // Slot to allow connection to levers
    translate([-1,0]) {
      translate([0,8]) circle(d=3);
      translate([0,12]) circle(d=3);
      translate([-1.5,8]) square([3,4]);
    }

    // T-slot to chain to next decoder
    translate([x_internal_space(n_positions)+40,0]) {
      nut_width = 5.5;
      nut_height = 2.5;
      translate([0,10-nut_width/2]) square([nut_height, nut_width]);
      translate([-5,10-1.5]) square([20, 3]);
    }

    // Slot which can be used to make an end stop
    translate([x_internal_space(n_positions)+34,18]) square([0.8,5]);

  }
}

// Place enumeration rods on 3D diagram
module enumerator_rods(n_inputs) {
  for(s=[0:n_inputs-1]) {
    translate([-12+1.5-enumerator_rod_travel/2+input_data[s]*enumerator_rod_travel,5+10*s,10])
      rotate([90,0,0]) linear_extrude(height=3) {
      enumerator_rod(s, n_inputs, follower_spacing, 0, 10);
    }
  }
}

// The follower levers. These drop into the enumeration rods.
module lever_2d()
{
  follower_length = attachment_distance+10;
  difference() {
    union() {
      translate([-follower_length,-5]) square(size=[follower_length,10]);
      circle(d=10);
    }
    circle(d=3);
    translate([-attachment_distance,0,0]) circle(d=3);
  }
}

module lever()
{
  rotate([90,0,0])
  rotate([0,90,0])
  linear_extrude(height=3) lever_2d();
}

follower_axis_y = 85-18+extend_back;

// Display a marker at the attachment point
translate([0, follower_axis_y-attachment_distance, 0]) sphere(d=5);
echo("Distance of output above plane is ",(follower_axis_y-attachment_distance));

// Note that memory requires a height of only 13mm

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
  leg_angle = 100;
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

module follower_slots(n_positions, slotStart, slotHeight) {
  for(i=[1:n_positions]) {
    // Slots for followers
    translate([i*follower_spacing-4-gap_adjust/2+(i>gap_position?gap:0),5+slotStart]) square([3+gap_adjust,slotHeight]);
  }
}

module lifter_bar_axles(n_positions)
{
    // Mounts for lifter bar
    translate([45,-4]) circle(d=3);
    translate([x_internal_space(pow(2,n_positions))+5,-4]) circle(d=3);
}

module enumerator_support_slots(num_inputs)
{
    // Slots to allow enumerator support
  for(x = enumerator_support_positions(num_inputs))
    translate([x,-15]) square([3,10]);
}

// An xBar is one of the 'input combs' which accomodate the followers.

module xBar_2d(n_positions, slotStart, slotHeight, height) {
  base=-20;
  difference() {
    union() {
      translate([0,-20]) square([xbar_length(n_positions),height+10]);
      translate([20,base-3]) square([10,3+thin]);
      translate([100,base-3]) square([10,3+thin]);

      // Tabs to connect to side plate
      translate([20,height-10-thin]) square([10,3+thin]);
      translate([100,height-10-thin]) square([10,3+thin]);
    }
    follower_slots(n_positions, slotStart, slotHeight);
    lifter_bar_axles(n_positions);
    enumerator_support_slots(n_positions);

    // Tabs to connect to the triangular plate
    translate([-thin,30]) square([3+thin,15]);
    translate([-thin,-10-thin]) square([3+thin,20]);
    translate([xbar_length(n_positions)-3,30]) square([3+thin,15]);
    translate([xbar_length(n_positions)-3,-10-thin]) square([3+thin,20]);

  }
}

module top_plate_2d(n_positions, side_mount) {
  slotStart = 5;
  slotHeight = 20;
  height = side_mount ? 90 : 60;
  base = 40-height;
  difference() {
    union() {
      translate([0,base]) square([xbar_length(n_positions),height]);
      // Tabs to connect for top mounting option.
      if(!side_mount) {
	translate([20,base-3]) square([10,3+thin]);
	translate([100,base-3]) square([10,3+thin]);
      }
      // Tabs to connect to side plate
      translate([20,base+height-thin]) square([10,3+thin]);
      translate([100,base+height-thin]) square([10,3+thin]);
    }
    follower_slots(n_positions, slotStart, slotHeight);
    lifter_bar_axles(n_positions);
    enumerator_support_slots();

    // Tabs to connect to the triangular plate
    translate([-thin,-5]) square([3+thin,35]);
    translate([xbar_length(n_positions)-3,-5]) square([3+thin,35]);

    // Holes to mount the whole assembly to the base
    for(x=mounting_holes_x(n_positions)) {
      translate([x,-35]) circle(d=mounting_screw_diameter);
    }
  }
}

// Fixed sections (chassis)
module xBar(n_positions, slotStart, slotHeight, height) {
  color([0.5,0.5,0.5]) {
    translate([0,3,0])
    rotate([90,0,0])
    linear_extrude(height=3) {
      xBar_2d(n_positions, slotStart, slotHeight, height);
    }
  }
}

module topPlate(n_positions, side_mount) {
  color([0.5,0.5,0.5]) {
    translate([0,3,0])
    rotate([90,0,0])
    linear_extrude(height=3) {
      top_plate_2d(n_positions, side_mount);
    }
  }
}

// A yComb holds all the input enumerator rods.
module yComb_2d()
{
  difference() {
    union() {
      translate([-5,0,0]) square([75,10]);
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

module lifter_bar_2d(n_positions)
{
  difference() {
    square([30+x_internal_space(n_positions),10]);
    translate([17,5]) circle(d=3);
    translate([x_internal_space(n_positions)-23,5]) circle(d=3);
  }
}

// Lifting bars
module lifter_bar(n_positions)
{
  rotate([90,0,0])
  linear_extrude(height=3) {
    lifter_bar_2d(n_positions);
  }
}

module triangular_support_plate_2d(side_mount)
{
  depth = ( side_mount ? 90 : 60 );
  difference() {
    union() {
      polygon(points = [[-3,0], [follower_axis_y+15,0], [follower_axis_y+15,0], [follower_axis_y+15,20], [50,50], [10,depth], [0, depth], [0,50], [-3,50]]);
      // Tabs for side plate
      translate([10,-3]) square([10,3+thin]);
      translate([50,-3]) square([10,3+thin]);
    }

    // Cut tabs for x-bars
    translate([-3-thin, -thin]) square([3+thin,10+thin]);
    translate([-3-thin, 45-thin]) square([3+thin,10+thin]);
    translate([distance_between_xbars-3, 10]) square([3,20]);

    // Main axle hole
    translate([follower_axis_y,15]) circle(d=3);

    // Mounting holes for a plate to support the axle
    translate([follower_axis_y+10,15]) circle(d=3);
    translate([follower_axis_y-10,15]) circle(d=3);

    // Gaps for enumerator rods
    for(rod=[0:4]) {
      translate([2-gap_adjust/2+10*rod,20]) square([3+gap_adjust, 20]);
    }

    // Gap for a reinforcing strip
    translate([20,65]) square([20,20]);

    // slot for the axle reinforcer
    translate([follower_axis_y-1.5,-1]) square([3,4]);

    // Holes for attaching the memory sender. 4mm diameter, 40mm
    // apart. These are meant to be exactly between the 2nd and 3rd
    // enumerator rod.
    translate([10+5+2+1.5,10]) circle(d=4);
    translate([10+5+2+1.5,50]) circle(d=4);
  }
}

module triangular_support_plate(side_mount)
{
  translate([0,0,50]) rotate([-90,0,90]) linear_extrude(height=3) triangular_support_plate_2d(side_mount);
}

module side_plate_2d(n_positions) {
  difference() {
    square([xbar_length(n_positions),100]);
    // Tab holes
    for(y=[-thin, distance_between_xbars]) {
      edge = (y==-thin? 1:0);
      translate([20,y]) square([10,3+thin*edge]);
      translate([100,y]) square([10,3+thin*edge]);
    }
    for(x=[-thin, xbar_length(n_positions)-3]) {
      translate([x,10+3]) square([3+thin,10]);
      translate([x,50+3]) square([3+thin,10]);
    }

    // Slots to hold lever supports
    for(rod=[0:4]) {
      translate([10,5+10*rod]) square([5, 3]);
      translate([35,5+10*rod]) square([15, 3]);
    }
  }
}


module side_plate(n_positions) {
  linear_extrude(height=3) side_plate_2d(n_positions);
}

lever_balance_length = 75; // Distance between mounting holes
module input_lever_2d() {
  lever_length = lever_balance_length+20;
  difference() {
    translate([-lever_length/2,-5]) square([lever_length,10]);
    translate([-lever_balance_length/2,0]) circle(d=3);
    translate([lever_balance_length/2,0]) circle(d=3);
    circle(d=3); // Centre axis
  }
}

module input_lever() {
  rotate([90,90,0]) linear_extrude(height=3) input_lever_2d();
}

module lever_support_2d() {
  support_length = 67;
  difference() {
    union() {
      polygon(points = [ [0,-5], [0,5], [support_length-15,5], [support_length,-5], [support_length,-5]]);
      translate([55,-11]) square([10,6+thin]);
      translate([60,-5-6]) square([6,3]);
      translate([56,-5]) circle(d=12);
      translate([25,-8]) square([5,10]);
      circle(d=10);
    }
    circle(d=3); // Top axis
  }
}

module lever_support() {
  rotate([90,0,0]) linear_extrude(height=3) lever_support_2d();
}

lever_rotation = atan2(enumerator_rod_travel, (lever_balance_length/2));

module decoder_assembly(n_inputs, side_mount) {
  n_positions = pow(2,n_inputs);
  color([0.5,0,0]) {
    for(i=[0:n_positions-1]) {
      rot = (i==raise_position?drop_angle:0);
      translate([10+follower_spacing*i+(i>=gap_position?gap:0),follower_axis_y,35]) rotate([rot,0,0]) lever();
    }
  }

  // Three bars which extend in the x dimension

  translate([0,-3,10]) topPlate(n_positions, side_mount);
  translate([0,-3+distance_between_xbars,10]) xBar(n_positions, 5,20,50); // Middle

  for(x=enumerator_support_positions(n_inputs))
    translate([x,-8,0]) yComb();

  color([0.5,0.5,0.5,0.5]) translate([0,-3,50]) side_plate(n_positions);

  for(side=[0:1]) {
    translate([3+side*(xbar_length(n_positions)-3),0,0]) triangular_support_plate(side_mount);
  }

  translate([0,-9,10]) lifter_bar(n_positions);
  translate([15,-6,10]) rotate([0,17,0]) front_lifter_lever();
  translate([x_internal_space(n_positions)-25,-6,10]) rotate([0,17,0]) back_lifter_lever();
}

module lever_assembly(n_inputs) {
  for(input=[0:n_inputs]) {
    color([0.5,0.5,1.0]) translate([-15,2+10*input,55+3]) rotate([0,-lever_rotation*input_data[input],0]) input_lever();
    translate([-15,5+10*input,55+3]) lever_support();
  }
}

// False raised plate - to account for the mismatched output height to memory

module false_raised_plate(n_positions) {
  color([0.5,0.3,0]) translate([0,-50,-200]) difference() {
    cube([300,18,200]);
    for(x=mounting_holes_x(n_positions)) {
      translate([x,-50,200-25]) rotate([-90,0,0]) cylinder(d=mounting_screw_diameter,h=100);
    }
  }
}

// Drift attached behind plate to extend the height
module support_drift(n_positions) {
  color([0.5,0.35,0]) translate([0,-32,-50]) difference() {
    cube([300,29,50]);
    for(x=mounting_holes_x(n_positions)) {
      translate([x,-50,50-25]) rotate([-90,0,0]) cylinder(d=mounting_screw_diameter,h=100);
    }
  }
}

module reinforcing_strip(n_positions)
{
  // Intended to be steel or aluminum rather than acrylic.
  translate([-10,20,-35]) difference()
    {
      cube([xbar_length(n_positions)+20, 3, 20]);
      for(x=mounting_holes_x(n_positions)) {
	translate([x+10,-35,10]) rotate([-90,0,0]) cylinder(d=mounting_screw_diameter,h=100);
      }
    }
}

axle_reinforce_x = [ follower_spacing*5, follower_spacing*13+gap, follower_spacing*8+gap/2 ];

module axle_reinforcing_strip_2d(n_positions)
{
  difference() {
    square([xbar_length(n_positions)+20, 20]);
    // cutouts for triangular supports
    translate([10,-1]) square([3,4]);
    translate([xbar_length(n_positions)+7,-1]) square([3,4]);
    // Cutouts for the axle supports
    for(x=axle_reinforce_x) {
      translate([x,-1]) square([3,4]);
    }
  }
}
module axle_reinforcing_strip(n_positions)
{
  rotate([90,0,0]) linear_extrude(height=3) axle_reinforcing_strip_2d(n_positions);
}

module axle_reinforcer_2d()
{
  height=15;
  difference() {
    union() {
      translate([-5,0]) square([10,height]);
      circle(d=10);
    }
    circle(d=3);
    translate([-1.5,height-3]) square([3,4]);
  }
}

module axle_reinforcer()
{
  rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=3) axle_reinforcer_2d();
}

translate([-10,follower_axis_y+1.5,44]) axle_reinforcing_strip(render_positions);
for(x=axle_reinforce_x) {
  translate([x-10,follower_axis_y,44-14+20-15]) axle_reinforcer(render_positions);
}

// Gives the length of the main box, not including enumerator rods
function decoder_box_length(render_positions) = pow(2,render_positions)*follower_spacing+17;

module address_decoder() {
  reinforcing_strip(render_positions);
  decoder_assembly(render_inputs, true);
  lever_assembly(render_inputs);
  enumerator_rods(render_inputs);
  support_drift(render_positions);
  false_raised_plate(render_positions);
}

address_decoder();
