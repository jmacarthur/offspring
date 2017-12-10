// Experimental 8-way chainable diverter

include <globs.scad>;
use <interconnect.scad>;
use <generic_conrods.scad>;

$fn=20;

mounting_holes_y = [4,16];
mounting_holes_x = [0.2*pitch, 4*pitch, 0.8*pitch+7*pitch];
m3_nut_space = 5.4;

// A grate that allows ball bearings in through holes in the top.
// Also includes mounting points.
module input_plate()
{
  difference() {
    square([8*pitch, 20]);
    // Holes suitable for PVC tube
    for(i=[0:7]) {
      translate([0.5*pitch+i*pitch, 10]) circle(d=11);
    }
    // Mounting holes
    for(y=mounting_holes_y) {
      for(x=mounting_holes_x) {
	translate([x,y]) circle(d=3, $fn=10);
      }
    }
    // Tab holes for side walls
    for(x=[-1, 8*pitch-3]) {
      translate([x, 7.5]) square([4,5]);
    }
  }
}

crank_offset_x = 10;
crank_offset_y = 10;
extend_down = 10;
extend_up = 10;

// The bit that connects the moving plate to the axle
module rotating_bar_support()
{
  difference() {
    union() {
      translate([-35,-5-crank_offset_y]) square([40,10+crank_offset_y]);
      translate([crank_offset_x-10,-5-crank_offset_y]) square([13,3]);
      translate([0,-5-crank_offset_y]) square([crank_offset_x,10]);
      translate([crank_offset_x-10,5-crank_offset_y-3]) square([13,3]);
    }
    // Axle hole
    translate([0,0]) circle(d=3, $fn=20);
    // Drive hole
    translate([-10,0]) circle(d=3, $fn=20);
  }
}

output_gap = 10;

// The bit that rotates to divert ball bearings
module diverter_plate()
{
  difference() {
    union() {
      translate([4,-extend_down]) square([8*pitch-4*2, 10+extend_down+extend_up]);
    }
    for(i=[1:6]) {
      translate([0.5*pitch+i*pitch-(output_gap/2)-3,0]) {
	square([3,10]);
      }
      translate([0.5*pitch+i*pitch+(output_gap/2),0]) {
	square([3,10]);
      }
    }
  }
}

// Optional separator plates
module separator_plate()
{
	polygon(points = [[5,0], [10,5], [20,5],[30,0], [20,0], [20,-3],[10,-3], [10,0]]);
}

// The wall with output holes for diverted ball bearings
module side_wall()
{
    difference() {
    square([8*pitch, 37]);
    for(i=[0:7]) {
      translate([0.5*pitch+i*pitch-output_gap/2,17]) square([output_gap, 10]);
    }
    for(i=[0:7]) {
      translate([0.5*pitch+i*pitch-output_gap/2,17]) square([output_gap, 10]);
    }
    for(x=mounting_holes_x) {
      for(y=[-1,37-3]) translate([x-m3_nut_space/2,y]) square([m3_nut_space,4]);
    }
    // Holes for the end wall
    for(x=[-1, 8*pitch-3]) {
      translate([x,10]) square([4,5]);
      translate([x,25]) square([4,5]);
    }
  }
}

module end_wall(mount_plate) {
  union() {
    square([17,37]);
    // Top pegs
    translate([7.5,-3]) square([5,43]);
    // Side pegs
    translate([0,10]) square([20,5]);
    translate([0,25]) square([20,5]);
    difference() {
      translate([-15,20]) square([20,10]);
      translate([-10,35-9]) circle(d=3, $fn=20);
    }
    if(mount_plate) {
      // Dropped section to attach bowden cable
      difference() {
        translate([-28,-3]) square([28,25]);
        translate([-23,2]) circle(d=3);
translate([-5,2]) circle(d=3, $fn=10);
      }
      translate([-1,0]) square([2,25]); // This just joins the two sections
    }
  }
}

// ------ 3D assembly ------

module diverter_swing_assembly()
{
  for(x=[10,8*pitch-13]) translate([x,0,0]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) rotating_bar_support();
  translate([0,crank_offset_x+3,-5-crank_offset_y]) rotate([90,0,0]) linear_extrude(height=3) diverter_plate();
  for(i=[0:7]) {
    translate([0.5*pitch+pitch*i-output_gap/2-3,10+3,5]) rotate([0,90,0]) linear_extrude(height=3) separator_plate();
    translate([0.5*pitch+pitch*i-output_gap/2+10,10+3,5]) rotate([0,90,0]) linear_extrude(height=3) separator_plate();// TODO Rationalise calculation
  }
}

module diverter() {
  linear_extrude(height=3) input_plate();
  translate([0,0,40]) linear_extrude(height=3) input_plate();
  translate([0,-crank_offset_x,crank_offset_y+9+extend_down]) rotate([$t*45,0,0]) diverter_swing_assembly();
  translate([0,20,3]) rotate([90,0,0]) linear_extrude(height=3) side_wall();
  for(x=[0, 8*pitch-3]) {
    color([0.5,0.5,0]) translate([x,0,3]) rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=3) end_wall(x!=0);
  }
}

diverter();
color([0.5,0,0]) translate([8*pitch,0,0]) diverter();
color([0,0.5,0]) translate([8*pitch,0,43]) diverter();
color([0.5,0,0]) translate([8*pitch,0,0]) diverter();
color([0,0.5,0.5]) translate([0,0,43]) diverter();


module interconnect_assembly() {
    rotate([0,90,0]) linear_extrude(height=3) bowden_cable_stator();
    translate([-3,0,-42]) rotate([0,90,0]) linear_extrude(height=3) stator_clamp();
    translate([0,5,-10-bowden_cable_travel])  color([0.5,0.5,0.5]) rotate([0,90,0]) linear_extrude(height=3) cable_connector_2d();
    translate([-4,11.5,-14-bowden_cable_travel+10]) rotate([180+3,0,0]) rotate([0,90,0]) linear_extrude(height=3) conrod(35);
}

translate([8*pitch-6,-28,10])  interconnect_assembly();

