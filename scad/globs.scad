/* Global definitions for millihertz 5 */

/* All dimensions are in millimetres */


memory_slope_angle = 10;

/** Memory cell pitch - the horizontal and vertical distances between one row and the next. Memory is arranged so one column (y) make up one word. Words are laid out vertically. */
memory_cell_pitch_y = 16;
memory_cell_pitch_x = 28 * cos(memory_slope_angle);


/* Number of bits used in the data. This must be 32. */
bits = 32;

/** Accumulator / subtractor unit. Pitch is the horizontal spacing between both input and output. */
accumulator_input_pitch = 22;

