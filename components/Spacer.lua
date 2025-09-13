print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("Spacer.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)

--- @module "__base_component"
local base_ctrl = require(BASE .. "base_classes.__base_component")


--- !doctype module
--- @class Spacer : base_component
local Spacer = base_ctrl:extend()

 function Spacer:new (o)
      o = o or {}   -- create object if user does not provide one
      self.name = "Spacer"
      self.time = 5

      self.state = "default"
      self.visible = true

end


function Spacer:draw()

end


function Spacer:update(clicked,x,y,focused)
   return focused, false
end

return Spacer
