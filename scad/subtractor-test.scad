use <subtractor.scad>;

kerf = 0.05;


/*offset(r=kerf) {
  input_guard_top_2d();

  translate([50,0]) 
    output_guard_top_2d();
}
*/

//scale([1,-1,1])
//pipe_connector_plate();

intersection() {

  translate([0,8,0]) pipe_extender();
  translate([0,0,-30]) cube([100,13,50]);
}


//translate([330,0]) back_layer_2d();
//io_support_layer_2d();
//translate([-500,-240]) rotate(180) top_layer_2d();

//translate([0,200]) reverse_reset_lever_2d();


//scale([-1,1,1]) subtractor_bracket_left();
