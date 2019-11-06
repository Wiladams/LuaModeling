--[[
local se = shape_ellipsoid({XRadius = 1, ZRadius = 1, MaxTheta = 360, MaxPhi = 180})
print(se)
--]]

package.path = "../?.lua;"..package.path


local oscad = require "lmodel.openscad_print"
local glsl = require("lmodel.glsl")
local degrees = glsl.degrees
local radians = glsl.radians

local Ellipsoid = require("lmodel.ellipsoid")

-- Create shape file
local f = assert(io.open("output/test_ellipsoid.scad", 'w'));

local se = Ellipsoid {
    USteps = 60,
    WSteps = 40,
    XRadius = 60, 
    ZRadius = 10, 
    MaxTheta = radians(360), 
    MaxPhi = radians(180),
    --Thickness = 5,
}


oscad.PolyMesh_print(f,se:getMesh())
