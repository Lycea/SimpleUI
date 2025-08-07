print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("Slider.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)

--- @module "__base_component"
local base_ctrl = require(BASE .. "base_classes.__base_component")

--- !doctype module
--- @class Slider : base_component
local Slider = base_ctrl:extend()
local s = Slider
 
local function lerp_(x,y,t) local num = x+t*(y-x)return num end

local function percent_(x,y,z) return (x -z)/(x - y) end


local function clamp(min, max, val)
    return math.max(min, math.min(val, max));
end

local function to_precision(value,precision)

end

---- set the new value of the slider
--- @param value integer value to set the slider to
function Slider:set_value(value)
  self.value = clamp(self.min, self.max, value)
  self.__prev_value = value

  self:recalc_position()
end

function Slider:recalc_slider_pos()
  -- temp.txt_pos = {}
  print("DEBUG pos:",self.x,self.y)
  print("DEBUG size:",self.width,self.height)

  -- temp.sli_pos = {}
  self.sli_pos.x = self.x + self.width/2 -10
  self.sli_pos.y = self.y + self.height / 2 - 10
  -- temp.sli_pos.h = 20
  -- temp.sli_pos.w = 20

  self.txt_pos.x = (self.x + 20) + self.width - 40 + 10
  self.txt_pos.y = self.sli_pos.y + 7
end

---- function to set the min and max bounds of the slider
--- @param min integer the start value of the slider
--- @param max integer the stop value of the slider
function Slider:set_bounds(min,max)
  self.min = min
  self.max = max

  self:recalc_position()
end

function Slider:set_size(width,height)
  self.super.set_size(self,width,height)
  self:recalc_slider_pos()
end

function Slider:set_pos(x,y)
  self.super.set_pos(self,x,y)
  self:recalc_slider_pos()
end


function Slider:new(o)
    o = o or {} -- create object if user does not provide one
    self.name = "Slider"
    self.precision = 1

    self.state = "default"
    self.visible = true
    -- initing some defaults
    self.value = 0

    self.min = 0
    self.max = 100

    self.height = 50
    self.width = 50

    self.x = 0
    self.y = 0
    self.__onChange = function() end

    if o.custom_labels == nil then
        o.custom_labels = {}
    end

    self:init_from_list(o)

    self.sli_pos={}
    self.sli_pos.h = 20
    self.sli_pos.w = 20

    self.txt_pos = {}
    self:recalc_slider_pos()

    self:set_value(self.value)
    self:set_bounds(self.min,self.max)
end

--- function to recalculate the position of the dragable part of the slider
-- @alias o self
function Slider:recalc_position()
  local per = percent_(self.min, self.max, self.value)
  print(per)
  self.sli_pos.x = math.ceil(lerp_(self.x + 10, self.x + self.width - 20, per))
end

function Slider.GetValue(obj)
  return obj.custom_labels[obj.value] or obj.value
end


function Slider.setPrecision(obj,precision)
    if precision <0 then
        precision =0
    end
    
    obj.precision = precision
end


function Slider.setCallback(obj, callback, fn)
  obj["__"..callback] = fn
end


function Slider.draw(obj)

  if obj.visible then
        --draw the label (value)
        love.graphics.setColor(obj.color["font_color"])

        love.graphics.print(obj.custom_labels[obj.value] or obj.value, obj.txt_pos.x,obj.txt_pos.y)

      
        
        --start drawing the stuff in it ....
        --draw the "line" whcih the slider is moving on
        
        love.graphics.setColor(0,0,0,255)
        love.graphics.rectangle("fill",obj.x+20,obj.y+ obj.height/2 -3,obj.width - 40,6)
        love.graphics.setColor(obj.color["border_color"])
        love.graphics.rectangle("line",obj.x+20,obj.y+ obj.height/2 -3,obj.width - 40,6)
        
        --draw the "background"
        love.graphics.setColor(obj.color[obj.state.."_color"])
        love.graphics.rectangle("fill",obj.sli_pos.x,obj.sli_pos.y,obj.sli_pos.w,obj.sli_pos.h)
        --draw the "border"
        love.graphics.setColor(obj.color["border_color"])
        love.graphics.rectangle("line",obj.sli_pos.x,obj.sli_pos.y,obj.sli_pos.w,obj.sli_pos.h)
      end
end



--- @alias obj self
function Slider:update(clicked,x,y,focused)
  local obj = self
  local redraw = false
  local old =obj.state 
  
  local min = obj.x +10
  local max = obj.x+obj.width-20


   if obj:in_area(self.sli_pos,{x=x,y=y} ) then
 
--   if  (obj.sli_pos.x < x) and (obj.sli_pos.y< y) and (obj.sli_pos.x+obj.sli_pos.w > x) and obj.sli_pos.y+obj.sli_pos.h > y and obj.visible then
    --it is in rectangle so hover or click!!!
      
      if focused == 0 or focused == obj.id then
        focused = obj.id
        obj.state = clicked and"clicked" or "hover"
        obj.sli_pos.x =  clamp(min,max,clicked and x-obj.sli_pos.w/2 or obj.sli_pos.x) 
        
        local per =      ((min) -obj.sli_pos.x)/((min) - (max))
        obj.value = lerp_(obj.min,obj.max,per)
      end
   elseif  obj.state == "clicked"  and clicked then
    -- it was dragged !! sooooo change x

      obj.sli_pos.x =  clamp(min,max,x-obj.sli_pos.w/2)

      local per =      ((min) -obj.sli_pos.x)/((min) - (max))
      obj.value = lerp_(obj.min,obj.max,per)

   else
     if focused == obj.id then focused = 0 end
       obj.state = "default" 
   end
   --print(components[name][i].value)
   obj.value = math.floor(obj.value*math.pow(10,obj.precision))/math.pow(10,obj.precision)
   --obj.value  = math.floor(obj.value )
   redraw = (old== obj.state) and redraw or true 

   if obj.value ~= obj.__prev_value then
     obj.__prev_value = obj.value
     obj.__onChange( obj.custom_labels[obj.value] or obj.value)
   end

  return focused, redraw
end


function Slider.setCustomLabels(obj, labels)
  print("setting custom labels")
  obj.use_custom_labels = true
  obj.custom_labels = labels
  obj.precision= 0
  obj.min = 1
  obj.max = #labels

  obj:recalc_position()
end

--- @return Slider
return Slider
