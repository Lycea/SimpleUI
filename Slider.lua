 
 
 
 local Slider = require(b(...).."BaseWidget"):extend()
 
   local function lerp_(x,y,t) local num = x+t*(y-x)return num end
  
  
  local function percent_(x,y,z) return (x -z)/(x - y) end
  
  
local function clamp(min, max, val)
    return math.max(min, math.min(val, max));
end
  



local function to_precision(value,precision)

end

 
 function Slider:new (o)
      o = o or {}   -- create object if user does not provide one


      for k,v in pairs(o) do
        self[k]=v
      end


      self.name = "Slider"
      self.precision = 1
      --Todo: please also set the right position here ...
      --setmetatable(o, self)
      --self.__index = self
      
      local per = percent_(self.min,self.max,self.value)
      print(per)
      self.sli_pos.x = math.ceil( lerp_(self.x +10,self.x+self.width-20,per))
      self.__prev_value = self.value
      self.__onChange = function() end
      --return o
end


function Slider:GetValue()
  return self.custom_labels[self.value] or self.value
end


function Slider:setPrecision(precision)
    if precision <0 then
        precision =0
    end
    
    self.precision = precision
end


function Slider:setCallback( callback, fn)
  self["__"..callback] = fn
end


function Slider:draw()

  if self.visible then
        --draw the label (value)
        love.graphics.setColor(self.color["font_color"])

        love.graphics.print(self.custom_labels[self.value] or self.value, self.txt_pos.x,self.txt_pos.y)

      
        
        --start drawing the stuff in it ....
        --draw the "line" whcih the slider is moving on
        
        love.graphics.setColor(0,0,0,255)
        love.graphics.rectangle("fill",self.x+20,self.y+ self.height/2 -3,self.width - 40,6)
        love.graphics.setColor(self.color["border_color"])
        love.graphics.rectangle("line",self.x+20,self.y+ self.height/2 -3,self.width - 40,6)
        
        --draw the "background"
        love.graphics.setColor(self.color[self.state.."_color"])
        love.graphics.rectangle("fill",self.sli_pos.x,self.sli_pos.y,self.sli_pos.w,self.sli_pos.h)
        --draw the "border"
        love.graphics.setColor(self.color["border_color"])
        love.graphics.rectangle("line",self.sli_pos.x,self.sli_pos.y,self.sli_pos.w,self.sli_pos.h)
      end
end




--function Slider.update(obj,clicked,x,y,focused)
function Slider:update(clicked,x,y,focused)
  --print("id:", self.id)
  print("name", self.name)
  local redraw = false
  local old = self.state 
  
  local min = self.x + 10
  local max = self.x + self.width-20
   
  if self:check_rect(self.sli_pos,{x=x,y=y}) and self.visible then
   --if  (obj.sli_pos.x < x) and (obj.sli_pos.y< y) and (obj.sli_pos.x+obj.sli_pos.w > x) and obj.sli_pos.y+obj.sli_pos.h > y and obj.visible then
    --it is in rectangle so hover or click!!!
      
      if focused == 0 or focused == self.id then
        focused = self.id
        self.state = clicked and"clicked" or "hover"
        self.sli_pos.x =  clamp(min,max,clicked and x-self.sli_pos.w/2 or self.sli_pos.x) 
        
        local per =      ((min) -self.sli_pos.x)/((min) - (max))
        self.value = lerp_(self.min,self.max,per)
      end
   elseif  self.state == "clicked"  and clicked then
    -- it was dragged !! sooooo change x
    
      self.sli_pos.x =  clamp(min,max,x-self.sli_pos.w/2)
      
      local per =      ((min) -self.sli_pos.x)/((min) - (max))
      self.value = lerp_(self.min,self.max,per)


   
   else
     if focused == self.id then focused = 0 end
       self.state = "default" 
   end
   --print(components[name][i].value)
   self.value = math.floor(self.value*math.pow(10,self.precision))/math.pow(10,self.precision)
   --self.value  = math.floor(self.value )
   redraw = (old== self.state) and redraw or true 

   if self.value ~= self.__prev_value then
     self.__prev_value = self.value
     self.__onChange( self.custom_labels[self.value] or self.value)
   end

  return focused, redraw
end


function Slider.setCustomLabels(self, labels)
  
  self.use_custom_labels = true
  self.custom_labels = labels
end

return Slider