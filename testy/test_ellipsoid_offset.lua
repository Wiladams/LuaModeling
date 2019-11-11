package.path = "../?.lua;"..package.path

local radians = math.rad

-- From Milind Gupta
local oscad = require "lmodel.openscad_print"
local f = assert(io.open("output/planetarium.scad", 'w'));
local ell = require("lmodel.ellipsoid")
local tform = require("lmodel.transformer")()

tform:translate(70, 70,20)
tform:rotate(radians(30),radians(0),radians(30))
tform:scale(1.5, 1, 1)

local e1 = ell {
	XRadius = 70,
	ZRadius = -70,
	USteps = 16,
	WSteps = 4,
	MaxPhi = math.pi/2
}


oscad.PolyMesh_print(f,e1:getMesh(), tform)