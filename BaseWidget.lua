BASE = b(...)

local base_widget = require(BASE.."classic.classic"):extend()

function base_widget:new()

end

function base_widget:draw()
end

function base_widget:update(clicked,x,y,focused)
    return focused, false
end


function base_widget:__onClick()

end

function base_widget:check_rect(p1,p2)
    return (p1.x < p2.x) and (p1.y< p2.y) and (p1.x+p1.w > p2.x) and p1.y + p1.h > p2.y 
end

return base_widget