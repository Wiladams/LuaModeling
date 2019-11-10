


--[[
==================================
  Spherical coordinates
==================================
--]]
local sqrt = math.sqrt
local sin, cos = math.sin, math.cos
local atan2 = math.atan2
local maths = require("lmodel.maths")
local clean = maths.clean


-- Utility functions
local exports = {}

-- Convert from cartesian to spherical
local function sph_from_cart(c)
	return sph(
	atan2(c[2],c[1]),
	atan2(sqrt(c[1]*c[1]+c[2]*c[2]), c[3]),
	sqrt(c[1]*c[1]+c[2]*c[2]+c[3]*c[3])
	)
end
exports.sph_from_cart = sph_from_cart

-- Convert spherical to cartesian
local function sph_to_cart(s)
	return {
	clean(s[3]*sin(s[2])*cos(s[1])),
	clean(s[3]*sin(s[2])*sin(s[1])),
	clean(s[3]*cos(s[2]))
	}
end
exports.sph_to_cart = sph_to_cart

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


local Spherical = {}
setmetatable(Spherical, {
	__call = function(self, ...)
		return self:new(...)
	end;
})
local Spherical_mt = {
	__index = Spherical
}

--[[
	Spherical - A class for handling spherical coordinates

 Spherical coordinates are defined as
 	longitude 	- rotation around z -axis		[0..2pi]
 	latitude 	- latitude, 0 == 'north pole' 	[0..pi]
 	radius 		- distance from center			[number]
--]]
local function Spherical.new(self, obj)
	local obj = obj or {
		longitude = 0;
		latitude = math.pi/2;
		radius = 1;
	}

	obj.radius = obj.radius or 1
	obj.latitude = obj.latitude or math.pi
	obj.longitude = obj.longitude or 0

	setmetatable(obj, Spherical_mt)

	return obj
end

--[[
	construct with x, y, z
]]
function Spherical.createFromCartesian(self, ...)
	local nargs = select('#', ...)
	local params

	if nargs == 3 then
		local x = select(1, ...)
		local y = select(2, ...)
		local z = select(3, ...)

		params = {
			atan2(y,x),
			atan2(sqrt(x*x+y*y), z),
			sqrt(x*x+y*y+z*z)
		}
	end

	return Spherical:new(params)
end

--[[
	Turn spherical coordinates into cartesian
	return a tuple of {x,y,z}
]]
function Spherical.toCartesian(self)
	return {
		clean(self.radius*sin(self.latitude)*cos(self.longitude)),
		clean(self.radius*sin(self.latitude)*sin(self.longitude)),
		clean(self.radius*cos(self.latitude))
		}
end


return exports
