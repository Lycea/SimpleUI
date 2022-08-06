print("\nlabel init")
local BASE = (...)..'.' 
print(BASE)
local i= BASE:find("Label.$")
print (i)
BASE=BASE:sub(1,i-1)
print(BASE)

local  Label = require(BASE.."BaseWidget"):extend() 
 function Label:new (o)
      o = o or {}   -- create object if user does not provide one


      for k,v in pairs(o) do
        self[k] = v
      end

      self.name = "Label"
      self.time = 5
      
      self.txt_pos = self.x
      
      --setmetatable(o, self)
      --self.__index = self
      
      --return o
end



function Label:draw()
  
  if self.visible then

    --draw the label
    love.graphics.setColor(self.color["font_color"])
    love.graphics.print(self.txt, self.txt_pos, self.y)
    
  end
end




return Label