// 3d-printable crank handle

$fn=50;
difference() {
  offset = 100;
  bolt_x = 15;
  union() {
    hull() {
      cylinder(d=20, h=20);
      translate([offset,0,0]) cylinder(d=15, h=20);
    }
    translate([bolt_x-5,-10,5]) cube([10,20,10]);
  }
  clearance = 0.5;
  translate([0,0,-1]) cylinder(d=12+clearance, h=22);
  translate([offset,0,-1]) cylinder(d=6, h=22);

  slot_width = 1;
  translate([-25,-slot_width/2,-1]) cube([75,slot_width, 22]);

  translate([bolt_x,20,10]) rotate([90,0,0]) cylinder(d=6,h=50);
}
