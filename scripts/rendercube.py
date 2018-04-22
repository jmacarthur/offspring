#!/usr/bin/env python2

# Example of how to do a render of a OpenSCAD .csg file using
# FreeCAD. This example uses the GUI. The headless version currently
# crashes due to a fault in netgen in current Ubuntu.

import sys
import math

# Import FreeCAD modules
sys.path.append('/usr/lib/freecad/lib')
import FreeCAD
import importCSG
import pivy
from pivy import coin

importCSG.insert(u"/home/jimm/temp/rendercube.csg","Fun cube")
App.setActiveDocument("Fun_cube")
cam = Gui.ActiveDocument.ActiveView.getCameraNode()

cam.orientation = (-0.105,1,0.2,math.radians(30)) # Gives a reasonable approximation of isometric view

Gui.SendMsgToActiveView("ViewFit")
Gui.activeDocument().activeView().saveImage('test.png',800,800,'Current')


