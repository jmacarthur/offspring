use <vertical-memory-2.scad>;
use <decoder.scad>;

slot_spacing = 50;
slot_diameter = 6;
slot_height = 28;

module perforated_angle() {
  difference() {
    cube([27,27,2000]);
    translate([3,3,-1]) cube([27,27,2002]);
    for(i=[0:39]) {
      translate([0,0,16]) {
	translate([-1, 18, i*slot_spacing]) rotate([0,90,0]) cylinder(d=slot_diameter,h=5);
	translate([-1, 18-slot_diameter/2, i*slot_spacing])  cube([slot_diameter, slot_diameter, slot_height-slot_diameter]);
	translate([-1, 18, i*slot_spacing+slot_height-slot_diameter]) rotate([0,90,0]) cylinder(d=slot_diameter,h=5);
	
	translate([18, -1, i*slot_spacing]) rotate([-90,0,0]) cylinder(d=slot_diameter,h=5);
	translate([18-slot_diameter/2, -1, i*slot_spacing])  cube([slot_diameter, slot_diameter, slot_height-slot_diameter]);
	translate([18, -1, i*slot_spacing+slot_height-slot_diameter]) rotate([-90,0,0]) cylinder(d=slot_diameter,h=5);
      }

    }
  }
}

rotate([90,0,0]) memory_assembly();
translate([200,50,115]) rotate([0,90,0]) address_decoder();

perforated_angle();
translate([-200,0,0]) rotate([0,0,90]) perforated_angle();
