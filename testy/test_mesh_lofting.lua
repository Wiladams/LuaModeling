package.path = "../?.lua;"..package.path

local imaging = require "lmodel.imaging"
local MeshRender = require "lmodel.Mesh_Renderer"

local checker_image = imaging.checker_image


local function test_heightmesh()
	MeshRender.PrintHeightMesh(64, 64, {xres=1/0.4, yres=1/0.4}, 4, checker_image)
end


test_heightmesh();

