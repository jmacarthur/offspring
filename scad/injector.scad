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
  }
  echo(stage2_half_width);
}

module injector_tray() {
  difference() {
    square([stage2_total_width,20]);
    for(x=[1:32]) {
      translate([x*stage2_output_pitch,0]) polygon(points = [[-stage2_output_pitch/2,20],[stage2_output_pitch/2,20], [0,10]]);
    }
  }
}

module injector_tray_support() {
  difference() {
    polygon(points = [ [-10,-5], [-10,5], [0,15], [10,5], [10,-5] ]);
    translate([-1.5,5]) square([3,10]);
    circle(d=3);
  }
}

module injector_crank() {
  difference() {
    union() {
      translate([-5,-5]) square([30,10]);
      translate([-5,-5]) square([10,30]);
      translate([20,-15]) square([5,20]);
    }
    circle(d=3);
  }
}

/* -------------------- 3D Assembly -------------------- */

rotate([90,0,0]) linear_extrude(height=3) input_riser();

translate([0,-5,0]) rotate([90,0,0]) linear_extrude(height=3) channel_wall(1);
translate([0,5,0]) rotate([90,0,0]) linear_extrude(height=3) channel_wall(0);

for(x=[0,slot_distance]) {
  translate([x-15,10,10]) rotate([0,13,0]) rotate([90,0,0]) linear_extrude(height=3) raiser_crank();
  translate([x-15,-10,10]) rotate([0,13,0]) rotate([90,0,0]) linear_extrude(height=3) raiser_crank();
}

translate([0,-55,20]) linear_extrude(height=3) stage1_base_plate();
translate([0,-55,30]) linear_extrude(height=3) stage1_top_plate();

module stage2_assembly() {
  linear_extrude(height=3) stage2_plate();
  linear_extrude(height=3) scale([-1,1,1]) stage2_plate();
  translate([0,0,10]) linear_extrude(height=3) stage2_plate();
  translate([0,0,10]) linear_extrude(height=3) scale([-1,1,1]) stage2_plate();
}

translate([centre_x, -52, -140]) rotate([90,0,0]) stage2_assembly();

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

translate([0,-73,80]) rotate([90,0,0]) color([1,0.5,0]) linear_extrude(height=1) distributor_wires();


module injector_assembly() {
  tray_rotate = 10;
  translate([0,-5-ball_bearing_diameter/2,0]) {
    rotate([-tray_rotate,0,0]) rotate([90,0,0]) linear_extrude(height=3) injector_tray();
    rotate([90-tray_rotate,0,0]) rotate([0,90,0]) translate([-1.5,-5,10]) linear_extrude(height=3) injector_tray_support();
    rotate([90-tray_rotate,0,0]) rotate([0,90,0]) translate([-1.5,-5,stage2_total_width-10]) linear_extrude(height=3) injector_tray_support();
  }
  for(x=[1:32]) {
    translate([x*stage2_output_pitch-1.5,12,37]) rotate([0,90,0]) linear_extrude(height=3) injector_crank();
  }
}

translate([centre_x - stage2_half_width,-53,-165]) injector_assembly();
// Output bearings in the injector assembly, for reference
for(x=[-16:15]) {
  translate([11.5+centre_x + 23*x, -59,-151]) sphere(d=ball_bearing_diameter);
}

// Bearings
for(x=[0:31]) translate([ball_bearing_diameter*x+ball_bearing_diameter/2, -1.75, 13+ball_bearing_diameter/2]) sphere(d=ball_bearing_diameter);
