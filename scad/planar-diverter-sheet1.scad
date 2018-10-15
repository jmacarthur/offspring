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
  
  translate([210,250]) 
  for(i=[0:1]) {
    translate([0,i*20,0]) regen_crank_2d();
    translate([32,2+i*20,0]) rotate(180) regen_crank_2d();
  }
  translate([370,190]) 
  for(i=[0:6]) {
    translate([0,i*15,0]) diverter_tab_2d(30);
  }
  for(i=[0:1]) {
    translate([360+30*i,0,0]) side_plate_2d();
  }
}

// Example A3 sheet
//color([0.8,0.8,1.0]) translate([0,0,-5]) square([420,297]);


// Example A4 sheet
//color([0.8,0.8,1.0]) translate([0,305,-5]) square([210,297]);
