package.path = "../?.lua;"..package.path


local oscad = require "lmodel.openscad_print"
local glsl = require("lmodel.glsl")
local degrees = glsl.degrees
local radians = glsl.radians

local Torus = require("lmodel.torus")

-- Create shape file
local f = assert(io.open("output/test_torus.scad", 'w'));

local shape = Torus {
    USteps = 60;
    WSteps = 60;
    HoleRadius = 10;
	ProfileRadius =  5;
	--ProfileSampler = obj.ProfileSampler or nil

    -- change the amount of cross section
    MinTheta = 0;
    MaxTheta = radians(270);

    -- change the amount around the donut
    MinPhi = 10;
    MaxPhi = radians(320);
}


oscad.PolyMesh_print(f,shape:getMesh())