include <globs.scad>;
use <subtractor.scad>;
use <infra.scad>;


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
