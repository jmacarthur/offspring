// Cam drive and sequencer unit for mechanical SSEM.


use <generic_conrods.scad>;

// At the moment, there are 17 cams. 4 of these are selective and only drive if certain instructions are in use. The rest are always in use.
// The instructions which need a gate are LDN, STO, JRP, JMP and CMP. LDN and CMP have the same cam pattern so share one (although they must have independent outputs). SUB is the default instruction so does not need a gate; HLT is unimplemented.

cam_diameter = 150;
cam_width=5;
cam_spacing = 2*cam_width;

axle_diameter = 20;

num_cams = 17;

gap_position = 8; // Gap for the drive gear happens after this many cams
gap_width = 40;
// Example cams


module cam_2d() {
  difference() {
    circle(d=cam_diameter);
    circle(d=axle_diameter);
  }
}

module drive_gear() {
  // Modelled on Technobots MOD 2 60 tooth gear
  outer_diameter = 124;
  tooth_width=20;
  bore=20;
  lowest_diameter = 116;
  overall_width=35;
  boss_diameter=70;
  difference() {
    union() {
      cylinder(h=tooth_width, d=outer_diameter);
      cylinder(h=overall_width, d=boss_diameter);
    }
    
    for(i=[0:60]) {
      rotate(i*360/60) translate([-1.5, lowest_diameter/2, -1]) cube([3,10,tooth_width+2]);
    }
    translate([0,0,-1]) cylinder(h=overall_width+2, d=bore);
  }
}

module follower_2d() {
  union() {
    conrod(cam_diameter/2);
    // Output blob
    translate([cam_diameter/2-10,4]) square([10,6]);
    // Follower blob
    translate([cam_diameter/2,-5]) circle(d=20);
  }
}

module camshaft() {
  follower_axle_y = cam_diameter/2+15;
  for(i=[0:num_cams-1]) {
    offset = (i>=gap_position?gap_width:0);
    translate([cam_spacing*i+offset, 0,0]) rotate([0,90,0]) linear_extrude(height=cam_width) cam_2d();
    translate([cam_spacing*i+offset, follower_axle_y,cam_diameter/2]) rotate([0,90,0]) linear_extrude(height=3) follower_2d();
  }
  // Bonus follower which is driven by the first cam, to drive CMP or LDN
  translate([cam_spacing*-1, follower_axle_y, cam_diameter/2]) rotate([0,90,0]) linear_extrude(height=3) follower_2d();

  translate([cam_spacing*gap_position,0,0]) rotate([0,90,0]) drive_gear();
}

camshaft();
