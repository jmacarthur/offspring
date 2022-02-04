use <vertical-memory-2.scad>;
use <octo-distributor-6.scad>;
use <regen-diverter.scad>;
use <decoder.scad>;
include <globs.scad>;
use <infra.scad>;
use <stacked-subtractor.scad>;
use <base-regen.scad>;

use <sequencer.scad>;

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
memory_mount_z = 800;

translate([0,0,1100]) injector_assembly();
translate([22.5,-5,memory_mount_z+158]) rotate([90,0,0]) memory_assembly();
translate([22.5,-5,memory_mount_z+10]) rotate([90,0,0]) memory_assembly();
translate([329.5,35,memory_mount_z+158+124.5]) rotate([0,90,0]) address_decoder();

translate([angle_iron_internal_spacing,0,0]) perforated_angle();
translate([0,0,0]) rotate([0,0,90]) perforated_angle();

openbeam();
translate([angle_iron_internal_spacing-15, 0 ,0]) openbeam();

color([0,0,0.9,0.5]) translate([-100+7.5,-5,memory_mount_z]) memory_mounting_plate();

// Indicate where memory input is
//color([0,1,1]) translate([data7_x, -11.5, 780]) cylinder(d=ball_bearing_diameter, h=50);


translate([0,0,550]) stacked_subtractor();

translate([0,-28,300]) rotate([0,0,-90]) base_regen(0);

translate([0,-130,100]) {
  sequencer_assembly();
  casing();
}
