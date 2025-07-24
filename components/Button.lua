print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("Button.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)

--- @alias base_ctrl base_component

--- @module "__base_component"
local base_ctrl = require(BASE .. "__base_component")

---- Button class
---
---
--- !doctype module
--- @class ButtonCtrl : base_component
local Button =  base_ctrl:extend() 

function Button:new (o)

  self.name = "Button"

  self.time = 0.0
  self.timeout =  0.1

  self.enabled =  true
  self.visible =  true
  self.__onClick = function() end

  self.txt_pos = self.txt_pos or {}
  self.state = "default"


  self:init_from_list(o)
end


function Button:setCallback( callback, fn)
  self["__"..callback] = fn
end

function Button:recalc_size()
  local w = self.color.font:getWidth(self.txt)
  local p = self.color.font:getHeight()

  self.width = w > self.width and w + 20 or self.width
  self.height = p > self.height and p * 3 or self.height

  self.width = self.width or 50
  self.height = self.height or 30


  local x = math.floor(self.x + (self.width - w) / 2)
  local y = math.floor(self.y + (self.height - p) / 2)

  self.txt_pos.x = x --x + 10
  self.txt_pos.y = y --y + 7
end

function Button:calc_text_pos()
  
end

function Button:draw()
  
  if self.visible then
    --draw the "background"
    -- love.graphics.setColor(self.color[self.state.."_color"][1],self.color[self.state.."_color"][2],self.color[self.state.."_color"][3],self.color[self.state.."_color"][4])
    -- love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)

    self:draw_bg(self.color[self.state.."_color"],
                 {x=self.x,y=self.y},
                 {width=self.width,height=self.height}
    )

    --draw the "border"
    love.graphics.setColor(self.color["border_color"])
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)
    --draw the label
    love.graphics.setColor(self.color["font_color"])
    love.graphics.print(self.txt,self.txt_pos.x,self.txt_pos.y)
  end
end


function Button:update(clicked,x,y,focused)
   -- print("   DB: state")
   -- print("   enabled",obj.enabled)
   -- print("   visible",obj.visible)

   -- print("button update",self.id,self.name,self.txt)

   local redraw = false
   local old =self.state 
   
   local time = love.timer.getDelta()

   if (self.x < x) and (self.y< y) and (self.x+self.width > x) and self.y+self.height > y and self.enabled then
      --it is in rectangle so hover or click!!!
      if focused == 0 or focused == self.id then
        focused = self.id
        self.time = self.time +time
        
        self.state = clicked  and"clicked" or "hover"
        -- print("   state",self.state)
        if self.time >0.2 and clicked then 
          t = clicked and self.__onClick(self.id,self.name) or "nope"
          self.time = 0
        end
      end
   else
     if focused == self.id then focused = 0 end
       self.state = "default" 
     
   end
   redraw = (old== self.state) and redraw or true 
   return focused, redraw
end

--- @return ButtonCtrl
return Button
