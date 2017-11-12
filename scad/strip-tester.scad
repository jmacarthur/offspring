/// Strip size grader for Albion Alloys "6mm"x0.8mm brass strip/


// As measured
height = 6.35;
width = 0.8;


kerf = 0.1;

module strip_tester() {
  difference() {
    step = 0.05;
    square([100,15]);
    for(adj=[-8:9]) {
      translate([5+(adj+8)*5,4]) {
	square([width+adj*step, height+adj*step]);
      }
    }
    translate([5+8*5+width/2,13]) {
      rotate(-90) circle($fn=3, d=2);
    }
  }
}

offset(r=kerf) {
  strip_tester();
}
