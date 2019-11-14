local maths = require("lmodel.maths")
local glsl = require("lmodel.glsl")

local point3h_from_vec3 = maths.point3h_from_vec3
local vec4_mult_mat4 = maths.vec4_mult_mat4
local vec3_from_point3h = maths.vec3_from_point3h


local mul = glsl.mul

local exports = {}

--[[
    The general design here is that all cubic curves can be
    represented by a 4x4 matrix.  These matrices are called
    blending functions, and a few typical ones are here.

    Then generic evaluators can resturn values either based
    on a single parameter, or two parameters.
]]
local Hermite_M = {
	{2, -2, 1, 1},
	{-3, 3, -2, -1},
	{0, 0, 1, 0},
	{1, 0, 0, 0}
}
exports.Hermite_M = Hermite_M

local Bezier_M = {
	{-1, 3, -3, 1},
	{3, -6, 3, 0},
	{-3, 3, 0, 0},
	{1, 0, 0, 0}
}
exports.Bezier_M = Bezier_M

local CatmullRom_M = {
	{-1, 3, -3, 1},
	{2, -5, 4, -1},
	{-1, 0, 1, 0},
	{0, 2, 0, 0}
}
exports.CatmullRom_M = CatmullRom_M

--	To use the B-spline, you must use a multiplier of 1/6 on the matrix itself
--	Also, the parameter matrix is
--	[(t-ti)^3, (t-ti)^2, (t-ti), 1]
--	and the geometry is
--	[Pi-3, Pi-2, Pi-1, Pi]
--	Reference: http://spec.winprog.org/curves/

local  Bspline_M = {
	{-1, 2, -3, 1},
	{3, -6, 3, 0},
	{-3, 0, 3, 0},
	{1, 4, 1, 0},
}

-- helpful in calculation of curcular arc
local Timmer_M = {
	{-2,  4, -4,  2},
	{ 5, -8,  4, -1},
	{-4,  4,  0,  0},
	{ 1,  0,  0,  0}
}


--=======================================
--
--		Cubic Curve Routines
--
--=======================================
function cubic_vec3_to_cubic_vec4(cps)
	return {
		point3h_from_vec3(cps[1]),
		point3h_from_vec3(cps[2]),
		point3h_from_vec3(cps[3]),
		point3h_from_vec3(cps[4])
		}
end

function vec43_to_vec44(mesh)
	return {
		cubic_vec3_to_cubic_vec4(mesh[1]),
		cubic_vec3_to_cubic_vec4(mesh[2]),
		cubic_vec3_to_cubic_vec4(mesh[3]),
		cubic_vec3_to_cubic_vec4(mesh[4]),
		}
end

--[[
    The quadratic_U is here to help in the calculation
    of the cubic derivatives.
]]
local function quadratic_U(u, mult)
    mult = mult or 1
	return {mult*3*(u*u), mult*2*u, mult*1, 0}
end

local function cubic_U(u, mult)
    mult = mult or 1
	return {mult*(u*u*u), mult*(u*u), mult*u, mult*1}
end
exports.cubic_U = cubic_U

local function cerp(U, M, G)
    --print("cerp: ", U, M, G)
	return vec4_mult_mat4(vec4_mult_mat4(U, M), G)
end
exports.cerp = cerp


--=====================================================
-- Function: bicerp
-- 		BiCubic Interpolation
--
-- M - Blending Function
-- mesh - 16 control points
-- u - Parametric
-- v - Parametric
--=====================================================
local function mesh_col(mesh, col)
	local column = {mesh[1][col], mesh[2][col], mesh[3][col], mesh[4][col]};

	return column;
end

local function bicerp(u, w, mesh, M, umult)
	-- 'U' for derivatives
	local dU = mul(quadratic_U(u), umult);
	local dW = mul(quadratic_U(w), umult);

	-- 'U' for curve
	local U = mul(cubic_U(u), umult);
	local W = mul(cubic_U(w), umult);

	-- Calculate point on curve in 'u' direction
	local uPt1 = cerp(U, M, mesh[1]);
	local uPt2 = cerp(U, M, mesh[2]);
	local uPt3 = cerp(U, M, mesh[3]);
	local uPt4 = cerp(U, M, mesh[4]);

	local wPt1 = cerp(W, M, mesh_col(mesh, 1));
	local wPt2 = cerp(U, M, mesh_col(mesh, 2));
	local wPt3 = cerp(U, M, mesh_col(mesh, 3));
	local wPt4 = cerp(U, M, mesh_col(mesh, 4));

	-- Calculate the surface pt
	local spt = cerp(W, M,{uPt1, uPt2, uPt3, uPt4});

	-- tangent in the 'u' direction
	local tupt = cerp(dU, M, {wPt1, wPt2, wPt3, wPt4});
	-- tangent in the 'w' direction
	local twpt = cerp(dW, M, {uPt1, uPt2, uPt3, uPt4});

	-- Get the normal vector by crossing the two tangent
	-- vectors
	local npt = glsl.normalize(glsl.cross(tupt, twpt));

	-- BUGBUG - maybe return the two tangents as well as the normal?
	-- return both the point, and the normal
	return {point = spt, normal = npt};
end
exports.bicerp = bicerp


--[[
	Specific curve evaluators
]]
local function catmull_eval(u, mult, geom4)
	return cerp(cubic_U(u, mult), CatmullRom_M, geom4)
end
exports.catmull_eval = catmull_eval

local function catmullm(u,v, mesh)
	return bicerp(u, v, CatmullRom_M, vec43_to_vec44(mesh));
end

--=======================================
--
--		Bezier Convenience Routines
--
--=======================================

local function berp(u, cps)
	return cerp(cubic_U(u), Bezier_M, cubic_vec3_to_cubic_vec4(cps));
end

local function bezier_eval(u, geom4)
	return cerp(cubic_U(u, 1), Bezier_M, geom4)
end

-- Calculate a point on a Bezier mesh
-- Given the mesh, and the parametric 'u', and 'v' values
-- BUGBUG - it is expensive to convert the geometry 
-- each time we make this call, so either assume the geometry
-- is already in the right format, or tag it in some way so 
-- it doesn't have to happen again.
local function berpm(u,v, mesh)
	return bicerp(u, v, Bezier_M, vec43_to_vec44(mesh));
end


--=======================================
--
--		Hermite Convenience Routines
--
--=======================================
local function herp(u, cps)
	return ccerp(cubic_U(u), Hermite_M, cubic_vec3_to_cubic_vec4(cps))
end

-- Calculate a point on a cubic mesh
-- Given the mesh, and the parametric 'u', and 'v' values
local function herpm(u, v, mesh)
	return bicerp(u, v, Hermite_M, vec43_to_vec44(mesh));
end


-- An iterator version
local function IterateCubicVertices(M, umult, G, steps)
	local step=-1

	return function()
		step = step+1;
		if step > steps then
			return nil;
		else
			local U = cubic_U(step/steps);
			local pt0 = cerp(U, M, G);

			return pt0;
		end
	end
end
exports.IterateCubicVertices = IterateCubicVertices


return exports