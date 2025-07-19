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
end

function base_component:set_size(width,height)
  self.width = width
  self.height = height
end

function base_component:recalc_size()
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




return base_component
