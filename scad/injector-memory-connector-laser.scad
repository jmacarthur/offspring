include <globs.scad>;
use <injector-memory-connector.scad>;

kerf = 0.07;

offset(r=kerf) {

for(i=[0:15]) {
  translate([i*15, 0]) {
    rotate(5) rib_2d();
  }
}

translate([5,30]) color([1,0,0]) connecting_plate_2d();

}
