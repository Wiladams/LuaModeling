package.path = "../?.lua;"..package.path

local tform = require("lmodel.transform")
local maths = require("lmodel.maths")
local mat4_mult_mat4 = maths.mat4_mult_mat4

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
	local TPT = maths.vec4_mult_mat4(P, TRXY);
	print("TPT: ", TPT);
end
