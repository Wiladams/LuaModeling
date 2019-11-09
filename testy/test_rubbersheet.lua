package.path = "../?.lua;"..package.path


local oscad = require ("lmodel.openscad_print")
local RubberSheet = require("lmodel.rubbersheet")

local rs = RubberSheet:new({
    Size = {1,1};           -- dimensional size
    Resolution = {1,1};   -- number of steps to iterate
    Thickness = 4;
})

local f = assert(io.open("output/rubbersheet.scad", 'w'));
oscad.PolyMesh_print(f, rs:getMesh())
f:close()