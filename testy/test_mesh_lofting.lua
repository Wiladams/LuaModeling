package.path = "../?.lua;"..package.path

local imaging = require "lmodel.imaging"
local oscad = require "lmodel.openscad_print"
local MeshRender = require "lmodel.Mesh_Renderer"

local map_to_array = imaging.map_to_array
local checker_image = imaging.checker_image
local PrintHeightMesh = MeshRender.PrintHeightMesh
local Iterate2DGrid = MeshRender.Iterate2DGrid



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

	for v in Iterate2DGrid(3,3, 1,1) do
		table.insert(vertices,v);
	end

	print_vertex_table(vertices);
end

local function test_heightmesh()
	PrintHeightMesh(64, 64, {1/0.4,1/0.4}, 4, checker_image)
end

function test_glsl()
io.write('0 ',map_to_array(3, 0),'\n');
io.write('0.3 ',map_to_array(3, 0.3),'\n');
io.write('1 ',map_to_array(3, 0.66),'\n');
io.write('3 ',map_to_array(3, 1),'\n');
end

--test_griditerate();
test_heightmesh();
--test_glsl();
