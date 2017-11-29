/* Ball bearing injector, mk 2 */

include <globs.scad>;

ball_bearing_diameter = 6.35; // Overrides globs.

// Max wire diameter is 1.59mm for 6.35mm ball bearings.
wire_diameter = 1.45; // Equivalent to AWG 15 / SWG 17.
  stage2_wire_diameter = 2.337; // SWG 13
$fn = 20;
stage1_output_pitch = 8;
stage2_output_pitch = 23;

// Distance between raiser slots
slot_distance = ball_bearing_diameter * 30;

centre_x = ball_bearing_diameter*16;
stage2_total_width = 33*stage2_output_pitch;
stage2_half_width = stage2_total_width/2;

assembly_rotation = 10; // How much is the whole assembly tilted?

// x-positions of the angled support plates
support1x = 20;
support2x = 210;

module input_riser()
{
  difference() {
    union() {
      translate([-10,0]) square([ball_bearing_diameter * 32 + 10, 13]);
      translate([-10,0]) square([10, 20]);
    }
    for(x=[0,slot_distance]) {
      translate([x+5,5]) circle(d=3);
    }
  }
}

module channel_wall(notch)
{
  difference() {
    translate([-20,0]) square([ball_bearing_diameter * 32 + 40, 20]);
    for(x=[0,slot_distance]) {
      translate([x+5,5]) circle(d=3);
      translate([x+5,15]) circle(d=3);
      translate([x+5-1.5,5]) square([3,10]);

      // Axle hole for raiser crank
      translate([x-15,10]) circle(d=3);
      if(notch == 1) {
	for(x=[0:32]) {
	  translate([x*ball_bearing_diameter-wire_diameter/2, 20-wire_diameter]) square([wire_diameter,5]);
	}
      }
    }

  }
}

module raiser_crank() {
  difference() {
    translate([-5,-5])
    union() {
      square([35,10]);
      translate([0,-20]) square([10,30]);
    }
    translate([0,0]) circle(d=3);
    translate([0,-20]) circle(d=3);
    translate([25,0]) circle(d=3);
    translate([15,0]) circle(d=3);
    translate([15,-1.5]) square([10,3]);
  }
}


module stage1_plate() {
  difference() {
    translate([-40,0]) square([32*ball_bearing_diameter+80, 50]);
    translate([-10,45]) circle(d=3);
    translate([15+slot_distance+ball_bearing_diameter,45]) circle(d=3);
    translate([-30,5]) circle(d=3);
    translate([35+slot_distance+ball_bearing_diameter,5]) circle(d=3);
  }
}

module stage1_base_plate() {
  stage1_expansion = stage1_output_pitch / ball_bearing_diameter;
  difference() {
    stage1_plate();
    for(x=[0:32]) {
      translate([x*ball_bearing_diameter, 50]) circle(d=wire_diameter);
    }
    for(x=[-16:16]) {
      translate([ball_bearing_diameter*16 - x*(ball_bearing_diameter*stage1_expansion), 0]) circle(d=wire_diameter);
    }
    // Holes to clip in the support plate
    translate([support1x,25]) square([3,10]);
    translate([support2x,25]) square([3,10]);
  }
}

module stage1_top_plate() {
  stage1_plate();
}

module stage2_plate() {
  difference() {
    polygon(points=[[0,0], [stage2_half_width,0], [stage2_half_width, 30], [stage1_output_pitch*16+10, 160], [0,160]]);
    for(x=[0:16]) {
      translate([x*stage1_output_pitch,155]) circle(d=stage2_wire_diameter);
      translate([x*stage2_output_pitch,5]) circle(d=stage2_wire_diameter);
    }
    translate([15*stage2_output_pitch+5,5]) circle(d=3);
    translate([8*stage2_output_pitch+5,5]) circle(d=3);
    translate([2*stage2_output_pitch+5,5]) circle(d=3);
    translate([17.5*stage1_output_pitch-5,155]) circle(d=3);

    // Holes for the support plate tab
    // We include holes for both support1x and support2x here. If the support plates
    // are equidistant from the centre, the holes will coincide. If not, one
    // set of holes will need to be filled in.
    translate([-support1x+centre_x-3,155-15]) square([3,10]);
    translate([support2x-centre_x,155-15]) square([3,10]);
    translate([-support1x+centre_x-3,20]) square([3,10]);
    translate([support2x-centre_x,20]) square([3,10]);

  }
  echo(stage2_half_width);
}

// Bracket aligned with the whole structure

module angled_support_bracket() {
    union() {
        difference() {
            translate([-10,-20]) square([62,50]);
            // Cut away the whole top for the lifter mechanism
            translate([-11,-21]) square([31,11]);
            // Wider hole for the raiser beam
            translate([-1,-11]) square([5,11]);
            // Close-fit slots for the walls
            translate([-5,-11]) square([3,11]);
            translate([5,-11]) square([3,11]);
            // Holes to allow a coupling rod for the lifter cranks to pass through
            translate([-8,10]) square([6,11]);
            translate([12,10]) square([5,11]);
            // Mounting holes
            translate([-5,25]) circle(d=3);
            translate([5,25]) circle(d=3);
            // Holes for a Bowden cable to pass, to control the lifter
            translate([3,10]) circle(d=bowden_cable_inner_diameter+0.5);

        }
        // Tab to fit into the stage1 plate
        translate([20,-23]) square([10,4]);
        // Tab to fit into the stage2 plate
        translate([51,-10]) square([4,10]);
    }
}

module lower_angled_support_bracket() {
    union() {
        difference() {
            translate([10,100]) square([42,30]);
            // Mounting holes
            translate([20,105]) circle(d=3);
            translate([20,125]) circle(d=3);

        }
        // Tab to fit into the stage2 plate
        translate([51,110]) square([4,10]);
    }
}

module support_bracket() {
    difference() {
        translate([-20,20]) square([30,115]);
        // Mounting holes
        rotate(assembly_rotation) {
            translate([20,105]) circle(d=3);
            translate([20,125]) circle(d=3);
            translate([-5,25]) circle(d=3);
            translate([5,25]) circle(d=3);
        }
    }
}


/* -------------------- 3D Assembly -------------------- */

/* Purely illustrative module to show how the second stage distributor wires should be arranged.*/
    
module distributor_wires()
{

  translate([centre_x-1,0,0])
    for(x=[1:17]) {
      if(x>1) {
	translate([-x*stage1_output_pitch, -200+x*stage1_output_pitch, 20]) difference() {
	  intersection() {
	    circle(r=10);
	    rotate(30) translate([0,-50]) square([50,50]);
	    translate([0,-50]) square([50,50]);
	  }
	  circle(r=8);
	}
      }
      translate([-x*stage1_output_pitch-4, -200+x*stage1_output_pitch+1, 20]) {
	rotate(-90-64) square([x*16.5-6,2]);
      }

      translate([-x*stage1_output_pitch, -200+x*stage1_output_pitch+8, 20]) {
	square([2,130-x*stage1_output_pitch]);
      }

      translate([-x*stage2_output_pitch, -215, 20]) {
	square([2,18+x*0.5]);
      }
    }
}


// There are two parts to this - functional assembly holds all the parts that touch ball bearings.
// The whole function assembly is then rotated and slots into the support assembly, which is kept
// othogonal to the machine's frame.

module functional_assembly() {
    rotate([90,0,0]) linear_extrude(height=3) input_riser();

    translate([0,-5,0]) rotate([90,0,0]) linear_extrude(height=3) channel_wall(1);
    translate([0,5,0]) rotate([90,0,0]) linear_extrude(height=3) channel_wall(0);

    for(x=[0,slot_distance]) {
        translate([x-15,10,10]) rotate([0,13,0]) rotate([90,0,0]) linear_extrude(height=3) raiser_crank();
        translate([x-15,-10,10]) rotate([0,13,0]) rotate([90,0,0]) linear_extrude(height=3) raiser_crank();
    }

    translate([0,-55,20]) linear_extrude(height=3) stage1_base_plate();
    //translate([0,-55,30]) linear_extrude(height=3) stage1_top_plate();
    
    module stage2_assembly() {
        linear_extrude(height=3) stage2_plate();
        linear_extrude(height=3) scale([-1,1,1]) stage2_plate();
        //translate([0,0,10]) linear_extrude(height=3) stage2_plate();
        //translate([0,0,10]) linear_extrude(height=3) scale([-1,1,1]) stage2_plate();
    }
    
    translate([centre_x, -52, -140]) rotate([90,0,0]) stage2_assembly();

    translate([0,-73,80]) rotate([90,0,0]) color([1,0.5,0]) linear_extrude(height=1) distributor_wires();

    // A row of bearings in the injector hopper
    for(x=[0:31]) translate([ball_bearing_diameter*x+ball_bearing_diameter/2, -1.75, 13+ball_bearing_diameter/2]) sphere(d=ball_bearing_diameter);
    color([0.5,1,1]) {
        for(x=[support1x, support2x])  {
            translate([x,0,0]) rotate([0,0,-90]) rotate([-90,0,0]) linear_extrude(height=3) angled_support_bracket();
            translate([x,0,0]) rotate([0,0,-90]) rotate([-90,0,0]) linear_extrude(height=3) lower_angled_support_bracket();
        }
    }
    
}

module support_assembly(){
    translate([support1x-3,0,0]) rotate([0,0,-90]) rotate([-90,0,0]) linear_extrude(height=3) support_bracket();
    translate([support2x-3,0,0]) rotate([0,0,-90]) rotate([-90,0,0]) linear_extrude(height=3) support_bracket();
}

rotate([assembly_rotation,0,0]) functional_assembly();
support_assembly();

// Marker for output row
rotate([assembly_rotation,0,0]) translate([0,-52-3-3.5,-140]) sphere(d=6);


echo("Output ball-bearing centre distance from wall is ",20+58.5*cos(assembly_rotation)-140*sin(assembly_rotation));
