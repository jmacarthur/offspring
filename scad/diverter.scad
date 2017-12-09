// Experimental 8-way chainable diverter

include <globs.scad>;

// A grate that allows ball bearings in through holes in the top. Also includes mounting points.
module input_plate()
{
  difference() {
    square([8*pitch, 20]);
    // Holes suitable for PVC tube
    for(i=[0:7]) {
      translate([0.5*pitch+i*pitch, 10]) circle(d=11);
    }
    // Mounting holes
    for(y=[4,16]) {
      for(x=[0.2*pitch, 4*pitch, 0.8*pitch+7*pitch]) {
	translate([x,y]) circle(d=3, $fn=10);
      }
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
      translate([-5,-5-crank_offset_y]) square([10,10+crank_offset_y]);
      translate([crank_offset_x-10,-5-crank_offset_y]) square([13,3]);
      translate([0,-5-crank_offset_y]) square([crank_offset_x,10]);
      translate([crank_offset_x-10,5-crank_offset_y-3]) square([13,3]);
    }
    // Axle hole
    translate([0,0]) circle(d=3);
  }
}

output_gap = 10;

// The bit that rotates to divert ball bearings
module diverter_plate()
{
  difference() {
    union() {
      translate([3,-extend_down]) square([8*pitch-3*2, 10+extend_down+extend_up]);
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
    square([8*pitch, 40]);
    for(i=[0:7]) {
      translate([0.5*pitch+i*pitch-output_gap/2,17]) square([output_gap, 10]);
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
}



diverter();
