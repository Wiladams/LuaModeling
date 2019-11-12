package.path = "../?.lua;"..package.path


local oscad = require "lmodel.openscad_print"
local glsl = require("lmodel.glsl")
local degrees = glsl.degrees
local radians = glsl.radians

local Torus = require("lmodel.torus")

-- Create shape file
local f = assert(io.open("output/test_torus.scad", 'w'));

local shape = Torus {
    USteps = 8*3;        -- around the circle
    WSteps = 32*4;        -- around the donut
    HoleRadius = 10;
	ProfileRadius =  5;
	--ProfileSampler = obj.ProfileSampler or nil

    -- change the amount of cross section
    --MinTheta = 0;
    --MaxTheta = radians(270);

    -- change the amount around the donut
    MinPhi = radians(0);
    MaxPhi = radians(270);

    --Thickness = 2;
}


oscad.PolyMesh_print(f,shape:getMesh())