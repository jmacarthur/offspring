use <memory.scad>;

include <globs.scad>;

word_horizontal_spacing = 40;

for(i=[0:word_width]) {
  translate([word_horizontal_spacing*i,0,3])  linear_extrude(height=3) stator_2d();
}

/* Rest position for each pusher is just left of the data slot. Pushing right by 6 will drop the data.
   To engage the ramp, you must move left by (word_horizontal_spacing+10). */
pusher_translate = -word_horizontal_spacing+26;

for(i=[0:word_width]) {
  color([1.0,0,0]) translate([word_horizontal_spacing*i+4+pusher_translate,22,6]) linear_extrude(height=3) pusher_2d();
}

color([0.5,0,0,0.2]) translate([0,22,9]) linear_extrude(height=3) row_bar_2d();
