package.path = "../?.lua;"..package.path

local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
local f = assert(io.open("output/supershape1.scad", 'w'));

-- Sphere
oscad.PolyMesh_print(f,RenderSuperShape(
	supershape(0, 1, 1, 1, 1, 1),
	supershape(0, 1, 1, 1, 1, 1),
	32,
	32))

