use <globs.scad>;

use <regen-2.scad>;


module regen_laser_layout() {

  translate([0,110]) back_plate_2d();
  translate([0,70]) front_plate_2d();

  for(c=[0:7]) {
    translate([40*c,0]) {
      translate([0,0]) output_pushrod_2d();
      translate([0,15]) input_pushrod_2d();
    }
  }

  for(c=[0:3]) {
    translate([70*c+5,40]) {
      output_crank_2d();
      translate([50,20]) rotate(180) output_crank_2d();
    }
  }

  translate([210,105]) {
    translate([0,0]) end_separator_plate_2d();
    translate([70,-25]) rotate(180) end_separator_plate_2d();
  }

  translate([0,160]) base_plate_2d();
  translate([0,210]) lower_output_comb_2d();


  translate([5,240]) {
    drive_plate_2d();
      for(c=[0:13]) {
	translate([c*12+30,45]) rotate(90) { separator_plate_2d(); }
      }
  }


  translate([210,120]) {
    bowden_cable_mount_2d();
    translate([25,0]) bowden_cable_outer_mount_2d();
    translate([50,0]) bowden_cable_outer_mount_2d();
  }
}

kerf=0.1;

offset(kerf) regen_laser_layout();

// example acrylic

color([0.5,0.5,0.7,0.5]) translate([0,0,-6]) cube([600,400,3]);
