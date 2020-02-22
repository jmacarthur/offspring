// Sequencer output assembly

include <sequencer_globs.scad>;

module fake_cam() {
  rotate([0,90,0]) {
    translate([0,0,-5.5])   cylinder(d=170,h=3);
    translate([0,0,-2.5]) color([0.4,0.4,0.4]) cylinder(d=150,h=5);
    translate([0,0,2.5])    cylinder(d=170,h=3);
  }
}

// Example cams, not part of finished assembly
for(i=[0:3]) {
  translate([cam_spacing*i, 0, 0]) fake_cam();
}

for(i=[1:5]) {
  translate([cam_spacing*3 + fixed_cam_spacing*i, 0, 0]) fake_cam();
}

function profile_position(x) = ( (x<8) ? cam_spacing*floor(x/2) : fixed_cam_spacing*floor((x-6)/2) + cam_spacing*3 ) -4 + 8*(x%2);
function follower_position(x) = ( (x<8) ? -3 + 6 * (x%2) : 0 ) + profile_position(x);
  
for(i=[0:17]) {
  translate([follower_position(i)-1.5, 90, 0]) cube([3,3,3]);
 }

  
