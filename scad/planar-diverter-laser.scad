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
    translate([270+i*40,10,0]) diverter_slider_plate_2d(diverter_offsets()[i]);
  }

  for(i=[0:2]) {
    translate([5+i*30,310,0]) exit_plate_2d(diverter_offsets()[i]);
  }

  translate([125,310,0]) regen_exit_plate_2d();
  translate([160,320,0]) regen_pusher_bar_2d();
  translate([185,315,0]) regen_top_plate_2d();

  translate([210,250])
  for(i=[0:1]) {
    translate([0,i*20,0]) regen_crank_2d();
    translate([32,2+i*20,0]) rotate(180) regen_crank_2d();
  }
  translate([385,190])
  for(i=[0:6]) {
    translate([0,i*15,0]) diverter_tab_2d(30);
  }
  for(i=[0:1]) {
    translate([385+30*i,0,0]) side_plate_2d();
  }

  translate([95,305,0]) bowden_plate_2d();
  translate([5,520]) 
  for(i=[0:2]) {
    translate([0,15+i*15,0]) bowden_plate_clip_2d();
  }
  translate([70,540]) 
  for(i=[0:3]) {
    translate([0,i*15,0]) diverter_tab_2d(30);
  }
  translate([220,300]) 
  for(i=[0:7]) {
    translate([0,i*15,0]) rotate(90) regen_output_2d(30);
  }
}

// Example A3 sheet
//color([0.8,0.8,1.0]) translate([0,0,-5]) square([420,297]);


// Example A4 sheet
//color([0.8,0.8,1.0]) translate([0,305,-5]) square([210,297]);

