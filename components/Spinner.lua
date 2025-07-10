local Spinner = {}
 
local btn =nil

local btn_width = 20
local padding = 5


function Spinner.setCallback(obj, callback, fn)
    obj["__"..callback] = fn
  end

--setup helper to know what the btn class is ...
function Spinner.set_btn(b)
    btn = b
end

function Spinner.inc_index(o)
    o.idx =  o.idx == #o.items and 1 or o.idx+1
end

function Spinner.dec_index(o)
    o.idx =  o.idx == 1 and #o.items  or o.idx-1
end

function Spinner.inc(o)
    o.idx = o.idx == o.max and o.max or o.idx+1
end

function Spinner.dec(o)
    o.idx = o.idx == o.min and o.min or o.idx-1
end

 
function Spinner:new (o)
     o = o or {}   -- create object if user does not provide one
     o.name = "Spinner"
     o.idx  = 1
     o.numbers = o.numbers or false


    btn_left_info  = {
        id = 0,
        txt = "<",
        x = o.x,
        y = o.y,
        width = btn_width,
        height = o.height,
        txt_pos = {  
            x =o.x + padding,
            y =o.y   },
        state = "default",
        visible = true,
        color = o.color,
        __onClick = function () 
            print("left_clicked")
            if o.numbers ==true then
                o:dec()
            else
                o:dec_index()
            end
          end
    }

    btn_right_info = {
        id = 1,
        txt = ">",
        x = o.x + btn_width +padding + o.width + padding,
        y = o.y,
        width = btn_width,
        height = o.height,
        txt_pos = {  
            x =(o.x + btn_width +padding + o.width + padding) + padding,
            y =o.y  },
        state = "default",
        visible = true,
        color = o.color,
        __onClick = function () 
            print("right_clicked")
            if o.numbers ==true then
                o:inc()
            else
                o:inc_index()
            end
          end
    }

     o.btn_left  = btn:new(btn_left_info)
     o.btn_right = btn:new(btn_right_info)


     setmetatable(o, self)
     self.__index = self
     return o
end




function Spinner.draw(obj)
 
    obj.btn_left:draw()
    obj.btn_right:draw()

    if obj.visible then
        love.graphics.print( obj.numbers == true and obj.idx  or  obj.items[obj.idx],obj.x + btn_width +padding, obj.y)
    end

 --if obj.visible then
   --draw the "background"
 --  love.graphics.setColor(obj.color[obj.state.."_color"][1],obj.color[obj.state.."_color"][2],obj.color[obj.state.."_color"][3],obj.color[obj.state.."_color"][4])
 --  love.graphics.rectangle("fill",obj.x,obj.y,obj.width,obj.height)
   --draw the "border"
 --  love.graphics.setColor(obj.color["border_color"])
 --  love.graphics.rectangle("line",obj.x,obj.y,obj.width,obj.height)
   --draw the label
 --  love.graphics.setColor(obj.color["font_color"])
 --  love.graphics.print(obj.txt,obj.txt_pos.x,obj.txt_pos.y)
 --end
end



function Spinner.GetValue(obj)
    return  obj.numbers ==true and obj.idx or obj.items[obj.idx]    
end

function Spinner.SetVisibility(o, visibility)
    o.visible = visibility
    o.btn_left.visible = visibility
    o.btn_right.visible = visibility
end


function Spinner.update(obj,clicked,x,y,focused)
    local focus, redraw = false,false
    focus , redraw =  obj.btn_left:update(clicked,x,y,focused)

    new_focus, new_redraw = obj.btn_right:update(clicked,x,y,focused)

    if new_focus == true then  focus = new_focus end
    if new_redraw == true then  redraw = new_redraw end

    return focused , redraw


end

return Spinner
