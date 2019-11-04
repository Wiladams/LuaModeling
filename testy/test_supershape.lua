package.path = "../?.lua;"..package.path

local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
local f = assert(io.open("output/test_supershape.scad", 'w'));



	-- Sphere
	-- scale([10,10,10])
--[[
oscad.PolyMesh_print(f,RenderSuperShape(
	supershape(0, 1, 1, 1, 1, 1),
	supershape(0, 1, 1, 1, 1, 1),
	32,
	32))
--]]





oscad.PolyMesh_print(f,RenderSuperShape(
		supershape(9.0, -89.25, 0.41, -31.90, 1, 1),
		supershape(4.0, 100, 1000, 1000, 1, 1),
		64,
		64))
