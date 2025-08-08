print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("Window.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)

--- @module "__base_component"
local base_ctrl = require(BASE .. "base_classes.__base_component_handler")

local base_component = require(BASE .. "base_classes.__base_component")


--- !doctype module
--- @class Window : base_component
local Window = base_ctrl:extend()
Window:implement(base_component)
Window:implement(require(BASE .. "interfaces.component_creator"))
local s = Window

--------------------------------
--- Creation helpers


function Window:add_component(cmp_, id)

  --if we don't use the base window coordinates we need
  --to recalculate the position of the control to inside the window
  if self.options.base_window_coordinates == false then
    --is set pos available for component ?
    if cmp_.set_pos == nil then
      print("component of type :" .. cmp_.name .. " : has no pos function,not resizable")

      cmp_.x = cmp_.x + self.x + self.margin
      cmp_.y = cmp_.y + self.y + self.margin

    else
      cmp_:set_pos(cmp_.x + self.x + self.margin,
                   cmp_.y + self.y + self.margin)
    end
  end

  self.super.add_component(self,cmp_,id)
end


---------------------------------
--- Base functions


function Window:new(o)
    self.super.new(self)

    o = o or {} -- create object if user does not provide one

    print("creating window")

    self.name = "Window"

    self.state = "default"
    self.visible = true
    -- initing some defaults

    self.height = 50
    self.width = 50

    self.x = 0
    self.y = 0

    self.margin = 0

    self.components = {}
    self.color = self:settings().button
    self.options = {
      enable_titlebar = true,
      enable_resize = nil,
      has_background = false,
      base_window_coordinates = false
    }

    self.__drag_obj = self:GetObject(self:AddDragable(self.x, self.y - 10, self.width, 10))
    
    self:init_from_list()

    self.has_backround = false
    
end


function Window:setCallback( callback, fn)
  self["__"..callback] = fn
end

function Window:set_size(width, height)
    self.width = width
    self.height = height

    self.__drag_obj:set_size(width, 10)
end

function Window:set_pos(x, y)
  self.x = x
  self.y = y

  self.__drag_obj:set_pos(x,y-10)
end

function Window:draw()

  if self.visible then
        --draw the "background"
        love.graphics.setColor(self.color[self.state.."_color"])
        love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
        --draw the "border"
        love.graphics.setColor(self.color["border_color"])
        love.graphics.rectangle("line",self.x,self.y,self.width,self.height)
  end


  if self:get_redraw() then
    for _, i in pairs(self.component_ids) do
      if self.components[i] then
        self.components[i]:draw()
      end
    end
  end

end



function Window:update(clicked,x,y,focused)
  local obj = self
  local redraw = false
  local old =obj.state 
  self:rectangle()

   -- if obj:in_area(self.rect_area,{x=x,y=y} ) then
   --  --it is in rectangle so hover or click!!!
   --    if focused == 0 or focused == obj.id then
   --      focused = obj.id
   --    end

   -- else
   --   if focused == obj.id then focused = 0 end
   --   obj.state = "default" 
   -- end
   -- redraw = (old== obj.state) and redraw or true 

  self:check_components()

  self.prev_x = self.x
  self.prev_y = self.y

  self:set_pos(self.__drag_obj.x,self.__drag_obj.y+10)

  self:update_component_sizes()

  self.__drag_obj:set_pos(self.x,self.y -10)
  
  return self:focus()
end


--- @return Window
return Window
