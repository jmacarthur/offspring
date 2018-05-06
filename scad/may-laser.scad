laser_view = true;

include <globs.scad>
use <stage2-distributor.scad>;
use <diverter-parts.scad>;
include <octo-distributor-5.scad>;
kerf = 0.1;

module part1() {

  offset(kerf) {

    translate([50,-10]) distributor_backing_plate_2d();



    translate([170,-95]) injector_diverter_support_bracket_2d();
    translate([190,-195]) injector_diverter_support_bracket_2d();

    translate([110,-95]) ejector_channel_2d();

    translate([35,-95]) ejector_support_2d();
    translate([75,-95]) ejector_support_2d();


    translate([390,-190]) {
      rotate(90) {
	translate([0,0])  ejector_comb_2d();
	translate([0,50]) discard_channel_side_2d();
	translate([0,100]) discard_channel_base_2d();
	translate([0,120]) discard_channel_side_2d();
      }
    }

    translate([5,-195]) output_flap_2d();

  }
  color([0.3,0.3,0.3]) translate([0,-200,-3]) cube([400,200,3]);
}


module part2() {
   offset(kerf) {
     translate([65,5]) intake_chamber_coupler_2d();

    translate([45,10]) rotating_plate_2d(0);
    translate([20,60]) rotate(180) rotating_plate_2d(44*sin(intake_slope));

    translate([70,35]) injector_diverter_support_2d();
    translate([130,65]) rotate(180) injector_diverter_support_2d();

    for(x=[0:2]) translate([325+x*25,50]) rotate(40) ejector_2d();
    for(x=[0]) translate([220+x*25,20]) rotate(90) bracketed_ejector_channel_2d();
    for(x=[1:3]) translate([220+x*25,20]) rotate(90) ejector_channel_2d();


    translate([150,50]) rotate(90) flap_support_2d();
    translate([190,65]) rotate(270) flap_support_2d();

  }
  color([0.3,0.3,0.3]) translate([0,0,-3]) cube([400,80,3]);
}


part1();
//part2();
