// Word-addressed memory system for Millihertz 5 (SSAM)

include <globs.scad>

bb_diameter = 6;
clearance = 1; // How much extra space for ball bearings?

module baseplate_2d()
{
  square(size=[1000,1000]);
}

module stator_2d()
{
  width = 30;
  difference() {
    square(size=[width,800]);
    for(i=[0:words]) {
      translate([width-6,20+50*i]) polygon(points=[[0,0],[bb_diameter+1,2],
					      [bb_diameter+1,2+bb_diameter+clearance],[0,bb_diameter+clearance]]);
    }
  }
}


module pusher_2d()
{
  difference() {
    square([20,10]);
    translate([0,10]) circle(r=10);
  }
}

module row_bar_2d()
{
  square([800,10]);
}
