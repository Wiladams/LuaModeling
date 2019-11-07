package.path = "../?.lua;"..package.path

local mpoly = require "lmodel.maths_poly"

print("external angle(3): ", mpoly.poly_external_angle(3));
print("internal angle(3): ", mpoly.poly_internal_angle(3));
