include <globs.scad>;
use <decoder.scad>;

follower_spacing = 14; // Spacing between each input follower
// Enumeration rods

n_inputs = 4;

translate([5,160]) top_plate_2d();
translate([5,230]) xBar_2d(5,20,50); // Middle


translate([390, 120]) rotate(90) triangular_support_plate_2d();
translate([290, 280]) rotate(270) triangular_support_plate_2d();

translate([5,5]) side_plate_2d();

for(i=[0:2])
  translate([300,i*25+5]) yComb_2d();

translate([0,0,-3]) color([0.5,0.5,0.5,0.5]) cube([420,297,3]);

for(i=[0:3]) translate([380,i*25+10]) axle_reinforcer_2d();
