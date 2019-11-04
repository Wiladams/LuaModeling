package.path = "../?.lua;"..package.path

require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
local f = assert(io.open("output/supershape4.scad", 'w'));



oscad.PolyMesh_print(f,RenderSuperShape(
		supershape(5, 1, 1, 1, 1, 1),
		supershape(0, 1, 1, 1, 1, 1),
		32,
		128))


