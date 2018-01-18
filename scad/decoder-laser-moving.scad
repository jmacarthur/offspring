include <globs.scad>;
use <decoder.scad>;

follower_spacing = 14; // Spacing between each input follower
// Enumeration rods

n_inputs = 4;

for(s=[0:n_inputs-1]) {
  translate([15,5+25*s])
    enumerator_rod(s, n_inputs, follower_spacing, 0, 10);
}

for(s=[0:11]) {
  translate([200, 110+15*s]) lever_2d();
}



translate([0,0,-3]) color([0.5,0.5,0.5,0.5]) cube([420,297,3]);

