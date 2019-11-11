package.path = "../?.lua;"..package.path

local oscad = require("lmodel.openscad_print")
local Transformer = require("lmodel.transformer")

local t = Transformer()

local function test_simpletransform()
print("== Identity ==")
oscad.mat4_print(t.CurrentTransform)

t:translate(20, 5, 0)
print("== Translate(25, 5, 0) ==")
oscad.mat4_print(t.CurrentTransform)

local c1 = t:transformCoordinates(1,0,0)
print("== Transform ==")
oscad.vec3_write(c1)
end

local function test_iterator()
    print("==== test_iterator ====")
    local t = Transformer()
    --t:translate(5,5,1)
    t:scale(10,20,1)
    
    local pts = {
        {0,0,0},
        {1,1,1},
        {2,2,2},
        {3,3,3}
    }

    for _, pt in t:transformedPoints(pts) do
        oscad.vec3_write(pt)
        print()
    end
end

test_iterator()
