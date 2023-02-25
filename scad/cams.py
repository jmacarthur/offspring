#!/usr/bin/env python3

""" Cam generation script for Millihertz 5. """


from dataclasses import dataclass

@dataclass
class Event:
    time: float = None
    cam_short_name: str = None
    to_level: float = None
    transition_time: float = 0.03

@dataclass
class Cam:
    short_name: str = None
    description: str = None
    timing_points: list = None
    index: int = None

events = [
    # Open diverter to PC read plane; config mid regen and address decoder rod hold
    Event(0.05, "DIVERTER-PCREAD", to_level=1.0),
    Event(0, "DEC-RODHOLD", to_level=1.0),
    Event(0.05, "MID-REGEN", to_level=1.0),
    Event(0, "DEC-LINEHOLD", to_level=1.0),

    Event(0, "MID-REGEN", to_level=1), # Open the mid regen so the injected data falls right through

    # Discard from acc sender
    Event(0, "ADDRSEND-RELEASE", to_level=1),
    Event(0.1, "ADDRSEND-RELEASE", to_level=0),

    # First inject all event, which sends ball bearings to read the PC
    Event(0.1, "INJ-ALL", to_level=1.0),
    Event(0.13, "INJ-ALL", to_level=0.0,transition_time=0),

    # Wait for accumulator to read into address sender and instruction...
    Event(0.2, "MID-REGEN", to_level=0.5), # Mid regen now ready to receive data
    Event(0.2, "DEC-RODHOLD", to_level=0, transition_time=0),
    Event(0.25, "DEC-LINEHOLD", to_level=0, transition_time=0),
    Event(0.3, "DEC-LINEHOLD", to_level=1),
    Event(0.35, "DEC-LINEHOLD", to_level=0, transition_time=0),
    Event(0.35, "DIVERTER-PCREAD", to_level=0),
    # Data is now out of memory and headed for regen...
    # Regenerate it
    Event(0.35, "MID-REGEN", to_level=0, transition_time=0),
    # And store back in memory.
    Event(0.4, "MEM-RESET", to_level=1),
    Event(0.42, "DEC-LINEHOLD", to_level=1),
    Event(0.45, "DEC-RODHOLD", to_level=1),
    Event(0.45, "ADDRSEND-RELEASE", to_level=1),
    Event(0.47, "ADDRSEND-RELEASE", to_level=0, transition_time=0),
    Event(0.5, "MID-REGEN", to_level=1),
    # Wait for instruction data to reach address sender and set up the instruction decoder
    # Now drop the memory decoder
    Event(0.65, "DEC-RODHOLD", to_level=0, transition_time=0),

    # Now we enter the instruction-dependent section.
    # Firstly, use STO to set the discard line...
    Event(0.65, "STO", to_level=0, transition_time=0), # Opens DISCARD
    Event(0.65, "SUB1", to_level=0, transition_time=0), # This is connected to DIVERTER-ACCUPDATE (does that need a separate line?)
    Event(0.65, "JMP", to_level=0, transition_time=0), # Resets PC
    Event(0.65, "LDN", to_level=0, transition_time=0), # Resets ACC
    Event(0.65, "JRE", to_level=0, transition_time=0), # Connects to DIVERTER-PCUPDATE (does that need a separate line?) - TODO: This also needs to fire for JMP!
    Event(0.7, "JMP", to_level=1), # Resets PC
    Event(0.7, "LDN", to_level=1), # Resets ACC

    # Now, eject from memory - this performs actions for JMP, JRE, LDN and SUB
    Event(0.7, "DEC-LINEHOLD", to_level=0, transition_time=0),
    Event(0.75, "DEC-LINEHOLD", to_level=1),
    Event(0.8, "DEC-LINEHOLD", to_level=0, transition_time=0), # Opening up memory again, ready for regenerated or stored data

    # Perform regen
    Event(0.8, "MID-REGEN", to_level=0, transition_time=0),
    Event(0.85, "MID-REGEN", to_level=1), # Ejecting from regen, performing all actions for JMP, JRE, LDN, SUB
    Event(0.85, "STO", to_level=1), # Closes DISCARD again
    Event(0.9, "MID-REGEN", to_level=0.5), # Prepare regen for new data

    # By now, all actions are complete apart from STO and CMP

    # Second inject all event, which sends ball bearings to read the accumulator for stores
    Event(0.95, "INJ-ALL", to_level=1.0),
    Event(1.0, "INJ-ALL", to_level=0.0, transition_time=0),

    # Mid-regen is now loaded with ball bearings; we now need to send them into the accumulator read plane
    # Close all the flaps which might have been open before
    Event(1.0, "SUB1", to_level=1, transition_time=0),
    Event(1.0, "JRE", to_level=1, transition_time=0),
    Event(1.0, "STO", to_level=0, transition_time=0), # Opens DISCARD again and opens DIVERTER-ACCREAD; enables lower regen (which would otherwise be blocked)
    Event(1.1, "MID-REGEN", to_level=0, transition_time=0), # Eject from mid regen; read data will shortly be in lower regen

    Event(1.2, "LOWER-REGEN", to_level=0, transition_time=0),

    # All that remains is to close the memory
    Event(1.3, "MEM-RESET", to_level=1),
    Event(1.4, "DEC-LINEHOLD", to_level=1),
    Event(1.5, "DEC-RODHOLD", to_level=1),
]

svg_output_filename = "timing.svg"
openscad_output_filename = "cams.scad"
openscad_time_step = 0.01

# The first 8 cams (0-7) are instruction cams
cams = {
    0: Cam("JMP", "Jump absolute"),
    1: Cam("JRE", "Jump relative"),
    2: Cam("LDN", "Load negative"),
    3: Cam("STO", "Store accumulator"),
    4: Cam("SUB1", "Subtract 1"),
    5: Cam("SUB2", "Subtract 2"),
    6: Cam("CMP", "Compare and skip"),
    7: Cam("HLT", "Halt"),
    8: Cam("INJ-ALL", "Inject ball bearings into all columns"),
    9: Cam("DIVERTER-PCREAD", "Set diverter to PC read"),
    10: Cam("DIVERTER-ACCUPDATE", "Set diverter to accumulator update"),
    11: Cam("DIVERTER-PCUPDATE", "Set diverter to PC update"),
    12: Cam("DIVERTER-ACCREAD", "Set diverter to accumulator read"),
    13: Cam("DEC-RODHOLD", "Pull all decoder rods high"),
    14: Cam("MID-REGEN", "Mid regenerator"),
    15: Cam("DEC-LINEHOLD", "Pull all memory rods right"),
    16: Cam("MEM-RESET", "Memory left reset"),
    17: Cam("ADDRSEND-RELEASE", "Release memory sender ball bearings"),
    18: Cam("LOWER-REGEN", "Lower regenerator"),
    }

def most_recent_value(timing_points, time):
    # Find the most recent value reached before time
    points = [(point_time, value) for (point_time, value) in timing_points if point_time <= time]
    sorted_points = sorted(points, key = lambda x: x[0])
    return (sorted_points[-1])

def nearest_future_value(timing_points, time):
    # Find the value of the cam at or after time
    points = [(point_time, value) for (point_time, value) in timing_points if point_time >= time]
    sorted_points = sorted(points, key = lambda x: x[0])
    return (sorted_points[0])

def process_cams(cams, events):
    cams_by_short_name = dict([(c.short_name, c) for c in cams.values()])
    for (index, cam) in cams.items():
        cam.index = index
        # All cams start at 0 (low) except instruction cams which start at 1.
        if index < 8:
            cam.timing_points = [(0.0,1.0)]
        else:
            cam.timing_points = [(0.0,0.0)]

    # Check for events at t=0 which override the first timing point.
    for e in events:
        cam = cams_by_short_name[e.cam_short_name]
        if e.time == 0.0:
            cam.timing_points = [(0.0, e.to_level)]
        else:
            (last_time, last_value) = most_recent_value(cam.timing_points, e.time)
            if(e.time - e.transition_time < last_time):
                print(f"While processing event: {e.cam_short_name} to {e.to_level} by time {e.time}, in {e.transition_time} - not enough time since last event at time {last_time}")
                assert False
            cam.timing_points.append((e.time - e.transition_time, last_value))
            cam.timing_points.append((e.time, e.to_level))

    # Close cams - write final point
    for c in cams.values():
        c.timing_points.append((1.0, c.timing_points[0][1]))

def interpolate(cam, time):
    # Find the right value of the cam at t...

    (last_time, last_value) = most_recent_value(cam.timing_points, time)
    (next_time, next_value) = nearest_future_value(cam.timing_points, time)

    # If there's an exact match, just return that
    if last_time == time:
        return last_value
    elif next_time == time:
        return next_value
    span = next_time - last_time
    progress = (time - last_time)/span
    return last_value + (next_value - last_value)*progress

def write_svg(svg_filename, cams):
    with open(svg_filename, "w") as f:
        f.write("<svg>\n")
        for c in cams.values():
            yoffset = c.index * 15
            (x,y) = c.timing_points[0]
            path_data = f"M {x*100} {y*-10+yoffset}"
            for (x,y) in c.timing_points[1:]:
                path_data += f" L {x*100} {y*-10+yoffset}"
            f.write(f"<line x1=\"0\" y1=\"{yoffset}\" x2=\"100\" y2=\"{yoffset}\" stroke=\"black\" stroke-width=\"0.25px\" />\n")
            f.write(f"<line x1=\"0\" y1=\"{yoffset-10}\" x2=\"100\" y2=\"{yoffset-10}\" stroke=\"black\" stroke-width=\"0.25px\" />\n")
            f.write(f"<path d=\"{path_data}\" fill=\"none\" stroke=\"red\" stroke-width=\"0.5px\"/>\n")
            f.write(f"<text x=\"-50\" y=\"{yoffset}\">{c.short_name}</text>\n")
            f.write(f"<text x=\"110\" y=\"{yoffset}\">{c.short_name}</text>\n")
        f.write("</svg>\n")

def write_openscad(filename, cams):
    with open(filename, "w") as f:
        f.write("cam_levels = [\n")
        for cam in cams.values():
            no_steps = int(1/openscad_time_step)
            steps = [ str(interpolate(cam, step*openscad_time_step)) for step in range(0,no_steps) ]
            f.write("[" + ", ".join(steps) + "],\n")
        f.write("];\n")

process_cams(cams, events)
write_svg(svg_output_filename, cams)
write_openscad(openscad_output_filename, cams)
