include <globs.scad>;
use <vertical-memory-2.scad>;
use <octo-distributor-5.scad>;

kerf = 0.1;

offset(delta = kerf, chamfer = true) {
  memory_top_plate_2d();


  // All injector arms
  translate([30,165]) {
    for(i=[0:7]) {
      translate([i*25,0]) rotate(45) ejector_2d();
    }
  }

  // Injector ribs
  translate([30,200]) {
    for(i=[0:4]) {
      translate([i*30,0]) rotate(90) ejector_channel_2d();
      translate([i*30-26,50]) rotate(270) ejector_channel_2d();
    }
    translate([4*30+20,0]) rotate(90) bracketed_ejector_channel_2d();
  }

}




