// Simple standoff for the memory decoder

module decoder_standoff() {
  difference() {
    cylinder(d=20, h=36);
    translate([0,0,-1]) cylinder(d=10,h=38);
  }
}

module decoder_profile_2d() {
  difference() {
    translate([5,0]) square([10,36]);
    translate([35,18]) circle(d=48, $fn=80);
  }
}

rotate_extrude() { decoder_profile_2d(); }
