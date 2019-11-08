package.path = "../?.lua;"..package.path

local oscad = require "lmodel.openscad_print"
local glsl = require("lmodel.glsl")
local metaball = require("lmodel.metaball")

-- Create shape file
local f = assert(io.open("output/metaball.scad", 'w'));

-- each ball specified a center, and a radius
local balls = {
    {15, 15, 0, 5}, 
    {30, 15, 0, 5}, 
    {20, 40, 0, 5}}

local s = metaball:new({
    USteps = 60;    -- steps around latitude
    WSteps = 30;    -- steps around longitude
    balls = balls;
})

oscad.PolyMesh_print(f,s:getMesh())

f:close()

