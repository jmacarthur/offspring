// Infrastructure parts - rack rail, openbeam
include <globs.scad>;

module perforated_angle() {
  color([0.5,0.5,0.5])
  difference() {
    cube([27,27,2000]);
    translate([3,3,-1]) cube([27,27,2002]);
    for(i=[0:39]) {
      translate([0,0,16]) {
	translate([-1, angle_iron_hole_offset, 0]) {
	  translate([0, 0, i*slot_spacing]) rotate([0,90,0]) cylinder(d=slot_diameter,h=5);
	  translate([0, -slot_diameter/2, i*slot_spacing])  cube([slot_diameter, slot_diameter, slot_height-slot_diameter]);
	  translate([0, 0, i*slot_spacing+slot_height-slot_diameter]) rotate([0,90,0]) cylinder(d=slot_diameter,h=5);
	}
	
	translate([angle_iron_hole_offset, -1, 0]) {
	  translate([0, 0, i*slot_spacing]) rotate([-90,0,0]) cylinder(d=slot_diameter,h=5);
	  translate([0-slot_diameter/2, 0, i*slot_spacing])  cube([slot_diameter, slot_diameter, slot_height-slot_diameter]);
	  translate([0, 0, i*slot_spacing+slot_height-slot_diameter]) rotate([-90,0,0]) cylinder(d=slot_diameter,h=5);
	}
      }
    }
  }
}
