// Memory line folding mould
/* This is a simple extrustion that was designed to fold brass strip to make
   parts for the old-style diagonal memory unit. It didn't work very well. */
fold1_length = 7.67;
fold2_length = 5.13;
fold3_length = 7.67;
fold4_length = 7.67;
fold5_length = 6.99;
fold6_length = 7.7;

fold0_angle = 10;
fold1_angle = fold0_angle + 80;
fold2_angle = fold1_angle + 80;
fold3_angle = fold2_angle + -160;
fold4_angle = fold3_angle + 80;
fold5_angle = fold4_angle + -80;
$fn = 20;
angle_exaggeration = 1.10;;

// Define all the points on the shape
ex = angle_exaggeration;
a = [0,0];
b = [ a[0] + fold1_length*cos(fold0_angle * ex), a[1] + fold1_length*sin(fold0_angle * ex) ];
c = [ b[0] + fold2_length*cos(fold1_angle * ex), b[1] + fold2_length*sin(fold1_angle * ex) ];
d = [ c[0] + fold3_length*cos(fold2_angle * ex), c[1] + fold3_length*sin(fold2_angle * ex) ];
e = [ d[0] + fold4_length*cos(fold3_angle * ex), d[1] + fold4_length*sin(fold3_angle * ex) ];
f = [ e[0] + fold5_length*cos(fold4_angle * ex), e[1] + fold5_length*sin(fold4_angle * ex) ];
g = [ f[0] + fold6_length*cos(fold5_angle * ex), f[1] + fold6_length*sin(fold5_angle * ex) ];



module mould_part1() {
a = [0,0];
b = [ a[0] + fold1_length*cos(85),  a[1] + fold1_length*sin(85)  ];
c = [ b[0] + fold2_length*cos(0),   b[1] + fold2_length*sin(0)   ];
d = [ c[0] + fold3_length*cos(-85), c[1] + fold3_length*sin(-85) ];
e = [ d[0] + fold4_length*cos(0),   d[1] + fold4_length*sin(0)   ];
union() {
polygon(points = [ a, b , c, d, e, [2.5,-1]]);
translate([-5,-5]) square([20,5]);
}
}

module mould_part1_outer() {
difference() {
translate([-5,0]) polygon(points = [[0,0],[20,0],[15,15], [0,15]]);
offset(r=0.5) mould_part1();
}
}

linear_extrude(height=10) mould_part1();
linear_extrude(height=10) mould_part1_outer();

