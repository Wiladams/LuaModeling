package.path = "../?.lua;"..package.path

local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
local f = assert(io.open("output/supershape2.scad", 'w'));


oscad.PolyMesh_print(f,RenderSuperShape(
		supershape(7, 0.2, 1.7, 1.7, 1, 1),
		supershape(7, 0.2, 1.7, 1.7, 1, 1),
		64,
		128))

