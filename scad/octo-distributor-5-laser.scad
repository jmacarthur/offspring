use <octo-distributor-5.scad>;

intake_slope = 10;

kerf = 0.1;
module octo_distributor_5_laser() {
  offset(kerf) {
    intake_chamber_2d();
    translate([45,15]) intake_sidewalls_2d();
    translate([0,55]) intake_sidewalls_2d();

    translate([40,65]) intake_sidebar_2d(10);
    translate([45,90]) intake_sidebar_2d(0);

    translate([110,-15]) intake_moving_top_2d();

    translate([125,30]) intake_grade_2d(0);
    translate([145,30]) intake_grade_2d(1);

    translate([100,70]) rotating_plate_2d(0);
    translate([160,70]) rotating_plate_2d(44*sin(intake_slope));
    translate([40,105]) rotate(90) right_swing_support_2d();
    translate([165,20]) rotate(180) distributor_cover_2d();
  }
}
octo_distributor_5_laser();
