
local exports = {}

local function poly_external_angle(p)
	return (360/p);
end
exports.poly_external_angle = poly_external_angle

local function poly_internal_angle(p)
	return 180-poly_external_angle(p);
end
exports.poly_internal_angle = poly_internal_angle

return exports

