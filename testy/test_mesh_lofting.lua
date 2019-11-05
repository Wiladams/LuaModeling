package.path = "../?.lua;"..package.path

local imaging = require "lmodel.imaging"
local oscad = require "lmodel.openscad_print"
local MeshRender = require "lmodel.Mesh_Renderer"

local map_to_array = imaging.map_to_array
local checker_image = imaging.checker_image
local PrintHeightMesh = MeshRender.PrintHeightMesh
local gridIterator = MeshRender.gridIterator



function print_vertex_table(a)
	print("[");
	for i=1, #a do
		vec2_print(a[i][1]);
		--vec2_print(a[i][2]);
		--io.write(i-1,',');
	end
	--io.write(#a);
	print("]");

end


local function test_griditerate()
	local vertices = {};

	for _, v in gridIterator(3,3, 1,1) do
		table.insert(vertices,v);
	end

	print_vertex_table(vertices);
end

local function test_heightmesh()
	PrintHeightMesh(64, 64, {xres=1/0.4, yres=1/0.4}, 4, checker_image)
end



test_griditerate();
--test_heightmesh();

