include <globs.scad>;
use <vertical-memory-2.scad>;
use <octo-distributor-5.scad>;

kerf = 0.1;

offset(delta = kerf, chamfer = true) {
  // Memory parts

  memory_top_plate_2d();
  
  translate([220,0]) {
    translate([25,40]) rotate(90) returner_support_2d();
    translate([40,40]) rotate(90) returner_support_2d();
    translate([25,20]) returner_swing_arm_2d();
    translate([40,20]) returner_swing_arm_2d();
    translate([10,0]) rotate(90)  returner_plate_2d();
  }

  // Final two memory rods
  translate([10,260]) {
    for(i=[0:1]) {
      translate([0,40*i]) row_mover_2d();
      translate([0,20+40*i]) row_interruptor_2d();
    }
  }
  
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




