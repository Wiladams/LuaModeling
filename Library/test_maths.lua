require "maths"
require "openscad_print"

print("Lua Maths")

-- Declare functions before they are used
function test_vector()
	len = vec3_length({0,10,0})

	print("Length: ", len)
end

function DemoTransforms()
	-- Just some simple transforms on a point
	P = {3, 2, 1, 1};
	T2 = {-1, -1, -1};
	TM = transform_translate(T2);
	RX  = transform_rotx(30);
	RY = transform_roty(45);

	print("P: ", P);
	print("TM: ", TM);
	print("RX: ", RX);
	print("RY: ", RY);

	-- Combine the two rotations
	RXY = mat4_mult_mat4(RX, RY);
	print("RXY: ", RXY);

	-- Combine the two rotations and the translation
	TRXY = mat4_mult_mat4(TM, RXY);
	print("TRXY: ", TRXY);

	-- Apply the combined rotations and translation to transform the point
	TPT = vec4_mult_mat4(P, TRXY);
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

	local Tr = transform_translate({0, -cubectr[2], -cubectr[3]});
	local Rx = transform_rotx(30);
	local TrT = transform_translate({0, cubectr[2], cubectr[3]});

	print("Tr");
	mat4_print(Tr);

	print("Rx");
	mat4_print(Rx);

	local T = mat4_mult_mat4(mat4_mult_mat4(Tr, Rx), TrT);
	print("T");
	mat4_print(T);

	for coord in Iter_matm4_mult_mat4(cubepts, T) do
		vec4_print(coord);io.write('\n');
	end
end

function test_clean()

	print(clean(0.001))
end

-- Call the test functions
--test_vector()
--DemoTransforms()
--test_axis_rotate();
test_clean();
