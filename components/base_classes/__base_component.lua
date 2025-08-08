---- base controll class
---
---
--- !doctype module
--- @class base_component : __simple_ui_base_class
local base_component = ___simple_ui_base_class:extend()

-- init helper
function base_component:init_from_list(list)
  list = list or {}     -- create object if user does not provide one


  for key, v in pairs(list) do
    self[key] = v
    print("updating ", key, v)
  end
end


function base_component:set_pos(x,y)
  self.x = x
  self.y = y

  self:recalc_size()
end

function base_component:set_size(width,height)
  self.width = width
  self.height = height

  self:recalc_size()
end

function base_component:recalc_size()
end

--- @class rectangle
--- @field x integer
--- @field y integer
--- @field w integer
--- @field h integer

---- Helper to convert values into a dictionary
--- @return rectangle
function base_component:to_rect(x,y,w,h)
  return {x=x,y=y,h=h,w=w}
end

function base_component:rectangle()
  --- @type rectangle
  self.rect_area = {x= self.x,y=self.y,w=self.width,h=self.height}
end

---------------------------------

--- area checker
--- @param rectangle rectangle
--- @return boolean if the given point is in the rectangle area
function base_component:in_area(rectangle, point)

  return point.x >= rectangle.x and point.x <= rectangle.x + rectangle.w and
         point.y >= rectangle.y and point.y <= rectangle.y + rectangle.h

end

---------------------
-- draw helpers
function base_component:draw_bg(color,pos,size)
  love.graphics.setColor(color[1], color[2], color[3], color[4])
  love.graphics.rectangle("fill", pos.x, pos.y, size.width, size.height)
end

function base_component:draw_border(color, pos, size)
  love.graphics.setColor(color[1], color[2], color[3], color[4])
  love.graphics.rectangle("line", pos.x, pos.y, size.width, size.height)
end

function base_component:draw_text(color, pos)
  love.graphics.setColor(color[1],color[2],color[3],color[4])
  love.graphics.print(self.txt,pos.x,pos.y)
end



-- @return base_component
return base_component
