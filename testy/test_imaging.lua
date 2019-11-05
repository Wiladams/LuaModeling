package.path = "../?.lua;"..package.path

local imaging = require "lmodel.imaging"

function test_glsl()
    io.write('0 ',map_to_array(3, 0),'\n');
    io.write('0.3 ',map_to_array(3, 0.3),'\n');
    io.write('1 ',map_to_array(3, 0.66),'\n');
    io.write('3 ',map_to_array(3, 1),'\n');
end

