package.path = "../?.lua;"..package.path

local maths = require "lmodel.maths"
local oscad = require "lmodel.openscad_print"
local glsl = require("lmodel.glsl")
local tform = require("lmodel.transform")

-- Declare functions before they are used
function test_vector()
	len = vec3_length({0,10,0})

	print("Length: ", len)
end

function test_transforms()
	-- Just some simple transforms on a point
	local P = {3, 2, 1, 1};
	local T2 = {-1, -1, -1};
	local TM = tform.translate(T2);
	local RX  = tform.rotx(30);
	local RY = tform.roty(45);

	print("P: ", P);
	print("TM: ", TM);
	print("RX: ", RX);
	print("RY: ", RY);

	-- Combine the two rotations
	local RXY = mat4_mult_mat4(RX, RY);
	print("RXY: ", RXY);

	-- Combine the two rotations and the translation
	local TRXY = mat4_mult_mat4(TM, RXY);
	print("TRXY: ", TRXY);

	-- Apply the combined rotations and translation to transform the point
	local TPT = vec4_mult_mat4(P, TRXY);
	print("TPT: ", TPT);
end

-- rotate around an axis parallel to x-axis
function test_axis_rotate()
	local cubepts = {
			{1,1,2,1},
			{2,1,2,1},
			{2,2,2,1},
			{1,2,2,1},
			{1,1,1,1},
			{2,1,1,1},
			{2,2,1,1},
			{1,2,1,1}
			};

	local cubectr = {3/2, 3/2, 3/2, 1};

	local Tr = tform.translate({0, -cubectr[2], -cubectr[3]});
	local Rx = tform.rotx(30);
	local TrT = tform.translate({0, cubectr[2], cubectr[3]});

	print("Tr");
	oscad.mat4_print(Tr);

	print("Rx");
	oscad.mat4_print(Rx);

	local T = mat4_mult_mat4(mat4_mult_mat4(Tr, Rx), TrT);
	print("T");
	oscad.mat4_print(T);

	for coord in Iter_matm4_mult_mat4(cubepts, T) do
		vec4_print(coord);io.write('\n');
	end
end

function test_clean()
	print(maths.clean(0.001))
end

-- Call the test functions
test_vector()
test_transforms()
test_axis_rotate();
test_clean();
