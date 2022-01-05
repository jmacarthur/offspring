include <globs.scad>;
use <subtractor.scad>;
use <infra.scad>;

use <regen-diverter.scad>;
use <diverter-end-clip.scad>;
// Main accumulator
translate([203,-15,0]) rotate([90,0,0]) subtractor_assembly();

// PC
translate([203,-15-30,0]) rotate([90,0,0]) subtractor_assembly();

// Represent mounting rails & data lines
translate([0,0,0]) cube([15,15,100]);
translate([250,0,0]) cube([15,15,100]);
translate([angle_iron_internal_spacing,0,-500]) perforated_angle();
translate([0,0,-500]) rotate([0,0,90]) perforated_angle();




translate([7.5,0,50]) rotate([90,0,0]) cylinder(d=3,h=50);
translate([data7_x, data7_y, -100]) cylinder(d=ball_bearing_diameter,h=200);

// Bracket for mounting

module subtractor_bracket_left() {
  difference() {
    translate([-25,-100,-100]) cube([25,100,110]);
    translate([-25-1,-5,-100]) rotate([120,0,0]) cube([25+2,150,100]);
    translate([-25-5,-100-5,-100-5]) cube([25,100,100]);

    // Drill holes to mount to frame
    translate([-19.5, -6, -30]) rotate([-90,0,0]) cylinder(d=6,h=50);
    translate([-19.5, -6, -30-50]) rotate([-90,0,0]) cylinder(d=6,h=50);

    for(i=[0:5]) translate([-26, -3-10*i, 0]) cube([28, 3, 15]);

    translate([-26,-100,0]) cube([10,115,15]);

    // Frame cutout
    translate([-6, -5,-5])     rotate([270,0,0]) rotate([0,90,0]) linear_extrude(height=7) polygon([[0,0], [30,0], [0,50]]);
  }
}


subtractor_bracket_left();
translate([250+15,0,0]) scale([-1,1,1]) subtractor_bracket_left();
translate([0,0,190]) regen_diverter_assembly();

translate([22,-78,57]) end_clip();
