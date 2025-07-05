 local  ToggleButton = {}
 
 function ToggleButton.setCallback(obj, callback, fn)
  obj["__"..callback] = fn
end


 function ToggleButton:new (o)
      o = o or {}   -- create object if user does not provide one
      o.name = "ToggleButton"
      o.time = 5
      
      --set the box a bit below the actual position ...
      --TODO: make dependant on the font height!
      o.box = {}
      o.box.x = o.x 
      o.box.y = o.y 
      o.box.w = o.w
      o.box.h = o.h
      
      o.txt_pos = o.box.x + 25
      if not o.__onClick then o.__onClick = function () end end
      setmetatable(o, self)
      self.__index = self
      
      return o
end


local function check(o)
    love.graphics.setColor(o.color["toggled_color"])
    local color_state = "toggled_color"

    love.graphics.setColor(o.color[color_state][1], o.color[color_state][2],
                           o.color[color_state][3], o.color[color_state][4])
    love.graphics.rectangle("fill",o.box.x,o.box.y,o.box.w,o.box.h)

    love.graphics.setLineWidth(1)

end

local function uncheck(o)
    
end

function ToggleButton.GetValue(obj)
  return obj.checked
end




function ToggleButton.draw(obj)
  
  if obj.visible then

    t = obj.checked and check(obj) or uncheck(obj)

    --draw the "background" ( for the box)
    love.graphics.setColor(obj.color[obj.state .. "_color"][1], obj.color[obj.state .. "_color"][2],
                           obj.color[obj.state .. "_color"][3], obj.color[obj.state .. "_color"][4])
    love.graphics.rectangle("fill", obj.box.x, obj.box.y, obj.box.w, obj.box.h)

    --draw the "border"
    love.graphics.setColor(obj.color["border_color"])
    love.graphics.rectangle("line", obj.box.x, obj.box.y, obj.box.w, obj.box.h)
    if obj.checked then
      love.graphics.rectangle("line", obj.box.x + 2, obj.box.y + 2, obj.box.w - 4, obj.box.h - 4)
    end

    --draw the label
    love.graphics.setColor(obj.color["font_color"])
    love.graphics.print(obj.txt, obj.box.x +5 , obj.box.y +obj.box.h/2 - obj.color.font:getHeight()/2  )
  end
end




function ToggleButton.update(obj,clicked,x,y,focused)
   local redraw = false
   local old =obj.state 
   
   local time = love.timer.getDelta()
   
   
   --check if the mouse is in the clickable region
   if (obj.box.x < x) and (obj.box.y< y) and (obj.box.x+obj.box.w > x) and obj.box.y+obj.box.h > y and obj.visible then
      --it is in rectangle so hover or click!!!
      if focused == 0 or focused == obj.id then
        focused = obj.id
        obj.state = clicked  and"clicked" or "hover"
        obj.time = obj.time +time
        
        --check if long enough time has passed since last click 
        if obj.time >0.2 and clicked then 
            obj.checked = not obj.checked
            t = clicked and obj.__onClick(obj.id,obj.name, obj.checked) or "nope"
            
            obj.time = 0
        end
      end
   else
     --if not in the rectangle reset the state
     if focused == obj.id then focused = 0 end 
       obj.state = "default" 
     
   end
   redraw = (old== obj.state) and redraw or true 
   return focused, redraw
end

return ToggleButton
