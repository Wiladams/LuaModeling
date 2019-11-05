package.path = "../?.lua;"..package.path

local glsl = require("lmodel.glsl")
local degrees, radians = glsl.degrees, glsl.radians

print("radians(180) = ", radians(180))
print("degrees(radians(180)) = ", degrees(glsl.radians(180)))
