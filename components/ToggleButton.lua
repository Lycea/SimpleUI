print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("ToggleButton.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)


--- @alias base_ctrl base_component

--- @module "__base_component"
local base_ctrl = require(BASE .. "base_classes.__base_component")

---- Button class
---
---
--- !doctype module
--- @class ToggleButtonCtrl : base_component
local ToggleButton = base_ctrl:extend()

 
 function ToggleButton.setCallback(obj, callback, fn)
  obj["__"..callback] = fn
end


 function ToggleButton:new (o)

    self.name = "ToggleButton"
    self.toggle_group = "-"

    self.time = 0.0
    self.timeout = 0.1
    
    self.width = 0
    self.height = 0
    
    self.enabled = true
    self.visible = true
    self.__onClick = function() end
    
    self.txt_pos = self.txt_pos or {}
    self.state = "default"

    if not o.__onClick then o.__onClick = function () end end

    self:init_from_list(o)
end

function ToggleButton:recalc_size()
  local w = self.color.font:getWidth(self.txt)
  local p = self.color.font:getHeight()

  self.width = w > self.width and w + 20 or self.width
  self.height = p > self.height and p * 3 or self.height

  self.width = math.min(self.width or 50, self.m_width or 9999)
  self.height = math.min(self.height or 30,self.m_height or 9999)


  local x = math.floor(self.x + (self.width - w) / 2)
  local y = math.floor(self.y + (self.height - p) / 2)

  self.txt_pos.x = x --x + 10
  self.txt_pos.y = y --y + 7
end


local function check(o)
    love.graphics.setColor(o.color["toggled_color"])
    local color_state = "toggled_color"

    love.graphics.setColor(o.color[color_state][1], o.color[color_state][2],
                           o.color[color_state][3], o.color[color_state][4])
    love.graphics.rectangle("fill",o.x,o.y,o.width,o.height)

    love.graphics.setLineWidth(1)

end

local function uncheck(o)
    
end

function ToggleButton.GetValue(obj)
  return obj.checked
end




function ToggleButton:draw()
  
  if self.visible then

    t = self.checked and check(self) or uncheck(self)

    --draw the "background" ( for the box)
    love.graphics.setColor(self.color[self.state .. "_color"][1], self.color[self.state .. "_color"][2],
                           self.color[self.state .. "_color"][3], self.color[self.state .. "_color"][4])
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    --draw the "border"
    love.graphics.setColor(self.color["border_color"])
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    if self.checked then
      love.graphics.rectangle("line", self.x + 2, self.y + 2, self.width - 4, self.height - 4)
    end

    --draw the label
    love.graphics.setColor(self.color["font_color"])
    love.graphics.print(self.txt, self.x +5 , self.y +self.height/2 - self.color.font:getHeight()/2  )
  end
end


function ToggleButton.toggle(obj,state)

  if state == nil then
    state = not obj.checked
  end

  obj.checked = state
  t = clicked and obj.__onClick(obj.id, obj.name, obj.checked) or "nope"
end

function ToggleButton:update(clicked,x,y,focused)
   local redraw = false
   local old =self.state 
   
   local time = love.timer.getDelta()
   
   self:rectangle()
   --check if the mouse is in the clickable region
   if self:in_area(self.rect_area,{x=x,y=y})   and self.visible and self.enabled then
      --it is in rectangle so hover or click!!!
      if focused == 0 or focused == self.id then
        focused = self.id
        self.state = clicked  and"clicked" or "hover"
        self.time = self.time +time
        
        --check if long enough time has passed since last click 
        if self.time >0.2 and clicked then 
            self.checked = not self.checked
            t = clicked and self.__onClick(self.id,self.name, self.checked) or "nope"

            --check if it creates a bigger issue if not checked if active
            if self.toggle_group ~= "-" then
              print("test", self.ui.toggle_groups)
              print("group",self.toggle_group)
              self.ui:update_toggles(self.id,self.toggle_group)
            end

            self.time = 0
        end
      end
   else
     --if not in the rectangle reset the state
     if focused == self.id then focused = 0 end 
       self.state = "default" 
     
   end
   redraw = (old== self.state) and redraw or true 
   return focused, redraw
end

return ToggleButton
