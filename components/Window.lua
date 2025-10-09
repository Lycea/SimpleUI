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
---@class Window: BaseComponentHandler
local Window = base_ctrl:extend()
Window:implement(base_component)
Window:implement(require(BASE .. "interfaces.component_creator"))
Window:implement(require(BASE .. "interfaces.layout_creator"))
Window:implement(require(BASE .. "interfaces.groups"))

local s = Window

--------------------------------
--- Creation helpers


function Window:add_component(cmp_, id)

  if self.layout then
    self.layout:add_component(cmp_,id)
    return
  end

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
    print("------------")
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

    self.margin = 10

    self.components = {}
    self.color = self:settings().button
    self.options = {
      enable_titlebar = true,
      enable_resize = nil,
      has_background = false,
      base_window_coordinates = false
    }

    self.__drag_obj = self:GetObject(self:AddDragable(self.x, self.y - 10, self.width, 10))

    if not self.options.enable_titlebar then
      self.__drag_obj.visible = false
    end

    self.layout = nil
    self:init_from_list()

    self.has_backround = false
    
end


function Window:set_layout(layout)
  if self.controls.layouts[layout] == nil then
    print("layout "..layout.."does not exist, choose from :\n   horizontal\n  vertical")
    return
  end

  print("win info:",self.width,self.height,self.x,self.y)
  local lay = self.controls.layouts[layout]()
  lay:set_size(self.width - self.margin*2 ,self.height - self.margin*2)
  lay:set_pos(self.x + self.margin, self.y+self.margin)
  

  self.layout = lay
end

function Window:reset_layout()
  self.layout = nil
end

function Window:setCallback( callback, fn)
  self["__"..callback] = fn
end

function Window:SetSpecialCallback(id, fn, event_to_set)
  print("setting cb ....")
    if self.layout then
        self.layout:SetSpecialCallback(id, fn, event_to_set)
        return
    end

    self.super.SetSpecialCallback(self,id,fn,event_to_set)

end


function Window:set_size(width, height)
    self.width = width
    self.height = height

    self.__drag_obj:set_size(width, 10)

    if self.layout then
      self.layout:set_size(width - self.margin*2,
                           height- self.margin*2)
    end
end

function Window:set_pos(x, y)
  self.x = x
  self.y = y

  self.__drag_obj:set_pos(x,y-10)

  if self.layout then
    self.layout:set_pos(self.x + self.margin,
                        self.y + self.margin)
  end
end

function Window:draw()

  if self.visible then

    if self.options.has_background then
      --draw the "background"
      love.graphics.setColor(self.color[self.state .. "_color"])
      love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    --draw the "border"
    love.graphics.setColor(self.color["border_color"])
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)

    if self:get_redraw() then
      for _, i in pairs(self.component_ids) do
        if self.components[i] then
          self.components[i]:draw()
        end
      end
    end

    if self.layout then
      self.layout:draw()
    end

  end

end

function Window:enable_titlebar(enable)
    self.__drag_obj.visible = enable
  self:redraw()
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

  if self.layout then

    diff_x = self.x - self.prev_x
    diff_y = self.y - self.prev_y
    self.layout:set_pos(self.layout.x + diff_x, self.layout.y + diff_y)

    self.layout:update(clicked,x,y,focused)
  end

  self.__drag_obj:set_pos(self.x,self.y -10)
  
  return self:focus()
end


function Window:GetObject(id)
  if self.layout then
    return self.layout:GetObject(id)
  else
    return self.super.GetObject(self,id)
  end
  
end


--- @return Window
return Window
