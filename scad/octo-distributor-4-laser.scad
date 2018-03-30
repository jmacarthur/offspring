include <globs.scad>;
use <octo-distributor-4.scad>;

columns = 8;

kerf = 0.1;

module a3_sheet_1() {
  translate([0,0]) diverter_2d();
  translate([0,35]) interplate_support_2d();
  translate([0,60]) diverted_output_plate_2d();
  translate([0,130]) output_plate_2d();

  translate([0,150]) {
    upper_plate_2d();
    translate([200,240]) rotate(180) core_plate_2d();

    translate([30,0])
    for(c=[0:13]) {
      translate([(c%5) *30,floor(c/5)*15]) diverter_rib_2d();
    }

    translate([25,217]) {
      diverter_rotate_arm_2d();
      translate([40,-15]) rotate(180) diverter_rotate_arm_2d();
    }
    translate([100,210]) for(x=[0,1]) { translate([x*50,0]) rotate(90) input_tube_holder_2d();  }
  }


}


module a3_sheet_2() {


  translate([0,220]) for(x=[0:7]) translate([x*20,0]) upper_output_separator_2d();
  translate([0,195]) spring_bar_2d();

  translate([0,0]) {
    top_plate_2d();
    translate([200,240]) rotate(180) base_plate_2d();
    translate([35,35])
    for(c=[0:5]) {
      translate([c*28,0]) diverter_output_rib_2d();
      translate([c*28-2,2]) rotate(180)  diverter_output_rib_2d();
    }
    translate([35,20])
    for(c=[0:1]) {
      translate([c*28,0]) diverter_output_rib_2d();
      translate([c*28-2,2]) rotate(180)  diverter_output_rib_2d();
    }
  }

  translate([10,320])
    for(c=[0:3]) {
      translate([c*40,0]) {
	translate([0,0]) {
	  ejector_arm_2d();
	}
	translate([15,55]) {
	  rotate(180) ejector_arm_2d();
	}
      }
    }

  translate([0,350]) for(x=[0,1]) {
    translate([x*20,-100]) diverter_support_2d();
  }

  translate([80,250])
  for(x=[0,1]) {
    translate([0,x*30]) rotate(90) ejector_support_2d();
  }

  translate([230,0]) rotate(90) stand_2d();
  translate([230,100]) rotate(90) stand_2d();
  translate([260,0]) rotate(90) stand_joiner_2d();
  translate([260,200]) rotate(90) stand_joiner_2d();
}

offset(kerf) { translate([20,0]) a3_sheet_1();}
offset(kerf) { translate([320,5]) a3_sheet_2(); }


// Simulated A3 acrylic sheets

module a3_sheet()
{
  translate([-5,-5,-3]) color([0.4,0.4,0.5,0.5]) cube([297,410,3]);
}

a3_sheet();
translate([300,0]) a3_sheet();
