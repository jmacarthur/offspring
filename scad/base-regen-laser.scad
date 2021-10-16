use <base-regen.scad>;


backing_plate_2d();
kerf = 0.08;
$fn=50;


offset(r=kerf) {
  translate([0,50]) 
    for(i=[0:15]) {
      translate([i*20,0]) rotate(90) input_coupler_2d();
    }
  
  translate([0,110]) 
    for(i=[0:7]) {
      translate([i*70,0]) input_arc_2d();
      translate([i*50,100]) output_arc_2d();
    }
}
