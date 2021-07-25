use <vertical-memory-2.scad>;
use <decoder.scad>;

slot_spacing = 50;
slot_diameter = 6;
slot_height = 28;

angle_iron_internal_spacing=265;
angle_iron_hole_offset = 19.5;
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

module memory_mounting_plate() {
  x1 = 100; // coord of first openbeam rail centre
  x2 = x1+20; // coord of first memory mounting hole
  y1 = 280;
  difference() {
    cube([420,5,300]);
    // Openbeam mounting holes
    translate([x1,-1,y1]) rotate([-90,0,0]) cylinder(d=3,h=10);
    translate([x1+250,-1,y1]) rotate([-90,0,0]) cylinder(d=3,h=10);

    // Memory mounting holes
    translate([x2,-1,y1]) rotate([-90,0,0]) cylinder(d=3,h=10);
    translate([x2+200,-1,y1]) rotate([-90,0,0]) cylinder(d=3,h=10);
    // Decoder mounting holes
    for(y=[0:2])
    translate([x1+250+47, -1, y1-17.5-119*y]) rotate([-90,0,0]) cylinder(d=10,h=10);
  }
}


module openbeam() {
  color([0.3,0.3,0.3]) cube([15,15,1000]);
}
memory_mount_z = 500;

translate([22.5,-5,memory_mount_z+158]) rotate([90,0,0]) memory_assembly();
translate([329.5,35,memory_mount_z+158+124.5]) rotate([0,90,0]) address_decoder();

translate([angle_iron_internal_spacing,0,0]) perforated_angle();
translate([0,0,0]) rotate([0,0,90]) perforated_angle();

openbeam();
translate([angle_iron_internal_spacing-15, 0 ,0]) openbeam();

color([0,0,0.9,0.5]) translate([-100+7.5,-5,memory_mount_z]) memory_mounting_plate();
