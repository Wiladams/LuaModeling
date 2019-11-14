-- Metaball.lua
--
-- BanateCAD
-- Copyright (c) 2019  William Adams
--

local BiParametric = require("lmodel.biparametric")
local maths = require ("lmodel.maths")
local glsl = require("lmodel.glsl")

local centroid = maths.centroid
local spherical = require("lmodel.spherical")
local sph_to_cart = spherical.sph_to_cart

local Cepsilon = 0.00000001;    -- a very small value
local PI = math.pi

-- Another influence function
-- http://www.geisswerks.com/ryan/BLOBS/blobs.html

-- g(r) = 6r^5 - 15r^4 + 10r^3
-- g(r) = r * r * r * (r * (r * 6 - 15) + 10)

-- metaball - x, y, z, radius


--[[
function g1(r)
	return  r * r * r * (r * (r * 6 - 15) + 10)
end

function  MBInfluence(x, y, z, mball, radius)
	local dx = x - mball[1]
	local dy = y - mball[2]
	local dz = z - mball[3]

	local x2 = g1(dx)
	local y2 = g1(dy)
	local z2 = g1(dz)

	local mag = math.sqrt(x2 + y2 + z2)


	return (radius / mag)
end
--]]

-- essentially a distance calculation
local function  MBInfluence(pt, mball, radius)
	local dx = pt[1] - mball[1]
	local dy = pt[2] - mball[2]
	local dz = pt[3] - mball[3]

	local x2 = dx * dx
	local y2 = dy * dy
	local z2 = dz * dz

	local rsquared = x2 + y2 + z2

	local mag = math.sqrt(rsquared)

	return (radius / mag)
end



local function SumInfluence(pt, ballList, func)
	local sum = 0;

	for i,ball in ipairs(ballList) do
		sum = sum + func(pt, ball, ball[4])
	end
	return sum;
end

--[[
    Metaball class
]]
local Metaball = {}
setmetatable(Metaball, {
    __index = BiParametric;
    __call = function(self, ...)
        return self:new(...)
    end;
})
local Metaball_mt = {
    __index = Metaball;
}
-- balls
-- radius
--
function Metaball.new(self, obj)
    obj = BiParametric:new(obj)

	-- Must specify at least the balls
	obj.balls = obj.balls
	obj.radius = obj.radius or 100


	obj.Threshold = obj.Threshold or 0.001
    obj.Influencer = obj.Influencer or MBInfluence

	obj.atcenter = centroid(obj.balls)
	-- determine tolerance for the solver
	obj.MaxThreshold = obj.Threshold + 1
	obj.MinThreshold = 1 - obj.Threshold

    setmetatable(obj, Metaball_mt)

    return obj
end

--[[
	Recursively search down the beam until we bump into the surface.
	The search space uses a scan of a polar coordinate system.
	We need to turn polar coordinates into cartesian coordinates
--]]
function Metaball.beamsearch(self, longitude, latitude, high, low)
	-- If the high and low have met, then there's no
	-- intersection with the surface
	if (high - low) < Cepsilon then
		return {0,0,0}
	end

	local midpoint = low + (high-low)/2

	-- start with the midpoint
	local xyz = glsl.add(self.atcenter, spherical.sph_to_cart({longitude, latitude, midpoint}))
	local sum = SumInfluence(xyz, self.balls, self.Influencer);

	-- We're right within the threshold, so return the point
	if sum > self.MinThreshold and sum < self.MaxThreshold then
		return xyz;
	end

	-- Test to see if we're 'outside'
	if sum < self.MinThreshold then
		-- we're outside, so we want to try again with
		-- midpoint and lower
		return self:beamsearch(longitude, latitude, midpoint, low)
	end

	-- If we're 'inside'
	-- Try again with midpoint and higher
	if sum > self.MaxThreshold then
		return self:beamsearch(longitude, latitude, high, midpoint)
	end
end

--[[
	getVertex

	Given parameters 'u' and 'v' determine a vertex on the surface

	'v' indicates the latitude, and is in radians, starting from
	0 at the north pole, and extending to PI at the south pole.

	'u' indicates longitude, and goes from 0 to 2*PI
]]
function Metaball.getVertex(self, u, v)
	-- We have the latitude and longitude
	-- We want to descend down the radius until
	-- we intersect the object using a binary search
	-- Ideally we could just solve for the intersection

	local longitude = u * 2 * PI;
	local latitude = PI - v * PI;

	local xyz = self:beamsearch(longitude, latitude, self.radius, 0)
	local norm = glsl.normalize(xyz)

	return xyz, norm;
end

return Metaball
