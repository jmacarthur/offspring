// Lasercut test for distributor. Not meant to go into production.

include <globs.scad>;
use <distributor.scad>;
use <vertical-memory.scad>;

module strip_grading_plate()
{
    /* Deflector is made from Albion alloys brass strip, 6mm x 0.8mm as sold.
       it's actually 6.3mm wide and 0.8mm thick. */
    strip_height = 6.3 - 0.25;
    strip_width = 0.8 - 0.16;
    difference() {
        square([100,20]);
        for(i=[0:10]) {
            // We know the above numbers are too small, so start at the smallest and work up
            translate([10+i*10,6.5]) square([strip_width + i*0.1, strip_height+i*0.1]);
        }
    }
}

kerf = 0.1;

offset(kerf) {

    translate([5,5]) stage2_plate();
    translate([45,170]) stage1_base_plate();
    translate([45,230]) stage1_top_plate();
    translate([300,100]) strip_grading_plate();

    translate([300,150]) {
      for(col=[0:3]) {
      union() {
	rows = 8;	cell_height = 14;

	for(row=[0:rows]) {
	  translate([col*30+10,row*cell_height]) memory_cell();
	  translate([col*30+15,row*cell_height+14]) rotate(180) memory_cell();
	}
      }
      }
    }

}

// An A3 sheet for sizing
color([0.1,0.1,0.1,0.1]) translate([0,0,-3]) cube([420,297,1]);
