 local  Label = {}
 
 function Label:new (o)
      o = o or {}   -- create object if user does not provide one
      o.name = "Label"
      o.time = 5
      
      o.txt_pos = o.x
      
      setmetatable(o, self)
      self.__index = self
      
      return o
end



function Label.draw(obj)
  
  if obj.visible then

    --draw the label
    love.graphics.setColor(obj.color["font_color"])
    love.graphics.print(obj.txt,obj.txt_pos,obj.y)
    
  end
end




function Label.update(obj,clicked,x,y,focused)
   return 0, false
end

return Label