--=====================================
-- This is public Domain Code
-- Contributed by: William A Adams
-- September 2011
--=====================================
local exports = {}

exports.pi = math.pi

-- Already built in, but I give them
-- glsl names
local function abs(x)
	return math.abs(x);
end
exports.abs = abs

local function ceil(x)
	return math.ceil(x);
end
exports.ceil = ceil

local function floor(x)
	return math.floor(x);
end
exports.floor = floor

local function max(x,y)
	return math.max(x,y);
end
exports.max = max

local function min(x,y)
	return math.min(x,y);
end
exports.min = min


--The following routines roughly map to those found in the
--OpenGL Shading language GLSL. They are largely convenience
--routines, but very useful when doing image processing.

local function radians(degrees)
	return pi/180 * degrees;
end
exports.radians = radians

local function degrees(radians)
	return 180/pi * radians;
end
exports.degrees = degrees

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