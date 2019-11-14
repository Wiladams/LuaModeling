--=====================================
-- This is public Domain Code
-- Contributed by: William A Adams
-- September 2011
--=====================================

local abs = math.abs
local min = math.min
local max = math.max
local floor = math.floor
local ceil = math.ceil
local rad = math.rad
local deg = math.deg
local log = math.log
local pow = math.pow

local epsilon = 1E-12

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

-- The base vector types
local function vec2(x, y) return {x, y} end
local function vec3(x, y, z) return {x, y, z} end
local function vec4(x, y, z, w) return {x, y, z, w} end

-- built-ins with same semantics
exports.pi = math.pi


--[[
	Apply the function 'f' to every element
	of vector 'v'.  if 'v' is a single scalar
	then apply the function to that single parameter

	RETURN: returns a new instance of the table, does
	not alter the existing table.
--]]
local function apply(f, v)
	if type(v) == "number" then
		return f(v)
	end

	if type(v) == "table" then
		local res = {}
		for i=1,#v do
			res[i] = f(v[i])
		end
		return res
	end

	return nil
end

--[[
	Apply the function 'f' using the two arrays
	'v1' and 'v2'
]]
local function apply2(f, v1, v2)
	if type(v1) == "number" then
		return f(v1, v2)
	end

	if type(v1) == "table" then
		local res = {}
		if type(v2)=="number" then
            for i=1,#v1 do
				res[i] = f(v1[i],v2)
			end
		else
			for i=1,#v1 do
				res[i] = f(v1[i], v2[i])
			end
		end
		return res
	end
	
	return nil
end

--[[
	==== The functions
]]
local function add(x,y)
	return apply2(function(x,y) return x + y end,x,y)
end
exports.add = add

local function sub(x,y)
	return apply2(function(x,y) return x - y end,x,y)
end
exports.sub = sub

local function mul(x,y)
	return apply2(function(x,y) return x * y end,x,y)
end
exports.mul = mul

local function div(x,y)
	return apply2(function(x,y) return x / y end,x,y)
end
exports.div = div

-- improved equality test with tolerance
local function equal(v1,v2,tol)
	tol = tol or epsilon

	assert(type(v1)==type(v2),"equal("..type(v1)..","..type(v2)..") : incompatible types")
	
	return apply(function(x) return x<=tol end,abs(sub(v1,v2)))
end
exports.equal = equal

local function notEqual(v1,v2,tol)
	assert(type(v1)==type(v2),"equal("..type(v1)..","..type(v2)..") : incompatible types")
	tol = tol or epsilon

	return apply(function(x) return x>tol end,abs(sub(v1,v2)))
end
exports.notEqual = notEqual

--[[
	Angle and Trigonometry Functions (5.1)

	These are done using the 'apply' functions, because
	the argument can be either a single number, or an 
	array of numbers.  Rather than having all that code
	replicated for each function, it's conveniently collapsed
	into the 'apply' functions.
--]]


local function radians(degs)
	return apply(math.rad, degs)
end
exports.radians = radians

local function degrees(rads)
	return apply(math.deg, rads)
end
exports.degrees = degrees

local function sin(rads)
	return apply(math.sin, rads)
end
exports.sin = sin

local function cos(rads)
	return apply(math.cos, rads)
end
exports.cos = cos

local function tan(rads)
	return apply(math.tan, rads)
end
exports.tan = tan

local function asin(rads)
	return apply(math.asin, rads)
end
exports.asin = asin

local function acos(rads)
	return apply(math.acos, rads)
end
exports.acos = acos

local function atan(rads)
	return apply(math.atan, rads)
end
exports.atan = atan

local function atan2(y,x)
	return apply2(math.atan2,y,x)
end
exports.atan2 = atan2

local function sinh(rads)
	return apply(math.sinh, rads)
end
exports.sinh = sinh

local function cosh(rads)
	return apply(math.cosh, rads)
end
exports.cosh = cosh

local function tanh(rads)
	return apply(math.tanh, rads)
end
exports.tanh = tanh


--=====================================
--	Exponential Functions (5.2)
--=====================================
exports.pow = math.pow

function exports.exp2(x) return pow(2, x) end
function exports.log2(x) return log(x)/log(2)  end

exports.sqrt = math.sqrt

local function inv(x)
	return apply(function(x) return 1/x end, x)
end
exports.inv = inv

local function invsqrt(x)
	return apply(function(x) return 1/sqrt(x) end, x)
end
exports.invsqrt = invsqrt


--=====================================
--	Common Functions (5.3)
--=====================================
exports.abs = math.abs

function exports.sign(x)
	if x > 0 then
		return 1
	elseif x < 0 then
		return -1
	end

	return 0
end

exports.floor = math.floor

function exports.trunc(x)
	local asign = exports.sign(x)
	local res = asign * floor(abs(x))

	return res
end

function exports.round(x)
	local asign = exports.sign(x)
	local res = asign*floor((abs(x) + 0.5))

	return res
end

exports.ceil = math.ceil


local function fract(x)
	return apply(function(x) return x-floor(x)end, x)
end
exports.fract = fract


exports.max = math.max
exports.min = math.min


--[[
	x + a*(y-x)

	Does NOT clamp to range.
	
]]
local function mix(x, y, a)
	return add(x,mul(sub(y,x),a))
end
exports.mix = mix

local function mod(x, y)
	return x-(y*floor(x/y));
end
exports.mod = mod

local function clamp(x, minValue, maxValue)
	if type(x) == "number" then
		return min(max(x,minValue),maxValue)
	end

	if type(x) == "table" then
		local res = {}
		for i=1,#x do
			res[i] = min(max(x[i],minValue),maxValue)
		end
		return res
	end

	return nil
end
exports.clamp = clamp


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


--=====================================
--	Geometric Functions (5.4)
--=====================================
function dot(v1,v2)
	if type(v1) == 'number' then
		return v1*v2
	end

	if (type(v1) == 'table') then
		-- if v1 is a table
		-- it could be vector.vector
		-- or matrix.vector
		if type(v1[1] == "number") then
			local sum=0
			for i=1,#v1 do
				sum = sum + (v1[i]*v2[i])
			end
			return sum;
		else -- matrix.vector
			local res={}
			for i,x in ipairs(v1) do
				res[i] = dot(x,v2) end
			return res
		end
	end
end
exports.dot = dot

local function length(v)
	return math.sqrt(dot(v,v))
end
exports.length = length

local function normalize(v)
	return mul(v, 1/length(v))
end
exports.normalize = normalize

local function distance(v1,v2)
	return length(sub(v1,v2))
end
exports.distance = distance

-- cross product
-- this only works when the length of v1 and v2
-- are at least 3
local function cross(v1, v2)
	if #v1 < 3 or #v2 < 3 then
		return nil
	end

	return {
		(v1[2]*v2[3])-(v2[2]*v1[3]),
		(v1[3]*v2[1])-(v2[3]*v1[1]),
		(v1[1]*v2[2])-(v2[1]*v1[2])
	}
end
exports.cross = cross

--=====================================
--	Vector Relational (5.4)
--=====================================
local function isnumtrue(x)
	local n = tonumber(x)
	return n ~= nil and n ~= 0
end
exports.isnumtrue = isnumtrue

local function any(x)
	for i=1,#x do
		if isnumtrue(x[i]) then
			return true 
		end
	end

	return false
end
exports.any = any

local function all(x)
	for i=1,#x do
		local f = isnumtrue(x[i])
		if not f then return false end
	end

	return true
end
exports.all = all

return exports