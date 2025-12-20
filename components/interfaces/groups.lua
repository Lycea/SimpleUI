
local group_interface = ___simple_ui_base_class:extend()



function group_interface:RemoveGroup(name)
  self.groups[name] = nil
end




-----------------------
-- component groups
function group_interface:AddGroup(tab_ids, name, visibility)
  if self.groups == nil then
    self.groups = {}
  end

  self.groups[name] = {}
  self.groups[name].ids = tab_ids
  self.groups[name].__visible = visibility

  if visibility == false then
    self:SetGroupVisible(name, false)
  end
end

function group_interface:SetGroupVisible(name, visible)
  --iterate over ids
  self.groups[name].__visible = visible
  for k, v in pairs(self.groups[name].ids) do
    self:SetVisibiliti(v, visible)
  end
end

function group_interface:toggle_group_visibility(name)
  self:SetGroupVisible(name, not self.groups[name].__visible)
end





----------------------
-- toggle group / option groups


function group_interface:set_toggle_group(id, group)
  self.components[id].toggle_group = group
end


function group_interface:update_toggles(enabled_id, group)
  for _, id in pairs(self.toggle_groups[group].ids) do
    if id ~= enabled_id then
      --      print(id,enabled_id)

      --components[id].checked = false
      self.components[id]:toggle(false)
      self:redraw()
    end
  end
end

function group_interface:AddOptionGroup(tab_ids, name, allow_non_selected)
  if self.toggle_groups == nil then
    print("add toggle group obj ...")
    self.toggle_groups = {}
  end
  self.toggle_groups[name] = {}
  self.toggle_groups[name].ids = tab_ids
  self.toggle_groups[name].allow_non_selected = allow_non_selected or true

  for _, id in pairs(tab_ids) do
    self:set_toggle_group(id, name)
  end
end


function group_interface:AddToOptionGroup(id, name)
    table.insert(self.toggle_groups[name].ids, id)
  self:set_toggle_group(id, name)
end

return group_interface
