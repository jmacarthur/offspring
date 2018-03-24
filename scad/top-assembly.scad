/* Top Assembly

   This includes the distributor, diverter and injector - all the
   parts of the machine above the memory. This is a perspex box which
   contains all the parts and holds them together on top of the memory
   case.

*/

include <globs.scad>;
use <interconnect.scad>;

use <diverter-v2.scad>;
use <stage2-distributor.scad>;
use <octo-distributor-3.scad>;
use <injector.scad>;

translate([0,0,260]) {
  translate([pitch*4,0,0]) 
  // Octo injector translated so the centre line is on x=0
  translate([-4-ball_bearing_diameter*4,0,0]) 3d_injector_assembly();
}
translate([pitch*4,0,240]) rotate([0,0,180]) 3d_stage2_assembly();
translate([0,0,150]) injector_assembly();
diverter_assembly();


