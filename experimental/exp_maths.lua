
local exports = {}

local function poly_external_angle(p)
	return (360/p);
end
exports.poly_external_angle = poly_external_angle

local function poly_internal_angle(p)
	return 180-poly_external_angle(p);
end
exports.poly_internal_angle = poly_internal_angle


local function factorial(n)
	if n==0 then
		return 1
	else
		return n * factorial(n-1)
	end
end


--=======================================
--
--	Linear Interpolation Routines
--
--=======================================
local function lerp1( p0, p1, u)
	return (1-u)*p0 + u*p1
end

local function vec3_lerp(v1, v2, u)
	return {
	lerp1(v1[1], v2[1],u),
	lerp1(v1[2], v2[2],u),
	lerp1(v1[3], v2[3],u)
	}
end

local function vec4_lerp(v1, v2, u)
	return {
	lerp1(v1[1], v2[1],u),
	lerp1(v1[2], v2[2],u),
	lerp1(v1[3], v2[3],u),
	lerp1(v1[4], v2[4],u)
	}
end


return exports

