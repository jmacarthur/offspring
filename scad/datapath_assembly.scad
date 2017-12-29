include <globs.scad>;
use <subtractor.scad>;
use <vertical-memory.scad>;
use <distributor.scad>;
use <diverter.scad>;



// Plywood board
translate([-600,-1200,-30]) color([0.7,0.5,0.0]) cube([1200,2400,18]);


translate([-140,950,0]) rotate([-90,0,0]) distributor_assembly();

translate([0,740,0]) diverter_set();

// Space reserved for injector assembly
translate([-16*pitch-50,680,0]) cube([800,50,30]);

for(i=[0:3]) {

  translate([0,200+i*150,0]) {
    rotate([180,0,0]) memory_cell_assembly(1);
    color([0,0.7,0.7]) translate([-memory_columns_per_cell*pitch-50,0]) rotate([180,0,0])  memory_cell_assembly(0);
  }
 }

// Space reserved for regenerator assembly
module regenerator_block()
{
  translate([-16*pitch-50,0,0]) cube([800,50,30]);
}

translate([0,0,0]) regenerator_block();

module diverter_set() {
  for(x=[-2:1]) {
    split = (x<0? -50:0);
    translate([x*pitch*8+split,0,20]) rotate([-90,0,0]) diverter();
  }
}



translate([0,-100,0]) diverter_set();
translate([0,-50,0]) diverter_set();

translate([343,-150,0]) {
  subtractor_assembly();
  translate([-8*pitch,-8*subtractor_pitch_y]) subtractor_assembly();
  translate([-16*pitch-50, 0])  subtractor_assembly();
  translate([-24*pitch-50,-8*subtractor_pitch_y]) subtractor_assembly();
}

translate([0,-700,0]) regenerator_block();
