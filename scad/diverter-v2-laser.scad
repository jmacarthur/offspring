// Laser layout for Diverter v2

include <globs.scad>;
use <diverter-v2.scad>;

$fn=20;
columns = 8;

support_positions = [16,(columns-2)*pitch+16];
conduit_width = 16;

drill_positions = [ pitch + conduit_width + (pitch-conduit_width)/2,
		    pitch*5 + conduit_width + (pitch-conduit_width)/2 ];


diversion_plate_2d();

translate([5,50]) support_2d();
translate([55,50]) support_2d();

translate([50,85]) axle_mounting_bracket_2d();
translate([105,85]) axle_mounting_bracket_2d();

translate([0,95]) back_mounting_plate_2d();
