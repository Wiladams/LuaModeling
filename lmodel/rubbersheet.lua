-- RubberSheet.lua
--
-- Copyright (c) 2019  William Adams
--

local BiParametric = require ("lmodel.biparametric")

-- USteps       - number
-- WSteps       - number
-- Size         - {x, y}
-- Resolution   - {x, y}
-- VertexSampler - GetVertex
-- ColorSampler

local RubberSheet = {}
setmetatable(RubberSheet, {
    __index = BiParametric;
    __call = function(self, ...)
        return self:new(...)
    end;
})
local RubberSheet_mt = {
    __index = RubberSheet;
}

function RubberSheet.new(self, obj)
    obj = BiParametric:new(obj)

    -- Get our specifics out of the parameters
    obj.Size = obj.Size or {1,1}
    obj.Resolution = obj.Resolution or {1,1}

    -- For BiParametric
    obj.USteps = obj.Size[1] * obj.Resolution[1]
    obj.WSteps = obj.Size[2] * obj.Resolution[2]
	--obj.VertexSampler = obj.VertexSampler or nil
    --obj.ColorSampler = obj.ColorSampler or nil
    
    print("RubberSheet.new(USteps, WSteps): ", obj.USteps, obj.WSteps)
    
    setmetatable(obj, RubberSheet_mt)

    return obj
end

function RubberSheet.getVertex(self, u, w)
	if self.VertexSampler ~= nil then
		return self.VertexSampler:GetVertex(u,w)
	end

	local x = u*self.Size[1]
	local y = w*self.Size[2]
	local z = 0

	return {x,y,z}
end


return RubberSheet