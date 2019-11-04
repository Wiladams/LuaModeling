package.path = "../?.lua;"..package.path

require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
local f = assert(io.open("output/supershape3.scad", 'w'));

--	scale([10,10,10])

oscad.PolyMesh_print(f,RenderSuperShape(
		supershape(4, 0.5, 0.5, 4, 1, 1),
		supershape(4, 0.5, 0.5, 4, 1, 1),
		32, 32))
