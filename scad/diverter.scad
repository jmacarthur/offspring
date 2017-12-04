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




// ------ 3D assembly ------

module diverter() {
  linear_extrude(height=3) input_plate();
  translate([0,0,50]) linear_extrude(height=3) input_plate();
}

diverter();
