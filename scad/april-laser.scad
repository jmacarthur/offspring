/* Test of : vertical memory 2, regenerator */

include <globs.scad>;
use <vertical-memory-2.scad>;
use <octo-distributor-4.scad>;
columns = memory_columns_per_cell;
rows = 8;
column_width = 7; // Must be bigger than bb diameter

joiner_extension = 2;
column_spacing = (column_width*3+joiner_extension); // This is no longer relevant, but necessary to calculate the mounting holes
$fn=30;

y_tab_positions = [20,100];

x_comb_positions = [8,198];

kerf = 0.1;

// ---------------------------------------- Vertical memory
  use <base-regenerator.scad>;

offset(kerf) {

  translate([0,160]) memory_base_plate_2d();

  translate([480,135]) {
    for(x=[0:3]) {
      translate([x*30,-5]) scale([1,-1]) deflector_line_2d();
      translate([x*30,-133]) rotate(180) scale([1,-1]) deflector_line_2d();
    }
  }
  for(y=[0:5]) {
    translate([10,18*y]) row_mover_2d();
    translate([230,15*y]) row_interruptor_2d();
    translate([450,15*y]) row_pusher_2d();
  }

  for(x=[0:1])
    translate([0,330+x*30]) row_comb_2d();

  translate([0,300]) input_gate_2d();

  translate([380,160]) rotate(90) ejector_comb_2d();

  // ----------------------------------------

  support_tab_x = [ 10, 200];
  pusher_support_x = [ 30,130];

  regen_start_y = 100;


  translate([350,160]) rotate(90) baseplate_2d();
  translate([530,160]) rotate(90) top_plate_2d();

  translate([550,140]) scale([-1,1]) actuator_arm_2d();
  translate([450,110]) scale([-1,1]) actuator_arm_2d();

  for(y=[0:2]) {
    for(c=[0:1]) {
      translate([550+c*20,190+65*y])    rotate(90) regen_rib_2d();
    }
  }

  translate([425,190]) rotate(90) regen_swing_arm_2d();
  translate([10,115]) regen_swing_arm_2d();

  for(x=[0:1]) {
    translate([140+x*40,330])  stop_plate_2d();
  }
  translate([160,365]) {
    translate([0,0]) triagonal_support_2d();
    translate([15,20]) rotate(180) triagonal_support_2d();
  }

  translate([0,130]) regen_pusher_2d(0);
  translate([180,130]) regen_pusher_2d(2);

  translate([370,120])
    for(x=[0:1]) {
      translate([x*40,0])
	pusher_support_2d();
    }

  translate([300,55])
    for(x=[0:1]) {
      translate([x*40,40])
	rotate(90) output_support_2d();
    }


}

// Example 600x400 sheet
translate([-5,-5,-5]) color([0.5,0.5,0.5,0.5]) cube([600,400,3]);
