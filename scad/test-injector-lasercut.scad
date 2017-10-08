/* Laser cutting layout for memory injector */

include <globs.scad>;
use <memory-injector.scad>;

$fn = 20;
kerf = 0.1;

module ejector_pair() {
  ejector_plate_2d();
  translate([35,15]) rotate(180) ejector_plate_2d();
}

// Fake 3d outline

//translate([0,0,-5]) color([0.1,0.1,0.1,0.1]) cube([420,297,1]);

truncate = true;

module cutting_area() {
  translate([5,5]) square([truncate? 230-10:1000,297-10]);
}

offset(delta = kerf, chamfer = true) {
  translate([200,50]){
    translate([-30,0]) ejector_plate_2d();
    translate([35,15]) rotate(180) ejector_plate_2d();
  }
  translate([100,25]) {
    rotate(180) ejector_plate_2d();
    translate([-25,55]) ejector_plate_2d();
  }
  translate([330,25]) {
    rotate(180) ejector_plate_2d();
    translate([-25,55]) ejector_plate_2d();
  }
  translate([340,95]) {
    rotate(180) ejector_plate_2d();
    translate([-35,55]) ejector_plate_2d();
  }

  translate([410,190]) {
    rotate(270) ejector_plate_2d();
  }

  translate([330,170]) {
    rotate(180) ejector_plate_2d();
  }

  
  translate([240,220])
  for(x=[0:0]) {
    translate([0,-x*90]) support_2d();
    translate([0+150,35-x*90]) rotate(180) support_2d();
  }


  intersection() {
    cutting_area();
    translate([25,280]) rotate(-90) base_plate_2d();
  }
  intersection() {
    cutting_area();
    translate([25,110]) rotate(-90) comb_2d();
  }
  intersection() {
    translate([25,150]) pipe_holder_bar_2d();
    cutting_area();
  }
  intersection() {
    translate([25,180]) pipe_holder_bar_2d();
    cutting_area();
  }


  // Bearing support bar - just a rectangle
  translate([190,5])
    intersection() {
    square([220,20]);
    input_rail_2d();
  }
}
