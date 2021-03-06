package.path = "../?.lua;"..package.path

local maths = require "lmodel.maths"
local oscad = require "lmodel.openscad_print"
local cubics = require("lmodel.cubics")


local function test_cubic_vertices()
	local cpts = {{0, 1, 0},{2,3,0}, {4,1,0},{5,2,0}};
	local cptsh = {{0, 1, 0,1},{2,3,0,1}, {4,1,0,1},{5,2,0,1}};

--u1 = cubic_U(0.5);
--g = cubic_vec3_to_cubic_vec4(cps);

--vec4_print(u1);
--mat4_print(cubic_bezier_M());

--pt0 = ccerp(u1, cubic_bezier_M(), cptsh)

--vec4_print(pt0);

--points = IterateBiCubicVertices(cubics.Bezier_M, 1, cpts, 10);
--polygon_print(points);

	local points = {};

	for v in cubics.IterateCubicVertices(cubics.Bezier_M, 1, cptsh, 30) do
		table.insert(points,v);
	end

	local f = assert(io.open("output/test_cubic_output.scad", 'w'));

	oscad.polygon_fprint(f, points);
	f:close();
end


test_cubic_vertices();