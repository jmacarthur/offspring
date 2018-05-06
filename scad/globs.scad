/* Global definitions for millihertz 5 */

// Ball bearings are sold as 6mm. We have seen two
// versions, one at 6.35mm (1/4") and one at 6.15mm.

ball_bearing_diameter = 6.35;
ball_bearing_radius = ball_bearing_diameter / 2;
pipe_outer_diameter = 11;

/* All dimensions are in millimetres */
memory_slope = 10; // Degrees

/** Memory cell pitch - the horizontal and vertical distances between one row and the next. Memory is arranged so one column (y) make up one word. Words are laid out vertically. */
memory_cell_pitch_x = 16;
memory_cell_pitch_y = 28 * cos(memory_slope);

// Max wire diameter is 1.59mm for 6.35mm ball bearings.
stage1_wire_diameter = 1.45; // Equivalent to AWG 15 / SWG 17.
stage2_wire_diameter = 2.337; // SWG 13

/* Number of bits used in the data. This must be 32. */
bits = 32;

/* Global pitch - the horizontal spacing between each bit */
pitch = 23;

/** Frame */

frame_internal_width = 900;
frame_internal_height = 2200;

/** Frame will probably be 50mm angle iron */
frame_width = 50;

/* Bowden cable specs based on lightweight 'snake' cable */

bowden_cable_inner_diameter = 2;
bowden_cable_outer_diameter = 3.5;

bowden_cable_travel = 10;

/* Specific names for the subtractor */
subtractor_pitch_x = pitch;
subtractor_pitch_y = 27;

memory_columns_per_cell = 8;

// Memory cell height
cell_height = 14;

// Gap between two memory cell units - allows for the last useless row
// in the cell and a gap of 20 to place a delay unit if necessary. The
// delay unit may be needed to slow the ball bearing to avoid damage to
// memory selectors.
memory_unit_gap = cell_height+20;

// centre_gap is a split in the middle of the two lanes
// to join cells together (since we will likely have two
// 16-bit memory cells, and 2 16-bit adders, there will
// be a gap needed to join them.
centre_gap = 50;

/* Colour for illustrating ball bearing paths */

bb_trace_colour = [0.5,0.0,0.0,0.5];


channel_width = 7; // Width of channels ball bearings roll in

columns_per_block = 8; // Number of columns in each injector/diverter block

// Used mainly by injector
function ejector_xpos(col) = 20+col*pitch+channel_width/2;

