package.path = "../?.lua;"..package.path

local maths = require "lmodel.maths"
local oscad = require "lmodel.openscad_print"


local function test_cubic_vertices()
	cpts = {{0, 1, 0},{2,3,0}, {4,1,0},{5,2,0}};
	cptsh = {{0, 1, 0,1},{2,3,0,1}, {4,1,0,1},{5,2,0,1}};

--u1 = cubic_U(0.5);
--g = cubic_vec3_to_cubic_vec4(cps);

--vec4_print(u1);
--mat4_print(cubic_bezier_M());

--pt0 = ccerp(u1, cubic_bezier_M(), cptsh)

--vec4_print(pt0);

--points = IterateBiCubicVertices(cubic_bezier_M(), 1, cpts, 10);
--polygon_print(points);

	points = {};

	for v in IterateCubicVertices(cubic_bezier_M(), 1, cptsh, 10) do
		table.insert(points,v);
	end

	oscad.polygon_print(points);
end

local function getpolymesh(M, umult, mesh, usteps, wsteps)

	local thickness = 1;
	local vertices = {};
	local points = {}

	for w=0, wsteps do
		for u=0, usteps do
			local vert = bicerp(u/usteps, w/wsteps, mesh, M, 1);
			--vec3_print(vert[1]);io.write(' ');vec3_print(vert[2]);io.write('\n');
			table.insert(vertices, vert);
			table.insert(points, vert.point);
		end
	end

	--[[
	-- construct the 'inner' polymesh
	local inner = {}
	for i,v in ipairs(vertices) do
		local innerpt = vec3_add(v, vec3_mults(v[2],thickness));
		--table.insert(vertices, innerpt);

		--vec3_print(v[1]);io.write('\n');
		--vec3_print(v[1]);io.write(' ');vec3_print(innerpt);io.write('\n');

	end
--]]

	return points;
end


local function test_bicubic_vertices()
	print("==== test_bicubic_vertices ====")
	local gcp4 = {{0,30,0,1}, {10,40,0,1}, {20,40,0,1}, {30,30,0,1}};
	local gcp3 = {{5,20,10,1}, {10,20,20,1}, {15,25,15,1}, {20,20,5,1}};
	local gcp2 = {{5,10,10,1}, {10,10,20,1}, {15,5,15,1}, {20,10,5,1}};
	local gcp1 = {{0,0,0,1}, {10,-10,0,1}, {20,-10,0,1}, {30,0,0,1}};

	local usteps = 48;
	local wsteps = 48;

	local polypoints = getpolymesh(cubic_bezier_M(), 1,
			{gcp1, gcp2, gcp3, gcp4}, usteps, wsteps);

	--print("Polypoints: ", type(polypoints));
	--print("  points: ", type(polypoints[1])));

	local width = usteps+1;
	local height = wsteps+1;

	local f = assert(io.open("output/test_cubic_output.scad", 'w'));

	oscad.polyhedron_print(f, polypoints, width, height);
	f:close();
end

-- Running Tests
--test_cubic_vertices();
test_bicubic_vertices();
