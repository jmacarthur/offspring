use <globs.scad>;
use <planar-diverter.scad>;

kerf = 0.1;

offset(r=kerf) {
  //for(i=[0:2]) translate([210+i*50,20,0]) diverter_array_2d();
  translate([15,15,0]) base_plate_2d();

  for(i=[0:2]) {
    translate([210+i*20,10,0]) diverter_top_plate_2d(diverter_offsets()[i]);
  }

  for(i=[0:2]) {
    translate([270+i*30,10,0]) diverter_slider_plate_2d(diverter_offsets()[i]);
  }

  for(i=[0:2]) {
    translate([360+i*30,10,0]) exit_plate_2d(diverter_offsets()[i]);
  }
  translate([450,10,0]) regen_exit_plate_2d();
  translate([490,10,0]) regen_pusher_bar_2d();
  translate([520,10,0]) regen_top_plate_2d();
  for(i=[0:3]) {
    translate([550,10+i*35,0]) regen_crank_2d();
    translate([562,25+i*35,0]) rotate(180) regen_crank_2d();
  }
  for(i=[0:15]) {
    translate([580,10+i*15,0]) diverter_tab_2d(30);
  }
  for(i=[0:1]) {
    translate([620+30*i,10,0]) side_plate_2d();
  }

  translate([680,10,0]) bowden_plate_2d();
}

// Example A3 sheet
color([0.8,0.8,1.0]) translate([0,0,-5]) square([420,297]);
