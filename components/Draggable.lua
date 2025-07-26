print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("Draggable.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)

--- @module "__base_component"
local base_ctrl = require(BASE .. "__base_component")


--- !doctype module
--- @class Draggable : base_component
local Draggable = base_ctrl:extend()
local s = Draggable
 
local function lerp_(x,y,t) local num = x+t*(y-x)return num end

local function percent_(x,y,z) return (x -z)/(x - y) end


function Draggable:recalc_slider_pos()

  self.x = self.x + self.width/2 -10
  self.y = self.y + self.height / 2 - 10

end


function Draggable:new(o)
    o = o or {} -- create object if user does not provide one
    self.name = "Draggable"
    self.precision = 1

    self.state = "default"
    self.visible = true
    -- initing some defaults

    self.height = 50
    self.width = 50

    self.x = 0
    self.y = 0
    self.__onChange = function() end

    self:init_from_list(o)

    self.txt_pos = {}
    self:recalc_slider_pos()
end

function Draggable:recalc_position()
  local per = percent_(self.min, self.max, self.value)
  print(per)
  self.x = math.ceil(lerp_(self.x + 10, self.x + self.width - 20, per))
end



function Draggable.setCallback(obj, callback, fn)
  obj["__"..callback] = fn
end


function Draggable.draw(obj)

  if obj.visible then
        --draw the "background"
        love.graphics.setColor(obj.color[obj.state.."_color"])
        love.graphics.rectangle("fill",obj.x,obj.y,obj.width,obj.height)
        --draw the "border"
        love.graphics.setColor(obj.color["border_color"])
        love.graphics.rectangle("line",obj.x,obj.y,obj.width,obj.height)
      end
end



function Draggable:update(clicked,x,y,focused)
  local obj = self
  local redraw = false
  local old =obj.state 
  self:rectangle()

   if obj:in_area(self.rect_area,{x=x,y=y} ) then
    --it is in rectangle so hover or click!!!
      if focused == 0 or focused == obj.id then
        focused = obj.id
        obj.state = clicked and"clicked" or "hover"

        obj.x =  clicked and x-obj.width/2 or obj.x
        obj.y =  clicked and y - obj.height / 2 or obj.y
      end
  elseif obj.state == "clicked" and clicked then
    -- it was dragged !! sooooo change x

    obj.x = x - obj.width / 2
    obj.y = y - obj.height / 2

  else
    if focused == obj.id then focused = 0 end
       obj.state = "default" 
  end
   redraw = (old== obj.state) and redraw or true 

  return focused, redraw
end


--- @return Draggable
return Draggable
