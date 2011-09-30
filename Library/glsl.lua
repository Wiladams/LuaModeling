--=====================================
-- This is public Domain Code
-- Contributed by: William A Adams
-- September 2011
--=====================================

pi = 3.14159;

-- Already built in, but I give them
-- glsl names
function abs(x)
	return math.abs(x);
end

function ceil(x)
	return math.ceil(x);
end

function floor(x)
	return math.floor(x);
end

function max(x,y)
	return math.max(x,y);
end

function min(x,y)
	return math.min(x,y);
end



--The following routines roughly map to those found in the
--OpenGL Shading language GLSL. They are largely convenience
--routines, but very useful when doing image processing.

function radians(degrees)
	return pi/180 * degrees;
end

function degrees(radians)
	return 180/pi * radians;
end

function fract(x)
	return x - floor(x);
end

function fract3(x)
	return {fract(x[1]), fract(x[2]), fract(x[3])};
end

function mix(x, y, a)
	return x*(1-a)+y*a;
end

function mix3(x, y,a)
	return {mix(x[1],y[1],a), mix(x[2],y[2],a), mix(x[3],y[3],a)};
end

function mod(x, y)
	return x-(y*floor(x/y));
end

function clamp(x, minValue, maxValue)
	return min(max(x,minValue),maxValue);
end

function clamp3(x, minValue, maxValue)
	return {clamp(x[1]), clamp(x[2]), clamp(x[3])};
end

function dot(v1,v2)
	return v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3];
end


function step(edge, x)
	if (x < edge) then
		return 0;
	else
		return 1;
	end
end

-- Hermite smoothing between two points
function herm(edge0, edge1, x)
	local range = (edge1 - edge0);
	local distance = (x - edge0);
	local t = clamp((distance / range), 0.0, 1.0);
	local r = t*t*(3.0-2.0*t);

	return r;
end

function smoothstep(edge0, edge1, x)
	if (x <= edge0) then
		return 0.0
	end

	if (x >= edge1) then
		return 1.0
	end

	return	herm(edge0, edge1, x);
end
