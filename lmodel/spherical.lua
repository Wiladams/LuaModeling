
local sqrt = math.sqrt
local sin, cos = math.sin, math.cos
local atan2 = math.atan2

--[[
==================================
  Spherical coordinates
==================================
--]]
local exports = {}

--[[
 create an instance of a spherical coordinate
 long - rotation around z -axis
 lat - latitude, starting at 0 == 'north pole'
 rad - distance from center
--]]
local function sph(long, lat, rad)
	return {long, lat, rad}
end
exports.sph = sph

-- Convert spherical to cartesian
local function sph_to_cart(s)
	return {
	clean(s[3]*sin(s[2])*cos(s[1])),
	clean(s[3]*sin(s[2])*sin(s[1])),
	clean(s[3]*cos(s[2]))
	}
end
exports.sph_to_cart = sph_to_cart

-- Convert from cartesian to spherical
local function sph_from_cart(c)
	return sph(
	atan2(c[2],c[1]),
	atan2(sqrt(c[1]*c[1]+c[2]*c[2]), c[3]),
	sqrt(c[1]*c[1]+c[2]*c[2]+c[3]*c[3])
	)
end
exports.sph_from_cart = sph_from_cart

local function sphu_from_cart(c, rad)
	return sph(
	atan2(c[2],c[1]),
	atan2(sqrt(c[1]*c[1]+c[2]*c[2]), c[3]),
	rad
	)
end
exports.sphu_from_cart = sphu_from_cart


-- compute the chord distance between two points on a sphere
local function sph_dist(c1, c2)
	return sqrt(
	c1[3]*c1[3] + c2[3]*c2[3] -
	2*c1[3]*c2[3]*
	((cos(c1[2])*cos(c2[2])) +
	cos(c1[1]-c2[1])*sin(c1[2])*sin(c2[2]))
	);
end
exports.sph_dist = sph_dist

return exports
