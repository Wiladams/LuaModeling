package.path = "../?.lua;"..package.path

local oscad = require "lmodel.openscad_print"
local metaball = require "lmodel.metaball"

balls = {{15, 15, 0, 5}, {30, 15, 0, 5}, {20, 40, 0, 5}}

--for i=1, #balls do
--	vec2_print(balls[i]);
--	print();
--end

for v in metaball.IterateMetaballs({200,200,200}, balls) do
	oscad.vec3_write(v);
	print();
end
