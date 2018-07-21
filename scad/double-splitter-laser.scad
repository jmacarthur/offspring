use <double-splitter.scad>;
use <diverter-parts.scad>;


kerf=0.1;

offset(kerf) {
  translate([0,5]) top_plate_2d(2);
  translate([0,106]) baseplate_2d(2);
  
  translate([0,215]) top_plate_2d(1);
  translate([0,280]) baseplate_2d(1);
 
  // It's sensible to cut a diverter backing plate at the same time

  translate([22,15]) diverter_2d();
  translate([22,15+45]) diverter_2d();
  translate([22,15+210]) diverter_2d();
  
  // Also supports
  for(i=[0:3]) translate([80+40*i,121]) rotate(90) diverter_support_2d();
}

// Example A4 sheet
color([0.7,0.7,1]) translate([-5,-5,-6]) cube([297,210,3]) ;
