--=====================================
-- This is public Domain Code
-- Contributed by: William A Adams
-- September 2011
--=====================================

--[[
	glsl is the pipeline programming language for OpenGL
	The language contains various math functions that have
	specific semantics.  We include them here to have some
	lua equivalents of the same.  
	
	In many cases the semantics
	are exactly the same as the built-in functions.  In those 
	cases, we just alias the builtin functions.

	In some cases they might have slightly different semantics, 
	so we replicate the the specific glsl function.
]]
local exports = {}

-- built-ins with same semantics
exports.pi = math.pi
exports.abs = math.abs
exports.ceil = math.ceil
exports.floor = math.floor
exports.max = math.max
exports.min = math.min
exports.radians = math.rad
exports.degrees = math.deg

--The following routines roughly map to those found in the
--OpenGL Shading language GLSL. They are largely convenience
--routines, but very useful when doing image processing.

local function fract(x)
	return x - floor(x);
end
exports.fract = fract

local function fract3(x)
	return {fract(x[1]), fract(x[2]), fract(x[3])};
end
exports.fract3 = fract3

local function mix(x, y, a)
	return x*(1-a)+y*a;
end
exports.mix = mix

local function mix3(x, y,a)
	return {mix(x[1],y[1],a), mix(x[2],y[2],a), mix(x[3],y[3],a)};
end
exports.mix3 = mix3

local function mod(x, y)
	return x-(y*floor(x/y));
end
exports.mod = mod

local function clamp(x, minValue, maxValue)
	return min(max(x,minValue),maxValue);
end
exports.clamp = clamp


local function clamp3(x, minValue, maxValue)
	return {clamp(x[1]), clamp(x[2]), clamp(x[3])};
end
exports.clamp3 = clamp3

local function dot(v1,v2)
	return v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3];
end
exports.dot = dot

local function step(edge, x)
	if (x < edge) then
		return 0;
	else
		return 1;
	end
end
exports.step = step

-- Hermite smoothing between two points
local function herm(edge0, edge1, x)
	local range = (edge1 - edge0);
	local distance = (x - edge0);
	local t = clamp((distance / range), 0.0, 1.0);
	local r = t*t*(3.0-2.0*t);

	return r;
end
exports.herm = herm

local function smoothstep(edge0, edge1, x)
	if (x <= edge0) then
		return 0.0
	end

	if (x >= edge1) then
		return 1.0
	end

	return	herm(edge0, edge1, x);
end
exports.smoothstep = smoothstep

return exports