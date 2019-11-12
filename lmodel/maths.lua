-- BUGBUG - replace equivalents with glsl
-- BUGBUG - separate the cubic curve stuff out
-- BUGBUG - separate vector stuff out

local glsl = require("lmodel.glsl")
local add, sub, mul, div = glsl.add, glsl.sub, glsl.mul, glsl.div

local radians = math.rad
local cos, sin = math.cos, math.sin

-- Useful constants
local Cphi = 1.618

local Cepsilon = 0.00000001;

local exports = {
	Cphi = Cphi;
	Cepsilon = Cepsilon
}


--[[
 Function: clean

 Parameters:
	n - A number that might be very close to zero
 Description:
	There are times when you want a very small number to
 	just be zero, instead of being that very small number.
	This function will compare the number to an arbitrarily small
	number.  If it is smaller than the 'epsilon', then zero will be
	 returned.  Otherwise, the original number will be returned.
	 
Perhaps this can simply be a  truncate, or round
--]]

local function clean(n, epsilon)
	epsilon = epsilon or Cepsilon

	if (n < 0) then
		if (n < -epsilon) then
			return n
		else
			return 0
		end
	else if (n < epsilon) then
			return 0
		else
			return n
		end
	end
end
exports.clean = clean

-- Basic vector routines
-- Conversions
local function point3h_from_vec3(vec)
	return {vec[1], vec[2], vec[3], 1};
end
exports.point3h_from_vec3 = vec3_from_point3h

local function vec3_from_point3h(pt)
	return {pt[1], pt[2], pt[3]};
end
exports.vec3_from_point3h = vec3_from_point3h


-- Multiply by a scalar
local function vec4_mults(v, s)
	return {v[1]*s, v[2]*s, v[3]*s, v[4]*s}
end

-- Magnitude of a vector
-- Gives the Euclidean norm
function vec3_lengthsquared(v)
	return (v[1]*v[1]+v[2]*v[2]+v[3]*v[3])
end

function vec3_length(v)
	return math.sqrt(vec3_lengthsquared(v))
end

local function vec3_norm(v)
	return glsl.mul(v, 1/glsl.length(v))
end
exports.vec3_norm = vec3_norm


--=========================================
--	Matrix 4X4 Operations
--
-- Upper left 3x3 == scaling, shearing, reflection, rotation (linear transformations)
-- Upper right 3x1 == Perspective transformation
-- Lower left 1x3 == translation
-- Lower right 1x1 == overall scaling
--=========================================

local function mat4_identity()
	return {
	{1, 0, 0, 0},
	{0, 1, 0, 0},
	{0, 0, 1, 0},
	{0, 0, 0, 1}
	}
end
exports.mat4_identity = mat4_identity


local function mat4_transpose(m)
	return {
	mat4_col(m,0),
	mat4_col(m,1),
	mat4_col(m,2),
	mat4_col(m,3)
	}
end

local function mat4_col(m, col)
	return {
	m[1][col],
	m[2][col],
	m[3][col],
	m[4][col]
	}
end

local function mat4_add_mat4(m1, m2)
	return {
	glsl.add(m1[1], m2[1]),
	glsl.add(m1[2], m2[2]),
	glsl.add(m1[3], m2[3]),
	glsl.add(m1[4], m2[4])
	}
end

-- Linear Transformations
--	Translate
function mat4_translation(x, y, z)
	return {
	{1, 0, 0, 0},
	{0, 1, 0, 0},
	{0, 0, 1, 0},
	{x, y, z, 1}
	}
end
exports.mat4_translation = mat4_translation

-- 	Scale
local function  mat4_scale(sx,sy,sz)
	return {
	{sx,0,0,0},
	{0,sy,0,0},
	{0,0,sz,0},
	{0,0,0,1}
	}
end
exports.mat4_scale = mat4_scale

--	Rotation
local function mat4_rotx(rads)
	local sinang = sin(rads);
	local cosang = cos(rads);

	return {
	{1, 0, 0, 0},
	{0, cosang, sinang, 0},
	{0, -sinang, cosang, 0},
	{0, 0, 0, 1}
	}
end
exports.mat4_rotx = mat4_rotx

local function  mat4_roty(rads)
	local sinang = math.sin(rads);
	local cosang = math.cos(rads);

	return {
	{cosang, 0, -sinang, 0},
	{0, 1, 0, 0},
	{sinang, 0, cosang, 0},
	{0, 0, 0, 1}
	}
end
exports.mat4_roty = mat4_roty

function  mat4_rotz(rads)
	local sinang = math.sin(rads);
	local cosang = math.cos(rads);

	return {
	{cosang, sinang, 0, 0},
	{-sinang, cosang, 0, 0},
	{0, 0, 1, 0},
	{0, 0, 0, 1}
	}
end
exports.mat4_rotz = mat4_rotz

-- Multiply two 4x4 matrices together
-- This is one of the workhorse mechanisms of the
-- graphics system
local function mat4_mult_mat4(m1, m2)
	return {
	{glsl.dot(m1[1], mat4_col(m2,1)),
	glsl.dot(m1[1], mat4_col(m2,2)),
	glsl.dot(m1[1], mat4_col(m2,3)),
	glsl.dot(m1[1], mat4_col(m2,4))},

	{glsl.dot(m1[2], mat4_col(m2,1)),
	glsl.dot(m1[2], mat4_col(m2,2)),
	glsl.dot(m1[2], mat4_col(m2,3)),
	glsl.dot(m1[2], mat4_col(m2,4))},

	{glsl.dot(m1[3], mat4_col(m2,1)),
	glsl.dot(m1[3], mat4_col(m2,2)),
	glsl.dot(m1[3], mat4_col(m2,3)),
	glsl.dot(m1[3], mat4_col(m2,4))},

	{glsl.dot(m1[4], mat4_col(m2,1)),
	glsl.dot(m1[4], mat4_col(m2,2)),
	glsl.dot(m1[4], mat4_col(m2,3)),
	glsl.dot(m1[4], mat4_col(m2,4))},
	}
end
exports.mat4_mult_mat4 = mat4_mult_mat4

-- This is the other workhorse routine
-- Most transformations are a multiplication
-- of a vec4 and a mat4
local function vec4_mult_mat4(vec, mat)
	return {
		glsl.dot(vec, mat4_col(mat,1)),
		glsl.dot(vec, mat4_col(mat,2)),
		glsl.dot(vec, mat4_col(mat,3)),
		glsl.dot(vec, mat4_col(mat,4)),
	}
end
exports.vec4_mult_mat4 = vec4_mult_mat4


--[[
	This routine is a speedup convenience.  It is a point 
	transform using homogeneous points (x,y,z,1).  The vec
	parameter is an xyz (only 3 elements).  Instead of padding
	the vec by creating a new table with a last value of '1',
	we can simply expand the dot product and put in the 
	implied '1'.  Faster than memory allocation for a new table
	and garbage collection pressure.

	BUGBUG - should unroll one more level deep and eliminate the
	mat4_col call.
]]
local function point_mult_mat4(vec, mat)
	local function dot34(a, b)
		return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]+1*b[4]
	end

	return {
		dot34(vec, mat4_col(mat,1)),
		dot34(vec, mat4_col(mat,2)),
		dot34(vec, mat4_col(mat,3)),
		dot34(vec, mat4_col(mat,4)),
	}
end
exports.point_mult_mat4 = point_mult_mat4



function vec4_mult_mat34(vec, mat)
	return {
	glsl.dot(vec, mat4_col(mat,1)),
	glsl.dot(vec, mat4_col(mat,2)),
	glsl.dot(vec, mat4_col(mat,3))
	}
end

--=======================================
--
--	Linear Interpolation Routines
--
--=======================================
function lerp1( p0, p1, u)
	return (1-u)*p0 + u*p1
end

function vec3_lerp(v1, v2, u)
	return {
	lerp1(v1[1], v2[1],u),
	lerp1(v1[2], v2[2],u),
	lerp1(v1[3], v2[3],u)
	}
end

function vec4_lerp(v1, v2, u)
	return {
	lerp1(v1[1], v2[1],u),
	lerp1(v1[2], v2[2],u),
	lerp1(v1[3], v2[3],u),
	lerp1(v1[4], v2[4],u)
	}
end






-- Useful functions
-- Calculate the centroid of a list of vertices
local function centroid(verts)
	local minx = math.huge; maxx = -math.huge
	local miny = math.huge; maxy = -math.huge
	local minz = math.huge; maxz = -math.huge

	for _,v in ipairs(verts) do
		minx = math.min(v[1], minx); maxx = math.max(v[1], maxx);
		miny = math.min(v[2], miny); maxy = math.max(v[2], maxy);
		minz = math.min(v[3], minz); maxz = math.max(v[3], maxz);
	end

	local x = minx + (maxx-minx)/2;
	local y = miny + (maxy-miny)/2;
	local z = minz + (maxz-minz)/2;

	return {x,y,z}
end
exports.centroid = centroid

local function factorial(n)
	if n==0 then
		return 1
	else
		return n * factorial(n-1)
	end
end



--[[
 Function: safediv

 Parameters
	n - The numerator
	d - The denominator

 Description:
	Since division by zero is generally not a desirable thing, safediv
	will return '0' whenever there is a division by zero.  Although this will
	mask some erroneous division by zero errors, it is often the case
	that you actually want this behavior.  So, it makes it convenient.

	BUGBUG - a better approach would be to return math.inf instead
--]]
local function safediv(n,d)
	if (d==0) then
		return 0
	end

	return n/d;
end


return exports