print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("Label.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)

--- @module "__base_component"
local base_ctrl = require(BASE .. "base_classes.__base_component")


--- !doctype module
--- @class Label : base_component
local Label = base_ctrl:extend()

 function Label:new (o)
      o = o or {}   -- create object if user does not provide one
      self.name = "Label"
      self.time = 5

      self.state = "default"
      self.visible = true

      self.txt_pos = o.x

      self:init_from_list(o)
      -- setmetatable(o, self)
      -- self.__index = self
end


function Label:draw()

  if self.visible then
    --draw the label
    love.graphics.setColor(self.color["font_color"])
    love.graphics.print(self.txt,self.txt_pos,self.y)
    
  end
end


function Label:update(clicked,x,y,focused)
   return focused, false
end

return Label
