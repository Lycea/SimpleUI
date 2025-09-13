local layer_adder = ___simple_ui_base_class:extend()

function layer_adder:AddVlayout(width, height, x, y)
  local id         = self:id() --#components.buttons +#components.slider  +1
  local temp       = {}

  temp.id          = id

  temp.color       = self:settings().button
  temp.ClickEvent  = self.components.ClickEvent

  local tmp_layout = self.layouts.vertical(temp)   --- @type Slider
  self:set_pos(x,y)
  self:set_size(width,height)

  self:add_component(tmp_layout, id)

  self:redraw()

  self:increase_id()
  return id
end

function layer_adder:AddHLayout(width, height, x, y)
  local id         = self:id() --#components.buttons +#components.slider  +1
  local temp       = {}

  temp.id          = id

  temp.color       = self:settings().button
  temp.ClickEvent  = self.components.ClickEvent

  local tmp_layout = self.controls.layouts.horizontal(temp) --- @type Slider

  self:add_component(tmp_layout, id)

  self:redraw()

  self:increase_id()
  return id
end

function layer_adder:AddGridlayout(width, height, x, y)

  love.window.close()

  local id         = self:id() --#components.buttons +#components.slider  +1
  local temp       = {}

  temp.id          = id

  temp.color       = self:settings().button
  temp.ClickEvent  = self.components.ClickEvent

  local tmp_layout = self.layouts.grid(temp) --- @type Slider

  self:set_pos(x, y)
  self:set_size(width,height)

  self:add_component(tmp_layout, id)

  self:redraw()

  self:increase_id()
  return id
end

return layer_adder
