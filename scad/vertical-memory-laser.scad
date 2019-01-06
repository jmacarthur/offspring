include <globs.scad>;
use <vertical-memory-2.scad>;

kerf = 0.1;

offset(r=kerf) {

  memory_base_plate_2d();
  translate([0,150]) memory_top_plate_2d();
  for(i=[0:7]) {
    translate([10,300+i*20]) row_mover_2d();
    translate([10,470+i*25]) row_stator_2d();
    translate([10,670+i*20]) row_interruptor_2d();
  }
  translate([220,0]) row_comb_2d();
  translate([220,30]) row_comb_2d();
  translate([220,60]) for(i=[0:3]) {
    translate([i*30+20,0]) deflector_line_2d();
    translate([i*30+20,130]) rotate(180) deflector_line_2d();
  }
  translate([220,200]) for(i=[0:7]) {
    translate([i*20,0]) row_pusher_2d();
  }
  translate([220,250]) input_gate_2d();


  translate([220,280]) {
    for(i=[0:1]) {
      translate([20+i*40,5])
	rotate(90) returner_swing_arm_2d();
      translate([90+i*40,0]) returner_support_2d();
    }
    translate([0,20]) returner_plate_2d();
  }

}
