/* Ball bearing injector, mk 2 */

include <globs.scad>;


$fn = 20;

// Pitch of ball bearings after passing through each stage:
stage1_output_pitch = 8;
stage2_output_pitch = 23;

// Distance between the slots cut in the raiser walls to
// allow the raiser to slide up and down:
slot_distance = ball_bearing_diameter * 30;

// Zero X is the far edge of the first ball bearing on input.
// Centre of the whole machine is between the two sets of 16
// ball bearings.
centre_x = ball_bearing_diameter*16;
stage2_total_width = 33*stage2_output_pitch+centre_gap;
stage2_half_width = stage2_total_width/2;

// How much is the whole assembly tilted?
assembly_rotation = 10;

// x-positions of the angled support plates
support1x = 20;
support2x = 210;


module input_riser()
{
  difference() {
    union() {
      translate([-10,0]) square([ball_bearing_diameter * 32 + 10, 15]);
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
    translate([-20,0]) square([ball_bearing_diameter * 32 + 60, 20 + (notch==1?0:5)]);
    for(x=[0,slot_distance]) {
      translate([x+5,5]) circle(d=3);
      translate([x+5,15]) circle(d=3);
      translate([x+5-1.5,5]) square([3,10]);

      // Axle hole for raiser crank
      translate([x-15,10]) circle(d=3);

      // If 'notch' is on, add a hole for the stage1 wire
      if(notch == 1) {
	for(x=[0:32]) {
	  translate([x*ball_bearing_diameter, 20]) circle(d=5);
	}
	translate([-14, 17]) square([9,5]);
	translate([33*ball_bearing_diameter-2, 17]) square([9,5]);
      }
    }
    translate([ball_bearing_diameter*32+15,5]) circle(d=3);
    translate([ball_bearing_diameter*32+35,5]) circle(d=3);


  }
}

module input_track() {
  difference() {
    translate([-10,0]) square([50, 15]);
    translate([5,5]) circle(d=3);
    translate([25,5]) circle(d=3);
  }
}

module input_pipe_holder() {
  difference() {
      square([20, 20]);
      translate([10,10]) circle(d=11);
      translate([10,10-1.5]) square([10,3]);
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
      translate([x*ball_bearing_diameter, 50]) circle(d=stage1_wire_diameter);
    }
    for(x=[-16:16]) {
      translate([ball_bearing_diameter*16 - x*(ball_bearing_diameter*stage1_expansion), 0]) circle(d=stage1_wire_diameter);
    }
    // Holes to clip in the support plate
    translate([support1x,25]) square([3,10]);
    translate([support2x,25]) square([3,10]);
  }
}

module stage1_top_plate() {
  stage1_plate();
}

// Module to show where to place the curve in the stage2 guide.
module turn_guide(x)
{
  scale([-1,1]) {
    translate([-x*stage1_output_pitch, -188+x*stage1_output_pitch*0.99]) difference() {
      circle(r=9.5);
      translate([-10,0]) square([20,10]);
      rotate(30) translate([-10,-10]) square([10,20]);
      circle(r=8.5);
    }
  }
}


module raiser_connector()
{
  l = 190;
  drop = 5;
  difference() {
    union() {
      circle(d=10);
      translate([l, 0]) circle(d=10);
      translate([20,-drop]) circle(d=10);
      translate([l-20, -drop]) circle(d=10);
      rotate(-atan2(drop,20)) translate([0,-5]) square([20,10]);
      translate([l,0]) rotate(180+atan2(drop,20)) translate([0,-5]) square([20,10]);
      translate([20,-drop]) translate([0,-3]) square([l-40,6]);
    }
    translate([0, 0]) circle(d=3);
    translate([l, 0]) circle(d=3);
  }
}


module stage2_plate() {
  difference() {
    polygon(points=[[0,0], [stage2_half_width,0], [stage2_half_width, 30], [stage1_output_pitch*16+10, 160], [0,160]]);
    for(x=[0:16]) {
      // Holes at the top to push wire through
      translate([x*stage1_output_pitch,155]) circle(d=stage2_wire_diameter);
      // Gaps at the top to allow the stage1 wires to fold under their plate
      translate([x*stage1_output_pitch,160]) circle(d=5);
      // Holes at the bottom to secure wire to
      translate([centre_gap/2 + x*stage2_output_pitch,5]) circle(d=stage2_wire_diameter);
      // Arc-shaped hole which is a guide for the wire - no functional purpose
      if(x<16) translate([1,220]) turn_guide(x);
    }
    // Single gap at the top to allow space for the stage1 separator screws
    translate([16*stage1_output_pitch,157.5]) square([10,6]);

    // Holes to add screws to hold top and bottom plate together
    translate([17*stage2_output_pitch+5,5]) circle(d=3);
    translate([9*stage2_output_pitch-5,5]) circle(d=3);
    translate([0*stage2_output_pitch+5,5]) circle(d=3);
    translate([17.5*stage1_output_pitch-5,155]) circle(d=3);
    translate([12.5*stage2_output_pitch,80]) circle(d=3);
    // Holes for the support plate tab
    // We include holes for both support1x and support2x here. If the support plates
    // are equidistant from the centre, the holes will coincide. If not, one
    // set of holes will need to be filled in.
    translate([-support1x+centre_x-3,155-15]) square([3,10]);
    translate([support2x-centre_x,155-15]) square([3,10]);
    translate([-support1x+centre_x-3,20]) square([3,10]);
    translate([support2x-centre_x,20]) square([3,10]);

  }
  echo("Half of stage2 width is",stage2_half_width);
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
    for(x=[0:17]) {

      // Long diagonals
      translate([-x*stage1_output_pitch-4, -188+x*stage1_output_pitch*0.99+1, 20]) {
	rotate(-90-64) square([x*17+20,2]);
      }

      translate([-x*stage1_output_pitch, -190+x*stage1_output_pitch+8, 20]) {
	square([2,130-x*stage1_output_pitch]);
      }

      // Base output channels
      translate([-x*stage2_output_pitch-2, -215, 20]) {
	square([2,18+x*0.5]);
      }
    }
}


// There are two parts to this - functional assembly holds all the parts that touch ball bearings.
// The whole function assembly is then rotated and slots into the support assembly, which is kept
// othogonal to the machine's frame.

module functional_assembly() {
  translate([0,0,10]) rotate([90,0,0]) linear_extrude(height=3) input_riser();
    translate([ball_bearing_diameter*32+10,0,0]) rotate([90,0,0]) linear_extrude(height=3) input_track();
    translate([ball_bearing_diameter*32+50,-10-1.5,31]) rotate([0,90,0]) linear_extrude(height=3) input_pipe_holder();
    translate([ball_bearing_diameter*32+45,-10-1.5,31]) rotate([0,90,0]) linear_extrude(height=3) input_pipe_holder();

    translate([0,-5,0]) rotate([90,0,0]) linear_extrude(height=3) channel_wall(1);
    translate([0,5,0]) rotate([90,0,0]) linear_extrude(height=3) channel_wall(0);

    for(x=[0,slot_distance]) {
        translate([x-15,10,10]) rotate([0,13,0]) rotate([90,0,0]) linear_extrude(height=3) raiser_crank();
        translate([x-15,-10,10]) rotate([0,13,0]) rotate([90,0,0]) linear_extrude(height=3) raiser_crank();
    }
    color([1.0,1.0,1.0]) translate([-20,7,-10]) rotate([90,0,0]) linear_extrude(height=3) raiser_connector();

    translate([0,-55,20]) linear_extrude(height=3) stage1_base_plate();
    //translate([0,-55,30]) linear_extrude(height=3) stage1_top_plate();
    
    module stage2_assembly() {
        linear_extrude(height=3) stage2_plate();
        linear_extrude(height=3) scale([-1,1,1]) stage2_plate();
        //translate([0,0,10]) linear_extrude(height=3) stage2_plate();
        //translate([0,0,10]) linear_extrude(height=3) scale([-1,1,1]) stage2_plate();
    }
    
    translate([centre_x, -52, -140]) rotate([90,0,0]) stage2_assembly();

    //translate([0,-56,80]) rotate([90,0,0]) color([1,0.5,0]) linear_extrude(height=1) distributor_wires();

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


module distributor_assembly() {

  rotate([assembly_rotation,0,0]) functional_assembly();
  support_assembly();
}

distributor_assembly();

// Marker for output row
rotate([assembly_rotation,0,0]) translate([0,-52-3-3.5,-140]) sphere(d=6);


echo("Output ball-bearing centre distance from wall is ",20+58.5*cos(assembly_rotation)-140*sin(assembly_rotation));
