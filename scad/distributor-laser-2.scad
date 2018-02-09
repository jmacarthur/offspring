include <globs.scad>;

use <distributor.scad>;


// Example A3 sheet
//translate([0,0,-10]) color([0.1,0.1,0.1]) cube([420,297,1]);
kerf = 0.1;
offset(kerf) {
  translate([5,5]) stage2_plate();
  translate([15,170]) input_riser();
  translate([25,195]) channel_wall();
  translate([25,220]) channel_wall();
  translate([15,245]) input_track();
  translate([5,265]) input_pipe_holder();
  translate([30,265]) input_pipe_holder();
  translate([360,85]) angled_support_bracket();

  translate([240,130]) {
    translate([0,55]) raiser_crank();
    translate([40,35]) rotate(180) raiser_crank();
    translate([0,20]) raiser_crank();
    translate([40,0]) rotate(180) raiser_crank();
  }
  translate([65,255]) raiser_connector();
}

// Memory things (not distributor related)
use <vertical-memory.scad>;
rows = 8;
cell_height = 14;

offset(kerf) {
  translate([295,120]) {
    for(col=[0:3]) {
      union() {
	rows = 8;	cell_height = 14;
	for(row=[0:rows]) {
	  translate([col*30+10,row*cell_height]) memory_cell((row % 4==0) || row==rows);
	  translate([col*30+15,row*cell_height+13.5]) rotate(180) memory_cell((row % 4==0) || row==rows);
	}
      }
    }
  }
  translate([190,275]) rotate(-90) row_comb();
  translate([60,275]) rotate(-90) row_comb();

  translate([90,280]) row_selector();
}
