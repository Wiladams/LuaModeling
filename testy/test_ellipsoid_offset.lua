package.path = "../?.lua;"..package.path

local radians = math.rad

-- From Milind Gupta
local oscad = require "lmodel.openscad_print"
local f = assert(io.open("output/planetarium.scad", 'w'));
local ell = require("lmodel.ellipsoid")
local Transformer = require("lmodel.transformer")

local tform1 = Transformer()
tform1:translate(70, 70,20)
tform1:rotate(radians(30),radians(0),radians(30))
tform1:scale(1.5, 1, 1)

local tform2 = Transformer()
tform2:scale(0.5, 0.25, 0.25)
tform2:translate(-80, -50, 0)

local e1 = ell {
	XRadius = 70,
	ZRadius = -70,
	USteps = 16,
	WSteps = 4,
	MaxPhi = math.pi/2
}

oscad.PolyMesh_print(f,e1:getMesh(), tform1)
oscad.PolyMesh_print(f,e1:getMesh(), tform2)

f:close()