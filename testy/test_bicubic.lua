package.path = "../?.lua;"..package.path

local maths = require "lmodel.maths"
local oscad = require "lmodel.openscad_print"
local cubics = require("lmodel.cubics")

local function getpolymesh(M, umult, mesh, usteps, wsteps)
	local thickness = 1;
	local vertices = {};
	local points = {}

	for w=0, wsteps do
		for u=0, usteps do
			local vert = cubics.bicerp(u/usteps, w/wsteps, mesh, M, 1);
			--vec3_print(vert[1]);io.write(' ');vec3_print(vert[2]);io.write('\n');
			table.insert(vertices, vert);
			table.insert(points, vert.point);
		end
	end

	return points;
end


local function test_bicubic_vertices()
	local gcp4 = {{0,30,0,1}, {10,40,0,1}, {20,40,0,1}, {30,30,0,1}};
	local gcp3 = {{5,20,10,1}, {10,20,20,1}, {15,25,15,1}, {20,20,5,1}};
	local gcp2 = {{5,10,10,1}, {10,10,20,1}, {15,5,15,1}, {20,10,5,1}};
	local gcp1 = {{0,0,0,1}, {10,-10,0,1}, {20,-10,0,1}, {30,0,0,1}};

	local usteps = 24;
	local wsteps = 24;

	local polypoints = getpolymesh(cubics.Bezier_M, 1,
			{gcp1, gcp2, gcp3, gcp4}, usteps, wsteps);

	--print("Polypoints: ", type(polypoints));
	--print("  points: ", type(polypoints[1])));

	local width = usteps+1;
	local height = wsteps+1;

	local f = assert(io.open("output/test_bicubic_output.scad", 'w'));

	oscad.polyhedron_fprint(f, polypoints, width, height);
	f:close();
end


test_bicubic_vertices();
