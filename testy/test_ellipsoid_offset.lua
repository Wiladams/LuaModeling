package.path = "../?.lua;"..package.path

-- From Milind Gupta
local oscad = require "lmodel.openscad_print"
local f = assert(io.open("output/planetarium.scad", 'w'));
ell = require("lmodel.ellipsoid")
local e1 = ell {
	XRadius = 70,
	ZRadius = -70,
	USteps = 16,
	WSteps = 4,
	MaxPhi = math.pi/2
}
oscad.PolyMesh_print(f,e1:getMesh())