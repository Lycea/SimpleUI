 local Button = {}
 
 
 function Button:new (o)
      o = o or {}   -- create object if user does not provide one
      o.name = "Button"
      o.time = 0.0
      o.timeout = 0.1
      o.enabled = true
      o.visible = true
      setmetatable(o, self)
      self.__index = self
      return o
end


function Button.setCallback(obj, callback, fn)
  obj["__"..callback] = fn
end



function Button.draw(obj)
  
  if obj.visible then
    --draw the "background"
    love.graphics.setColor(obj.color[obj.state.."_color"][1],obj.color[obj.state.."_color"][2],obj.color[obj.state.."_color"][3],obj.color[obj.state.."_color"][4])
    love.graphics.rectangle("fill",obj.x,obj.y,obj.width,obj.height)
    --draw the "border"
    love.graphics.setColor(obj.color["border_color"])
    love.graphics.rectangle("line",obj.x,obj.y,obj.width,obj.height)
    --draw the label
    love.graphics.setColor(obj.color["font_color"])
    love.graphics.print(obj.txt,obj.txt_pos.x,obj.txt_pos.y)
  end
end




function Button.update(obj,clicked,x,y,focused)
   local redraw = false
   local old =obj.state 
   
   local time = love.timer.getDelta()

   if (obj.x < x) and (obj.y< y) and (obj.x+obj.width > x) and obj.y+obj.height > y and obj.enabled then
      --it is in rectangle so hover or click!!!
      if focused == 0 or focused == obj.id then
        focused = obj.id
        obj.time = obj.time +time
        
        obj.state = clicked  and"clicked" or "hover"
        if obj.time >0.2 and clicked then 
          t = clicked and obj.__onClick(obj.id,obj.name) or "nope"
          obj.time = 0
        end
      end
   else
     if focused == obj.id then focused = 0 end
       obj.state = "default" 
     
   end
   redraw = (old== obj.state) and redraw or true 
   return focused, redraw
end

return Button
