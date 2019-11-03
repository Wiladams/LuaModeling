package.path = "../?.lua;"..package.path

require "lmodel.maths_poly"

print("external angle(3): ", poly_external_angle(3));
print("internal angle(3): ", poly_internal_angle(3));
