// The small scale sequencer

use <decoder.scad>;

cam_max_diameter = 100;
cam_min_diameter = 80;
cam_boss_diameter = 50;

cam_spacing = 10;

// Internal space in frame is 230mm (inside openbeam)
// 265mm (inside angle iron)

// We require 18 cams.
ncams = 18;
follower_length = 150;


enumerator_y_spacing = 4;

module example_cam_2d() {
  union() {
    difference() {
      circle(d=cam_max_diameter);
      square([cam_max_diameter+1, cam_max_diameter+1]);
      rotate(180) square([cam_max_diameter+1, cam_max_diameter+1]);
    }
    circle(d=cam_min_diameter);
  }
}

module example_cam() {
  union() {
    linear_extrude(height=3) example_cam_2d();
    cylinder(d=cam_boss_diameter,h=cam_spacing);
  }
}

module follower_2d() {
  difference() {
    square([follower_length,10]);
    translate([5,5]) circle(d=3);
    translate([follower_length-10,5]) circle(d=3);
    // Indents for the cam bearing
    translate([follower_length/2-10,-1]) square([5,2]);
    translate([follower_length/2+5,-1]) square([5,2]);
  }
}

module cam_bearing() {
  color([1,1,0])
  difference() {
    cube([9,20,20]);
    translate([-1,10,2.5]) rotate([0,90,0]) cylinder(d=3,h=12, $fn=10);
    translate([3,-1,-1]) cube([3,32,13]);
    translate([3,-1,16]) cube([3,25,20]);
    translate([3,5,15]) cube([3,10,10]);

    // Entry ramps
    translate([4.5,0,-1]) rotate([0,0,45]) translate([-2.5,-2.5,0]) cube([5,5,13]);

  }

}

module follower() {
  translate([0,-follower_length,0])  rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) follower_2d();
  translate([-3,-follower_length/2 - 10,-15]) cam_bearing();
}

module cam_and_follower_assembly() {
  for(i=[0:ncams-1]) {
    translate([i*cam_spacing,0,0]) rotate([0,90,0]) rotate([0,0,90])example_cam();
    translate([i*cam_spacing,follower_length/2,cam_max_diameter/2+10]) follower();
  }
}


module trimmed_enumerator_rod_2d(i)
{
  difference() {
    square([8*10+100,20]);
    enumerator_cutouts(i, 8, 10, 5, 10);
  }
}

module enumerator_base() {
  difference() {
    cube([30,enumerator_y_spacing*2+10,15]);
    for(i=[0:2]) {
      translate([-1,3+enumerator_y_spacing*i-0.25,5]) cube([32,3.5,20]);
    }
  }
}

module enumerator_rods() {
  for(i=[0:2]) {
    seq = $t*10;
    offset = floor(seq/(pow(2,i))) % 2;
    translate([99-offset*5,-50+i*enumerator_y_spacing,40]) rotate([90,0,0]) linear_extrude(height=3) trimmed_enumerator_rod_2d(i);
  }
}


module side_plate_generic_2d() {
  hook_y = 60;
  perf_angle_spacing = 50;
  difference() {
    translate([-100,-20]) square([200,100]);

    // Cam axle hole
    circle(d=10);

    // Hooks to mount to frame
    translate([hook_y,-10]) circle(d=6);
    translate([hook_y-3,-21]) square([6,11]);

    translate([hook_y, -10 + perf_angle_spacing]) circle(d=6);
  }
}


module enumerator_mount_plate_2d() {
  square([cam_spacing*18+40, 20]);
}

module frame() {
  frame_x = [-20,cam_spacing*18+20];
  for(x=frame_x) {
    translate([x,0,0]) rotate([0,90,0]) linear_extrude(height=5) rotate(90) side_plate_generic_2d();
  }
  translate([-20,-56,30]) rotate([90,0,0]) linear_extrude(height=5) enumerator_mount_plate_2d();
}

module sequencer() {

  cam_and_follower_assembly();
  enumerator_rods();
  for(x=[100,150]) translate([x,-50-3-3,35-1]) enumerator_base();
  color([0,1,0]) frame();


  // Emulate perf angle
  translate([-50,0,-200]) {
    cube([25,25,400]);
    translate([295,0,0]) cube([25,25,400]);
  }

}

sequencer();
