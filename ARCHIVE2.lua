do
  local function lnsTrimText(text)
    return tostring(text or ""):lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
  end

  local function lnsBotNameOk()
    local botWindow = modules and modules.game_bot and modules.game_bot.botWindow
    if not botWindow or type(botWindow.getText) ~= "function" then
      return false
    end

    local ok, text = pcall(function()
      return botWindow:getText()
    end)

    if not ok then
      return false
    end

    return lnsTrimText(text) == "lns custom"
  end

  local function lnsStorageOk()
    return type(storage) == "table"
      and type(storage.extras) == "table"
      and storage.extras.skinMonsters == true
  end

  if not lnsBotNameOk() or not lnsStorageOk() then
    return
  end
end

local function lnsRunBlock(name, fn)
  local ok, err = pcall(fn)
  if not ok then
    warn("[LNS FAIL] " .. tostring(name) .. ": " .. tostring(err))
  end
end

lnsRunBlock("SWAPING", function()
storage = storage or {}
storage.LNSEqManagerGlobal = storage.LNSEqManagerGlobal or {}

local eqManagerStorage = storage.LNSEqManagerGlobal

local function saveEqManagerGlobal()
  storage.LNSEqManagerGlobal = eqManagerStorage
end

local function saveEqManagerChar()
  saveEqManagerGlobal()
end

UI.Separator()

local switchEqManager = "eqManagerButton"
eqManagerStorage[switchEqManager] = eqManagerStorage[switchEqManager] or { enabled = false }

eqManagerButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: EQ Manager
    height: 18
    color: white
  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])
eqManagerButton:setId(switchEqManager)
eqManagerButton.title:setOn(eqManagerStorage[switchEqManager].enabled)
eqManagerButton.title.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  eqManagerStorage[switchEqManager].enabled = state
  saveEqManagerChar()
end

equipInterface = setupUI([=[
EQPanel < Panel
  size: 160 230
  padding-left: 10
  padding-right: 10
  padding-bottom: 10

  BotItem
    id: head
    image-source: /images/game/slots/head
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: 10
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: body
    image-source: /images/game/slots/body
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: legs
    image-source: /images/game/slots/legs
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: feet
    image-source: /images/game/slots/feet
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: neck
    image-source: /images/game/slots/neck
    anchors.top: head.top
    margin-top: 13
    anchors.right: head.left
    margin-right: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: left-hand
    image-source: /images/game/slots/left-hand
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: finger
    image-source: /images/game/slots/finger
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: right-hand
    image-source: /images/game/slots/right-hand
    anchors.left: body.right
    margin-left: 5
    anchors.top: left-hand.top
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: ammo
    image-source: /images/game/slots/ammo
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

MainWindow
  id: mainPanel
  size: 453 420
  text: Panel EQ Manager
  margin-top: -50

  Panel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    size: 190 225
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-left: -4
    margin-right: -4

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Settings EQ
      margin-top: 2

  EQPanel
    id: eqConfig
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 50
    margin-bottom: 30
    anchors.bottom: prev.bottom

  TextEdit
    id: nameConfig
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: -25
    margin-left: 6
    margin-right: 6
    placeholder: Profile Name

  Button
    id: cloneEq
    anchors.top: prev.bottom
    anchors.right: prev.right
    size: 35 18
    text: Clone
    margin-top: 2
    tooltip: Clone Current Equipments

  Panel
    id: panelRules
    anchors.top: infolist1.top
    anchors.left: infolist1.right
    margin-right: -8
    size: 230 225
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-left: 10

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Rules to Equip
      margin-top: 2

    CheckBox
      id: hppercent
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 10
      margin-left: 10
      text: HP% below:
      $checked:
        color: #3CB371
        image-color: #3CB371
        
    SpinBox
      id: qtdHppercent
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: mppercent
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: MP% below:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: qtdMppercent
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: safe
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: Safe (Anti-red)
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: targetisPlayer
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 8
      margin-left: 10
      text: Target is Player
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: creatures
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 8
      margin-left: 10
      text: Amount Creatures:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: qtdCreatures
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 10
      text-align: center

    CheckBox
      id: noTarget
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: No Combat
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: nameCreature
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 9
      margin-left: 10
      text: Target Name
      $checked:
        color: #3CB371
        image-color: #3CB371

    Button
      id: listNameCreature
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      text: List

    CheckBox
      id: distance
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 6
      margin-left: 10
      text: Distance:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: distsqm
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: setPrincipal
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-left: 10
      text: Default Set
      margin-bottom: 10
      $checked:
        color: #3CB371
        image-color: #3CB371

  Panel
    id: flatp
    anchors.top: eqConfig.bottom
    anchors.left: eqConfig.left
    anchors.right: panelRules.right
    anchors.bottom: parent.bottom
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-top: 35
    margin-left: 1
    margin-right: 60

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: List Equipment Manager
      margin-top: 2

  TextList
    id: listSettingsEQ
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: prev.bottom
    margin: 5
    margin-top: 20
    margin-right: 17
    height: 120
    opacity: 0.95
    vertical-scrollbar: panelEQListScroll

  VerticalScrollBar
    id: panelEQListScroll
    anchors.top: listSettingsEQ.top
    anchors.bottom: listSettingsEQ.bottom
    anchors.left: listSettingsEQ.right
    width: 13
    step: 18
    pixels-scroll: true

  Button
    id: adicionar
    anchors.top: flatp.top
    anchors.left: flatp.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 5
    height: 73
    text: Add Settings
    text-wrap: true

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: flatp.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 5
    height: 73
    margin-top: 4
    text: Close


]=], g_ui.getRootWidget())
equipInterface:hide()

if modules._G.g_app.isMobile() then
  equipInterface:setSize("453 440")
end

equipInterface.closePanel.onClick = function()
  equipInterface:hide()
end
eqManagerButton.settings.onClick = function()
  equipInterface:show()
end

local function W(parent, id)
  if not parent then return nil end
  return (parent.getChildById and parent:getChildById(id)) or
         (parent.recursiveGetChildById and parent:recursiveGetChildById(id))
end

local function trim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function clearChildren(w)
  if not w then return end
  local ch = w:getChildren()
  for i = #ch, 1, -1 do
    ch[i]:destroy()
  end
end

local SLOTS = { "head","neck","body","left-hand","right-hand","legs","feet","finger","ammo" }

eqManagerStorage.eqManagerProfiles = eqManagerStorage.eqManagerProfiles or {}
local eqProfiles = eqManagerStorage.eqManagerProfiles
local editingEqIndex = nil

local targetListPanelName = "eqManagerTargetNames"
eqManagerStorage[targetListPanelName] = eqManagerStorage[targetListPanelName] or { names = {} }

local eqRowTemplate = [[
UIWidget
  height: 24
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 0
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    margin-top: 0
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    width: 20
    height: 20
    text: ""
    image-source: /images/ui/button_rounded

  Label
    id: profileName
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    text-auto-resize: true
    color: orange
    text: ""
    font: verdana-11px-rounded

  Panel
    id: itemsPanel
    anchors.left: profileName.right
    anchors.right: remove.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    margin-left: 4
    margin-top: -5
    margin-right: 4

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 20
    height: 20
    margin-right: 4
    text: X
    font: verdana-11px-rounded
    color: white
    $hover:
      image-color: red
      color: #ffd0d0
]]

local targetNameRowTemplate = [[
UIWidget
  height: 18
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  Label
    id: creatureName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-11px-rounded
    color: white
    text: ""

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: X
    color: #FF4040
    image-source: /images/ui/button_rounded
    image-color: #363636
]]

targetNameListWindow = setupUI([[
MainWindow
  id: mainPanel
  size: 250 315
  text: Target Name List
  anchors.centerIn: parent
  margin-top: -50

  Panel
    id: panelList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 225
    margin: -6
    margin-bottom: 3
    margin-top: 1
    image-source: /images/ui/miniwindow
    image-border: 20

  TextList
    id: nameList
    anchors.top: panelList.top
    anchors.left: panelList.left
    anchors.right: panelList.right
    anchors.bottom: panelList.bottom
    margin-top: 21
    margin-left: 5
    margin-right: 17
    margin-bottom: 5
    vertical-scrollbar: nameListScroll

  VerticalScrollBar
    id: nameListScroll
    anchors.top: nameList.top
    anchors.bottom: nameList.bottom
    anchors.left: nameList.right
    width: 13
    step: 18
    pixels-scroll: true

  TextEdit
    id: inputName
    anchors.left: panelList.left
    anchors.right: addName.left
    anchors.bottom: closePanel.top
    margin-right: 3
    margin-bottom: 4
    height: 20
    placeholder: Creature name

  Button
    id: addName
    anchors.right: panelList.right
    anchors.bottom: closePanel.top
    margin-bottom: 4
    size: 35 20
    text: +

  Button
    id: closePanel
    anchors.left: panelList.left
    anchors.right: panelList.right
    anchors.bottom: parent.bottom
    height: 22
    text: Close
]], g_ui.getRootWidget())
targetNameListWindow:hide()

local function copyList(t)
  local out = {}
  for i, v in ipairs(t or {}) do out[i] = v end
  return out
end

local function getItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and id and id > 0 then return id end
  end
  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and id and id > 0 then return id end
    end
  end
  return 0
end

local function setBotItem(widget, itemId)
  itemId = tonumber(itemId) or 0
  if not widget then return end

  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem and Item and Item.create then
    if itemId > 0 then
      widget:setItem(Item.create(itemId, 1))
    else
      pcall(function() widget:setItem(nil) end)
    end
  end

  if widget.setOn then
    widget:setOn(itemId > 0)
  end
end

local function bindBotItemVisual(widget)
  if not widget then return end

  local old = widget.onItemChange
  widget.onItemChange = function(self, ...)
    if self and self.setOn then
      self:setOn(getItemId(self) > 0)
    end
    if old then old(self, ...) end
  end

  if widget.setOn then
    widget:setOn(getItemId(widget) > 0)
  end
end

local function bindEqPanelVisuals()
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end
  for _, slot in ipairs(SLOTS) do
    local w = W(eqConfig, slot)
    if w then bindBotItemVisual(w) end
  end
end

local function normalizeTargetName(name)
  return trim(name):lower()
end

local function targetNameExists(name)
  local n = normalizeTargetName(name)
  for _, v in ipairs(eqManagerStorage[targetListPanelName].names or {}) do
    if normalizeTargetName(v) == n then
      return true
    end
  end
  return false
end

local function removeTargetName(name)
  local n = normalizeTargetName(name)
  local newList = {}
  for _, v in ipairs(eqManagerStorage[targetListPanelName].names or {}) do
    if normalizeTargetName(v) ~= n then
      table.insert(newList, v)
    end
  end
  eqManagerStorage[targetListPanelName].names = newList
  saveEqManagerChar()
end

local function refreshTargetNameList()
  local list = W(targetNameListWindow, "nameList")
  if not list then return end
  clearChildren(list)

  for _, name in ipairs(eqManagerStorage[targetListPanelName].names or {}) do
    local row = setupUI(targetNameRowTemplate, list)
    row.creatureName:setText(name)
    row.remove.onClick = function()
      removeTargetName(name)
      refreshTargetNameList()
    end
  end
end

local function addTargetNameFromInput()
  local input = W(targetNameListWindow, "inputName")
  if not input then return end

  local name = trim(input:getText())
  if name == "" then return end
  if targetNameExists(name) then
    input:setText("")
    return
  end

  table.insert(eqManagerStorage[targetListPanelName].names, name)
  saveEqManagerChar()
  input:setText("")
  refreshTargetNameList()
end

local function collectItems()
  local eqConfig = W(equipInterface, "eqConfig")
  local items = {}
  local hasAny = false

  if not eqConfig then return items, false end

  for _, slot in ipairs(SLOTS) do
    local id = getItemId(W(eqConfig, slot))
    if id > 0 then
      items[slot] = id
      hasAny = true
    end
  end

  return items, hasAny
end

local function applyItems(items)
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end

  items = items or {}
  for _, slot in ipairs(SLOTS) do
    setBotItem(W(eqConfig, slot), tonumber(items[slot]) or 0)
  end
end

local function collectRules()
  local function checked(id)
    local w = W(equipInterface, id)
    return w and w:isChecked() or false
  end

  local function spin(id, def)
    local w = W(equipInterface, id)
    return w and w:getValue() or def
  end

  return {
    hppercent = checked("hppercent"),
    qtdHppercent = spin("qtdHppercent", 1),
    mppercent = checked("mppercent"),
    qtdMppercent = spin("qtdMppercent", 1),
    safe = checked("safe"),
    targetisPlayer = checked("targetisPlayer"),
    creatures = checked("creatures"),
    qtdCreatures = spin("qtdCreatures", 1),
    noTarget = checked("noTarget"),
    nameCreature = checked("nameCreature"),
    distance = checked("distance"),
    distsqm = spin("distsqm", 1),
    setPrincipal = checked("setPrincipal"),
    targetNames = copyList(eqManagerStorage[targetListPanelName].names or {})
  }
end

local function applyRules(rules)
  rules = rules or {}

  local function setCheck(id, val)
    local w = W(equipInterface, id)
    if w then w:setChecked(val == true) end
  end

  local function setSpin(id, val)
    local w = W(equipInterface, id)
    if w then w:setValue(tonumber(val) or 1) end
  end

  setCheck("hppercent", rules.hppercent)
  setSpin("qtdHppercent", rules.qtdHppercent)
  setCheck("mppercent", rules.mppercent)
  setCheck("safe", rules.safe)
  setSpin("qtdMppercent", rules.qtdMppercent)
  setCheck("targetisPlayer", rules.targetisPlayer)
  setCheck("creatures", rules.creatures)
  setSpin("qtdCreatures", rules.qtdCreatures)
  setCheck("noTarget", rules.noTarget)
  setCheck("nameCreature", rules.nameCreature)
  setCheck("distance", rules.distance)
  setSpin("distsqm", rules.distsqm)
  setCheck("setPrincipal", rules.setPrincipal)

  eqManagerStorage[targetListPanelName].names = copyList(rules.targetNames or {})
  refreshTargetNameList()
  saveEqManagerChar()
end

local function resetForm()
  local nameConfig = W(equipInterface, "nameConfig")
  if nameConfig then nameConfig:setText("") end

  applyItems({})
  applyRules({
    hppercent=false, qtdHppercent=1,
    mppercent=false, qtdMppercent=1,
    targetisPlayer=false,
    creatures=false, qtdCreatures=1,
    noTarget=false,
    nameCreature=false,
    distance=false, distsqm=1,
    setPrincipal=false,
    targetNames={}
  })

  editingEqIndex = nil
  local addButton = W(equipInterface, "adicionar")
  if addButton then
    addButton:setText("Add\nSettings")
  end
end

local function findProfileByName(name, ignoreIndex)
  name = trim(name):lower()
  if name == "" then return nil end

  for i, profile in ipairs(eqProfiles) do
    if i ~= ignoreIndex and trim(profile.name):lower() == name then
      return i
    end
  end
  return nil
end

local function getRowName(profile)
  return (trim(profile.name) ~= "" and profile.name or "Profile") .. ":"
end

local function orderedItemIds(items)
  local out = {}
  items = items or {}
  for _, slot in ipairs(SLOTS) do
    local id = tonumber(items[slot]) or 0
    if id > 0 then table.insert(out, id) end
  end
  return out
end

local function setupEqDragAndDrop(row)
  row.onDragEnter = function(self, mousePos)
    self:setOpacity(0.4)
    return true
  end

  row.onDragLeave = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
  end

  row.onDrop = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
    if droppedWidget and droppedWidget.setOpacity then
      droppedWidget:setOpacity(1.0)
    end

    local parent = self:getParent()
    if not parent then return true end

    local children = parent:getChildren()
    local fromIndex, toIndex = 0, 0

    for i, child in ipairs(children) do
      if child == droppedWidget then fromIndex = i end
      if child == self then toIndex = i end
    end

    if fromIndex > 0 and toIndex > 0 and fromIndex ~= toIndex then
      local moved = table.remove(eqProfiles, fromIndex)
      table.insert(eqProfiles, toIndex, moved)

      if editingEqIndex then
        if editingEqIndex == fromIndex then
          editingEqIndex = toIndex
        elseif fromIndex < editingEqIndex and toIndex >= editingEqIndex then
          editingEqIndex = editingEqIndex - 1
        elseif fromIndex > editingEqIndex and toIndex <= editingEqIndex then
          editingEqIndex = editingEqIndex + 1
        end
      end

      saveEqManagerChar()
      rebuildEqManagerList()
    end

    return true
  end
end

local function getEquippedSlotItemId(slotConst)
  local item = getSlot(slotConst)
  return item and item:getId() or 0
end

local function cloneCurrentEquip()
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end

  setBotItem(W(eqConfig, "head"), getEquippedSlotItemId(SlotHead))
  setBotItem(W(eqConfig, "body"), getEquippedSlotItemId(SlotBody))
  setBotItem(W(eqConfig, "legs"), getEquippedSlotItemId(SlotLeg))
  setBotItem(W(eqConfig, "feet"), getEquippedSlotItemId(SlotFeet))
  setBotItem(W(eqConfig, "neck"), getEquippedSlotItemId(SlotNeck))
  setBotItem(W(eqConfig, "left-hand"), getEquippedSlotItemId(SlotLeft))
  setBotItem(W(eqConfig, "right-hand"), getEquippedSlotItemId(SlotRight))
  setBotItem(W(eqConfig, "finger"), getEquippedSlotItemId(SlotFinger))
  setBotItem(W(eqConfig, "ammo"), getEquippedSlotItemId(SlotAmmo))
end

function rebuildEqManagerList()
  local list = W(equipInterface, "listSettingsEQ")
  if not list then return end

  clearChildren(list)

  for index, profile in ipairs(eqProfiles) do
    local row = setupUI(eqRowTemplate, list)
    setupEqDragAndDrop(row)

    row.enabled:setOn(profile.enabled ~= false)
    row.enabled.onClick = function(widget)
      local state = not widget:isOn()
      widget:setOn(state)
      if eqProfiles[index] then
        eqProfiles[index].enabled = state
        saveEqManagerChar()
      end
    end

    row.profileName:setText(getRowName(profile))
    row.profileName:setColor(profile.rules and profile.rules.setPrincipal and "#00FF66" or "orange")

    local items = orderedItemIds(profile.items)
    for i, itemId in ipairs(items) do
      local item = setupUI(string.format([[
UIItem
  id: item%d
  size: 20 20
  focusable: false
  phantom: true
  anchors.left: parent.left
  anchors.top: parent.top
  margin-left: %d
  margin-top: 9
]], i, (i - 1) * 22), row.itemsPanel)
      setBotItem(item, itemId)
    end

    row.remove.onClick = function()
      table.remove(eqProfiles, index)
      if editingEqIndex == index then
        resetForm()
      elseif editingEqIndex and editingEqIndex > index then
        editingEqIndex = editingEqIndex - 1
      end
      saveEqManagerChar()
      rebuildEqManagerList()
    end

    row.onDoubleClick = function()
      local nameConfig = W(equipInterface, "nameConfig")
      if nameConfig then nameConfig:setText(profile.name or "") end
      applyItems(profile.items)
      applyRules(profile.rules)
      editingEqIndex = index
    
    local addButton = W(equipInterface, "adicionar")
      if addButton then
        addButton:setText("Add\nSettings")
      end
    end
  end
end

local function saveProfile()
  local nameConfig = W(equipInterface, "nameConfig")
  local profileName = trim(nameConfig and nameConfig:getText() or "")

  if profileName == "" then
    profileName = "Profile " .. tostring(editingEqIndex or (#eqProfiles + 1))
  end

  if findProfileByName(profileName, editingEqIndex) then
    return warn("Já existe um profile com esse nome.")
  end

  local items, hasAny = collectItems()
  if not hasAny then
    return warn("Selecione pelo menos 1 item no Settings EQ.")
  end

  local rules = collectRules()

  if #eqProfiles == 0 and editingEqIndex == nil and not rules.setPrincipal then
    return warn("Configure primeiro um Default Set.")
  end

  if rules.setPrincipal then
    for i = 1, #eqProfiles do
      eqProfiles[i].rules = eqProfiles[i].rules or {}
      eqProfiles[i].rules.setPrincipal = false
    end
  end

  local oldEnabled = true
  if editingEqIndex and eqProfiles[editingEqIndex] then
    oldEnabled = eqProfiles[editingEqIndex].enabled ~= false
  end

  local data = {
    enabled = oldEnabled,
    name = profileName,
    items = items,
    rules = rules
  }

  if editingEqIndex and eqProfiles[editingEqIndex] then
    eqProfiles[editingEqIndex].enabled = data.enabled
    eqProfiles[editingEqIndex].name = data.name
    eqProfiles[editingEqIndex].items = data.items
    eqProfiles[editingEqIndex].rules = data.rules
  else
    table.insert(eqProfiles, data)
  end

  eqManagerStorage.eqManagerProfiles = eqProfiles
  saveEqManagerChar()

  rebuildEqManagerList()
  resetForm()
end

local addButton = W(equipInterface, "adicionar")
if addButton then
  addButton.onClick = saveProfile
end

local cloneButton = W(equipInterface, "cloneEq")
if cloneButton then
  cloneButton.onClick = function()
    cloneCurrentEquip()
  end
end

local listNameCreatureButton = W(equipInterface, "listNameCreature")
if listNameCreatureButton then
  listNameCreatureButton.onClick = function()
    refreshTargetNameList()
    targetNameListWindow:show()
    targetNameListWindow:raise()
    targetNameListWindow:focus()
  end
end

targetNameListWindow.addName.onClick = function()
  addTargetNameFromInput()
end

targetNameListWindow.closePanel.onClick = function()
  targetNameListWindow:hide()
end

targetNameListWindow.inputName.onKeyPress = function(widget, keyCode)
  if keyCode == KeyEnter or keyCode == KeyReturn then
    addTargetNameFromInput()
    return true
  end
  return false
end

bindEqPanelVisuals()
refreshTargetNameList()
rebuildEqManagerList()

-----------------------------
local EQM_SLOT_CONST = {
  ["head"] = SlotHead,
  ["neck"] = SlotNeck,
  ["body"] = SlotBody,
  ["left-hand"] = SlotLeft,
  ["right-hand"] = SlotRight,
  ["legs"] = SlotLeg,
  ["feet"] = SlotFeet,
  ["finger"] = SlotFinger,
  ["ammo"] = SlotAmmo
}

local EQM_EQUIP_ORDER = {
  "neck", "head", "body", "legs", "feet", "right-hand", "left-hand", "finger", "ammo"
}

local EQM_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local EQM_ACTION_DELAY = EQM_IS_OLD_CLIENT and 250 or 0
local eqmNextAction = 0

local function eqmFullTankIsOn()
  if type(isLnsFullTankActive) == "function" then
    return isLnsFullTankActive() == true
  end

  return lnsFullTankActive == true
end

local function eqmSkipFullTankSlot(part)
  return eqmFullTankIsOn() and (part == "neck" or part == "finger")
end
    
local function eqm_now()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function eqm_getSlotItem(slotConst)
  return getSlot(slotConst)
end

local function eqm_getSlotId(slotConst)
  local it = eqm_getSlotItem(slotConst)
  return it and it:getId() or 0
end

local function eqm_getContainersSafe()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function eqm_findVisibleItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, cont in pairs(eqm_getContainersSafe()) do
    for _, it in ipairs(cont:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function eqm_unequipSlot(slotConst)
  local item = eqm_getSlotItem(slotConst)
  if not item then return false end

  if EQM_IS_OLD_CLIENT then
    if moveToSlot then
      local ok = pcall(function()
        moveToSlot(item, SlotBack, item:getCount())
      end)
      if ok then return true end
    end
  end

  local ok = pcall(function()
    g_game.equipItemId(item:getId())
  end)
  return ok
end

local function eqm_equipToSlot(id, slotConst)
  id = tonumber(id) or 0
  if id <= 0 then return false end

  if not EQM_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(id, slotConst)
    end)
    if ok then return true end

    ok = pcall(function()
      g_game.equipItemId(id)
    end)
    return ok
  end

  local it = eqm_findVisibleItemById(id)
  if not it then return false end

  local ok = pcall(function()
    g_game.move(it, {x = 65535, y = slotConst, z = 0}, 1)
  end)
  return ok
end

local function eqm_isPlayer(creature)
  return creature and creature.isPlayer and creature:isPlayer() or false
end

local function eqm_isMonster(creature)
  return creature and creature.isMonster and creature:isMonster() or false
end

local function eqm_localPlayer()
  return g_game.getLocalPlayer and g_game.getLocalPlayer() or nil
end

local function eqm_getTarget()
  return g_game.getAttackingCreature and g_game.getAttackingCreature() or nil
end

local function eqm_hasTarget()
  return eqm_getTarget() ~= nil
end

local function eqm_nameInList(name, list)
  local n = trim(name):lower()
  if n == "" then return false end

  for _, v in ipairs(list or {}) do
    if trim(v):lower() == n then
      return true
    end
  end

  return false
end

local function eqm_countCreatures()
  local me = pos()
  if not me then return 0 end

  local count = 0
  for _, spec in ipairs(getSpectators() or {}) do
    if eqm_isMonster(spec) then
      local sPos = spec:getPosition()
      if sPos and sPos.z == me.z then
        count = count + 1
      end
    end
  end
  return count
end

local function eqm_isCreatureAttackingMe(creature, me)
  if not creature or not me or creature == me then return false end

  if creature.getTarget then
    local ok, t = pcall(function() return creature:getTarget() end)
    if ok and t then
      if type(t) == "number" and me.getId and t == me:getId() then
        return true
      end
      if t == me then
        return true
      end
    end
  end

  return false
end

local function eqm_ruleMatches(profile)
  if not profile or profile.enabled == false then return false end
  local rules = profile.rules or {}

  if rules.hppercent and hppercent() > (tonumber(rules.qtdHppercent) or 1) then
    return false
  end

  if rules.mppercent and manapercent() > (tonumber(rules.qtdMppercent) or 1) then
    return false
  end

  if rules.targetisPlayer then
    local target = eqm_getTarget()
    if not eqm_isPlayer(target) then
      return false
    end
  end

  if rules.creatures and eqm_countCreatures() < (tonumber(rules.qtdCreatures) or 1) then
    return false
  end

  if rules.noTarget and eqm_hasTarget() then
    return false
  end

  if rules.nameCreature then
    local target = eqm_getTarget()
    local targetName = target and target:getName() or ""
    if targetName == "" then
      return false
    end
    if not eqm_nameInList(targetName, rules.targetNames or {}) then
      return false
    end
  end

  if rules.safe then
    if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
      if LNS_HAS_UNSAFE_CONDITION() then
        return false
      end
    end
  end

  if rules.distance then
    local target = eqm_getTarget()
    if not target then
      return false
    end

    local tPos = target:getPosition()
    local pPos = pos()

    if not tPos or not pPos or tPos.z ~= pPos.z then
      return false
    end

    local dist = math.max(math.abs(tPos.x - pPos.x), math.abs(tPos.y - pPos.y))
    local maxDist = tonumber(rules.distsqm) or 1

    if dist > maxDist then
      return false
    end
  end

  return true
end

local function eqm_getDefaultProfile()
  for _, profile in ipairs(eqProfiles or {}) do
    if profile.enabled ~= false and profile.rules and profile.rules.setPrincipal then
      return profile
    end
  end
  return nil
end

local function eqm_buildResolvedItems(activeProfile)
  local resolved = {}
  local defaultProfile = eqm_getDefaultProfile()

  if defaultProfile and type(defaultProfile.items) == "table" then
    for _, slot in ipairs(EQM_EQUIP_ORDER) do
      local v = tonumber(defaultProfile.items[slot]) or 0
      if v > 0 then
        resolved[slot] = v
      end
    end
  end

  if activeProfile and type(activeProfile.items) == "table" then
    for _, slot in ipairs(EQM_EQUIP_ORDER) do
      local v = tonumber(activeProfile.items[slot]) or 0
      if v > 0 then
        resolved[slot] = v
      end
    end
  end

  return resolved
end

local function eqm_getMatchedProfileAndItems()
  for _, profile in ipairs(eqProfiles or {}) do
    if profile.enabled ~= false and not (profile.rules and profile.rules.setPrincipal) then
      if eqm_ruleMatches(profile) then
        return profile, eqm_buildResolvedItems(profile)
      end
    end
  end

  local defaultProfile = eqm_getDefaultProfile()
  if defaultProfile then
    return defaultProfile, eqm_buildResolvedItems(defaultProfile)
  end

  return nil, nil
end

local function eqm_prepareHands(resolvedItems)
  local wantLeft = tonumber(resolvedItems["left-hand"]) or 0
  local wantRight = tonumber(resolvedItems["right-hand"]) or 0

  -- slot nao configurado = NAO MEXE
  if wantLeft <= 0 and wantRight <= 0 then
    return false
  end

  local curLeft = eqm_getSlotId(SlotLeft)
  local curRight = eqm_getSlotId(SlotRight)

  -- se só configurou left-hand, não limpa right-hand
  if wantLeft > 0 and curLeft ~= wantLeft then
    -- só tira right se ele estiver bloqueando o left
    if curRight > 0 and curRight ~= wantRight and wantRight > 0 then
      if eqm_unequipSlot(SlotRight) then return true end
    end
  end

  -- se só configurou right-hand, não limpa left-hand
  if wantRight > 0 and curRight ~= wantRight then
    -- só tira left se ele estiver bloqueando o right
    if curLeft > 0 and curLeft ~= wantLeft and wantLeft > 0 then
      if eqm_unequipSlot(SlotLeft) then return true end
    end
  end

  return false
end

local function eqm_applyResolvedOldClient(resolvedItems)
  if not resolvedItems then return false end

  if eqm_prepareHands(resolvedItems) then
    return true
  end

  for _, part in ipairs(EQM_EQUIP_ORDER) do
    if not eqmSkipFullTankSlot(part) then
      local wantedId = tonumber(resolvedItems[part]) or 0

      -- slot nao configurado = nao mexe
      if wantedId > 0 then
        local slotConst = EQM_SLOT_CONST[part]
        local currentId = eqm_getSlotId(slotConst)

        if currentId ~= wantedId then
          if eqm_equipToSlot(wantedId, slotConst) then
            return true
          end
        end
      end
    end
  end

  return false
end

local function eqm_applyResolvedNewClient(resolvedItems)
  if not resolvedItems then return false end

  local changed = false

  for _, part in ipairs(EQM_EQUIP_ORDER) do
    if not eqmSkipFullTankSlot(part) then
      local wantedId = tonumber(resolvedItems[part]) or 0

      -- slot nao configurado = nao mexe
      if wantedId > 0 then
        local slotConst = EQM_SLOT_CONST[part]
        local currentId = eqm_getSlotId(slotConst)

        if currentId ~= wantedId then
          pcall(function()
            g_game.equipItemId(wantedId)
          end)

          changed = true
        end
      end
    end
  end

  return changed
end

macro(200, function()
  if not eqManagerStorage[switchEqManager] or eqManagerStorage[switchEqManager].enabled ~= true then return end
  if #eqProfiles == 0 then return end

  local t = eqm_now()
  if eqmNextAction > t then return end

  local profile, resolvedItems = eqm_getMatchedProfileAndItems()
  if not profile or not resolvedItems then return end

  local changed = false

  if EQM_IS_OLD_CLIENT then
    changed = eqm_applyResolvedOldClient(resolvedItems)
  else
    changed = eqm_applyResolvedNewClient(resolvedItems)
  end

  if changed then
    eqmNextAction = t + EQM_ACTION_DELAY
  end
end)


end)

lnsRunBlock("SWAP", function()
storage = storage or {}
storage.LNSSmartSwapGlobal = storage.LNSSmartSwapGlobal or {}

local smartSwapStorage = storage.LNSSmartSwapGlobal

local function saveSmartSwapGlobal()
  storage.LNSSmartSwapGlobal = smartSwapStorage
end

local function saveSmartSwapChar()
  saveSmartSwapGlobal()
end

setDefaultTab("Main")

local switchSwap = "swapButton"
smartSwapStorage[switchSwap] = smartSwapStorage[switchSwap] or { enabled = false }

swapButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Smart Swap
    height: 18
    color: white
  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])
swapButton:setId(switchSwap)
swapButton.title:setOn(smartSwapStorage[switchSwap].enabled)

swapButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  smartSwapStorage[switchSwap].enabled = newState
  saveSmartSwapChar()
end

panelSwap = setupUI([[  
RingConfig < Panel
  height: 244
  margin-top: 0
  phantom: false

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: "Normal Ring ID:"
    text-auto-resize: true

  BotItem
    id: ringNormal
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title2
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left:3
    text: Custom Ring ID:
    text-auto-resize: true

  BotItem
    id: ringCustom
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title3
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Custom Equipped ID:
    text-auto-resize: true

  BotItem
    id: ringCustom2
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Hp% to Equip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    margin-left: 3
    text: Hp% to Unequip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpUnequip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  BotSwitch
    id: ativador
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 5
    margin-left: 3
    margin-right: 5
    text: Smart Swap

AmuletConfig < Panel
  height: 244
  margin-top: 0
  phantom: false

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: "Normal Amulet ID:"
    text-auto-resize: true

  BotItem
    id: amuletNormal
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title2
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left:3
    text: Custom Amulet ID:
    text-auto-resize: true

  BotItem
    id: amuletCustom
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title3
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Custom Equipped ID:
    text-auto-resize: true

  BotItem
    id: amuletCustom2
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Hp% to Equip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    margin-left: 3
    text: Hp% to Unequip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpUnequip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100
    
  BotSwitch
    id: ativador
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 5
    margin-left: 3
    margin-right: 5
    text: Smart Swap

EQPanel < Panel
  size: 155 190
  padding-left: 10
  padding-right: 10
  image-source: /images/ui/panel_flat
  image-border: 1
  padding-bottom: 10

  BotItem
    id: head
    image-source: /images/game/slots/head
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: 10
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: body
    image-source: /images/game/slots/body
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: legs
    image-source: /images/game/slots/legs
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: feet
    image-source: /images/game/slots/feet
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: neck
    image-source: /images/game/slots/neck
    anchors.top: head.top
    margin-top: 13
    anchors.right: head.left
    margin-right: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: left-hand
    image-source: /images/game/slots/left-hand
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: finger
    image-source: /images/game/slots/finger
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: right-hand
    image-source: /images/game/slots/right-hand
    anchors.left: body.right
    margin-left: 5
    anchors.top: left-hand.top
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: ammo
    image-source: /images/game/slots/ammo
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotTextEdit
    id: iconName
    anchors.top: feet.bottom
    anchors.left: parent.left
    size: 120 18
    margin-top: 10
    placeholder: Icon Name
    text-align: left
    
  Button
    id: iconShow
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-top: 0
    margin-left: 2
    height: 18
    text: I
    tooltip: Show/Hide Icone Swap
    $on:
      color: green

MainWindow
  id: panelSwap
  size: 560 355
  border: 1 #000000
  anchors.centerIn: parent
  margin-top: -40
  text: Panel Smart-Swap
  background-color: #101010

  FlatPanel
    id: panelBut
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    background-color: #141414
    border-right: 1 #2a2a2a

  Button
    id: Ring
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    margin-left: 5
    size: 100 20
    text: Ring
    color: #e6e6e6

  Button
    id: Amulet
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 5
    size: 100 20
    text: Amulet
    color: #e6e6e6

  Button
    id: swapSet
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 5
    size: 100 20
    text: Swap Sets
    color: #e6e6e6

  Button
    id: bpConfig
    anchors.verticalCenter: prev.verticalCenter
    anchors.right: panelBut.right
    margin-right: 5
    size: 100 20
    text: Bp Control
    tooltip: Control for open containers (necessary to tibia version < 9.60) [DESATIVED]
    color: #e6e6e6

  FlatPanel
    id: scriptsPanel
    anchors.top: panelBut.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-top: 5

    FlatPanel
      id: ring1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      margin: 5
      width: 167
      layout: verticalBox
      RingConfig
        id: ring1

    FlatPanel
      id: ring2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      RingConfig
        id: ring2

    FlatPanel
      id: ring3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      RingConfig
        id: ring3

    FlatPanel
      id: amulet1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      margin: 5
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet1

    FlatPanel
      id: amulet2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet2

    FlatPanel
      id: amulet3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet3
      
    ScrollablePanel
      id: content
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      vertical-scrollbar: contentScroll
      margin: 5
      image-source: /images/ui/panel_flat
      image-border: 1
      margin-right: 18

      EQPanel
        id: set1
        anchors.top: parent.top
        anchors.left: parent.left
        margin-top: 10
        margin-left: 10

      EQPanel
        id: set2
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set3
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set4
        anchors.top: set1.bottom
        anchors.left: parent.left
        margin-top: 10
        margin-left: 10

      EQPanel
        id: set5
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set6
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10


    VerticalScrollBar
      id: contentScroll
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.bottom: prev.bottom
      step: 28
      pixels-scroll: true
      margin-left: 0

  Button
    id: closePanel
    anchors.left: scriptsPanel.left
    anchors.right: scriptsPanel.right
    anchors.top: scriptsPanel.bottom
    margin-left: -1
    margin-top: 5
    text: Close
    
]], g_ui.getRootWidget())
panelSwap.closePanel.onClick = function()
  panelSwap:hide()
end

if g_app and g_app.isMobile and g_app.isMobile() then
  equipInterface:setSize("560 355")
end

local SMART_SWAP_STORAGE = "lnsSmartSwapPanel"

smartSwapStorage[SMART_SWAP_STORAGE] = smartSwapStorage[SMART_SWAP_STORAGE] or {}
local ssCfg = smartSwapStorage[SMART_SWAP_STORAGE]

ssCfg.selectedTab = ssCfg.selectedTab or "ring"
ssCfg.rings = ssCfg.rings or {}
ssCfg.amulets = ssCfg.amulets or {}
ssCfg.sets = ssCfg.sets or {}

for i = 1, 3 do
  ssCfg.rings[i] = ssCfg.rings[i] or {
    normalId = 0,
    customId = 0,
    equippedId = 0,
    hpEquip = 90,
    hpUnequip = 95,
    enabled = false
  }

  ssCfg.amulets[i] = ssCfg.amulets[i] or {
    normalId = 0,
    customId = 0,
    equippedId = 0,
    hpEquip = 90,
    hpUnequip = 95,
    enabled = false
  }
end

for i = 1, 6 do
  ssCfg.sets[i] = ssCfg.sets[i] or {
    iconName = "",
    iconShow = false,
    slots = {
      head = 0,
      body = 0,
      legs = 0,
      feet = 0,
      neck = 0,
      ["left-hand"] = 0,
      finger = 0,
      ["right-hand"] = 0,
      ammo = 0
    }
  }
end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    return tonumber(widget:getItemId()) or 0
  elseif widget.getItem then
    local it = widget:getItem()
    if type(it) == "number" then return it end
    if type(it) == "table" and it.getId then return it:getId() end
  end
  return 0
end

local function updateBlessedState(widget)
  if not widget or not widget.setOn then return end
  widget:setOn(getBotItemId(widget) > 0)
end

local function setBotItemId(widget, itemId)
  itemId = tonumber(itemId) or 0
  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem then
    widget:setItem(itemId)
  end
  updateBlessedState(widget)
end

local function setScrollValue(scroll, value)
  value = tonumber(value) or 0
  if scroll.setValue then scroll:setValue(value) end
  if scroll.setText then scroll:setText(value .. "%") end
end

local function updateScrollText(scroll)
  if scroll and scroll.getValue and scroll.setText then
    scroll:setText(scroll:getValue() .. "%")
  end
end

local function styleTabButton(btn, active)
  if not btn then return end
  btn:setOpacity(active and 1 or 0.78)
  btn:setOn(active)
  btn:setTextOffset(active and {x = 0, y = -1} or {x = 0, y = 0})
  btn:setColor(active and "#ffffff" or "#bcbcbc")
  if btn.setBackgroundColor then
    btn:setBackgroundColor(active and "#1f1f1f" or "#141414")
  end
end

local function animateTabButton(btn)
  if not btn then return end
  local seq = {0.70, 0.82, 0.94, 1.00}
  for i, v in ipairs(seq) do
    schedule(100, function()
      if btn and not btn:isDestroyed() then
        btn:setOpacity(v)
      end
    end, i * 35)
  end
end

local function hideAllSwapSections()
  panelSwap.scriptsPanel.ring1:hide()
  panelSwap.scriptsPanel.ring2:hide()
  panelSwap.scriptsPanel.ring3:hide()
  panelSwap.scriptsPanel.amulet1:hide()
  panelSwap.scriptsPanel.amulet2:hide()
  panelSwap.scriptsPanel.amulet3:hide()
  panelSwap.scriptsPanel.content:hide()
  panelSwap.scriptsPanel.contentScroll:hide()
end

local function showSwapTab(tabName)
  hideAllSwapSections()

  styleTabButton(panelSwap.Ring, tabName == "ring")
  styleTabButton(panelSwap.Amulet, tabName == "amulet")
  styleTabButton(panelSwap.swapSet, tabName == "set")

  if tabName == "ring" then
    panelSwap.scriptsPanel.ring1:show()
    panelSwap.scriptsPanel.ring2:show()
    panelSwap.scriptsPanel.ring3:show()
    animateTabButton(panelSwap.Ring)

  elseif tabName == "amulet" then
    panelSwap.scriptsPanel.amulet1:show()
    panelSwap.scriptsPanel.amulet2:show()
    panelSwap.scriptsPanel.amulet3:show()
    animateTabButton(panelSwap.Amulet)

  elseif tabName == "set" then
    panelSwap.scriptsPanel.content:show()
    panelSwap.scriptsPanel.contentScroll:show()
    animateTabButton(panelSwap.swapSet)
  end

  ssCfg.selectedTab = tabName
  saveSmartSwapChar()
end

local smartSwapRefs = {
  ring = {},
  amulet = {}
}

local function smartSwapGetRows(kind)
  kind = tostring(kind or ""):lower()

  if kind == "ring" then
    return ssCfg.rings, smartSwapRefs.ring
  elseif kind == "amulet" then
    return ssCfg.amulets, smartSwapRefs.amulet
  end

  return nil, nil
end

local function smartSwapGetPresetLevel(kind)
  local rows = smartSwapGetRows(kind)
  if not rows then return 0 end

  local s1 = rows[1] and rows[1].enabled == true or false
  local s2 = rows[2] and rows[2].enabled == true or false
  local s3 = rows[3] and rows[3].enabled == true or false

  if s1 and not s2 and not s3 then
    return 1
  end

  if s1 and s2 and not s3 then
    return 2
  end

  if s1 and s2 and s3 then
    return 3
  end

  return 0
end

function lnsGetSmartSwapPreset(kind, level)
  level = tonumber(level) or 0
  return smartSwapGetPresetLevel(kind) == level
end

function lnsSetSmartSwapPreset(kind, level)
  kind = tostring(kind or ""):lower()
  level = tonumber(level) or 0

  if level < 0 then level = 0 end
  if level > 3 then level = 3 end

  local rows, refs = smartSwapGetRows(kind)
  if not rows then return false end

  for i = 1, 3 do
    local state = (level > 0 and i <= level)

    rows[i] = rows[i] or {}
    rows[i].enabled = state

    local ui = refs and refs[i]
    if ui and ui.ativador and ui.ativador.setOn then
      ui.ativador:setOn(state)
    end
  end

  saveSmartSwapChar()
  return true
end

local function bindRingPanel(widget, index)
  smartSwapRefs.ring[index] = widget
  local cfg = ssCfg.rings[index]

  setBotItemId(widget.ringNormal, cfg.normalId)
  setBotItemId(widget.ringCustom, cfg.customId)
  setBotItemId(widget.ringCustom2, cfg.equippedId)
  setScrollValue(widget.hpEquip, cfg.hpEquip)
  setScrollValue(widget.hpUnequip, cfg.hpUnequip)
  widget.ativador:setOn(cfg.enabled)

  updateScrollText(widget.hpEquip)
  updateScrollText(widget.hpUnequip)

  widget.ringNormal.onItemChange = function()
    cfg.normalId = getBotItemId(widget.ringNormal)
    saveSmartSwapChar()
  end

  widget.ringCustom.onItemChange = function()
    cfg.customId = getBotItemId(widget.ringCustom)
    saveSmartSwapChar()
  end

  widget.ringCustom2.onItemChange = function()
    cfg.equippedId = getBotItemId(widget.ringCustom2)
    saveSmartSwapChar()
  end

  widget.hpEquip.onValueChange = function(scroll, value)
    cfg.hpEquip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.hpUnequip.onValueChange = function(scroll, value)
    cfg.hpUnequip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.ativador.onClick = function(bt)
    local state = not bt:isOn()
    bt:setOn(state)
    cfg.enabled = state
    saveSmartSwapChar()
  end
end

local function bindAmuletPanel(widget, index)
  smartSwapRefs.amulet[index] = widget
  local cfg = ssCfg.amulets[index]

  setBotItemId(widget.amuletNormal, cfg.normalId)
  setBotItemId(widget.amuletCustom, cfg.customId)
  setBotItemId(widget.amuletCustom2, cfg.equippedId)
  setScrollValue(widget.hpEquip, cfg.hpEquip)
  setScrollValue(widget.hpUnequip, cfg.hpUnequip)
  widget.ativador:setOn(cfg.enabled)

  updateScrollText(widget.hpEquip)
  updateScrollText(widget.hpUnequip)

  widget.amuletNormal.onItemChange = function()
    cfg.normalId = getBotItemId(widget.amuletNormal)
    saveSmartSwapChar()
  end

  widget.amuletCustom.onItemChange = function()
    cfg.customId = getBotItemId(widget.amuletCustom)
    saveSmartSwapChar()
  end

  widget.amuletCustom2.onItemChange = function()
    cfg.equippedId = getBotItemId(widget.amuletCustom2)
    saveSmartSwapChar()
  end

  widget.hpEquip.onValueChange = function(scroll, value)
    cfg.hpEquip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.hpUnequip.onValueChange = function(scroll, value)
    cfg.hpUnequip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.ativador.onClick = function(bt)
    local state = not bt:isOn()
    bt:setOn(state)
    cfg.enabled = state
    saveSmartSwapChar()
  end
end

local function bindSetPanel(widget, index)
  local cfg = ssCfg.sets[index]

  local slotIds = {
    "head", "body", "legs", "feet", "neck",
    "left-hand", "finger", "right-hand", "ammo"
  }

  for _, slot in ipairs(slotIds) do
    if widget[slot] then
      setBotItemId(widget[slot], cfg.slots[slot] or 0)
      updateBlessedState(widget[slot])

      local oldOnItemChange = widget[slot].onItemChange
      widget[slot].onItemChange = function(self)
        cfg.slots[slot] = getBotItemId(self)
        updateBlessedState(self)
        saveSmartSwapChar()
        if oldOnItemChange then oldOnItemChange(self) end
      end
    end
  end

  if widget.iconName then
    widget.iconName:setText(cfg.iconName or "")
    widget.iconName.onTextChange = function(edit, text)
      cfg.iconName = text
      saveSmartSwapChar()
    end
  end

  if widget.iconShow then
    widget.iconShow:setOn(cfg.iconShow or false)
    widget.iconShow.onClick = function(bt)
      local state = not bt:isOn()
      bt:setOn(state)
      cfg.iconShow = state
      saveSmartSwapChar()
    end
  end
end

bindRingPanel(panelSwap.scriptsPanel.ring1.ring1, 1)
bindRingPanel(panelSwap.scriptsPanel.ring2.ring2, 2)
bindRingPanel(panelSwap.scriptsPanel.ring3.ring3, 3)

bindAmuletPanel(panelSwap.scriptsPanel.amulet1.amulet1, 1)
bindAmuletPanel(panelSwap.scriptsPanel.amulet2.amulet2, 2)
bindAmuletPanel(panelSwap.scriptsPanel.amulet3.amulet3, 3)

bindSetPanel(panelSwap.scriptsPanel.content.set1, 1)
bindSetPanel(panelSwap.scriptsPanel.content.set2, 2)
bindSetPanel(panelSwap.scriptsPanel.content.set3, 3)
bindSetPanel(panelSwap.scriptsPanel.content.set4, 4)
bindSetPanel(panelSwap.scriptsPanel.content.set5, 5)
bindSetPanel(panelSwap.scriptsPanel.content.set6, 6)

panelSwap.Ring.onClick = function()
  showSwapTab("ring")
end

panelSwap.Amulet.onClick = function()
  showSwapTab("amulet")
end

panelSwap.swapSet.onClick = function()
  showSwapTab("set")
end

showSwapTab(ssCfg.selectedTab or "ring")
panelSwap:hide()

swapButton.settings.onClick = function()
  if panelSwap:isVisible() then
    panelSwap:hide()
  else
    panelSwap:show()
    panelSwap:raise()
    panelSwap:focus()
    showSwapTab(ssCfg.selectedTab or "ring")
  end
end

local SMART_SWAP_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local SMART_SWAP_COOLDOWN_MS = 0
local SMART_SWAP_ACTION_DELAY = 0
local SMART_SWAP_TICK = 10

local CD_MIGHT_RING = 3048
local CD_SSA_AMULET = 3081

local SMART_SLOT_FINGER = SlotFinger or 9
local SMART_SLOT_NECK   = SlotNeck or 2

local SMART_RING_NORMAL_PAIRS = {
  [3091] = 3094,
  [3053] = 3090,
  [3098] = 3100,
  [3052] = 3089,
  [3051] = 3088,
  [3097] = 3099,
  [23533] = 23534,
  [3049] = 3086,
  [3050] = 3087,
  [3093] = 3096,
  [3092] = 3095
}

local SMART_AMULET_NORMAL_PAIRS = {
  [23544] = 23528
}

local function smartResolveNormalPair(kind, selectedId)
  selectedId = tonumber(selectedId) or 0
  if selectedId <= 0 then return 0, 0 end

  local map = kind == "ring" and SMART_RING_NORMAL_PAIRS or SMART_AMULET_NORMAL_PAIRS
  local equippedId = map[selectedId]
  if equippedId then return selectedId, equippedId end

  for unequippedId, equipped in pairs(map) do
    if selectedId == equipped then
      return unequippedId, equipped
    end
  end

  return selectedId, selectedId
end

local function smartActionDelay() end

local ringCdUntil = 0
local amuletCdUntil = { [1] = 0, [2] = 0, [3] = 0 }

local function smartNow()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function smartItemId(it)
  if not it then return 0 end
  if it.getId then return tonumber(it:getId()) or 0 end
  return 0
end

local function smartGetFinger()
  if type(getFinger) == "function" then return getFinger() end
  return getSlot(SMART_SLOT_FINGER)
end

local function smartGetNeck()
  if type(getNeck) == "function" then return getNeck() end
  return getSlot(SMART_SLOT_NECK)
end

local function smartIsIdIn(id, a, b)
  id = tonumber(id) or 0
  a = tonumber(a) or 0
  b = tonumber(b) or 0
  if id <= 0 then return false end
  return (a > 0 and id == a) or (b > 0 and id == b)
end

local function smartUseCooldown(kind, item2, item3)
  item2 = tonumber(item2) or 0
  item3 = tonumber(item3) or 0

  if kind == "ring" then
    return item2 == CD_MIGHT_RING or item3 == CD_MIGHT_RING
  end

  if kind == "amulet" then
    return item2 == CD_SSA_AMULET or item3 == CD_SSA_AMULET
  end

  return false
end

local function smartGetContainers()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function smartFindItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, c in ipairs(smartGetContainers()) do
    for _, it in ipairs(c:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function smartGetContainerCount(container)
  if not container then return 0 end
  if container.getItemsCount then return tonumber(container:getItemsCount()) or 0 end
  return #(container:getItems() or {})
end

local function smartGetContainerCapacity(container)
  if not container then return 0 end
  if container.getCapacity then return tonumber(container:getCapacity()) or 0 end
  return 0
end

local function smartGetFreeContainer()
  for _, container in ipairs(smartGetContainers()) do
    local name = (container.getName and container:getName() or ""):lower()
    local cap = smartGetContainerCapacity(container)
    local count = smartGetContainerCount(container)

    if (cap <= 0 or count < cap)
      and not name:find("dead")
      and not name:find("slain")
      and not name:find("depot")
      and not name:find("quiver") then
      return container
    end
  end

  return nil
end

local function smartUnequip(slot)
  local item = getSlot(slot)
  if not item then return false end

  if g_game.getClientVersion() >= 959 then
    g_game.equipItemId(item:getId())
    return true
  end

  local dest = smartGetFreeContainer()
  if not dest then return false end

  local pos = dest:getSlotPosition(smartGetContainerCount(dest))
  g_game.move(item, pos, item:getCount())
  return true
end

local function smartEquipToSlot(id, slot)
  id = tonumber(id) or 0
  if id <= 0 then return false end

  if g_game.getClientVersion() >= 959 then
    local ok, result = pcall(function() return g_game.equipItemId(id, slot) end)
    if ok and result ~= false then return true end

    ok, result = pcall(function() return g_game.equipItemId(id) end)
    return ok and result ~= false
  end

  local it = smartFindItemById(id)
  if not it then return false end

  g_game.move(it, {x = 65535, y = slot, z = 0}, 1)
  return true
end

local function smartEquipSpecial(id1, id2, slot)
  id1 = tonumber(id1) or 0
  id2 = tonumber(id2) or 0
  local pick = id1 > 0 and id1 or id2
  if pick <= 0 then return false end

  if g_game.getClientVersion() >= 959 then
    local ok, result = pcall(function() return g_game.equipItemId(pick, slot) end)
    if ok and result ~= false then return true end

    ok, result = pcall(function() return g_game.equipItemId(pick) end)
    return ok and result ~= false
  end

  local it = smartFindItemById(id1) or smartFindItemById(id2)
  if not it then return false end

  g_game.move(it, {x = 65535, y = slot, z = 0}, 1)
  return true
end

local function getEnabledRingRows()
  local rows = {}
  if not ssCfg or not ssCfg.rings then return rows end

  for i = 1, 3 do
    local row = ssCfg.rings[i]
    if row and row.enabled == true then
      rows[#rows + 1] = {
        index = i,
        normalId = tonumber(row.normalId) or 0,
        customId = tonumber(row.customId) or 0,
        equippedId = tonumber(row.equippedId) or 0,
        hpEquip = tonumber(row.hpEquip) or 0,
        hpUnequip = tonumber(row.hpUnequip) or tonumber(row.hpEquip) or 0
      }
    end
  end

  table.sort(rows, function(a, b)
    if a.hpEquip == b.hpEquip then
      return a.index < b.index
    end
    return a.hpEquip < b.hpEquip
  end)

  return rows
end

local function getCurrentEquippedRingRow(equippedId, rows)
  equippedId = tonumber(equippedId) or 0
  if equippedId <= 0 then return nil end

  for _, row in ipairs(rows) do
    if smartIsIdIn(equippedId, row.customId, row.equippedId) then
      return row
    end
  end

  return nil
end

local function getBestRingRowToEquip(hp, rows)
  local best = nil

  for _, row in ipairs(rows) do
    if hp < row.hpEquip and (row.customId > 0 or row.equippedId > 0) then
      best = row
      break
    end
  end

  return best
end

local function getRingNormalIds(rows)
  for _, row in ipairs(rows) do
    if row.normalId > 0 then
      return smartResolveNormalPair("ring", row.normalId)
    end
  end
  return 0, 0
end

local function processRingSwapSystem()
  local hp = hppercent()
  local t = smartNow()
  local finger = smartGetFinger()
  local equippedId = smartItemId(finger)
  local rows = getEnabledRingRows()

  if #rows == 0 then return false end

  local currentRow = getCurrentEquippedRingRow(equippedId, rows)
  local bestRow = getBestRingRowToEquip(hp, rows)
  local normalId, normalEquippedId = getRingNormalIds(rows)
  local cdActive = ringCdUntil > t

  if currentRow then
    local currentIsCooldownRing = smartUseCooldown("ring", currentRow.customId, currentRow.equippedId)

    if bestRow and bestRow.index ~= currentRow.index and bestRow.hpEquip <= currentRow.hpEquip then
      if not (cdActive and currentIsCooldownRing) then
        if smartEquipSpecial(bestRow.customId, bestRow.equippedId, SMART_SLOT_FINGER) then
          if smartUseCooldown("ring", bestRow.customId, bestRow.equippedId) then
            ringCdUntil = t + SMART_SWAP_COOLDOWN_MS
          end
          smartActionDelay()
          return true
        end
      end
      return false
    end

    if hp <= currentRow.hpUnequip then
      return false
    end
  end

  if bestRow then
    if not currentRow or currentRow.index ~= bestRow.index then
      if smartEquipSpecial(bestRow.customId, bestRow.equippedId, SMART_SLOT_FINGER) then
        if smartUseCooldown("ring", bestRow.customId, bestRow.equippedId) then
          ringCdUntil = t + SMART_SWAP_COOLDOWN_MS
        end
        smartActionDelay()
        return true
      end
    end
    return false
  end

  if cdActive then
    return false
  end

  if normalId > 0 then
    if not smartIsIdIn(equippedId, normalId, normalEquippedId) then
      if smartEquipToSlot(normalId, SMART_SLOT_FINGER) then
        smartActionDelay()
        return true
      end
    end
    return false
  end

  if equippedId ~= 0 then
    if smartUnequip(SMART_SLOT_FINGER) then
      smartActionDelay()
      return true
    end
  end

  return false
end

local function processAmuletSwap(index, row)
  if not row or row.enabled ~= true then return false end

  local hp = hppercent()
  local t = smartNow()

  local neck = smartGetNeck()
  local equippedId = smartItemId(neck)

  local normalId, normalEquippedId = smartResolveNormalPair("amulet", row.normalId)
  local specialId  = tonumber(row.customId) or 0
  local specialEq  = tonumber(row.equippedId) or 0
  local equipPct   = tonumber(row.hpEquip) or 0
  local unequipPct = tonumber(row.hpUnequip) or equipPct

  local hasNormal = normalId > 0
  local useCd = smartUseCooldown("amulet", specialId, specialEq)
  local cdActive = useCd and ((amuletCdUntil[index] or 0) > t) or false

  if hp < equipPct then
    if smartIsIdIn(equippedId, specialId, specialEq) then return false end

    if smartEquipSpecial(specialId, specialEq, SMART_SLOT_NECK) then
      if useCd then
        amuletCdUntil[index] = t + SMART_SWAP_COOLDOWN_MS
      end
      smartActionDelay()
      return true
    end
    return false
  end

  if useCd and cdActive then
    if hp > unequipPct and equippedId ~= 0 then
      if smartUnequip(SMART_SLOT_NECK) then
        smartActionDelay()
        return true
      end
    end
    return false
  end

  if hp > unequipPct then
    if hasNormal then
      if not smartIsIdIn(equippedId, normalId, normalEquippedId) then
        if smartEquipToSlot(normalId, SMART_SLOT_NECK) then
          smartActionDelay()
          return true
        end
      end
      return false
    end

    if equippedId ~= 0 then
      if smartUnequip(SMART_SLOT_NECK) then
        smartActionDelay()
        return true
      end
    end
  end

  return false
end

local function fullTankIsOn()
  if type(isLnsFullTankActive) == "function" then
    return isLnsFullTankActive() == true
  end

  return lnsFullTankActive == true
end

macro(SMART_SWAP_TICK, function()
  if fullTankIsOn() then return end
  if not smartSwapStorage[switchSwap] or smartSwapStorage[switchSwap].enabled ~= true then return end
  if not ssCfg or not ssCfg.rings then return end
  processRingSwapSystem()
end)

macro(SMART_SWAP_TICK, function()
  if fullTankIsOn() then return end
  if not smartSwapStorage[switchSwap] or smartSwapStorage[switchSwap].enabled ~= true then return end
  if not ssCfg or not ssCfg.amulets then return end

  for i = 1, 3 do
    if processAmuletSwap(i, ssCfg.amulets[i]) then
      return
    end
  end
end)

-- =========================
-- SWAP SET ICONS / EQUIP FAST
-- =========================

local SWAPSET_SLOT_CONST = {
  head = SlotHead,
  neck = SlotNeck,
  body = SlotBody,
  ["left-hand"] = SlotLeft,
  ["right-hand"] = SlotRight,
  legs = SlotLeg,
  feet = SlotFeet,
  finger = SlotFinger,
  ammo = SlotAmmo
}

local SWAPSET_ORDER = {
  "neck", "head", "body", "legs", "feet", "right-hand", "left-hand", "finger", "ammo"
}

local SWAPSET_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local SWAPSET_ACTION_DELAY = SWAPSET_IS_OLD_CLIENT and 250 or 25

local swapSetIcons = {}
local swapSetRuntime = {}

local function sswapNow()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function sswapTrim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function sswapGetSet(index)
  if not ssCfg or not ssCfg.sets then return nil end
  local cfg = ssCfg.sets[index]
  if type(cfg) ~= "table" then return nil end
  return cfg
end

local function sswapGetState(index)
  if not swapSetRuntime[index] then
    swapSetRuntime[index] = { active = false, nextAction = 0 }
  end
  return swapSetRuntime[index]
end

local function sswapGetSetName(index)
  local cfg = sswapGetSet(index) or {}
  local txt = sswapTrim(cfg.iconName or "")
  if txt == "" then txt = "SET" .. index end
  return txt
end

local function sswapGetIconItemId(index)
  local cfg = sswapGetSet(index) or {}
  local slots = cfg.slots or {}
  return tonumber(slots["left-hand"]) or 0
end

local function sswapSetIconItem(icon, itemId)
  itemId = tonumber(itemId) or 0
  if not icon then return end

  if icon.item and icon.item.setItemId then
    icon.item:setItemId(itemId)
    return
  end

  if icon.getChildById then
    local child = icon:getChildById("item")
    if child and child.setItemId then
      child:setItemId(itemId)
    end
  end
end

local function sswapGetSlotItem(slotConst)
  return getSlot(slotConst)
end

local function sswapGetSlotId(slotConst)
  local it = sswapGetSlotItem(slotConst)
  return it and it:getId() or 0
end

local function sswapGetContainers()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function sswapFindItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, cont in pairs(sswapGetContainers()) do
    for _, it in ipairs(cont:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function sswapGetFreeContainer()
  for _, container in ipairs(sswapGetContainers()) do
    local name = (container.getName and container:getName() or ""):lower()
    local cap = container.getCapacity and tonumber(container:getCapacity()) or 0
    local count = container.getItemsCount and tonumber(container:getItemsCount()) or #(container:getItems() or {})

    if (cap <= 0 or count < cap)
      and not name:find("dead")
      and not name:find("slain")
      and not name:find("depot")
      and not name:find("locker")
      and not name:find("quiver") then
      return container
    end
  end
  return nil
end

local function sswapUnequipSlot(slotConst)
  local item = sswapGetSlotItem(slotConst)
  if not item then return false end

  if not SWAPSET_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(item:getId())
    end)
    return ok
  end

  local dest = sswapGetFreeContainer()
  if not dest then return false end

  local pos = dest.getSlotPosition and dest:getSlotPosition(dest.getItemsCount and dest:getItemsCount() or #(dest:getItems() or {}))
  if not pos then return false end

  local ok = pcall(function()
    g_game.move(item, pos, item:getCount())
  end)
  return ok
end

local function sswapEquipToSlot(itemId, slotConst)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return false end

  if not SWAPSET_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(itemId, slotConst)
    end)
    if ok then return true end

    ok = pcall(function()
      g_game.equipItemId(itemId)
    end)
    return ok
  end

  local it = sswapFindItemById(itemId)
  if not it then return false end

  local ok = pcall(function()
    g_game.move(it, {x = 65535, y = slotConst, z = 0}, 1)
  end)
  return ok
end

local function sswapPrepareHands(slots)
  local wantLeft = tonumber(slots["left-hand"]) or 0
  local wantRight = tonumber(slots["right-hand"]) or 0

  local curLeft = sswapGetSlotId(SlotLeft)
  local curRight = sswapGetSlotId(SlotRight)

  if curLeft > 0 and wantLeft == 0 and wantRight > 0 then
    if sswapUnequipSlot(SlotLeft) then return true end
  end

  if curRight > 0 and wantRight == 0 and wantLeft > 0 then
    if sswapUnequipSlot(SlotRight) then return true end
  end

  if wantRight > 0 and curLeft > 0 and curLeft ~= wantLeft then
    if sswapUnequipSlot(SlotLeft) then return true end
  end

  if wantLeft > 0 and curRight > 0 and curRight ~= wantRight then
    if sswapUnequipSlot(SlotRight) then return true end
  end

  return false
end

local function sswapApplyOldClient(index)
  local cfg = sswapGetSet(index)
  if not cfg then return false, true end

  local slots = cfg.slots or {}

  if sswapPrepareHands(slots) then
    return true, false
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId <= 0 then
      if currentId > 0 then
        if sswapUnequipSlot(slotConst) then
          return true, false
        end
      end
    else
      if currentId ~= wantedId then
        if sswapEquipToSlot(wantedId, slotConst) then
          return true, false
        end
        return false, false
      end
    end
  end

  return false, true
end

local function sswapApplyNewClient(index)
  local cfg = sswapGetSet(index)
  if not cfg then return false, true end

  local slots = cfg.slots or {}
  local changed = false

  if sswapPrepareHands(slots) then
    changed = true
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId <= 0 then
      if currentId > 0 then
        if sswapUnequipSlot(slotConst) then
          changed = true
        end
      end
    else
      if currentId ~= wantedId then
        local ok = pcall(function()
          g_game.equipItemId(wantedId)
        end)

        if not ok then
          ok = pcall(function()
            g_game.equipItemId(wantedId)
          end)
        end

        if ok then
          changed = true
        end
      end
    end
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId > 0 and currentId ~= wantedId then
      return changed, false
    end

    if wantedId <= 0 and currentId > 0 then
      return changed, false
    end
  end

  return changed, true
end

local function sswapRefreshIcon(index)
  local icon = swapSetIcons[index]
  if not icon then return end

  local cfg = sswapGetSet(index)
  local state = sswapGetState(index)

  if not smartSwapStorage[switchSwap] or smartSwapStorage[switchSwap].enabled ~= true or not cfg or cfg.iconShow ~= true then
    state.active = false
    icon:hide()
    return
  end

  local iconItemId = sswapGetIconItemId(index)
  local name = sswapGetSetName(index)

  sswapSetIconItem(icon, iconItemId)

  if state.active then
    icon.text:setColoredText({name, "green"})
    icon.text:setFont("verdana-11px-rounded")
  else
    icon.text:setColoredText({name, "white"})
    icon.text:setFont("verdana-11px-rounded")
  end

  icon:show()
end

local function sswapRefreshAllIcons()
  for i = 1, 6 do
    sswapRefreshIcon(i)
  end
end

local function sswapStart(index)
  local cfg = sswapGetSet(index)
  if not cfg or cfg.iconShow ~= true then return end
  if not smartSwapStorage[switchSwap] or smartSwapStorage[switchSwap].enabled ~= true then return end

  local state = sswapGetState(index)
  state.active = true
  state.nextAction = 0
  sswapRefreshIcon(index)
end

local function sswapStop(index)
  local state = sswapGetState(index)
  state.active = false
  sswapRefreshIcon(index)
end

local function sswapCreateIcon(index)
  local icon = addIcon("LNS_SWAP_SET_ICON_" .. index, {
    item = {id = 0, count = 1},
    text = "SET" .. index,
    switchable = false,
    moveable = true
  }, function()
    sswapStart(index)
  end)

  icon:setSize({height = 50, width = 52})
  icon:hide()
  swapSetIcons[index] = icon
end

for i = 1, 6 do
  sswapCreateIcon(i)
end

macro(100, function()
  sswapRefreshAllIcons()
end)

macro(200, function()
  if fullTankIsOn() then return end
  if not smartSwapStorage[switchSwap] or smartSwapStorage[switchSwap].enabled ~= true then
    for i = 1, 6 do
      sswapGetState(i).active = false
    end
    sswapRefreshAllIcons()
    return
  end

  local t = sswapNow()

  for i = 1, 6 do
    local state = sswapGetState(i)

    if state.active and state.nextAction <= t then
      local changed, finished

      if SWAPSET_IS_OLD_CLIENT then
        changed, finished = sswapApplyOldClient(i)
      else
        changed, finished = sswapApplyNewClient(i)
      end

      if finished then
        sswapStop(i)
      elseif changed then
        state.nextAction = t + SWAPSET_ACTION_DELAY
      end
    end
  end
end)

end)

lnsRunBlock("AUTOPREY", function()

-- ===============================
-- STORAGE GLOBAL
-- ===============================
storage = storage or {}
storage.LNSAutoPreyGlobal = storage.LNSAutoPreyGlobal or {}

local autoPreyStorage = storage.LNSAutoPreyGlobal

local function saveAutoPreyGlobal()
  storage.LNSAutoPreyGlobal = autoPreyStorage
end

local function savePreyChar()
  saveAutoPreyGlobal()
end

setDefaultTab("Main")

-- ===============================
-- MAIN BUTTON
-- ===============================
local switchPrey = "preyButton"

autoPreyStorage[switchPrey] = autoPreyStorage[switchPrey] or { enabled = false }

preyButton = setupUI([[
Panel
  height: 19
  margin-top: 0

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 45
    text-align: center
    height: 18
    text: Auto Prey
    color: white
    tooltip: Auto Prey

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    color: white
    text: Config
]])

preyButton:setId(switchPrey)
preyButton.title:setOn(autoPreyStorage[switchPrey].enabled)

preyButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  autoPreyStorage[switchPrey].enabled = newState
  savePreyChar()
end

-- ===============================
-- PANEL
-- ===============================
preyInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 320 395
  text: Panel Auto Prey
  margin-top: -50

  FlatPanel
    id: monstersBlock
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 190
    margin-left: -4
    margin-right: -4

    ComboBox
      id: selectStorage
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 5
      font: verdana-11px-rounded
      margin-left: 5
      size: 220 20

    TextEdit
      id: nameStorage
      anchors.top: prev.top
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 0
      height: 20
      font: verdana-11px-rounded
      visible: false

    Button
      id: addStorage
      anchors.left: prev.right
      anchors.right: parent.right
      margin-right: 5
      anchors.verticalCenter: prev.verticalCenter
      text: Insert
      height: 20
      margin-left: 5

    HorizontalSeparator
      anchors.top: prev.bottom
      margin-top: 3
      anchors.left: parent.left
      anchors.right: parent.right
      margin-left: 1
      margin-right: 1

  TextList
    id: panelPreyList1
    anchors.top: monstersBlock.top
    anchors.left: monstersBlock.left
    anchors.right: monstersBlock.right
    margin-top: 35
    margin-left: 5
    margin-right: 17
    height: 125
    width: 220
    padding: 1
    vertical-scrollbar: prey1Scroll
    opacity: 0.95

  VerticalScrollBar
    id: prey1Scroll
    anchors.top: panelPreyList1.top
    anchors.bottom: panelPreyList1.bottom
    anchors.left: panelPreyList1.right
    step: 18
    pixels-scroll: true
    visible: true
    opacity: 0.90
    margin-left: 0

  TextEdit
    id: inserirMobName1
    anchors.top: panelPreyList1.bottom
    anchors.left: panelPreyList1.left
    anchors.right: panelPreyList1.right
    margin-top: 4
    margin-right: 5
    width: 300
    height: 20
    color: #c0c0c0
    placeholder: Insert monster name

  Button
    id: buttonAdd
    anchors.top: inserirMobName1.top
    anchors.right: prey1Scroll.right
    width: 20
    height: 20
    text: +
    font: sans-bold-16px

  Panel
    id: slotsBlock
    anchors.top: monstersBlock.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 135
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-top: 6
    margin-left: -4
    margin-right: -4

    Label
      id: slotsTitle
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 2
      text: Rerrol Slots & Settings
      text-auto-resize: true

  UIWidget
    id: ativarPrey1
    anchors.top: slotsBlock.top
    anchors.left: slotsBlock.left
    margin-top: 25
    margin-left: 18
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey1
    anchors.top: ativarPrey1.bottom
    anchors.horizontalCenter: ativarPrey1.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 1
    color: white
    text-auto-resize: true

  UIWidget
    id: ativarPrey2
    anchors.top: ativarPrey1.top
    anchors.horizontalCenter: slotsBlock.horizontalCenter
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey2
    anchors.top: ativarPrey2.bottom
    anchors.horizontalCenter: ativarPrey2.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 2
    color: white
    text-auto-resize: true

  UIWidget
    id: ativarPrey3
    anchors.top: ativarPrey1.top
    anchors.right: slotsBlock.right
    margin-right: 18
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey3
    anchors.top: ativarPrey3.bottom
    anchors.horizontalCenter: ativarPrey3.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 3
    color: white
    text-auto-resize: true

  Label
    id: labelMaxRetries
    anchors.top: prev.bottom
    anchors.left: ativarPrey1.left
    margin-top: 10
    margin-left: -5
    text: Maximum Retries:
    font: verdana-11px-rounded
    text-auto-resize: true

  SpinBox
    id: maxRetriesPrey
    anchors.left: labelMaxRetries.right
    anchors.verticalCenter: labelMaxRetries.verticalCenter
    margin-left: 5
    size: 150 20
    font: verdana-11px-rounded
    text-align: center
    minimum: 0
    maximum: 9999
    step: 1

  Label
    id: labelDelayRetries
    anchors.left: labelMaxRetries.left
    anchors.top: labelMaxRetries.bottom
    margin-left: 0
    margin-top:12
    text: Delay Retries:
    font: verdana-11px-rounded
    text-auto-resize: true

  HorizontalScrollBar
    id: delayRetries
    anchors.left: maxRetriesPrey.left
    anchors.right: maxRetriesPrey.right
    anchors.verticalCenter: labelDelayRetries.verticalCenter
    margin-left: 0
    margin-right: 0
    height: 14
    minimum: 0
    maximum: 5000
    step: 100

  Label
    id: delayMsValue
    anchors.centerIn: delayRetries
    text-align: center
    text: 0ms
    font: verdana-11px-rounded
    color: white
    text-auto-resize: true

  Button
    id: closePanel
    anchors.top: slotsBlock.bottom
    anchors.left: slotsBlock.left
    anchors.right: slotsBlock.right
    margin-top: 6
    text: Close
]=], g_ui.getRootWidget())

preyInterface:hide()

-- ===============================
-- BIND WIDGETS RECURSIVO
-- Necessario porque selectStorage/nameStorage/addStorage ficam dentro do monstersBlock.
-- Alguns OTC nao criam preyInterface.selectStorage direto quando o widget esta aninhado.
-- ===============================
local function WAutoPrey(root, id)
  if not root or not id then return nil end

  if root[id] then
    return root[id]
  end

  if root.getChildById then
    local ok, child = pcall(function() return root:getChildById(id) end)
    if ok and child then return child end
  end

  if root.recursiveGetChildById then
    local ok, child = pcall(function() return root:recursiveGetChildById(id) end)
    if ok and child then return child end
  end

  if root.getChildren then
    local ok, childs = pcall(function() return root:getChildren() end)
    if ok and childs then
      for i = 1, #childs do
        local found = WAutoPrey(childs[i], id)
        if found then return found end
      end
    end
  end

  return nil
end

local function bindAutoPreyWidgets()
  local ids = {
    "monstersBlock", "selectStorage", "nameStorage", "addStorage",
    "panelPreyList1", "prey1Scroll", "inserirMobName1", "buttonAdd",
    "slotsBlock", "ativarPrey1", "ativarPrey2", "ativarPrey3",
    "labelPrey1", "labelPrey2", "labelPrey3",
    "fundoconfigsprey", "maxRetriesPrey", "delayRetries", "delayMsValue",
    "closePanel"
  }

  for i = 1, #ids do
    local id = ids[i]
    if preyInterface and not preyInterface[id] then
      preyInterface[id] = WAutoPrey(preyInterface, id)
    end
  end
end

bindAutoPreyWidgets()

if modules._G.g_app.isMobile() then
  preyInterface:setSize("320 410")
end

preyButton.settings.onClick = function()
  preyInterface:show()
  preyInterface:raise()
  preyInterface:focus()
end

if preyInterface.closePanel then
  preyInterface.closePanel.onClick = function()
    preyInterface:hide()
  end
end

-- ===============================
-- STORAGE
-- ===============================
local STKEY = "lnsPreyRerollPanel"

autoPreyStorage[STKEY] = autoPreyStorage[STKEY] or {
  lists = { [1] = {} },
  enabled = { [1] = false, [2] = false, [3] = false },
  delayMs = 400,
  maxRetries = 15
}

local st = autoPreyStorage[STKEY]
st.lists = st.lists or { [1] = {} }
st.lists[1] = st.lists[1] or {}
st.enabled = st.enabled or { [1] = false, [2] = false, [3] = false }
st.delayMs = tonumber(st.delayMs) or 400
st.maxRetries = tonumber(st.maxRetries) or 15

st.renewBelowPercent = 5


-- ===============================
-- SHARED STORAGE NAMES / MONSTER LISTS
-- Compartilhado entre chars:
-- /bot/<config atual>/storage/shared/sharedAutoPrey.json
-- Mantem local no storage normal: slots, delay e maxRetries.
-- ===============================
st.selectedStorage = tostring(st.selectedStorage or "Default")

local SHARED_AUTOPREY_DIR = nil
local SHARED_AUTOPREY_FILE = nil
local SharedAutoPrey = {
  profiles = {},
  loaded = false,
  comboSilent = false,
  insertMode = false
}

local function sharedPreyTrim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function sharedPreyNormalizeName(name)
  name = sharedPreyTrim(name)
  name = name:gsub('[\\/:*?"<>|]', "")
  name = name:gsub("%s+", " ")
  if #name > 32 then
    name = name:sub(1, 32)
  end
  return name
end

local function sharedPreyEscape(s)
  s = tostring(s or "")
  s = s:gsub("\\", "\\\\")
  s = s:gsub('"', '\\"')
  s = s:gsub("\n", "\\n")
  s = s:gsub("\r", "\\r")
  return s
end

local function sharedPreyUnescape(s)
  s = tostring(s or "")
  s = s:gsub('\\n', "\n")
  s = s:gsub('\\r', "\r")
  s = s:gsub('\\"', '"')
  s = s:gsub('\\\\', "\\")
  return s
end

local function sharedPreyCopyList(list)
  local out = {}
  local used = {}

  if type(list) == "table" then
    for _, value in ipairs(list) do
      local name = sharedPreyTrim(value)
      local key = name:lower()
      if name ~= "" and not used[key] then
        table.insert(out, name)
        used[key] = true
      end
    end
  end

  table.sort(out, function(a, b)
    return a:lower() < b:lower()
  end)

  return out
end

local function getCurrentAutoPreyConfigName()
  local panel = modules and modules.game_bot and modules.game_bot.contentsPanel
  local cfg = panel and panel.config
  local opt = cfg and cfg.getCurrentOption and cfg:getCurrentOption()

  if opt and opt.text and tostring(opt.text) ~= "" then
    return tostring(opt.text)
  end

  return nil
end

local function safeAutoPreyDirExists(path)
  if not g_resources then return false end

  if g_resources.directoryExists then
    local ok, exists = pcall(function()
      return g_resources.directoryExists(path)
    end)
    if ok and exists == true then
      return true
    end
  end

  return false
end

local function safeAutoPreyMakeDir(path)
  if not path or path == "" then return false end
  if safeAutoPreyDirExists(path) then return true end
  if not g_resources or not g_resources.makeDir then return false end

  local ok = pcall(function()
    g_resources.makeDir(path)
  end)

  if not ok then return false end
  return safeAutoPreyDirExists(path)
end

local function safeAutoPreyFileExists(path)
  if not path or path == "" then return false end
  if not g_resources or not g_resources.fileExists then return false end

  local ok, exists = pcall(function()
    return g_resources.fileExists(path)
  end)

  return ok and exists == true
end

local function safeAutoPreyWriteDefaultFile(path, defaultJson)
  if not path or path == "" then return false end
  if safeAutoPreyFileExists(path) then return true end
  if not g_resources or not g_resources.writeFileContents then return false end

  local ok = pcall(function()
    g_resources.writeFileContents(path, defaultJson or "{}")
  end)

  if not ok then return false end
  return true
end

local function initSharedAutoPreyPath()
  if SHARED_AUTOPREY_FILE then return true end

  local configName = getCurrentAutoPreyConfigName()
  if not configName or configName == "" then
    return false
  end

  -- Cria primeiro a pasta pai, depois a pasta shared, e só então cria o .json.
  -- Isso evita debug em client que não aceita read/write em arquivo inexistente.
  local baseDir = "/bot/" .. configName .. "/storage/"
  local sharedDir = baseDir .. "shared/"
  local filePath = sharedDir .. "sharedAutoPrey.json"

  if not safeAutoPreyMakeDir(baseDir) then return false end
  if not safeAutoPreyMakeDir(sharedDir) then return false end
  if not safeAutoPreyWriteDefaultFile(filePath, "{\n  \"profiles\": {\n    \"Default\": []\n  }\n}") then return false end

  SHARED_AUTOPREY_DIR = sharedDir
  SHARED_AUTOPREY_FILE = filePath
  return true
end

local function sharedPreyEncodeArray(list)
  local arr = {}
  for _, value in ipairs(sharedPreyCopyList(list)) do
    table.insert(arr, '"' .. sharedPreyEscape(value) .. '"')
  end
  return "[" .. table.concat(arr, ",") .. "]"
end

local function sharedPreyDecodeArray(body)
  local out = {}
  body = tostring(body or "")

  for value in body:gmatch('"(.-)"') do
    local name = sharedPreyTrim(sharedPreyUnescape(value))
    if name ~= "" then
      table.insert(out, name)
    end
  end

  return sharedPreyCopyList(out)
end


local function sharedPreyExtractArrayBody(text, key)
  text = tostring(text or "")
  key = tostring(key or "")

  local _, stopAt = text:find('"' .. key .. '"%s*:%s*%[')
  if not stopAt then return nil end

  local startAt = stopAt + 1
  local depth = 1
  local inString = false
  local escaped = false

  for i = startAt, #text do
    local ch = text:sub(i, i)

    if inString then
      if escaped then
        escaped = false
      elseif ch == "\\" then
        escaped = true
      elseif ch == '"' then
        inString = false
      end
    else
      if ch == '"' then
        inString = true
      elseif ch == "[" then
        depth = depth + 1
      elseif ch == "]" then
        depth = depth - 1
        if depth == 0 then
          return text:sub(startAt, i - 1)
        end
      end
    end
  end

  return nil
end

local function sharedPreyCollectObjects(body)
  local objects = {}
  body = tostring(body or "")

  local depth = 0
  local startAt = nil
  local inString = false
  local escaped = false

  for i = 1, #body do
    local ch = body:sub(i, i)

    if inString then
      if escaped then
        escaped = false
      elseif ch == "\\" then
        escaped = true
      elseif ch == '"' then
        inString = false
      end
    else
      if ch == '"' then
        inString = true
      elseif ch == "{" then
        if depth == 0 then startAt = i end
        depth = depth + 1
      elseif ch == "}" then
        depth = depth - 1
        if depth == 0 and startAt then
          table.insert(objects, body:sub(startAt, i))
          startAt = nil
        end
      end
    end
  end

  return objects
end

local function sharedPreyDecodeStringKey(obj, key)
  local raw = tostring(obj or ""):match('"' .. key .. '"%s*:%s*"(.-)"')
  if not raw then return "" end
  return sharedPreyUnescape(raw)
end

local function encodeSharedAutoPrey()
  local profileNames = {}
  for name, _ in pairs(SharedAutoPrey.profiles or {}) do
    local cleanName = sharedPreyNormalizeName(name)
    if cleanName ~= "" then
      table.insert(profileNames, cleanName)
    end
  end

  table.sort(profileNames, function(a, b)
    return a:lower() < b:lower()
  end)

  local lines = {}
  table.insert(lines, "{\n")
  table.insert(lines, '  "profiles": {\n')

  for i, name in ipairs(profileNames) do
    local comma = i < #profileNames and "," or ""
    table.insert(lines, '    "' .. sharedPreyEscape(name) .. '": ' .. sharedPreyEncodeArray(SharedAutoPrey.profiles[name]) .. comma .. "\n")
  end

  table.insert(lines, "  }\n")
  table.insert(lines, "}")

  return table.concat(lines)
end

local function decodeSharedAutoPrey(text)
  text = tostring(text or "")
  local profiles = {}

  local body = text:match('"profiles"%s*:%s*{%s*(.-)%s*}%s*}') or text:match('"profiles"%s*:%s*{%s*(.-)%s*}')
  if body then
    for rawName, listBody in body:gmatch('"(.-)"%s*:%s*%[(.-)%]') do
      local name = sharedPreyNormalizeName(sharedPreyUnescape(rawName))
      if name ~= "" then
        profiles[name] = sharedPreyDecodeArray(listBody)
      end
    end
  end

  local hasProfile = false
  for _, _ in pairs(profiles) do
    hasProfile = true
    break
  end

  -- Compatibilidade com a versao anterior ruim:
  -- "profiles": [{ "name": "Cave", "monsters": [...] }]
  if not hasProfile then
    local profilesArrayBody = sharedPreyExtractArrayBody(text, "profiles")
    if profilesArrayBody then
      for _, obj in ipairs(sharedPreyCollectObjects(profilesArrayBody)) do
        local name = sharedPreyNormalizeName(sharedPreyDecodeStringKey(obj, "name"))
        local monstersBody = sharedPreyExtractArrayBody(obj, "monsters")
        if name ~= "" then
          profiles[name] = sharedPreyDecodeArray(monstersBody or "")
        end
      end
    end
  end

  hasProfile = false
  for _, _ in pairs(profiles) do
    hasProfile = true
    break
  end

  -- Compatibilidade simples com arquivo editado como:
  -- { "storages": ["Cave 1", "Cave 2"] }
  if not hasProfile then
    local storageBody = text:match('"storages"%s*:%s*%[(.-)%]')
    if storageBody then
      for rawName in storageBody:gmatch('"(.-)"') do
        local name = sharedPreyNormalizeName(sharedPreyUnescape(rawName))
        if name ~= "" then
          profiles[name] = {}
        end
      end
    end
  end

  return { profiles = profiles }
end

local function readSharedAutoPreyFile()
  if not initSharedAutoPreyPath() then return nil end
  if not g_resources or not g_resources.readFileContents then return nil end

  local ok, data = pcall(function()
    return g_resources.readFileContents(SHARED_AUTOPREY_FILE)
  end)

  if ok and type(data) == "string" and data ~= "" then
    return decodeSharedAutoPrey(data)
  end

  return nil
end

local function writeSharedAutoPreyFile()
  if not initSharedAutoPreyPath() then return false end
  if not g_resources or not g_resources.writeFileContents then return false end

  local ok = pcall(function()
    g_resources.writeFileContents(SHARED_AUTOPREY_FILE, encodeSharedAutoPrey())
  end)

  return ok == true
end

local function sharedAutoPreyHasProfiles()
  for _, _ in pairs(SharedAutoPrey.profiles or {}) do
    return true
  end
  return false
end

local function getSharedAutoPreyProfileNames()
  local names = {}
  for name, _ in pairs(SharedAutoPrey.profiles or {}) do
    table.insert(names, name)
  end

  table.sort(names, function(a, b)
    return tostring(a):lower() < tostring(b):lower()
  end)

  return names
end

local function ensureSharedAutoPreyProfile(name, list)
  name = sharedPreyNormalizeName(name)
  if name == "" then name = "Default" end

  if type(SharedAutoPrey.profiles[name]) ~= "table" then
    SharedAutoPrey.profiles[name] = sharedPreyCopyList(list or {})
  end

  return name
end

local function loadSharedAutoPreyProfiles()
  local data = readSharedAutoPreyFile()

  if data and type(data.profiles) == "table" then
    SharedAutoPrey.profiles = data.profiles
  else
    SharedAutoPrey.profiles = {}
  end

  if not sharedAutoPreyHasProfiles() then
    SharedAutoPrey.profiles.Default = sharedPreyCopyList(st.lists and st.lists[1] or {})
  end

  local selected = sharedPreyNormalizeName(st.selectedStorage)
  if selected == "" or type(SharedAutoPrey.profiles[selected]) ~= "table" then
    selected = getSharedAutoPreyProfileNames()[1] or "Default"
  end

  selected = ensureSharedAutoPreyProfile(selected, st.lists and st.lists[1] or {})

  st.selectedStorage = selected
  st.lists = st.lists or { [1] = {} }
  st.lists[1] = sharedPreyCopyList(SharedAutoPrey.profiles[selected])

  writeSharedAutoPreyFile()
  SharedAutoPrey.loaded = true
end

local function saveCurrentAutoPreyStorageList()
  local selected = ensureSharedAutoPreyProfile(st.selectedStorage, {})
  st.selectedStorage = selected
  SharedAutoPrey.profiles[selected] = sharedPreyCopyList(st.lists and st.lists[1] or {})
  writeSharedAutoPreyFile()
end

local function refreshAutoPreyStorageCombo()
  local combo = preyInterface and preyInterface.selectStorage
  if not combo then return end

  SharedAutoPrey.comboSilent = true

  if combo.clearOptions then
    pcall(function() combo:clearOptions() end)
  end

  local names = getSharedAutoPreyProfileNames()
  for _, name in ipairs(names) do
    pcall(function() combo:addOption(name) end)
  end

  local selected = sharedPreyNormalizeName(st.selectedStorage)
  if selected == "" then selected = names[1] or "Default" end

  if combo.setCurrentOption then
    pcall(function() combo:setCurrentOption(selected) end)
  end
  if combo.setOption then
    pcall(function() combo:setOption(selected) end)
  end

  SharedAutoPrey.comboSilent = false
end

local function setAutoPreyStorageInsertMode(enabled)
  SharedAutoPrey.insertMode = enabled == true

  if preyInterface and preyInterface.selectStorage then
    if SharedAutoPrey.insertMode then
      preyInterface.selectStorage:hide()
    else
      preyInterface.selectStorage:show()
    end
  end

  if preyInterface and preyInterface.nameStorage then
    if SharedAutoPrey.insertMode then
      preyInterface.nameStorage:show()
      preyInterface.nameStorage:setText("")
      if preyInterface.nameStorage.focus then
        preyInterface.nameStorage:focus()
      end
    else
      preyInterface.nameStorage:hide()
      preyInterface.nameStorage:setText("")
    end
  end
end

loadSharedAutoPreyProfiles()

savePreyChar()

-- ===============================
-- HELPERS
-- ===============================
local PREY_ACTION_LISTREROLL = 0
local PREY_ACTION_MONSTERSELECTION = 2

local function nowMillis()
  if g_clock and type(g_clock.millis) == "function" then
    return g_clock.millis()
  end
  if g_clock and type(g_clock.seconds) == "function" then
    return math.floor(g_clock.seconds() * 1000)
  end
  return os.time() * 1000
end

local function trim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim(s)
end

local function sameText(a, b)
  return normalizeText(a) == normalizeText(b)
end

local function capitalizeEachWord(str)
  return tostring(str or ""):gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
end

local function clamp(n, a, b)
  n = tonumber(n) or a
  if n < a then return a end
  if n > b then return b end
  return n
end

local function desiredList()
  st.lists[1] = st.lists[1] or {}
  return st.lists[1]
end

local function listHasDesired(name)
  name = normalizeText(name)
  if name == "" then return false end

  for _, v in ipairs(desiredList()) do
    if normalizeText(v) == name then
      return true
    end
  end

  return false
end

-- ===============================
-- MONSTER LIST UI
-- ===============================
local mobRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: false
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  Label
    id: mobName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    color: white
    text: ""

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: X
    color: #FF4040
]]

local function sortMonsterList()
  table.sort(st.lists[1], function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
end

local function refreshMobList()
  local listW = preyInterface.panelPreyList1
  if not listW then return end

  if listW.destroyChildren then
    listW:destroyChildren()
  else
    local ch = listW:getChildren()
    for i = #ch, 1, -1 do
      ch[i]:destroy()
    end
  end

  sortMonsterList()

  for _, mobName in ipairs(st.lists[1]) do
    local row = g_ui.loadUIFromString(mobRowTemplate, listW)
    row.mobName:setText(mobName)

    row.remove.onClick = function()
      local newList = {}
      for _, v in ipairs(st.lists[1]) do
        if not sameText(v, mobName) then
          table.insert(newList, v)
        end
      end
      st.lists[1] = newList
      saveCurrentAutoPreyStorageList()
      savePreyChar()
      refreshMobList()
    end
  end
end

local function addMobFromInput()
  local edit = preyInterface.inserirMobName1
  if not edit then return end

  local name = trim(edit:getText())
  if name == "" then return end

  local pretty = capitalizeEachWord(name)

  for _, v in ipairs(st.lists[1]) do
    if sameText(v, pretty) then
      edit:setText("")
      return
    end
  end

  table.insert(st.lists[1], pretty)
  edit:setText("")
  saveCurrentAutoPreyStorageList()
  savePreyChar()
  refreshMobList()
end

if preyInterface.buttonAdd then
  preyInterface.buttonAdd.onClick = addMobFromInput
end

if preyInterface.inserirMobName1 then
  preyInterface.inserirMobName1.onKeyPress = function(widget, keyCode)
    if keyCode == KeyEnter or keyCode == KeyReturn then
      addMobFromInput()
      return true
    end
    return false
  end
end


-- ===============================
-- STORAGE / CAVE SELECTOR UI
-- 1 clique no Insert = abre TextEdit.
-- 2 clique no Insert = salva o nome e volta para ComboBox.
-- ===============================
local function selectAutoPreyStorage(name)
  name = sharedPreyNormalizeName(name)
  if name == "" then return end

  ensureSharedAutoPreyProfile(name, {})
  st.selectedStorage = name
  st.lists = st.lists or { [1] = {} }
  st.lists[1] = sharedPreyCopyList(SharedAutoPrey.profiles[name])

  savePreyChar()
  writeSharedAutoPreyFile()
  refreshAutoPreyStorageCombo()
  refreshMobList()
end

refreshAutoPreyStorageCombo()
setAutoPreyStorageInsertMode(false)

if preyInterface.selectStorage then
  preyInterface.selectStorage.onOptionChange = function(_, option)
    if SharedAutoPrey.comboSilent then return end

    local text = option
    if type(option) == "table" and option.text then
      text = option.text
    end

    selectAutoPreyStorage(text)
  end
end

local function finishAutoPreyStorageInsert()
  local name = sharedPreyNormalizeName(preyInterface.nameStorage and preyInterface.nameStorage:getText() or "")
  if name ~= "" then
    selectAutoPreyStorage(name)
  end

  setAutoPreyStorageInsertMode(false)
  refreshAutoPreyStorageCombo()
end

if preyInterface.addStorage then
  preyInterface.addStorage.onClick = function()
    if not SharedAutoPrey.insertMode then
      setAutoPreyStorageInsertMode(true)
      return
    end

    finishAutoPreyStorageInsert()
  end
end

if preyInterface.nameStorage then
  preyInterface.nameStorage.onKeyPress = function(widget, keyCode)
    if keyCode == KeyEnter or keyCode == KeyReturn then
      finishAutoPreyStorageInsert()
      return true
    end
    return false
  end
end

-- ===============================
-- DELAY / RETRY UI
-- ===============================
local function applyDelayLabel()
  preyInterface.delayMsValue:setText(tostring(math.floor(st.delayMs)) .. "ms")
end

preyInterface.delayRetries:setValue(clamp(st.delayMs, 0, 5000))
applyDelayLabel()

preyInterface.delayRetries.onValueChange = function(_, value)
  st.delayMs = clamp(value, 0, 5000)
  applyDelayLabel()
  savePreyChar()
end

preyInterface.maxRetriesPrey:setValue(clamp(st.maxRetries, 0, 9999))
preyInterface.maxRetriesPrey.onValueChange = function(_, value)
  st.maxRetries = clamp(value, 0, 9999)
  savePreyChar()
end

-- ===============================
-- SLOT SWITCH UI
-- ===============================
local function getSlotSwitchWidget(i)
  if i == 1 then return preyInterface.ativarPrey1, preyInterface.labelPrey1 end
  if i == 2 then return preyInterface.ativarPrey2, preyInterface.labelPrey2 end
  if i == 3 then return preyInterface.ativarPrey3, preyInterface.labelPrey3 end
  return nil, nil
end

local function applySwitchUI(i)
  local w, lbl = getSlotSwitchWidget(i)
  if not w or not lbl then return end

  if st.enabled[i] == true then
    w:setImageSource("/images/game/prey/prey_select")
  else
    w:setImageSource("/images/game/prey/prey_select_blocked")
  end

  lbl:setText("Prey " .. i)
end

local function bindSwitch(i)
  local w = getSlotSwitchWidget(i)
  if not w then return end

  w.onClick = function()
    st.enabled[i] = not (st.enabled[i] == true)
    savePreyChar()
    applySwitchUI(i)
  end
end

for i = 1, 3 do
  bindSwitch(i)
  applySwitchUI(i)
end

refreshMobList()

-- ===============================
-- PREY CORE - BASEADO NO TRACKER
-- ===============================
local currentRolls = { [0] = 0, [1] = 0, [2] = 0 }
local lastActionAt = { [0] = 0, [1] = 0, [2] = 0 }

local function mainEnabled()
  return autoPreyStorage[switchPrey] and autoPreyStorage[switchPrey].enabled == true
end

local function slotEnabled(slotIndex)
  return mainEnabled() and st.enabled[slotIndex + 1] == true
end

local function canAction(slotIndex)
  local t = nowMillis()
  local delay = tonumber(st.delayMs) or 400
  if delay < 100 then delay = 100 end

  if t - (lastActionAt[slotIndex] or 0) < delay then
    return false
  end

  lastActionAt[slotIndex] = t
  return true
end

local function getPreyTracker()
  return modules.game_prey and modules.game_prey.preyTracker
end

local function getPreyWindow()
  return modules.game_prey and modules.game_prey.preyWindow
end

local function getSlotObjects(slotIndex)
  local tracker = getPreyTracker()
  local window = getPreyWindow()

  if not tracker or not tracker.contentsPanel then return nil, nil end
  if not window then return nil, nil end

  local slotName = "slot" .. tostring(slotIndex + 1)
  return tracker.contentsPanel[slotName], window[slotName]
end

local function getSlotCreatureName(windowSlot)
  if not windowSlot or not windowSlot.title or not windowSlot.title.getText then
    return ""
  end

  local ok, text = pcall(function()
    return windowSlot.title:getText()
  end)

  if ok then
    return normalizeText(text)
  end

  return ""
end

local function getSlotPercent(trackerSlot)
  if not trackerSlot or not trackerSlot.time or not trackerSlot.time.getPercent then
    return nil
  end

  local ok, percent = pcall(function()
    return trackerSlot.time:getPercent()
  end)

  if ok then
    return tonumber(percent)
  end

  return nil
end

local function getCreatureNameFromTracker(trackerSlot)
  if not trackerSlot or not trackerSlot.creature or not trackerSlot.creature.getTooltip then
    return ""
  end

  local ok, tip = pcall(function()
    return trackerSlot.creature:getTooltip()
  end)

  if not ok or not tip then return "" end

  local name = tostring(tip):match("Creature:%s*([^\n]+)")
  return normalizeText(name or "")
end

local function rerollSlot(slotIndex)
  if not canAction(slotIndex) then return false end

  currentRolls[slotIndex] = (currentRolls[slotIndex] or 0) + 1
  if currentRolls[slotIndex] > (tonumber(st.maxRetries) or 15) then
    return false
  end

  g_game.preyAction(slotIndex, PREY_ACTION_LISTREROLL, 0)
  return true
end

local function selectMonster(slotIndex, optionIndex)
  if not canAction(slotIndex) then return false end

  currentRolls[slotIndex] = 0
  g_game.preyAction(slotIndex, PREY_ACTION_MONSTERSELECTION, optionIndex)
  return true
end

local function handleSelectMonster(slotIndex, windowSlot)
  if not windowSlot or not windowSlot.inactive or not windowSlot.inactive.list then
    return false
  end

  local children = windowSlot.inactive.list:getChildren() or {}

  for j, child in ipairs(children) do
    local name = ""
    if child.getTooltip then
      local ok, tip = pcall(function()
        return child:getTooltip()
      end)
      if ok then name = tip or "" end
    end

    if listHasDesired(name) then
      return selectMonster(slotIndex, j - 1)
    end
  end

  return rerollSlot(slotIndex)
end

local function handleActivePrey(slotIndex, trackerSlot, creatureName)
  local percent = getSlotPercent(trackerSlot)
  if not percent then return false end

  if not listHasDesired(creatureName) then
    return false
  end

  if percent <= 5 then
    currentRolls[slotIndex] = 0
    return rerollSlot(slotIndex)
  end

  currentRolls[slotIndex] = 0
  return false
end

local preyOpenedByScript = false

macro(400, function()
  if not mainEnabled() then
    preyOpenedByScript = false
    return
  end

  if #desiredList() == 0 then return end

  if not preyOpenedByScript and modules.game_prey and modules.game_prey.show then
    modules.game_prey.show()
    preyOpenedByScript = true

    schedule(500, function()
      if modules.game_prey and modules.game_prey.hide then
        modules.game_prey.hide()
      end
    end)
  end

  for slotIndex = 0, 2 do
    if slotEnabled(slotIndex) then
      local trackerSlot, windowSlot = getSlotObjects(slotIndex)
      if trackerSlot and windowSlot then
        local creatureName = getSlotCreatureName(windowSlot)

        if creatureName == "select monster" then
          if handleSelectMonster(slotIndex, windowSlot) then
            return
          end
        else
          local trackerCreatureName = getCreatureNameFromTracker(trackerSlot)
          if trackerCreatureName ~= "" then
            creatureName = trackerCreatureName
          end

          if handleActivePrey(slotIndex, trackerSlot, creatureName) then
            return
          end
        end
      end
    end
  end
end)

UI.Separator()
end)

lnsRunBlock("BUYMARKET", function()

setDefaultTab("Main")

-- ===============================
-- STORAGE GLOBAL
-- ===============================
storage = storage or {}
storage.LNSBuyMarketGlobal = storage.LNSBuyMarketGlobal or {}

local buyMarketStorage = storage.LNSBuyMarketGlobal

local function saveBuyMarketGlobal()
  storage.LNSBuyMarketGlobal = buyMarketStorage
end

local function saveImbuementsChar()
  saveBuyMarketGlobal()
end

local MARKET_STORAGE_KEY = "lns_buy_market_v2"
local DEPOT_IDS = { [3497]=true, [3498]=true, [3499]=true, [2594]=true }
local MARKET_ID = 12903
local MAIL_ID = 12902

-- =========================
-- BASE
-- =========================
local function deepCopy(t)
  if type(t) ~= "table" then return t end
  local r = {}
  for k, v in pairs(t) do r[k] = deepCopy(v) end
  return r
end

local function mergeDefaults(dst, def)
  if type(dst) ~= "table" then dst = {} end
  for k, v in pairs(def) do
    if dst[k] == nil then
      dst[k] = deepCopy(v)
    elseif type(v) == "table" and type(dst[k]) == "table" then
      dst[k] = mergeDefaults(dst[k], v)
    end
  end
  return dst
end

local function clamp(n, a, b)
  n = tonumber(n) or a
  if n < a then return a end
  if n > b then return b end
  return n
end

local function trim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalize(s)
  return trim(tostring(s or ""):lower():gsub("%s+", " "))
end

local function ms()
  if g_clock and g_clock.millis then return g_clock.millis() end
  if g_clock and g_clock.seconds then return math.floor(g_clock.seconds() * 1000) end
  return os.time() * 1000
end

local function safeChildren(w)
  if not w or not w.getChildren then return {} end
  local ok, c = pcall(function() return w:getChildren() end)
  return ok and c or {}
end

local function clearChildren(w)
  local c = safeChildren(w)
  for i = #c, 1, -1 do
    local child = c[i]
    if child and not child:isDestroyed() then child:destroy() end
  end
end

local function safeText(w)
  if not w or not w.getText then return nil end
  local ok, t = pcall(function() return w:getText() end)
  return ok and t or nil
end

local function safeVisible(w)
  if not w then return false end
  if w.isVisible then
    local ok, v = pcall(function() return w:isVisible() end)
    if ok then return v end
  end
  if w.isHidden then
    local ok, h = pcall(function() return w:isHidden() end)
    if ok then return not h end
  end
  return true
end

local function safeEnabled(w)
  if not w then return false end
  if w.isEnabled then
    local ok, v = pcall(function() return w:isEnabled() end)
    if ok then return v end
  end
  return true
end

local function click(w)
  if not w then return false end
  if w.click and pcall(function() w:click() end) then return true end
  if w.onClick and pcall(function() w:onClick() end) then return true end
  pcall(function() w:onMousePress({x=5,y=5}, 1) end)
  if w.onMouseRelease and pcall(function() w:onMouseRelease({x=5,y=5}, 1) end) then return true end
  return false
end

local function focus(w)
  if w and w.focus then pcall(function() w:focus() end) end
end

local function setText(w, text)
  if not w or not w.setText then return false end
  return pcall(function() w:setText(text) end)
end

local function parseNumber(v)
  local n = tostring(v or ""):gsub("[^%d]", "")
  return n ~= "" and tonumber(n) or nil
end

local function rfind(w, id)
  if not w then return nil end
  if w.recursiveGetChildById then
    local ok, child = pcall(function() return w:recursiveGetChildById(id) end)
    if ok and child then return child end
  end
  for _, c in ipairs(safeChildren(w)) do
    local found = rfind(c, id)
    if found then return found end
  end
  return nil
end

local function getBotItemId(w)
  if not w then return 0 end
  if w.getItemId then return tonumber(w:getItemId()) or 0 end
  if w.getItem and w:getItem() and w:getItem().getId then
    return tonumber(w:getItem():getId()) or 0
  end
  return 0
end

local function setBotItemId(w, id)
  if not w then return end
  id = tonumber(id) or 0
  if w.setItemId then
    w:setItemId(id)
    return
  end
  if w.setItem and Item and Item.create and id > 0 then
    w:setItem(Item.create(id, 1))
  end
end

local function getWidgetItemId(widget)
  if not widget then return nil end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and id then return id end
    end
  end

  if widget.item and widget.item.getId then
    local ok, id = pcall(function() return widget.item:getId() end)
    if ok and id then return id end
  end

  if widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and id then return id end
  end

  return nil
end

local function findWidgetByItemId(widget, wantedId)
  if not widget then return nil end
  if getWidgetItemId(widget) == wantedId then return widget end
  for _, child in ipairs(safeChildren(widget)) do
    local found = findWidgetByItemId(child, wantedId)
    if found then return found end
  end
  return nil
end

local function posEq(a, b)
  return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function mapDist(a, b)
  return getDistanceBetween and getDistanceBetween(a, b) or math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function topThing(tile)
  if not tile or not tile.getTopUseThing then return nil end
  local ok, thing = pcall(function() return tile:getTopUseThing() end)
  return ok and thing or nil
end

local function topId(tile)
  local thing = topThing(tile)
  if not thing or not thing.getId then return nil end
  local ok, id = pcall(function() return thing:getId() end)
  return ok and id or nil
end

local function hasOtherPlayer(tile)
  if not tile or not tile.getCreatures then return false end
  local ok, list = pcall(function() return tile:getCreatures() end)
  if not ok or not list then return false end
  local me = player:getName()
  for _, c in ipairs(list) do
    if c and c.isPlayer and c:isPlayer() and c:getName() ~= me then
      return true
    end
  end
  return false
end

local function canStand(pos)
  local tile = g_map.getTile(pos)
  -- Apagamos a checagem de outros players aqui:
  if not tile then return false end 
  if posEq(player:getPosition(), pos) then return true end
  if tile.isWalkable then
    local ok, v = pcall(function() return tile:isWalkable() end)
    return ok and v or false
  end
  return false
end

local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then return root:recursiveGetChildById(id) end
  if root.getChildById then return root:getChildById(id) end
  return nil
end

-- =========================
-- ITEM NAMES
-- =========================
local function safeRead(path)
  if not g_resources or not g_resources.readFileContents then
    return nil
  end
  local ok, content = pcall(function() return g_resources.readFileContents(path) end)
  if not ok or not content or content == "" then return nil end
  return content
end

local function loadLootItems()
  local cfgName = (type(MyConfigName) == "string" and MyConfigName ~= "" and MyConfigName) or "CUSTOM"
  local content =
    safeRead("/bot/" .. cfgName .. "/loot_items.lua") or
    safeRead("/bot/" .. cfgName .. "/loot_items") or
    safeRead("loot_items.lua")

  if not content then
    return {}
  end

  local list, seen = {}, {}
  for name, idStr in content:gmatch('%["(.-)"%]%s*=%s*(%d+)') do
    local id = tonumber(idStr)
    if id and not seen[id] then
      seen[id] = true
      list[#list + 1] = { name = tostring(name), id = id }
    end
  end

  table.sort(list, function(a, b) return (a.id or 0) < (b.id or 0) end)
  return list
end

local itemNameById = {}
for _, e in ipairs(loadLootItems()) do
  if e.id and e.name and e.name ~= "" then
    itemNameById[e.id] = e.name
  end
end

local function getItemDisplayName(itemId)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return "Unknown Item" end
  return itemNameById[itemId] or ("Item ID " .. itemId)
end

-- =========================
-- STORAGE
-- =========================
local function defaultMarketCfg()
  return {
    list = {},
    draft = {
      itemId = 0,
      name = "",
      amount = 1,
      maxPrice = 1
    }
  }
end

buyMarketStorage[MARKET_STORAGE_KEY] = mergeDefaults(buyMarketStorage[MARKET_STORAGE_KEY], defaultMarketCfg())
local marketCfg = buyMarketStorage[MARKET_STORAGE_KEY]
if type(marketCfg.list) ~= "table" then marketCfg.list = {} end
marketCfg.draft = marketCfg.draft or { itemId = 0, name = "", amount = 1, maxPrice = 1 }

saveImbuementsChar()

marketInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 380 320
  anchors.centerIn: parent
  margin-top: -50
  text: Panel Buy Market
  opacity: 1.00

  UIButton
    id: clickHere
    anchors.top: parent.top
    anchors.left: parent.left
    text: Click Here
    margin-top: 0
    margin-left: 65
    color: #FFD700
    font: verdana-11px-rounded
    text-auto-resize: true
    opacity: 1.00
    $hover:
      opacity: 0.80

  Label
    id: labelClick
    anchors.verticalCenter: clickHere.verticalCenter
    anchors.left: clickHere.right
    margin-left: 5
    text: to manager buy market
    text-auto-resize: true
    font: verdana-11px-rounded

  TextList
    id: marketList
    anchors.top: clickHere.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -5
    margin-top: 5
    margin-right: 6
    margin-bottom: 20
    vertical-scrollbar: marketListScrollBar

  VerticalScrollBar
    id: marketListScrollBar
    anchors.top: marketList.top
    anchors.bottom: marketList.bottom
    anchors.left: marketList.right
    step: 10
    pixels-scroll: true

  Button
    id: closePanel
    anchors.left: marketList.left
    anchors.right: marketListScrollBar.right
    anchors.top: marketList.bottom
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())
marketInterface:hide()

marketAdd = setupUI([=[
MainWindow
  id: mainPanel
  size: 300 125
  anchors.centerIn: parent
  margin-top: -60
  opacity: 1.00
  text: Insert Item to Buy Market

  Panel
    anchors.fill: parent
    margin-top: 0
    opacity: 0.88

  FlatPanel
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: -2
    image-border: 1

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: " #           Quantify          Max Price"
      text-auto-resize: true
      font: verdana-11px-rounded
      margin-top: 2

    HorizontalSeparator
      id: sepp
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-left: 2
      margin-top: 1
      margin-right: 2

  BotItem
    id: itemMarket
    anchors.top: topBar.top
    anchors.left: parent.left
    margin-top: 25
    margin-left: 15

  SpinBox
    id: amount
    anchors.verticalCenter: itemMarket.verticalCenter
    anchors.left: itemMarket.right
    width: 90
    margin-left: 18
    text-align: center
    minimum: 1
    maximum: 1000000000
    step: 1
    editable: true
    focusable: true

  SpinBox
    id: maxprice
    anchors.verticalCenter: itemMarket.verticalCenter
    anchors.left: amount.right
    width: 90
    margin-left: 15
    text-align: center
    minimum: 1
    maximum: 1000000000
    step: 1
    editable: true
    focusable: true

  Button
    id: cancelarBt
    anchors.left: topBar.left
    anchors.top: topBar.bottom
    size: 125 20
    margin-top: 5
    text: Cancel

  Button
    id: adicionarBt
    anchors.right: topBar.right
    anchors.top: cancelarBt.top
    size: 125 20
    text: Insert
]=], g_ui.getRootWidget())
marketAdd:hide()

local marketList = W(marketInterface, "marketList")
local marketClose = W(marketInterface, "closePanel")
local marketClickHere = W(marketInterface, "clickHere")

local addItemBot = W(marketAdd, "itemMarket")
local addAmount = W(marketAdd, "amount")
local addMaxPrice = W(marketAdd, "maxprice")
local addCancel = W(marketAdd, "cancelarBt")
local addConfirm = W(marketAdd, "adicionarBt")

local editingIndex = nil

local rowTemplate = [[
UIWidget
  id: root
  height: 40
  focusable: true
  background-color: alpha

  $hover:
    background-color: #2F2F2F
    opacity: 0.80

  $focus:
    background-color: #404040
    opacity: 0.90

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 14
    height: 14
    margin-left: 4
    image-source: /images/ui/checkbox_round

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    size: 38 38

  Label
    id: itemName
    anchors.left: icon.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    font: verdana-9px
    color: white

  Label
    id: amountText
    anchors.left: itemName.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-9px
    color: white
    text-auto-resize: true

  Label
    id: priceText
    anchors.left: amountText.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    font: verdana-9px
    color: white
    text-auto-resize: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 3
    text: X
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

local function resetDraft()
  editingIndex = nil
  marketCfg.draft.itemId = 0
  marketCfg.draft.name = ""
  marketCfg.draft.amount = 1
  marketCfg.draft.maxPrice = 1
  if addItemBot then setBotItemId(addItemBot, 0) end
  if addAmount then addAmount:setValue(1) end
  if addMaxPrice then addMaxPrice:setValue(1) end
  saveImbuementsChar()
end

local function loadDraft()
  if addItemBot then setBotItemId(addItemBot, marketCfg.draft.itemId or 0) end
  if addAmount then addAmount:setValue(clamp(marketCfg.draft.amount or 1, 1, 1000000000)) end
  if addMaxPrice then addMaxPrice:setValue(clamp(marketCfg.draft.maxPrice or 1, 1, 1000000000)) end
end

local function refreshMarketList()
  if not marketList then return end
  clearChildren(marketList)

  for i, entry in ipairs(marketCfg.list) do
    entry.enabled = (entry.enabled ~= false)
    entry.itemId = tonumber(entry.itemId or 0) or 0
    entry.name = tostring(entry.name or getItemDisplayName(entry.itemId))
    entry.amount = clamp(entry.amount or 1, 1, 1000000000)
    entry.maxPrice = clamp(entry.maxPrice or 1, 1, 1000000000)

    local row = setupUI(rowTemplate, marketList)
    row.entryIndex = i
    row.enabled:setChecked(entry.enabled)

    row.enabled.onClick = function()
      entry.enabled = not entry.enabled
      row.enabled:setChecked(entry.enabled)
      saveImbuementsChar()
    end

    if row.icon and row.icon.setItemId then
      row.icon:setItemId(entry.itemId)
    elseif row.icon and row.icon.setItem and Item and Item.create and entry.itemId > 0 then
      row.icon:setItem(Item.create(entry.itemId, 1))
    end

    row.itemName:setText("[" .. string.upper(entry.name):sub(1, 12) .. "]")
    row.amountText:setText("[AMOUNT: " .. tostring(entry.amount) .. "]")
    row.priceText:setText("[MAX PRICE: " .. tostring(entry.maxPrice) .. "]")

    row.remove.onClick = function()
      table.remove(marketCfg.list, row.entryIndex)
      if editingIndex == row.entryIndex then editingIndex = nil end
      refreshMarketList()
      saveImbuementsChar()
    end

    row.onClick = function(widget)
      if marketList.focusChild then marketList:focusChild(widget) end
    end

    row.onDoubleClick = function(widget)
      local idx = widget.entryIndex
      local e = marketCfg.list[idx]
      if not e then return end

      editingIndex = idx
      marketCfg.draft.itemId = tonumber(e.itemId or 0) or 0
      marketCfg.draft.name = tostring(e.name or getItemDisplayName(e.itemId))
      marketCfg.draft.amount = clamp(e.amount or 1, 1, 1000000000)
      marketCfg.draft.maxPrice = clamp(e.maxPrice or 1, 1, 1000000000)

      loadDraft()
      marketInterface:hide()
      marketAdd:show()
      marketAdd:raise()
      marketAdd:focus()
    end
  end
end

if addItemBot and addItemBot.onItemChange then
  addItemBot.onItemChange = function(widget)
    local itemId = getBotItemId(widget)
    marketCfg.draft.itemId = itemId
    marketCfg.draft.name = getItemDisplayName(itemId)
    saveImbuementsChar()
  end
end

if addAmount then
  addAmount.onValueChange = function(widget, value)
    local v = tonumber(value)
    if not v and widget.getValue then v = tonumber(widget:getValue()) end
    marketCfg.draft.amount = clamp(v or 1, 1, 1000000000)
    saveImbuementsChar()
  end
end

if addMaxPrice then
  addMaxPrice.onValueChange = function(widget, value)
    local v = tonumber(value)
    if not v and widget.getValue then v = tonumber(widget:getValue()) end
    marketCfg.draft.maxPrice = clamp(v or 1, 1, 1000000000)
    saveImbuementsChar()
  end
end

if marketClickHere then
  marketClickHere.onClick = function()
    editingIndex = nil
    loadDraft()
    marketInterface:hide()
    marketAdd:show()
    marketAdd:raise()
    marketAdd:focus()
  end
end

if marketClose then
  marketClose.onClick = function()
    marketInterface:hide()
  end
end

if addCancel then
  addCancel.onClick = function()
    marketAdd:hide()
    marketInterface:show()
    marketInterface:raise()
    marketInterface:focus()
    resetDraft()
    saveImbuementsChar()
  end
end

if addConfirm then
  addConfirm.onClick = function()
    local itemId = getBotItemId(addItemBot)
    local amount = clamp(addAmount and addAmount:getValue() or 1, 1, 1000000000)
    local maxPrice = clamp(addMaxPrice and addMaxPrice:getValue() or 1, 1, 1000000000)

    if itemId <= 0 then
      return
    end

    local resolvedName = getItemDisplayName(itemId)
    if editingIndex and marketCfg.list[editingIndex] and resolvedName:find("^Item ID ") then
      resolvedName = tostring(marketCfg.list[editingIndex].name or resolvedName)
    end

    local entry = {
      enabled = true,
      itemId = itemId,
      name = resolvedName,
      amount = amount,
      maxPrice = maxPrice
    }

    if editingIndex and marketCfg.list[editingIndex] then
      entry.enabled = (marketCfg.list[editingIndex].enabled ~= false)
      marketCfg.list[editingIndex] = entry
    else
      table.insert(marketCfg.list, entry)
    end

    refreshMarketList()
    resetDraft()
    saveImbuementsChar()

    marketAdd:hide()
    marketInterface:show()
    marketInterface:raise()
    marketInterface:focus()
  end
end

loadDraft()
refreshMarketList()

-- =========================
-- MARKET UI
-- =========================
local function getMarketUI()
  if not rootWidget or not rootWidget.recursiveGetChildById then return nil end
  local m = rootWidget:recursiveGetChildById("marketWindow")
  if not m then return nil end
  return {
    market = m,
    searchEdit = m:recursiveGetChildById("searchEdit"),
    filterSearchAll = m:recursiveGetChildById("filterSearchAll"),
    itemsPanel = m:recursiveGetChildById("itemsPanel"),
    sellingTable = m:recursiveGetChildById("sellingTable"),
    sellingTableData = m:recursiveGetChildById("sellingTableData"),
    buyButton = m:recursiveGetChildById("buyButton"),
  }
end

local function closeMarketWindow()
  if modules and modules.game_market and modules.game_market.hide then
    local ok = pcall(function() modules.game_market.hide() end)
    if ok then return true end
  end

  local ui = getMarketUI()
  if not ui or not ui.market then return false end

  local closeBtn =
    ui.market:recursiveGetChildById("closeButton") or
    ui.market:recursiveGetChildById("closePanel") or
    ui.market:recursiveGetChildById("closeButtonTop")

  if closeBtn and click(closeBtn) then return true end
  if ui.market.hide then
    local ok = pcall(function() ui.market:hide() end)
    if ok then return true end
  end
  return false
end

local function marketReady()
  local ui = getMarketUI()
  if not ui or not ui.market then return nil end
  if ui.market.isHidden then
    local ok, hidden = pcall(function() return ui.market:isHidden() end)
    if ok and hidden then return nil end
  end
  return ui
end

local function setSearchAll(ui)
  local btn = ui and ui.filterSearchAll
  if not btn then return end
  if btn.isChecked then
    local ok, checked = pcall(function() return btn:isChecked() end)
    if ok and checked then return end
  end
  if btn.setChecked then pcall(function() btn:setChecked(true) end) end
  click(btn)
end

local function collectItemBoxes(w, out)
  out = out or {}
  if not w then return out end

  local ok, hasItem = pcall(function()
    return w.item and w.item.marketData and w.item.marketData.name
  end)

  if ok and hasItem and safeVisible(w) then
    out[#out + 1] = w
  end

  for _, c in ipairs(safeChildren(w)) do
    collectItemBoxes(c, out)
  end
  return out
end

local function findItemBox(itemsPanel, itemName)
  local wanted = normalize(itemName)
  for _, box in ipairs(collectItemBoxes(itemsPanel, {})) do
    local ok, name = pcall(function() return tostring(box.item.marketData.name) end)
    if ok and normalize(name) == wanted then return box end
  end
  return nil
end

local function selectItemBox(box)
  if not box then return false end
  if box.setChecked then pcall(function() box:setChecked(true) end) end
  if box.onCheckChange and pcall(function() box:onCheckChange(true) end) then return true end
  return click(box)
end

local function rowLooksLikeOffer(row)
  if not row or not safeVisible(row) or row.ref == nil then return false end
  local ch = safeChildren(row)
  if #ch < 4 then return false end
  for i = 1, #ch do
    local t = safeText(ch[i])
    if t and t ~= "" then return true end
  end
  return false
end

local function collectOfferRows(w, out)
  out = out or {}
  if not w then return out end
  for _, c in ipairs(safeChildren(w)) do
    if rowLooksLikeOffer(c) then
      out[#out + 1] = c
    else
      collectOfferRows(c, out)
    end
  end
  return out
end

local function firstSellRow(ui)
  local base = ui and (ui.sellingTableData or ui.sellingTable)
  local rows = collectOfferRows(base, {})
  return rows[1]
end

local function getPiecePrice(row)
  local ch = safeChildren(row)
  if #ch < 4 then return nil end
  local v3 = parseNumber(safeText(ch[3]))
  local v4 = parseNumber(safeText(ch[4]))
  if v3 and v4 then return math.min(v3, v4) end
  return v3 or v4
end

local function deepClick(row)
  if click(row) then return true end
  for _, c in ipairs(safeChildren(row)) do
    if click(c) then return true end
  end
  return false
end

local function selectOffer(ui, row)
  if not ui or not ui.sellingTable or not row or row.ref == nil then return false end

  focus(ui.sellingTable)
  focus(row)

  pcall(function() row:setChecked(true) end)
  pcall(function() row:setOn(true) end)
  pcall(function() row:setSelected(true) end)

  deepClick(row)

  if type(ui.sellingTable.onSelectionChange) == "function" then
    pcall(function() ui.sellingTable.onSelectionChange(ui.sellingTable, row, nil) end)
  end

  deepClick(row)

  if ui.buyButton and safeEnabled(ui.buyButton) then return true end

  if row.isChecked then
    local ok, v = pcall(function() return row:isChecked() end)
    if ok and v then return true end
  end
  if row.isOn then
    local ok, v = pcall(function() return row:isOn() end)
    if ok and v then return true end
  end
  if row.isSelected then
    local ok, v = pcall(function() return row:isSelected() end)
    if ok and v then return true end
  end

  return false
end

local function findAmountPopup()
  if not rootWidget then return nil end
  local sb = rootWidget:recursiveGetChildById("amountScrollBar")
  if not sb then return nil end
  if sb.getParent then
    local ok, p = pcall(function() return sb:getParent() end)
    if ok then return p end
  end
  return nil
end

local function setPopupAmount(popup, amount)
  local sb = rfind(popup, "amountScrollBar")
  if not sb or not sb.setValue then return false end
  return pcall(function() sb:setValue(amount) end)
end

local function getPopupAmount(popup)
  local sb = rfind(popup, "amountScrollBar")
  if not sb or not sb.getValue then return nil end
  local ok, v = pcall(function() return sb:getValue() end)
  return ok and tonumber(v) or nil
end

local function popupConfirm(popup)
  return click(rfind(popup, "buttonOk"))
end

local function popupCancel(popup)
  return click(rfind(popup, "buttonCancel"))
end

-- =========================
-- INVENTORY / MAIL
-- =========================
local function getAllContainers()
  if g_game and g_game.getContainers then
    local ok, containers = pcall(function() return g_game:getContainers() end)
    if ok and containers then return containers end
  end
  return {}
end

local function getContainerName(container)
  if not container or not container.getName then return "" end
  local ok, name = pcall(function() return tostring(container:getName() or "") end)
  return ok and name or ""
end

local function getContainerItems(container)
  if not container or not container.getItems then return {} end
  local ok, items = pcall(function() return container:getItems() end)
  return ok and items or {}
end

local function isBlockedContainerName(name)
  name = normalize(name)
  return name:find("your inbox", 1, true)
      or name:find("inbox", 1, true)
      or name:find("locker", 1, true)
      or name:find("depot", 1, true)
end

local function findMailContainer()
  for _, c in pairs(getAllContainers()) do
    if normalize(getContainerName(c)):find("inbox", 1, true) then
      return c
    end
  end
  return nil
end

local function getAnyOpenLootContainer()
  for _, c in pairs(getAllContainers()) do
    if not isBlockedContainerName(getContainerName(c)) then
      return c
    end
  end
  return nil
end

local function ensureLootContainerOpen()
  if getAnyOpenLootContainer() then return true end

  local playerObj = g_game.getLocalPlayer()
  if not playerObj or not playerObj.getInventoryItem or not InventorySlotFirst or not InventorySlotLast then
    return false
  end

  for slot = InventorySlotFirst, InventorySlotLast do
    local ok, item = pcall(function() return playerObj:getInventoryItem(slot) end)
    if ok and item then
      local idOk, itemId = pcall(function() return item:getId() end)
      if idOk and itemId and itemId > 0 then
        pcall(function() g_game.open(item) end)
      end
    end
  end

  schedule(150, function() end)
  return getAnyOpenLootContainer() ~= nil
end

local function getContainerDropPosition(container)
  if not container then return nil end

  if container.getItemsCount and container.getSlotPosition then
    local okCount, itemsCount = pcall(function() return container:getItemsCount() end)
    if okCount and tonumber(itemsCount) then
      local okPos, pos = pcall(function() return container:getSlotPosition(itemsCount) end)
      if okPos and pos then return pos end
    end
  end

  if container.getSlotPosition then
    local okPos, pos = pcall(function() return container:getSlotPosition(0) end)
    if okPos and pos then return pos end
  end

  return nil
end

local function moveItemToContainer(item, count, container)
  if not item or not container or not g_game or not g_game.move then return false end
  local pos = getContainerDropPosition(container)
  if not pos then return false end
  count = tonumber(count) or 1
  return pcall(function() g_game.move(item, pos, count) end)
end

local function getItemStackCount(item)
  if not item then return 0 end
  if item.getCount then
    local ok, c = pcall(function() return item:getCount() end)
    if ok and tonumber(c) then
      c = tonumber(c)
      if c > 1 then return c end
    end
  end
  return 1
end

local function countItemOpenContainersAndInventory(itemId)
  local total = 0
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return 0 end

  local playerObj = g_game.getLocalPlayer()
  if playerObj and playerObj.getInventoryItem and InventorySlotFirst and InventorySlotLast then
    for slot = InventorySlotFirst, InventorySlotLast do
      local ok, item = pcall(function() return playerObj:getInventoryItem(slot) end)
      if ok and item and item.getId then
        local ok2, id = pcall(function() return item:getId() end)
        if ok2 and tonumber(id) == itemId then
          total = total + getItemStackCount(item)
        end
      end
    end
  end

  for _, container in pairs(getAllContainers()) do
    for _, item in ipairs(getContainerItems(container)) do
      if item and item.getId then
        local ok3, id = pcall(function() return item:getId() end)
        if ok3 and tonumber(id) == itemId then
          total = total + getItemStackCount(item)
        end
      end
    end
  end

  return total
end

local function getOwnedAmount(itemId)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return 0 end

  if type(itemAmount) == "function" then
    local ok, amount = pcall(function() return itemAmount(itemId) end)
    if ok and tonumber(amount) then
      return math.max(0, tonumber(amount))
    end
  end

  return countItemOpenContainersAndInventory(itemId)
end

local function buildAllowedMailItemOrder()
  local list, seen = {}, {}
  for _, entry in ipairs(marketCfg.list or {}) do
    if entry.enabled ~= false then
      local id = tonumber(entry.itemId or 0) or 0
      if id > 0 and not seen[id] then
        seen[id] = true
        list[#list + 1] = id
      end
    end
  end
  return list
end

local function findFirstAllowedItemInMailById(mail, wantedId)
  wantedId = tonumber(wantedId) or 0
  if wantedId <= 0 then return nil end

  for _, item in ipairs(getContainerItems(mail)) do
    if item and item.getId then
      local ok, id = pcall(function() return item:getId() end)
      id = ok and tonumber(id) or 0
      if id == wantedId then
        return item
      end
    end
  end

  return nil
end

local function collectAllowedMailItems(targetItemId)
  local mail = findMailContainer()
  if not mail then return "error", "mail container nao encontrado" end

  local dest = getAnyOpenLootContainer()
  if not dest then
    local opened = ensureLootContainerOpen()
    if opened then
      return "ensure_loot", nil
    end
    return "error", "nenhum container aberto"
  end

  local targetId = tonumber(targetItemId) or 0
  if targetId <= 0 then
    return "done_item", nil
  end

  local item = findFirstAllowedItemInMailById(mail, targetId)
  if not item then
    return "done_item", nil
  end

  local count = getItemStackCount(item)
  if moveItemToContainer(item, count, dest) then
    return "moved", nil, targetId, count
  end

  return "move_failed", "falha ao mover item id " .. tostring(targetId), targetId, count
end

-- =========================
-- DEPOT / LOCKER
-- =========================
local function bestDepot(range)
  local me = g_game.getLocalPlayer()
  if not me then return nil end
  local p = me:getPosition()
  if not p then return nil end

  local best
  local fallbackCurrent
  local offs = {{0,1},{0,-1},{1,0},{-1,0},{1,1},{-1,1},{1,-1},{-1,-1}}

  for x = -range, range do
    for y = -range, range do
      local dp = {x = p.x + x, y = p.y + y, z = p.z}
      local tile = g_map.getTile(dp)

      if tile and DEPOT_IDS[topId(tile)] then
        local foundStand = false

        for i = 1, #offs do
          local sp = {x = dp.x + offs[i][1], y = dp.y + offs[i][2], z = dp.z}
          if canStand(sp) then
            foundStand = true
            local d = mapDist(p, sp)
            if not best or d < best.d then
              best = { d = d, stand = sp, depot = dp }
            end
          end
        end

        -- fallback especial:
        -- se eu já estou colado no depot, aceita usar da posição atual
        if not foundStand and mapDist(p, dp) <= 1 then
          local d = mapDist(p, dp)
          if not fallbackCurrent or d < fallbackCurrent.d then
            fallbackCurrent = { d = d, stand = p, depot = dp }
          end
        end
      end
    end
  end

  return best or fallbackCurrent
end

local function useDepotAt(pos)
  local tile = g_map.getTile(pos)
  local thing = tile and topThing(tile)
  if not thing then return false end
  local id = topId(tile)
  if not id or not DEPOT_IDS[id] then return false end
  return pcall(function() g_game.use(thing) end)
end

local function useMarketFromLocker()
  if not rootWidget then return false end
  local widget = findWidgetByItemId(rootWidget, MARKET_ID)
  if not widget then return false end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and pcall(function() g_game.use(item) end) then return true end
  end

  if widget.item and pcall(function() g_game.use(widget.item) end) then return true end
  return click(widget)
end

local function useMailFromLocker()
  if not rootWidget then return false end
  local widget = findWidgetByItemId(rootWidget, MAIL_ID)
  if not widget then return false end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and pcall(function() g_game.use(item) end) then return true end
  end

  if widget.item and pcall(function() g_game.use(widget.item) end) then return true end
  return click(widget)
end

-- =========================
-- TASKS
-- =========================
local function buildMarketBuyListFromPanel()
  local list = {}
  for _, entry in ipairs(marketCfg.list or {}) do
    if entry.enabled ~= false then
      local itemId = tonumber(entry.itemId or 0) or 0
      local amount = tonumber(entry.amount or 0) or 0
      local maxPrice = tonumber(entry.maxPrice or 0) or 0
      local name = trim(entry.name or getItemDisplayName(itemId) or "")

      if itemId > 0 and amount > 0 and maxPrice > 0 and name ~= "" then
        list[#list + 1] = {
          itemId = itemId,
          name = name,
          amount = amount,
          maxPrice = maxPrice,
          baseOwned = nil
        }
      end
    end
  end
  return list
end

-- =========================
-- ENGINE
-- =========================
local autoBuyStep

local autoBuy = {
  running = false,
  step = "idle",
  nextAt = 0,

  tick = 50,

  waitSearch = 250,
  waitItem = 200,
  waitOffer = 180,
  waitBuy = 220,
  waitPopup = 180,

  maxSearch = 7,
  maxItem = 8,
  maxOffer = 5,
  maxSelect = 7,
  maxPopup = 7,

  retryItemMs = 200,
  closePopupOnFail = false,

  depotTarget = nil,
  depotPos = nil,
  depotTries = 0,
  openTries = 0,
  mailTries = 0,
  collectTries = 0,
  ensureLootTries = 0,

  mailItemOrder = {},
  mailItemIndex = 1,
  mailItemRetries = {},

  tasks = {},
  idx = 1,
  bought = {},
  tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 },
  row = nil
}

local lastLog = { msg = nil, at = 0 }
local function log(msg)
  msg = tostring(msg)
  local now = ms()
  if lastLog.msg == msg and now - lastLog.at < 1500 then return end
  lastLog.msg, lastLog.at = msg, now
  print("[AutoBuyMarket] " .. msg)
end

local function stopAutoBuy()
  autoBuy.running = false
  autoBuy.step = "idle"
  autoBuy.nextAt = 0
  autoBuy.depotTarget = nil
  autoBuy.depotPos = nil
  autoBuy.depotTries = 0
  autoBuy.openTries = 0
  autoBuy.mailTries = 0
  autoBuy.collectTries = 0
  autoBuy.ensureLootTries = 0
  autoBuy.mailItemOrder = {}
  autoBuy.mailItemIndex = 1
  autoBuy.mailItemRetries = {}
  autoBuy.tasks = {}
  autoBuy.idx = 1
  autoBuy.bought = {}
  autoBuy.tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 }
  autoBuy.row = nil

  if CaveBot and CaveBot.setOn then
    pcall(function() CaveBot.setOn() end)
  end
end

local function scheduleAutoBuy(delayMs)
  delayMs = math.max(1, tonumber(delayMs) or autoBuy.tick)
  autoBuy.nextAt = ms() + delayMs
  schedule(delayMs, function()
    if autoBuy.running then autoBuyStep() end
  end)
end

local function autoCurrentTask()
  return autoBuy.tasks[autoBuy.idx]
end

local function autoBoughtCount(itemId)
  return tonumber(autoBuy.bought[tonumber(itemId) or 0] or 0) or 0
end

local function autoAddBought(itemId, amount)
  itemId = tonumber(itemId) or 0
  autoBuy.bought[itemId] = autoBoughtCount(itemId) + (tonumber(amount) or 0)
end

local function autoRemaining(task)
  if not task then return 0 end

  if task.baseOwned == nil then
    task.baseOwned = getOwnedAmount(task.itemId)
    log(string.format("%s: possui %d, alvo %d, falta %d",
      tostring(task.name),
      tonumber(task.baseOwned) or 0,
      tonumber(task.amount) or 0,
      math.max(0, (tonumber(task.amount) or 0) - (tonumber(task.baseOwned) or 0))
    ))
  end

  return math.max(0, (tonumber(task.amount) or 0) - ((tonumber(task.baseOwned) or 0) + autoBoughtCount(task.itemId)))
end

local function autoResetTries()
  autoBuy.tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 }
  autoBuy.row = nil
end

local function autoNextTask()
  autoBuy.idx = autoBuy.idx + 1
  autoBuy.step = "buyer_idle"
  autoResetTries()
end

local function autoRetryItem(delayMs)
  autoBuy.step = "buyer_search"
  autoResetTries()
  scheduleAutoBuy(delayMs or autoBuy.retryItemMs)
end

local function autoCurrentMailItemId()
  return tonumber(autoBuy.mailItemOrder[autoBuy.mailItemIndex] or 0) or 0
end

local function autoNextMailItem()
  autoBuy.mailItemIndex = autoBuy.mailItemIndex + 1
  autoBuy.ensureLootTries = 0
end

autoBuyStep = function()
  if not autoBuy.running then return end

  local now = ms()
  if now < autoBuy.nextAt then
    scheduleAutoBuy(autoBuy.nextAt - now)
    return
  end

  -- DEPOT
  if autoBuy.step == "go_depot" then
    local found = bestDepot(7)
    if not found then
      stopAutoBuy()
      return
    end

    autoBuy.depotTarget = found.stand
    autoBuy.depotPos = found.depot
    autoBuy.depotTries = 0
    autoBuy.step = "walking_depot"
    scheduleAutoBuy(50)
    return
  end

  if autoBuy.step == "walking_depot" then
    local myPos = player:getPosition()
    if not myPos or not autoBuy.depotTarget or not autoBuy.depotPos then
      stopAutoBuy()
      return
    end

    if mapDist(myPos, autoBuy.depotPos) <= 1 then
      autoBuy.step = "use_depot"
      scheduleAutoBuy(50)
      return
    end

    autoBuy.depotTries = autoBuy.depotTries + 1
    if autoBuy.depotTries > 40 then
      stopAutoBuy()
      return
    end

    autoWalk(autoBuy.depotTarget, 500, {ignoreNonPathable = true, precision = 1})
    scheduleAutoBuy(1500)
    return
  end

  if autoBuy.step == "use_depot" then
    if useDepotAt(autoBuy.depotPos) then
      autoBuy.openTries = 0
      autoBuy.step = "open_market"
      scheduleAutoBuy(700)
      return
    end

    stopAutoBuy()
    return
  end

  if autoBuy.step == "open_market" then
    autoBuy.openTries = autoBuy.openTries + 1
    if autoBuy.openTries > 10 then
      stopAutoBuy()
      return
    end

    if useMarketFromLocker() then
      autoBuy.tasks = buildMarketBuyListFromPanel()

      if #autoBuy.tasks == 0 then
        closeMarketWindow()
        stopAutoBuy()
        return
      end

      autoBuy.idx = 1
      autoBuy.bought = {}
      autoBuy.step = "buyer_idle"
      autoResetTries()
      scheduleAutoBuy(900)
      return
    end

    scheduleAutoBuy(300)
    return
  end

  -- MAIL
  if autoBuy.step == "open_mail" then
    autoBuy.mailTries = autoBuy.mailTries + 1
    if autoBuy.mailTries > 10 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    if useMailFromLocker() then
      autoBuy.collectTries = 0
      autoBuy.ensureLootTries = 0
      autoBuy.mailItemOrder = buildAllowedMailItemOrder()
      autoBuy.mailItemIndex = 1
      autoBuy.mailItemRetries = {}
      autoBuy.step = "collect_mail"
      scheduleAutoBuy(700)
      return
    end

    scheduleAutoBuy(300)
    return
  end

  if autoBuy.step == "collect_mail" then
    autoBuy.collectTries = autoBuy.collectTries + 1

    local targetId = autoCurrentMailItemId()
    if targetId <= 0 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    local tries = tonumber(autoBuy.mailItemRetries[targetId] or 0) or 0
    local status, err, movedId, movedCount = collectAllowedMailItems(targetId)

    if status == "moved" then
      autoBuy.ensureLootTries = 0
      autoBuy.mailItemRetries[targetId] = 0
      scheduleAutoBuy(350)
      return
    end

    if status == "done_item" then
      autoBuy.mailItemRetries[targetId] = 0
      autoNextMailItem()
      scheduleAutoBuy(120)
      return
    end

    if status == "ensure_loot" then
      autoBuy.ensureLootTries = autoBuy.ensureLootTries + 1
      if autoBuy.ensureLootTries > 5 then
        autoNextMailItem()
        scheduleAutoBuy(300)
        return
      end
      scheduleAutoBuy(600)
      return
    end

    if status == "move_failed" then
      tries = tries + 1
      autoBuy.mailItemRetries[targetId] = tries
      if tries >= 3 then
        autoNextMailItem()
        scheduleAutoBuy(250)
        return
      end
      scheduleAutoBuy(350)
      return
    end

    if status == "error" then
      tries = tries + 1
      autoBuy.mailItemRetries[targetId] = tries
      if tries >= 3 then
        autoNextMailItem()
        scheduleAutoBuy(250)
        return
      end
      scheduleAutoBuy(400)
      return
    end

    if autoBuy.collectTries > 80 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    scheduleAutoBuy(300)
    return
  end

  -- BUYER
  local task = autoCurrentTask()

  if autoBuy.step == "buyer_idle" then
    if not task then
      closeMarketWindow()
      autoBuy.mailTries = 0
      autoBuy.collectTries = 0
      autoBuy.step = "open_mail"
      scheduleAutoBuy(700)
      return
    end

    if autoRemaining(task) <= 0 then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_search"
    scheduleAutoBuy(30)
    return
  end

  if not task then
    closeMarketWindow()
    autoBuy.mailTries = 0
    autoBuy.collectTries = 0
    autoBuy.step = "open_mail"
    scheduleAutoBuy(700)
    return
  end

  if autoRemaining(task) <= 0 then
    autoNextTask()
    scheduleAutoBuy(80)
    return
  end

  local ui = marketReady()
  if not ui then
    scheduleAutoBuy(1000)
    return
  end

  if autoBuy.step == "buyer_search" then
    if not ui.searchEdit then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    setSearchAll(ui)
    focus(ui.searchEdit)

    if not setText(ui.searchEdit, task.name) then
      autoBuy.tries.search = autoBuy.tries.search + 1
      if autoBuy.tries.search <= autoBuy.maxSearch then
        scheduleAutoBuy(autoBuy.waitSearch)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    pcall(function()
      if ui.searchEdit.onTextChange then
        ui.searchEdit.onTextChange(ui.searchEdit, task.name)
      end
    end)

    autoBuy.step = "buyer_item"
    scheduleAutoBuy(autoBuy.waitSearch)
    return
  end

  if autoBuy.step == "buyer_item" then
    local box = findItemBox(ui.itemsPanel, task.name)
    if not box then
      autoBuy.tries.item = autoBuy.tries.item + 1
      if autoBuy.tries.item <= autoBuy.maxItem then
        pcall(function()
          if ui.searchEdit and ui.searchEdit.onTextChange then
            ui.searchEdit.onTextChange(ui.searchEdit, task.name)
          end
        end)
        scheduleAutoBuy(autoBuy.waitSearch)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not selectItemBox(box) then
      autoBuy.tries.item = autoBuy.tries.item + 1
      if autoBuy.tries.item <= autoBuy.maxItem then
        scheduleAutoBuy(autoBuy.waitItem)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_offer"
    autoBuy.row = nil
    autoBuy.tries.offer = 0
    scheduleAutoBuy(autoBuy.waitItem)
    return
  end

  if autoBuy.step == "buyer_offer" then
    local row = firstSellRow(ui)
    if not row then
      autoBuy.tries.offer = autoBuy.tries.offer + 1
      if autoBuy.tries.offer <= autoBuy.maxOffer then
        scheduleAutoBuy(autoBuy.waitItem)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    local piecePrice = getPiecePrice(row)
    if not piecePrice then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if piecePrice > (tonumber(task.maxPrice) or 0) then
      log(task.name .. ": primeira offer acima do maxPrice (" .. piecePrice .. " > " .. tostring(task.maxPrice) .. ")")
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.row = row
    autoBuy.step = "buyer_select"
    autoBuy.tries.select = 0
    scheduleAutoBuy(60)
    return
  end

  if autoBuy.step == "buyer_select" then
    local row = autoBuy.row or firstSellRow(ui)
    if not row then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if selectOffer(ui, row) then
      autoBuy.step = "buyer_buy"
      scheduleAutoBuy(autoBuy.waitOffer)
      return
    end

    autoBuy.tries.select = autoBuy.tries.select + 1
    if autoBuy.tries.select <= autoBuy.maxSelect then
      scheduleAutoBuy(autoBuy.waitOffer)
      return
    end
    autoNextTask()
    scheduleAutoBuy(80)
    return
  end

  if autoBuy.step == "buyer_buy" then
    if not ui.buyButton then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not safeEnabled(ui.buyButton) then
      autoBuy.tries.select = autoBuy.tries.select + 1
      if autoBuy.tries.select <= autoBuy.maxSelect + 4 then
        local row = autoBuy.row or firstSellRow(ui)
        if row then selectOffer(ui, row) end
        scheduleAutoBuy(autoBuy.waitOffer)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not click(ui.buyButton) then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_popup"
    autoBuy.tries.popup = 0
    scheduleAutoBuy(autoBuy.waitBuy)
    return
  end

  if autoBuy.step == "buyer_popup" then
    local popup = findAmountPopup()
    if not popup then
      autoBuy.tries.popup = autoBuy.tries.popup + 1
      if autoBuy.tries.popup <= autoBuy.maxPopup then
        scheduleAutoBuy(autoBuy.waitPopup)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    local want = autoRemaining(task)
    if want <= 0 then
      if autoBuy.closePopupOnFail then popupCancel(popup) end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not setPopupAmount(popup, want) then
      setPopupAmount(popup, 1)
      want = 1
    end

    local finalAmount = getPopupAmount(popup) or want or 1
    if finalAmount < 1 then finalAmount = 1 end

    if not popupConfirm(popup) then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoAddBought(task.itemId, finalAmount)

    if autoRemaining(task) <= 0 then
      autoNextTask()
      scheduleAutoBuy(80)
    else
      autoRetryItem(autoBuy.retryItemMs)
    end
    return
  end

  stopAutoBuy()
end

function startAutoBuyMarket()
  if autoBuy.running then return end

  if CaveBot and CaveBot.setOff then
    pcall(function() CaveBot.setOff() end)
  end

  autoBuy.running = true
  autoBuy.step = "go_depot"
  autoBuy.nextAt = 0
  autoBuy.tasks = {}
  autoBuy.idx = 1
  autoBuy.bought = {}
  autoBuy.depotTarget = nil
  autoBuy.depotPos = nil
  autoBuy.depotTries = 0
  autoBuy.openTries = 0
  autoBuy.mailTries = 0
  autoBuy.collectTries = 0
  autoBuy.ensureLootTries = 0
  autoBuy.mailItemOrder = {}
  autoBuy.mailItemIndex = 1
  autoBuy.mailItemRetries = {}
  autoResetTries()
  autoBuyStep()
end
end)

lnsRunBlock("IMBUESCROLL", function()

-- Scroll Imbue - LNS
-- Storage global

storage = storage or {}
storage.LNSImbueScrollGlobal = storage.LNSImbueScrollGlobal or {
  scrolls = {},
  entries = {},
  nextUid = 0,
  selectedTab = "blank"
}

local imbueScrollStorage = storage.LNSImbueScrollGlobal
imbueScrollStorage.scrolls = imbueScrollStorage.scrolls or {}
imbueScrollStorage.entries = imbueScrollStorage.entries or {}
imbueScrollStorage.nextUid = tonumber(imbueScrollStorage.nextUid or 0) or 0
imbueScrollStorage.selectedTab = imbueScrollStorage.selectedTab or "blank"

local db = imbueScrollStorage

local function saveImbueScrollGlobal()
  storage.LNSImbueScrollGlobal = imbueScrollStorage
end

local function saveScrollImbue()
  saveImbueScrollGlobal()
end

local IMBUE_OPTIONS = {
  "Hit Points Leech",
  "Mana Leech",
  "Critical",
  "Magic Level",
  "Capacity",
  "Speed Bonus",
  "Elemental Damage (Fire)",
  "Elemental Damage (Earth)",
  "Elemental Damage (Ice)",
  "Elemental Damage (Energy)",
  "Elemental Damage (Death)",
  "Elemental Protection (Fire)",
  "Elemental Protection (Earth)",
  "Elemental Protection (Ice)",
  "Elemental Protection (Energy)",
  "Elemental Protection (Holy)",
  "Skill Bonus (Axe)",
  "Skill Bonus (Sword)",
  "Skill Bonus (Club)",
  "Skill Bonus (Distance)",
  "Skill Bonus (Fist)",
  "Skill Bonus (Shielding)"
}

local function trim(v)
  return tostring(v or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then return root:recursiveGetChildById(id) end
  if root.getChildById then return root:getChildById(id) end
  return nil
end

local function clearChildren(widget)
  if not widget or not widget.getChildren then return end
  local childs = widget:getChildren()
  for i = #childs, 1, -1 do
    if childs[i] and childs[i].destroy then childs[i]:destroy() end
  end
end

local function itemId(widget)
  if not widget then return 0 end
  if widget.getItemId then return tonumber(widget:getItemId()) or 0 end
  if widget.getItem then
    local it = widget:getItem()
    if it and it.getId then return tonumber(it:getId()) or 0 end
  end
  return 0
end

local function setItem(widget, id)
  if widget and widget.setItemId then widget:setItemId(tonumber(id) or 0) end
end

local function spinValue(widget)
  if widget and widget.getValue then return tonumber(widget:getValue()) or 0 end
  return 0
end

local function setSpin(widget, value)
  if widget and widget.setValue then widget:setValue(tonumber(value) or 0) end
end

local function switchValue(widget)
  if not widget then return false end
  if widget.isOn then return widget:isOn() end
  if widget.getOn then return widget:getOn() end
  if widget.isChecked then return widget:isChecked() end
  return widget.on == true
end

local function setSwitch(widget, value)
  if not widget then return end
  value = value == true
  if widget.setOn then
    widget:setOn(value)
  elseif widget.setChecked then
    widget:setChecked(value)
  end
end

local function validImbueName(name)
  name = trim(name)
  for i = 1, #IMBUE_OPTIONS do
    if IMBUE_OPTIONS[i] == name then return name end
  end
  return nil
end

local function optionText(option)
  if type(option) == "string" then return trim(option) end
  if type(option) == "table" then
    if option.getText then
      local ok, txt = pcall(function() return option:getText() end)
      if ok then return trim(txt) end
    end
    if option.text then return trim(option.text) end
    if option.name then return trim(option.name) end
  end
  return ""
end

local function comboText(combo)
  if not combo then return IMBUE_OPTIONS[1] end

  if combo.getText then
    local txt = validImbueName(combo:getText())
    if txt then return txt end
  end

  if combo.getCurrentOption then
    local ok, option = pcall(function() return combo:getCurrentOption() end)
    if ok then
      local txt = validImbueName(optionText(option))
      if txt then return txt end
    end
  end

  return IMBUE_OPTIONS[1]
end

local function setCombo(combo, text)
  if not combo then return end
  text = validImbueName(text) or IMBUE_OPTIONS[1]

  -- NUNCA passe a tabela da option aqui. Em algumas builds isso vira "table: 0x..." no ComboBox.
  if combo.setCurrentOption then
    pcall(function() combo:setCurrentOption(text) end)
  end

  if combo.setText then
    combo:setText(text)
  end
end

local function getItemName(id)
  id = tonumber(id) or 0
  if id <= 0 then return "Item 0" end

  if g_things and g_things.getThingType then
    local ok, thing = pcall(function()
      return g_things.getThingType(id, ThingCategoryItem)
    end)
    if ok and thing and thing.getName then
      local name = trim(thing:getName())
      if name ~= "" then return name end
    end
  end

  return "Item " .. id
end

local SCROLL_ID_TO_DISPLAY_NAME = {
  [51462] = "Critical",
  [51459] = "Elemental Fire",
  [51453] = "Elemental Ice",
  [51464] = "Life Leech",
  [51467] = "Mana Leech",
  [51445] = "Shielding",
  [51455] = "Distance",
  [51450] = "Elemental Energy",
  [51465] = "Elemental Earth",
  [51461] = "Protect Earth",
  [51448] = "Protect Holy",
  [51457] = "Protect Ice",
  [51449] = "Protect Fire",
  [41454] = "Protect Death",
  [51454] = "Protect Death",
  [51447] = "Protect Energy",
  [51446] = "Axe",
  [51460] = "Sword",
  [51452] = "Capacity",
  [51463] = "Speed Bonus",
  [51451] = "Magic Level"
}

local SCROLL_ID_TO_CONFIG_NAME = {
  [51462] = "Critical",
  [51459] = "Elemental Damage (Fire)",
  [51453] = "Elemental Damage (Ice)",
  [51464] = "Hit Points Leech",
  [51467] = "Mana Leech",
  [51445] = "Skill Bonus (Shielding)",
  [51455] = "Skill Bonus (Distance)",
  [51450] = "Elemental Damage (Energy)",
  [51465] = "Elemental Damage (Earth)",
  [51461] = "Elemental Protection (Earth)",
  [51448] = "Elemental Protection (Holy)",
  [51457] = "Elemental Protection (Ice)",
  [51449] = "Elemental Protection (Fire)",
  [41454] = "Elemental Protection (Death)",
  [51454] = "Elemental Protection (Death)",
  [51447] = "Elemental Protection (Energy)",
  [51446] = "Skill Bonus (Axe)",
  [51460] = "Skill Bonus (Sword)",
  [51452] = "Capacity",
  [51463] = "Speed Bonus",
  [51451] = "Magic Level"
}

local function scrollDisplayNameById(id)
  id = tonumber(id) or 0
  return SCROLL_ID_TO_DISPLAY_NAME[id] or ("Scroll " .. id)
end

local function scrollConfigNameById(id)
  id = tonumber(id) or 0
  return SCROLL_ID_TO_CONFIG_NAME[id] or ""
end

local function formatEntry(entry)
  local names = {}
  for _, scrollId in ipairs(entry.scrollIds or {}) do
    local name = scrollDisplayNameById(scrollId)
    if name ~= "" then names[#names + 1] = name end
  end

  if #names == 0 then
    return "sem scroll"
  end

  return table.concat(names, "\n")
end

local rowTemplate = [[
scrollImbueListRow < UIWidget
  id: root
  height: 45
  focusable: true
  background-color: alpha
  margin-top: 2
  opacity: 1.00
  border: 1 alpha

  $hover:
    background-color: #2F2F2F
    opacity: 0.85
    border: 1 gray

  $focus:
    background-color: #404040
    border: 1 gray
    opacity: 0.95

  UIItem
    id: icon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    size: 34 34
    phantom: true

  Label
    id: text
    anchors.left: icon.right
    anchors.right: remove.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    margin-left: 7
    margin-right: 4
    text-align: center
    font: verdana-11px-rounded
    color: white
    text-wrap: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 18
    height: 18
    margin-right: 4
    text: X
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

g_ui.loadUIFromString(rowTemplate)

panelScrollImbue = setupUI([[
blankScroll < Panel
  height: 30
  margin-top: 0
  phantom: false

  BotItem
    id: blankScroll
    anchors.left: parent.left
    anchors.top: parent.top
    margin-top: 2
    margin-left: 5

  Label
    id: labelImbue
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 10
    margin-top: 0
    text: Slot Imbue:
    text-auto-resize: true
    font: verdana-11px-rounded

  ComboBox
    id: imbueType
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-left: 0
    margin-top: 2
    height: 18
    width: 180
    font: verdana-11px-rounded
    @onSetup: |
      self:addOption("Hit Points Leech")
      self:addOption("Mana Leech")
      self:addOption("Critical")
      self:addOption("Magic Level")
      self:addOption("Capacity")
      self:addOption("Speed Bonus")
      self:addOption("Elemental Damage (Fire)")
      self:addOption("Elemental Damage (Earth)")
      self:addOption("Elemental Damage (Ice)")
      self:addOption("Elemental Damage (Energy)")
      self:addOption("Elemental Damage (Death)")
      self:addOption("Elemental Protection (Fire)")
      self:addOption("Elemental Protection (Earth)")
      self:addOption("Elemental Protection (Ice)")
      self:addOption("Elemental Protection (Energy)")
      self:addOption("Elemental Protection (Holy)")
      self:addOption("Skill Bonus (Axe)")
      self:addOption("Skill Bonus (Sword)")
      self:addOption("Skill Bonus (Club)")
      self:addOption("Skill Bonus (Distance)")
      self:addOption("Skill Bonus (Fist)")
      self:addOption("Skill Bonus (Shielding)")

  Label
    id: labelQtde
    anchors.top: labelImbue.top
    anchors.left: prev.right
    margin-left: 10
    margin-top: 0
    text: Amount:
    text-auto-resize: true
    font: verdana-11px-rounded

  SpinBox
    id: qtdeScroll
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-left: 0
    margin-top: 2
    height: 18
    width: 80
    minimum: 0
    maximum: 100
    text-align: center

  Label
    id: labelONOFF
    anchors.top: labelQtde.top
    anchors.left: prev.right
    margin-left: 10
    margin-top: 0
    text: Status:
    text-auto-resize: true
    font: verdana-11px-rounded

  BotSwitch
    id: ativador
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-left: 0
    margin-top: 2
    height: 18
    width: 55
    font: verdana-11px-rounded
    $on:
      text: ON
      color: green
      image-color: green
    $!on:
      text: OFF
      color: white
      image-color: #7a0000

MainWindow
  size: 410 350
  text: Panel Imbue Scroll

  Button
    id: imbueBlank
    checkable: true
    anchors.top: parent.top
    anchors.left: parent.left
    height: 33
    margin-left: -5
    width: 194
    text-align: center
    text: Blank Scroll

    UIItem
      id: idBlank
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -5
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 35
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: imbueItems
    checkable: true
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    height: 33
    margin-left: 0
    width: 194
    text-align: center
    text: Imbue Items

    UIItem
      id: idItem
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -5
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 35
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  FlatPanel
    id: flatp1
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-left: -5
    margin-top: 6
    margin-right: -5

    blankScroll
      id: blank1
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5

    blankScroll
      id: blank2
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

    blankScroll
      id: blank3
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

    blankScroll
      id: blank4
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

    blankScroll
      id: blank5
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

    blankScroll
      id: blank6
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

  FlatPanel
    id: flatp2
    anchors.top: flatp1.top
    anchors.left: flatp1.left
    anchors.right: flatp1.right
    anchors.bottom: flatp1.bottom

    UIButton
      id: clickHere
      anchors.top: parent.top
      anchors.left: parent.left
      text: Click Here
      margin-top: 5
      margin-left: 80
      color: #FFD700
      text-auto-resize: true
      font: verdana-11px-rounded
      opacity: 1.00
      $hover:
        opacity: 0.80

    Label
      id: labelClick
      anchors.verticalCenter: clickHere.verticalCenter
      anchors.left: clickHere.right
      margin-left: 4
      margin-top: 0
      font: verdana-11px-rounded
      text: to configure scroll imbue

    HorizontalSeparator
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5

    TextList
      id: scrollList
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-top: 5
      margin-left: 5
      margin-right: 15
      margin-bottom: 5
      vertical-scrollbar: scrollListBar
      font: verdana-11px-rounded

    VerticalScrollBar
      id: scrollListBar
      anchors.top: scrollList.top
      anchors.bottom: scrollList.bottom
      anchors.left: scrollList.right
      step: 10
      pixels-scroll: true
      visible: true

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    text: Close
    margin-top: 5
]], g_ui.getRootWidget())

panelScrollImbue:hide()
panelScrollImbue.imbueBlank.idBlank:setItemId(51442)
panelScrollImbue.imbueItems.idItem:setItemId(28719)

if modules._G.g_app.isMobile() then
  panelScrollImbue:setSize("410 370")
end

panelScrollImbue.closePanel.onClick = function()
  panelScrollImbue:hide()
end

scrollImbueCfg = setupUI([[
MainWindow
  size: 260 120
  text: Panel Imbue Scroll

  HorizontalSeparator
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    margin-left: -5
    margin-right: -5

  Label
    id: label1
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 6
    margin-left: 10
    text: ITEM ID
    text-auto-resize: true
    font: cipsoftFont

  BotItem
    id: itemImbue
    anchors.top: prev.bottom
    anchors.horizontalCenter: prev.horizontalCenter
    margin-top: 7

  Label
    id: label2
    anchors.top: label1.top
    anchors.left: label1.right
    margin-top: 0
    margin-left: 37
    text: SLOT 1
    text-auto-resize: true
    font: cipsoftFont

  BotItem
    id: itemSlot1
    anchors.top: prev.bottom
    anchors.horizontalCenter: prev.horizontalCenter
    margin-top: 7

  Label
    id: label3
    anchors.top: label2.top
    anchors.left: label2.right
    margin-top: 0
    margin-left: 20
    text: SLOT 2
    text-auto-resize: true
    font: cipsoftFont

  BotItem
    id: itemSlot2
    anchors.top: prev.bottom
    anchors.horizontalCenter: prev.horizontalCenter
    margin-top: 7

  Label
    id: label4
    anchors.top: label3.top
    anchors.left: label3.right
    margin-top: 0
    margin-left: 20
    text: SLOT 3
    text-auto-resize: true
    font: cipsoftFont

  BotItem
    id: itemSlot3
    anchors.top: prev.bottom
    anchors.horizontalCenter: prev.horizontalCenter
    margin-top: 7

  HorizontalSeparator
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    margin-left: -5
    margin-right: -5

  VerticalSeparator
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: prev.bottom
    margin-top: 3
    margin-left: -5

  VerticalSeparator
    anchors.top: prev.top
    anchors.left: label1.right
    anchors.bottom: prev.bottom
    margin-left: 15

  VerticalSeparator
    anchors.top: prev.top
    anchors.left: label4.right
    anchors.bottom: prev.bottom
    margin-left: 20

  Button
    id: cancel
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-left: -5
    width: 119
    height: 20
    text: CANCEL
    font: cipsoftFont
    margin-top: 5

  Button
    id: insert
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 1
    width: 119
    height: 20
    text: INSERT
    font: cipsoftFont
    margin-top: 0
]], g_ui.getRootWidget())

scrollImbueCfg:hide()

local main = panelScrollImbue
local cfg = scrollImbueCfg
local editingUid = nil
local loadingScrollRows = false

local function eachScrollRow(fn)
  for i = 1, 6 do
    local row = main.flatp1["blank" .. i]
    if row then fn(i, row) end
  end
end

local function saveBlankRows()
  if loadingScrollRows then return end

  eachScrollRow(function(i, row)
    db.scrolls[i] = {
      itemId = itemId(row.blankScroll),
      imbue = comboText(row.imbueType),
      amount = spinValue(row.qtdeScroll),
      enabled = switchValue(row.ativador)
    }
  end)

  saveScrollImbue()
  rebuildScrollList()
end

local function loadBlankRows()
  loadingScrollRows = true

  eachScrollRow(function(i, row)
    local data = db.scrolls[i] or {}
    local imbue = validImbueName(data.imbue) or IMBUE_OPTIONS[1]
    data.imbue = imbue
    db.scrolls[i] = data

    setItem(row.blankScroll, data.itemId or 0)
    setCombo(row.imbueType, imbue)
    setSpin(row.qtdeScroll, data.amount or 0)
    setSwitch(row.ativador, data.enabled == true)
  end)

  loadingScrollRows = false
end

local function bindBlankRows()
  eachScrollRow(function(i, row)
    row.blankScroll.onItemChange = saveBlankRows
    row.imbueType.onOptionChange = saveBlankRows
    row.imbueType.onTextChange = saveBlankRows
    row.qtdeScroll.onValueChange = saveBlankRows
    row.qtdeScroll.onValueChanged = saveBlankRows
    row.ativador.onClick = function(widget)
      setSwitch(widget, not switchValue(widget))
      saveBlankRows()
      return true
    end
  end)
end

local function newUid()
  db.nextUid = (tonumber(db.nextUid) or 0) + 1
  return db.nextUid
end

local function clearCfg()
  editingUid = nil
  setItem(cfg.itemImbue, 0)
  setItem(cfg.itemSlot1, 0)
  setItem(cfg.itemSlot2, 0)
  setItem(cfg.itemSlot3, 0)
end

local function loadEntry(entry)
  editingUid = tonumber(entry.uid)
  setItem(cfg.itemImbue, entry.itemId or 0)
  setItem(cfg.itemSlot1, entry.scrollIds and entry.scrollIds[1] or 0)
  setItem(cfg.itemSlot2, entry.scrollIds and entry.scrollIds[2] or 0)
  setItem(cfg.itemSlot3, entry.scrollIds and entry.scrollIds[3] or 0)
end

local function removeEntry(uid)
  uid = tonumber(uid)
  if not uid then return end

  for i = #db.entries, 1, -1 do
    if tonumber(db.entries[i].uid) == uid then
      table.remove(db.entries, i)
      break
    end
  end

  saveScrollImbue()
  rebuildScrollList()
end

function rebuildScrollList()
  local list = main.flatp2.scrollList
  if not list then return end

  clearChildren(list)

  for _, entry in ipairs(db.entries) do
    local row = g_ui.createWidget("scrollImbueListRow", list)
    row._uid = tonumber(entry.uid)
    row.icon:setItemId(tonumber(entry.itemId) or 0)
    row.text:setText(formatEntry(entry))

    row.onClick = function(widget)
      for _, data in ipairs(db.entries) do
        if tonumber(data.uid) == tonumber(widget._uid) then
          loadEntry(data)
          cfg:show()
          cfg:raise()
          cfg:focus()
          break
        end
      end
    end

    row.remove.onClick = function()
      removeEntry(entry.uid)
      return true
    end
  end
end

local function saveEntryFromCfg()
  local targetItem = itemId(cfg.itemImbue)
  if targetItem <= 0 then
    return false
  end

  local scrollIds = {}
  local s1 = itemId(cfg.itemSlot1)
  local s2 = itemId(cfg.itemSlot2)
  local s3 = itemId(cfg.itemSlot3)

  if s1 > 0 then scrollIds[#scrollIds + 1] = s1 end
  if s2 > 0 then scrollIds[#scrollIds + 1] = s2 end
  if s3 > 0 then scrollIds[#scrollIds + 1] = s3 end

  if #scrollIds == 0 then
    return false
  end

  local entry = {
    uid = editingUid or newUid(),
    itemId = targetItem,
    scrollIds = scrollIds
  }

  local replaced = false
  for i = 1, #db.entries do
    if tonumber(db.entries[i].uid) == tonumber(entry.uid) then
      db.entries[i] = entry
      replaced = true
      break
    end
  end

  if not replaced then
    db.entries[#db.entries + 1] = entry
  end

  saveScrollImbue()
  rebuildScrollList()
  clearCfg()
  cfg:hide()
  main:show()
  main:raise()
  main:focus()
  return true
end

local function showWidget(widget, visible)
  if not widget then return end
  if visible then
    if widget.show then widget:show() end
  else
    if widget.hide then widget:hide() end
  end
end

local function setTabPressed(button, pressed)
  if not button then return end
  showWidget(W(button, "activeLine"), pressed)

  if button.setChecked then pcall(function() button:setChecked(pressed) end) end
  if button.setPressed then pcall(function() button:setPressed(pressed) end) end
  if button.setOn then pcall(function() button:setOn(pressed) end) end

  if button.setOpacity then button:setOpacity(pressed and 1.00 or 0.74) end
  if button.setColor then button:setColor(pressed and "#d7c08a" or "#d6d6d6") end

end

local function setTab(tab)
  db.selectedTab = tab

  if tab == "blank" then
    main.flatp1:show()
    main.flatp2:hide()
    setTabPressed(main.imbueBlank, true)
    setTabPressed(main.imbueItems, false)
  else
    main.flatp1:hide()
    main.flatp2:show()
    setTabPressed(main.imbueBlank, false)
    setTabPressed(main.imbueItems, true)
  end

  saveScrollImbue()
end

main.imbueBlank.onClick = function()
  setTab("blank")
end

main.imbueItems.onClick = function()
  setTab("items")
end

main.flatp2.clickHere.onClick = function()
  clearCfg()
  cfg:show()
  cfg:raise()
  cfg:focus()
end

cfg.cancel.onClick = function()
  clearCfg()
  cfg:hide()
end

cfg.insert.onClick = function()
  saveEntryFromCfg()
end

loadBlankRows()
bindBlankRows()
rebuildScrollList()
setTab(db.selectedTab or "blank")
saveScrollImbue()


-- =========================================================
-- BLANK SCROLL AUTO IMBUE ENGINE
-- =========================================================

local BLANK_SCROLL_ID = 51442
local SHRINES = {25060, 25061, 25174, 25175, 25182, 25183}

-- IDs finais dos scrolls ja imbuídos, usados para contar quanto falta fazer.
local SCROLL_RESULT_IDS = {
  ["Critical"] = 51462,
  ["Elemental Damage (Fire)"] = 51459,
  ["Elemental Damage (Ice)"] = 51453,
  ["Hit Points Leech"] = 51464,
  ["Mana Leech"] = 51467,
  ["Skill Bonus (Shielding)"] = 51445,
  ["Skill Bonus (Distance)"] = 51455,
  ["Elemental Damage (Energy)"] = 51450,
  ["Elemental Damage (Earth)"] = 51465,
  ["Elemental Protection (Earth)"] = 51461,
  ["Elemental Protection (Holy)"] = 51448,
  ["Elemental Protection (Ice)"] = 51457,
  ["Elemental Protection (Fire)"] = 51449,
  ["Elemental Protection (Death)"] = 41454,
  ["Elemental Protection (Energy)"] = 51447,
  ["Skill Bonus (Axe)"] = 51446,
  ["Skill Bonus (Sword)"] = 51460,
  ["Capacity"] = 51452,
  ["Speed Bonus"] = 51463,
  ["Magic Level"] = 51451
}

local IMBUE_ALIASES = {
  ["Hit Points Leech"] = {"Hit Points Leech", "Life Leech", "Vampirism"},
  ["Mana Leech"] = {"Mana Leech", "Void"},
  ["Critical"] = {"Critical", "Strike"},
  ["Magic Level"] = {"Magic Level", "Epiphany"},
  ["Capacity"] = {"Capacity", "Featherweight"},
  ["Speed Bonus"] = {"Speed", "Speed Bonus", "Swiftness"},

  ["Elemental Damage (Fire)"] = {"Elemental Damage (Fire)", "Fire Damage", "Scorch"},
  ["Elemental Damage (Earth)"] = {"Elemental Damage (Earth)", "Earth Damage", "Venom"},
  ["Elemental Damage (Ice)"] = {"Elemental Damage (Ice)", "Ice Damage", "Frost"},
  ["Elemental Damage (Energy)"] = {"Elemental Damage (Energy)", "Energy Damage", "Electrify"},
  ["Elemental Damage (Death)"] = {"Elemental Damage (Death)", "Death Damage", "Reap"},

  ["Elemental Protection (Fire)"] = {"Elemental Protection (Fire)", "Fire Protection", "Dragon Hide"},
  ["Elemental Protection (Earth)"] = {"Elemental Protection (Earth)", "Earth Protection", "Snake Skin"},
  ["Elemental Protection (Ice)"] = {"Elemental Protection (Ice)", "Ice Protection", "Quara Scale"},
  ["Elemental Protection (Energy)"] = {"Elemental Protection (Energy)", "Energy Protection", "Cloud Fabric"},
  ["Elemental Protection (Holy)"] = {"Elemental Protection (Holy)", "Holy Protection", "Demon Presence"},
  ["Elemental Protection (Death)"] = {"Elemental Protection (Death)", "Death Protection", "Lich Shroud"},

  ["Skill Bonus (Axe)"] = {"Skill Bonus (Axe)", "Skillboost (Axe)", "Axe", "Chop"},
  ["Skill Bonus (Sword)"] = {"Skill Bonus (Sword)", "Skillboost (Sword)", "Sword", "Slash"},
  ["Skill Bonus (Club)"] = {"Skill Bonus (Club)", "Skillboost (Club)", "Club", "Bash"},
  ["Skill Bonus (Distance)"] = {"Skill Bonus (Distance)", "Skillboost (Distance)", "Distance", "Precision"},
  ["Skill Bonus (Fist)"] = {"Skill Bonus (Fist)", "Skillboost (Fist)", "Fist"},
  ["Skill Bonus (Shielding)"] = {"Skill Bonus (Shielding)", "Skillboost (Shielding)", "Shielding", "Shield"}
}

local scrollCraftState = {
  active = false,
  queue = {},
  idx = 1,
  waitingWindow = false,
  waitingApply = false,
  current = nil,
  currentBlank = nil,
  shrine = nil,
  shrinePos = nil,
  lastAction = 0,
  startedAt = 0,
  timeoutAt = 0,
  releaseCavebotUntil = 0,

  -- Controle usado APENAS pelo checker do CaveBot.
  -- startScrollImbueBlank(), stopScrollImbueBlank() e icones NAO desligam/ligam CaveBot.
  cavebotControl = false,
  cavebotWasOn = false,
  cavebotFallbackAt = 0
}

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function later(ms, fn)
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end
  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end
  if g_dispatcher and g_dispatcher.scheduleEvent then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  return fn()
end

local BLANK_CAVEBOT_FALLBACK_BASE_MS = 60000
local BLANK_CAVEBOT_FALLBACK_PER_SCROLL_MS = 18000

local function caveBotIsOnSafe()
  if not CaveBot then return true end

  if type(CaveBot.isOn) == "function" then
    local ok, result = pcall(function()
      return CaveBot.isOn()
    end)
    if ok then return result == true end
  end

  if type(CaveBot.isOff) == "function" then
    local ok, result = pcall(function()
      return CaveBot.isOff()
    end)
    if ok then return result ~= true end
  end

  -- Se nao tiver isOn/isOff, considera ligado porque esta vindo de uma Action do CaveBot.
  return true
end

local function caveBotSetOffSafe()
  if CaveBot and type(CaveBot.setOff) == "function" then
    return pcall(function()
      CaveBot.setOff()
    end)
  end
  return false
end

local function caveBotSetOnSafe()
  if CaveBot and type(CaveBot.setOn) == "function" then
    return pcall(function()
      CaveBot.setOn()
    end)
  end
  return false
end

local function calcBlankCavebotFallbackMs(queue)
  local total = type(queue) == "table" and #queue or 0
  return math.max(
    BLANK_CAVEBOT_FALLBACK_BASE_MS,
    15000 + (total * BLANK_CAVEBOT_FALLBACK_PER_SCROLL_MS)
  )
end

local function pauseCaveBotForBlank(queue)
  scrollCraftState.cavebotControl = true
  scrollCraftState.cavebotWasOn = caveBotIsOnSafe()
  scrollCraftState.cavebotFallbackAt = nowMs() + calcBlankCavebotFallbackMs(queue)

  if scrollCraftState.cavebotWasOn == true then
    caveBotSetOffSafe()
  end
end

local function releaseCaveBotFromBlank()
  if scrollCraftState.cavebotControl == true and scrollCraftState.cavebotWasOn == true then
    caveBotSetOnSafe()
  end

  scrollCraftState.cavebotControl = false
  scrollCraftState.cavebotWasOn = false
  scrollCraftState.cavebotFallbackAt = 0
end

local function keepCaveBotOffDuringBlank()
  if scrollCraftState.cavebotControl == true and scrollCraftState.cavebotWasOn == true then
    caveBotSetOffSafe()
  end
end

local function lower(v)
  return trim(v):lower()
end

local function hasText(text, piece)
  text = lower(text)
  piece = lower(piece)
  if piece == "" then return false end
  return text:find(piece, 1, true) ~= nil
end

local function getDistance(a, b)
  return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function getChebyshevDistance(a, b)
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function isWalkablePos(pos)
  if not g_map or not g_map.getTile then return false end
  local tile = g_map.getTile(pos)
  if not tile then return false end
  if tile.isWalkable then return tile:isWalkable() end
  return true
end

local function getBestAdjacentShrinePos(shrinePos, playerPos)
  local candidates = {
    {x = shrinePos.x + 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y - 1, z = shrinePos.z}
  }

  local bestPos, bestDist = nil, 99999
  for _, pos in ipairs(candidates) do
    if isWalkablePos(pos) then
      local dist = getDistance(playerPos, pos)
      if dist < bestDist then
        bestDist = dist
        bestPos = pos
      end
    end
  end

  return bestPos
end

local function findNearestShrine()
  if not player or not player.getPosition or not g_map or not g_map.getTile then return nil, nil end
  local playerPos = player:getPosition()
  local bestShrine, bestDist, bestPos = nil, 99999, nil

  for x = -7, 7 do
    for y = -5, 5 do
      local scanPos = {x = playerPos.x + x, y = playerPos.y + y, z = playerPos.z}
      local tile = g_map.getTile(scanPos)
      if tile and tile.getItems then
        local items = tile:getItems()
        if items then
          for _, item in ipairs(items) do
            local id = item:getId()
            for _, shrineId in ipairs(SHRINES) do
              if id == shrineId then
                local dist = getDistance(playerPos, scanPos)
                if dist < bestDist then
                  bestDist = dist
                  bestShrine = item
                  bestPos = scanPos
                end
                break
              end
            end
          end
        end
      end
    end
  end

  return bestShrine, bestPos
end

local function isNearShrine(shrine)
  if not shrine or not shrine.getPosition or not player or not player.getPosition then return false end
  return getChebyshevDistance(player:getPosition(), shrine:getPosition()) <= 1
end

local function ensureNearShrine(shrine)
  if not shrine or not shrine.getPosition or not player or not player.getPosition then return false end
  if isNearShrine(shrine) then return true end

  local walkPos = getBestAdjacentShrinePos(shrine:getPosition(), player:getPosition())
  if not walkPos then return false end

  if type(autoWalk) == "function" then
    autoWalk(walkPos, 20, {ignoreNonPathable = true, precision = 1})
  end

  return false
end

local function useThingWithSafe(a, b)
  -- Em algumas builds do OTC/vBot, useThingWith/useWith abre a janela mas retorna nil/false.
  -- Por isso: se a função existe e foi chamada sem erro, consideramos como tentativa válida.
  if type(useThingWith) == "function" then
    local ok = pcall(function() useThingWith(a, b) end)
    return ok == true
  end

  if type(useWith) == "function" then
    local ok = pcall(function() useWith(a, b) end)
    return ok == true
  end

  return false
end

local function openShrineOnBlankScroll(itemObj)
  if not itemObj then return false end

  local shrine, shrinePos = findNearestShrine()
  if not shrine then
    return false
  end

  scrollCraftState.shrine = shrine
  scrollCraftState.shrinePos = shrinePos

  if not isNearShrine(shrine) then
    ensureNearShrine(shrine)

    later(1800, function()
      if not scrollCraftState.active then return end
      if not scrollCraftState.currentBlank then return end
      if not scrollCraftState.shrine then return end
      if not isNearShrine(scrollCraftState.shrine) then return end

      scrollCraftState.waitingWindow = true
      scrollCraftState.lastAction = nowMs()
      useThingWithSafe(scrollCraftState.shrine, scrollCraftState.currentBlank)
    end)

    return true
  end

  return useThingWithSafe(shrine, itemObj)
end

local function itemCount(it)
  if not it then return 0 end
  if it.getCount then
    local c = tonumber(it:getCount()) or 0
    if c > 0 then return c end
  end
  if it.getSubType then
    local c = tonumber(it:getSubType()) or 0
    if c > 0 then return c end
  end
  return 1
end

local function countItemInContainers(id)
  id = tonumber(id) or 0
  if id <= 0 then return 0 end

  -- Primeiro tenta contadores nativos do bot, porque eles costumam contar melhor
  -- todos os itens visíveis nas containers abertas.
  if type(itemAmount) == "function" then
    local ok, amount = pcall(function() return itemAmount(id) end)
    amount = tonumber(ok and amount or 0) or 0
    if amount > 0 then return amount end
  end

  if type(getItemsCount) == "function" then
    local ok, amount = pcall(function() return getItemsCount(id) end)
    amount = tonumber(ok and amount or 0) or 0
    if amount > 0 then return amount end
  end

  if type(getContainers) ~= "function" then return 0 end

  local total = 0
  local conts = getContainers()
  if not conts then return 0 end

  for c = 1, #conts do
    local cont = conts[c]
    if cont and cont.getItems then
      local items = cont:getItems()
      if items then
        for i = 1, #items do
          local it = items[i]
          if it and it.getId and it:getId() == id then
            total = total + itemCount(it)
          end
        end
      end
    end
  end

  return total
end

local function findItemInContainersById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it and it.getId and it:getId() == id then return it end
  end

  if type(getContainers) ~= "function" then return nil end
  local conts = getContainers()
  if not conts then return nil end

  for c = 1, #conts do
    local cont = conts[c]
    if cont and cont.getItems then
      local items = cont:getItems()
      if items then
        for i = 1, #items do
          local it = items[i]
          if it and it.getId and it:getId() == id then return it end
        end
      end
    end
  end

  return nil
end

local function tierScore(name)
  name = lower(name)
  if name:find("powerful", 1, true) then return 3 end
  if name:find("intricate", 1, true) then return 2 end
  if name:find("basic", 1, true) then return 1 end
  return 0
end

local function findImbueFromWindow(windowImbuements, desiredName)
  if type(windowImbuements) ~= "table" then return nil end

  desiredName = validImbueName(desiredName) or trim(desiredName)
  local aliases = IMBUE_ALIASES[desiredName] or {desiredName}
  local best, bestScore = nil, -1

  for i = 1, #windowImbuements do
    local imb = windowImbuements[i]
    local groupName = tostring(imb.group or "")
    local windowName = tostring(imb.name or "")
    local allText = groupName .. " " .. windowName
    local matched = false

    for _, alias in ipairs(aliases) do
      if hasText(allText, alias) then
        matched = true
        break
      end
    end

    if matched then
      local score = tierScore(windowName)
      if score >= bestScore then
        best = imb
        bestScore = score
      end
    end
  end

  return best
end

local function tryApplyImbuement(slotIdx, imbData)
  if not imbData then return false end
  if g_game and type(g_game.applyImbuement) == "function" then
    g_game.applyImbuement(slotIdx, imbData.id, true)
    return true
  end
  return false
end

local function closeImbuingWindowSafe()
  local closed = false

  if g_game and type(g_game.closeImbuingWindow) == "function" then
    pcall(function() g_game.closeImbuingWindow() end)
    closed = true
  end

  if g_ui and g_ui.getRootWidget then
    local root = g_ui.getRootWidget()
    if root and root.recursiveGetChildById then
      local knownIds = {"imbuingWindow", "imbueWindow", "ImbuingWindow", "imbueItemWindow"}
      for i = 1, #knownIds do
        local w = root:recursiveGetChildById(knownIds[i])
        if w and w.isVisible and w:isVisible() and w.hide then
          w:hide()
          closed = true
        end
      end
    end

    if root and root.getChildren then
      local childs = root:getChildren()
      for i = 1, #childs do
        local w = childs[i]
        if w and w.recursiveGetChildById then
          local title = w:recursiveGetChildById("title")
          if title and title.getText and tostring(title:getText()) == "Imbue Item" and w.hide then
            w:hide()
            closed = true
          end
        end
      end
    end
  end

  return closed
end

local function resetScrollCraftState()
  scrollCraftState.active = false
  scrollCraftState.queue = {}
  scrollCraftState.idx = 1
  scrollCraftState.waitingWindow = false
  scrollCraftState.waitingApply = false
  scrollCraftState.current = nil
  scrollCraftState.currentBlank = nil
  scrollCraftState.shrine = nil
  scrollCraftState.shrinePos = nil
  scrollCraftState.lastAction = 0
  scrollCraftState.startedAt = 0
  scrollCraftState.timeoutAt = 0
  scrollCraftState.cavebotControl = false
  scrollCraftState.cavebotWasOn = false
  scrollCraftState.cavebotFallbackAt = 0
end

local function finishScrollCrafting(message, releaseCavebotMs)
  -- So religa o CaveBot se o processo foi iniciado pelo checker especifico do CaveBot.
  releaseCaveBotFromBlank()

  resetScrollCraftState()
  closeImbuingWindowSafe()

  if releaseCavebotMs and releaseCavebotMs > 0 then
    scrollCraftState.releaseCavebotUntil = nowMs() + releaseCavebotMs
  end

  if message and message ~= "" then warn(message) end
end

local function buildScrollCraftQueue()
  local q = {}
  local maxByResult = {}

  -- Junta linhas repetidas do mesmo imbue e usa a MAIOR quantidade configurada.
  -- Ex.: duas linhas de Mana Leech com amount 3 nao viram 6, continuam meta 3.
  for i = 1, 6 do
    local cfgData = db.scrolls[i]
    if cfgData and cfgData.enabled == true then
      local name = validImbueName(cfgData.imbue) or ""
      local amount = tonumber(cfgData.amount or 0) or 0
      local resultId = SCROLL_RESULT_IDS[name]
      local blankId = tonumber(cfgData.itemId or 0) or BLANK_SCROLL_ID
      if blankId <= 0 then blankId = BLANK_SCROLL_ID end

      if name ~= "" and amount > 0 then
        if not resultId then
        else
          local key = tostring(resultId)
          local current = maxByResult[key]
          if not current or amount > current.amount then
            maxByResult[key] = {
              row = i,
              name = name,
              amount = amount,
              resultId = resultId,
              blankId = blankId
            }
          end
        end
      end
    end
  end

  for _, data in pairs(maxByResult) do
    local currentAmount = countItemInContainers(data.resultId)
    local missing = data.amount - currentAmount

    if missing > 0 then
      for n = 1, missing do
        q[#q + 1] = {
          row = data.row,
          name = data.name,
          amount = data.amount,
          resultId = data.resultId,
          blankId = data.blankId
        }
      end
    end
  end

  return q
end

function startScrollImbueBlank()
  if scrollCraftState.active then
    return false
  end

  saveBlankRows()
  local q = buildScrollCraftQueue()

  if #q == 0 then
    return false
  end

  local t = nowMs()
  scrollCraftState.active = true
  scrollCraftState.queue = q
  scrollCraftState.idx = 1
  scrollCraftState.waitingWindow = false
  scrollCraftState.waitingApply = false
  scrollCraftState.current = nil
  scrollCraftState.currentBlank = nil
  scrollCraftState.shrine = nil
  scrollCraftState.shrinePos = nil
  scrollCraftState.lastAction = t
  scrollCraftState.startedAt = t
  scrollCraftState.timeoutAt = t + math.max(90000, (#q * 18000) + 60000)
  scrollCraftState.releaseCavebotUntil = 0

  setTab("blank")
  return true
end

function stopScrollImbueBlank()
  finishScrollCrafting("[Scroll Imbue] Parado.", 8000)
end

function checkerScrollImbueBlank()
  if scrollCraftState.active then return "retry" end

  if nowMs() < (scrollCraftState.releaseCavebotUntil or 0) then
    return true
  end

  saveBlankRows()
  if #buildScrollCraftQueue() == 0 then
    return true
  end

  if startScrollImbueBlank() then
    return "retry"
  end

  return true
end

function startScrollImbueBlankCaveBot()
  if scrollCraftState.active then
    keepCaveBotOffDuringBlank()
    return true
  end

  saveBlankRows()
  local q = buildScrollCraftQueue()

  if #q == 0 then
    return false
  end

  if startScrollImbueBlank() then
    pauseCaveBotForBlank(q)
    return true
  end

  return false
end

function checkerScrollImbueBlankCaveBot()
  if scrollCraftState.active then
    keepCaveBotOffDuringBlank()
    return "retry"
  end

  if nowMs() < (scrollCraftState.releaseCavebotUntil or 0) then
    return true
  end

  saveBlankRows()
  local q = buildScrollCraftQueue()

  if #q == 0 then
    return true
  end

  if startScrollImbueBlank() then
    pauseCaveBotForBlank(q)
    return "retry"
  end

  return true
end

function checkerScrollImbueBlankWithCaveBot()
  return checkerScrollImbueBlankCaveBot()
end

local function onScrollImbuementWindow(itemIdFromWindow, slots, activeSlots, windowImbuements, needItems)
  if not scrollCraftState.active then return end
  if not scrollCraftState.waitingWindow then return end
  if not scrollCraftState.current then return end

  local current = scrollCraftState.current
  if tonumber(itemIdFromWindow) ~= tonumber(current.blankId) then return end

  scrollCraftState.waitingWindow = false
  scrollCraftState.waitingApply = true
  scrollCraftState.lastAction = nowMs()

  local imbData = findImbueFromWindow(windowImbuements or {}, current.name)
  if not imbData then
    finishScrollCrafting("[Scroll Imbue] Imbue nao encontrado na janela: " .. current.name, 12000)
    return
  end

  current.beforeCount = tonumber(current.beforeCount or countItemInContainers(current.resultId)) or 0

  if not tryApplyImbuement(0, imbData) then
    finishScrollCrafting("[Scroll Imbue] Falha ao aplicar: " .. current.name, 12000)
    return
  end

  -- Depois de aplicar no scroll, fecha a janela do jogo.
  -- O proximo scroll SEMPRE sera feito reabrindo a shrine no blank scroll novamente.
  later(800, function()
    if scrollCraftState.active and scrollCraftState.waitingApply then
      closeImbuingWindowSafe()
    end
  end)

  later(1600, function()
    if scrollCraftState.active and scrollCraftState.waitingApply then
      closeImbuingWindowSafe()
    end
  end)

  local applyDeadline = nowMs() + 6500
  local function releaseAfterApply()
    if not scrollCraftState.active then return end
    if not scrollCraftState.waitingApply then return end

    closeImbuingWindowSafe()

    local currentAmount = countItemInContainers(current.resultId)
    local increased = currentAmount > (tonumber(current.beforeCount or 0) or 0)
    local expired = nowMs() >= applyDeadline

    -- Espera a backpack atualizar o novo scroll antes de tentar abrir a shrine de novo.
    -- Se a contagem nao atualizar por algum motivo, segue no deadline para nao travar.
    if not increased and not expired then
      later(500, releaseAfterApply)
      return
    end

    scrollCraftState.waitingApply = false
    scrollCraftState.current = nil
    scrollCraftState.currentBlank = nil
    scrollCraftState.lastAction = nowMs()
  end

  later(2600, releaseAfterApply)
end

if type(onImbuementWindow) == "function" then
  onImbuementWindow(onScrollImbuementWindow)
else
end

macro(200, function()
  if not scrollCraftState.active then return end

  local t = nowMs()

  if scrollCraftState.cavebotControl == true then
    keepCaveBotOffDuringBlank()

    if (scrollCraftState.cavebotFallbackAt or 0) > 0 and t > scrollCraftState.cavebotFallbackAt then
      finishScrollCrafting("[Scroll Imbue] Fallback CaveBot: tempo limite atingido, religando CaveBot.", 12000)
      return
    end
  end

  if (scrollCraftState.timeoutAt or 0) > 0 and t > scrollCraftState.timeoutAt then
    finishScrollCrafting("[Scroll Imbue] Timeout de seguranca.", 12000)
    return
  end

  if scrollCraftState.waitingWindow and t - (scrollCraftState.lastAction or 0) > 18000 then
    finishScrollCrafting("[Scroll Imbue] Travou esperando abrir a janela.", 12000)
    return
  end

  if scrollCraftState.waitingApply and t - (scrollCraftState.lastAction or 0) > 18000 then
    finishScrollCrafting("[Scroll Imbue] Travou aplicando o imbue.", 12000)
    return
  end

  if t - (scrollCraftState.lastAction or 0) < 800 then return end
  if scrollCraftState.waitingWindow or scrollCraftState.waitingApply then return end

  if scrollCraftState.idx > #scrollCraftState.queue then
    finishScrollCrafting("[Scroll Imbue] Finalizado.")
    return
  end

  local data = scrollCraftState.queue[scrollCraftState.idx]
  scrollCraftState.idx = scrollCraftState.idx + 1

  -- Reconfere a quantidade antes de gastar outro blank scroll.
  -- Isso evita imbuir se voce ja tem a quantidade configurada na backpack aberta.
  local beforeCount = countItemInContainers(data.resultId)
  if beforeCount >= data.amount then
    scrollCraftState.lastAction = t
    return
  end
  data.beforeCount = beforeCount

  local blank = findItemInContainersById(data.blankId)
  if not blank then
    finishScrollCrafting("[Scroll Imbue] Acabou blank scroll ID " .. data.blankId .. ".", 12000)
    return
  end

  scrollCraftState.current = data
  scrollCraftState.currentBlank = blank
  scrollCraftState.waitingWindow = true
  scrollCraftState.lastAction = t

  if not openShrineOnBlankScroll(blank) then
    scrollCraftState.waitingWindow = false
    scrollCraftState.current = nil
    scrollCraftState.currentBlank = nil
    finishScrollCrafting("[Scroll Imbue] Nao consegui abrir a shrine no blank scroll.", 12000)
  end
end)


-- =========================================================
-- IMBUE ITEMS WITH READY SCROLLS ENGINE
-- =========================================================

db.itemAutoEnabled = db.itemAutoEnabled == true

local itemUseState = {
  active = false,
  queue = {},
  idx = 1,
  current = nil,
  recheck = nil,
  waitingLook = false,
  waitingApply = false,
  lastAction = 0,
  timeoutAt = 0,
  releaseCavebotUntil = 0,
  nextScanAt = 0
}

local EQUIP_SLOTS = {
  InventorySlotHead or 1,
  InventorySlotNeck or 2,
  InventorySlotBack or 3,
  InventorySlotBody or 4,
  InventorySlotRight or 5,
  InventorySlotLeft or 6,
  InventorySlotLeg or 7,
  InventorySlotFeet or 8,
  InventorySlotFinger or 9,
  InventorySlotAmmo or 10
}

local function getInventoryItemSafe(slot)
  if type(getInventoryItem) == "function" then
    local ok, item = pcall(function() return getInventoryItem(slot) end)
    if ok and item then return item end
  end

  if g_game and g_game.getLocalPlayer then
    local playerObj = g_game.getLocalPlayer()
    if playerObj and playerObj.getInventoryItem then
      local ok, item = pcall(function() return playerObj:getInventoryItem(slot) end)
      if ok and item then return item end
    end
  end

  return nil
end

local function findEquippedItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  for i = 1, #EQUIP_SLOTS do
    local item = getInventoryItemSafe(EQUIP_SLOTS[i])
    if item and item.getId and tonumber(item:getId()) == id then
      return item
    end
  end

  return nil
end

local function findTargetItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  local equipped = findEquippedItemById(id)
  if equipped then return equipped, "equip" end

  local inContainer = findItemInContainersById(id)
  if inContainer then return inContainer, "container" end

  return nil, nil
end

local function doLookItem(item)
  if not item then return false end

  if g_game and type(g_game.look) == "function" then
    local ok = pcall(function() g_game.look(item) end)
    if ok then return true end
  end

  if type(look) == "function" then
    local ok = pcall(function() look(item) end)
    if ok then return true end
  end

  return false
end


local itemLookSuppress = {
  active = false,
  untilTime = 0,
  lastClear = 0
}

local function startItemLookSuppress(ms)
  itemLookSuppress.active = true
  itemLookSuppress.untilTime = nowMs() + (tonumber(ms) or 1800)
end

local function stopItemLookSuppress()
  itemLookSuppress.active = false
  itemLookSuppress.untilTime = 0
end

local function isItemLookSuppressActive()
  if itemLookSuppress.active ~= true then return false end
  if nowMs() > (itemLookSuppress.untilTime or 0) then
    stopItemLookSuppress()
    return false
  end
  return true
end

local function clearItemLookMessage()
  local t = nowMs()
  if t - (itemLookSuppress.lastClear or 0) < 200 then return end
  itemLookSuppress.lastClear = t

  if modules and modules.game_textmessage and modules.game_textmessage.clearMessages then
    modules.game_textmessage.clearMessages()
  end
end

local function cleanLookImbueName(part)
  part = trim(part)
  part = part:gsub("^Basic%s+", "")
  part = part:gsub("^Intricate%s+", "")
  part = part:gsub("^Powerful%s+", "")
  part = part:gsub("%d+:%d+%s*[hH]", "")
  part = part:gsub("%d+%s*[hH]%s*%d+%s*[mM]", "")
  part = part:gsub("%d+%s*[hH]", "")
  return trim(part)
end

local function parseItemImbueLook(text)
  local info = {
    hasBlock = false,
    freeSlots = 0,
    active = {}
  }

  text = tostring(text or "")
  local block = text:match("Imbuements:%s*%((.-)%)")
  if not block or block == "" then return info end

  info.hasBlock = true

  for part in block:gmatch("([^,]+)") do
    part = trim(part)
    local lp = lower(part)

    local isFreeSlot =
      (lp:find("free", 1, true) and lp:find("slot", 1, true)) or
      (lp:find("empty", 1, true) and lp:find("slot", 1, true)) or
      (lp:find("available", 1, true) and lp:find("slot", 1, true)) or
      (lp:find("vazio", 1, true) and lp:find("slot", 1, true))

    if isFreeSlot then
      info.freeSlots = info.freeSlots + 1
    else
      local name = cleanLookImbueName(part)
      if name ~= "" then
        info.active[#info.active + 1] = name
      end
    end
  end

  return info
end

local function sameImbueName(activeName, desiredName)
  activeName = trim(activeName)
  desiredName = trim(desiredName)
  if activeName == "" or desiredName == "" then return false end

  if hasText(activeName, desiredName) or hasText(desiredName, activeName) then
    return true
  end

  local aliases = IMBUE_ALIASES[desiredName] or {desiredName}
  for i = 1, #aliases do
    local alias = aliases[i]
    if hasText(activeName, alias) or hasText(alias, activeName) then
      return true
    end
  end

  return false
end

local function itemAlreadyHasImbue(lookInfo, desiredName)
  if not lookInfo or type(lookInfo.active) ~= "table" then return false end

  for i = 1, #lookInfo.active do
    if sameImbueName(lookInfo.active[i], desiredName) then
      return true
    end
  end

  return false
end

local function resetItemUseState()
  stopItemLookSuppress()
  itemUseState.active = false
  itemUseState.queue = {}
  itemUseState.idx = 1
  itemUseState.current = nil
  itemUseState.recheck = nil
  itemUseState.waitingLook = false
  itemUseState.waitingApply = false
  itemUseState.lastAction = 0
  itemUseState.timeoutAt = 0
end

local function scheduleNextItemScan(ms)
  if db.itemAutoEnabled == true then
    itemUseState.nextScanAt = nowMs() + (tonumber(ms) or 30000)
  else
    itemUseState.nextScanAt = 0
  end
end

local function finishScrollItems(message, releaseCavebotMs)
  local keepNextScan = itemUseState.nextScanAt or 0
  resetItemUseState()
  itemUseState.nextScanAt = keepNextScan

  if releaseCavebotMs and releaseCavebotMs > 0 then
    itemUseState.releaseCavebotUntil = nowMs() + releaseCavebotMs
  end

  scheduleNextItemScan(30000)

  if message and message ~= "" then warn(message) end
end

local function buildScrollItemQueue()
  local q = {}

  for i = 1, #db.entries do
    local entry = db.entries[i]
    if entry and tonumber(entry.itemId or 0) > 0 and type(entry.scrollIds) == "table" and #entry.scrollIds > 0 then
      local target = findTargetItemById(entry.itemId)
      if target then
        q[#q + 1] = {
          uid = entry.uid,
          itemId = tonumber(entry.itemId),
          scrollIds = entry.scrollIds
        }
      end
    end
  end

  return q
end

local function requestLookForItem(data)
  local target, source = findTargetItemById(data.itemId)
  if not target then
    itemUseState.lastAction = nowMs()
    return false
  end

  data.source = source
  itemUseState.current = data
  itemUseState.waitingLook = true
  itemUseState.lastAction = nowMs()

  startItemLookSuppress(1800)

  if not doLookItem(target) then
    stopItemLookSuppress()
    itemUseState.waitingLook = false
    itemUseState.current = nil
    itemUseState.lastAction = nowMs()
    return false
  end

  return true
end

local function applyFirstMissingScrollFromLook(text)
  if not itemUseState.active then return end
  if not itemUseState.current then return end

  local data = itemUseState.current
  local lookInfo = parseItemImbueLook(text)

  itemUseState.waitingLook = false
  itemUseState.lastAction = nowMs()

  if not lookInfo.hasBlock then
    itemUseState.current = nil
    return
  end

  if lookInfo.freeSlots <= 0 then
    itemUseState.current = nil
    return
  end

  local target = findTargetItemById(data.itemId)
  if not target then
    itemUseState.current = nil
    return
  end

  for i = 1, #data.scrollIds do
    local scrollId = tonumber(data.scrollIds[i]) or 0
    local desiredName = scrollConfigNameById(scrollId)

    if desiredName == "" then
    elseif not itemAlreadyHasImbue(lookInfo, desiredName) then
      local scrollItem = findItemInContainersById(scrollId)

      if not scrollItem then
      else
        if useThingWithSafe(scrollItem, target) then
          itemUseState.waitingApply = true
          itemUseState.lastAction = nowMs()

          later(1800, function()
            if not itemUseState.active then return end
            if not itemUseState.waitingApply then return end

            itemUseState.waitingApply = false
            itemUseState.recheck = data
            itemUseState.current = nil
            itemUseState.lastAction = nowMs()
          end)

          return
        end
      end
    end
  end

  itemUseState.current = nil
end

function startScrollImbueItems(silent)
  if itemUseState.active then
    if not silent then end
    return false
  end

  if scrollCraftState.active then
    if not silent then end
    return false
  end

  if type(db.entries) ~= "table" or #db.entries == 0 then
    if not silent then end
    return false
  end

  local q = buildScrollItemQueue()
  if #q == 0 then
    if not silent then end
    return false
  end

  local t = nowMs()
  itemUseState.active = true
  itemUseState.queue = q
  itemUseState.idx = 1
  itemUseState.current = nil
  itemUseState.recheck = nil
  itemUseState.waitingLook = false
  itemUseState.waitingApply = false
  itemUseState.lastAction = t
  itemUseState.timeoutAt = t + math.max(90000, (#q * 12000) + 30000)
  itemUseState.releaseCavebotUntil = 0
  itemUseState.nextScanAt = 0

  setTab("items")
  if not silent then end
  return true
end

function stopScrollImbueItems()
  finishScrollItems("", 8000)
end

function checkerScrollImbueItems()
  if itemUseState.active then return "retry" end

  if nowMs() < (itemUseState.releaseCavebotUntil or 0) then
    return true
  end

  if db.itemAutoEnabled ~= true then
    return true
  end

  if startScrollImbueItems(true) then
    return "retry"
  end

  return true
end

local function handleItemLookText(text)
  if not itemUseState.active then return false end
  if not itemUseState.waitingLook then return false end
  if type(text) ~= "string" then return false end
  if not text:find("Imbuements:", 1, true) then return false end

  applyFirstMissingScrollFromLook(text)

  if isItemLookSuppressActive() then
    later(1, clearItemLookMessage)
    later(80, clearItemLookMessage)
  end

  stopItemLookSuppress()
  return true
end

if type(onTextMessage) == "function" then
  onTextMessage(function(mode, text)
    handleItemLookText(text)
  end)
else
end

-- Algumas builds exibem o look por displayStatusMessage em vez de disparar onTextMessage.
-- Esse hook deixa o recheck mais confiavel e ainda limpa a mensagem da tela.
if modules and modules.game_textmessage and modules.game_textmessage.displayStatusMessage then
  local oldItemStatusMessage = modules.game_textmessage.displayStatusMessage
  modules.game_textmessage.displayStatusMessage = function(text, color)
    if oldItemStatusMessage then
      oldItemStatusMessage(text, color)
    end
    handleItemLookText(text)
  end
end

macro(200, function()
  if not itemUseState.active then return end

  local t = nowMs()

  if (itemUseState.timeoutAt or 0) > 0 and t > itemUseState.timeoutAt then
    finishScrollItems("", 12000)
    return
  end

  if itemUseState.waitingLook and t - (itemUseState.lastAction or 0) > 4500 then
    stopItemLookSuppress()
    itemUseState.waitingLook = false
    itemUseState.current = nil
    itemUseState.lastAction = t
    return
  end

  if itemUseState.waitingApply and t - (itemUseState.lastAction or 0) > 6500 then
    itemUseState.waitingApply = false
    itemUseState.current = nil
    itemUseState.lastAction = t
    return
  end

  if t - (itemUseState.lastAction or 0) < 600 then return end
  if itemUseState.waitingLook or itemUseState.waitingApply then return end

  local data = nil

  if itemUseState.recheck then
    data = itemUseState.recheck
    itemUseState.recheck = nil
  else
    if itemUseState.idx > #itemUseState.queue then
      finishScrollItems("")
      return
    end

    data = itemUseState.queue[itemUseState.idx]
    itemUseState.idx = itemUseState.idx + 1
  end

  if data then
    requestLookForItem(data)
  end
end)

-- Recheca os itens a cada 30 segundos para atualizar os slots livres.
-- Nao depende do macro de 30000ms; usa timer interno para nao perder o ciclo.
macro(1000, function()
  if db.itemAutoEnabled ~= true then
    itemUseState.nextScanAt = 0
    return
  end

  if itemUseState.active then return end
  if scrollCraftState.active then return end

  local t = nowMs()
  if (itemUseState.nextScanAt or 0) <= 0 then
    itemUseState.nextScanAt = t + 30000
    return
  end

  if t < itemUseState.nextScanAt then return end

  if startScrollImbueItems(true) then
    itemUseState.nextScanAt = 0
  else
    itemUseState.nextScanAt = t + 30000
  end
end)

-- =========================================================
-- EXTERNAL ICON API
-- Os icones ficam no painel icons.lua. Esta script so expoe as funcoes.
-- =========================================================

function isScrollImbueBlankActive()
  return scrollCraftState.active == true
end

function toggleScrollImbueBlankIcon()
  if scrollCraftState.active then
    stopScrollImbueBlank()
    return false
  end

  return startScrollImbueBlank()
end

function isScrollImbueItemsEnabled()
  return db.itemAutoEnabled == true
end

function setScrollImbueItemsAuto(state)
  state = state == true

  if db.itemAutoEnabled == state then
    if state == true and not itemUseState.active then
      itemUseState.nextScanAt = 0
      if not startScrollImbueItems(true) then
        scheduleNextItemScan(30000)
      end
    end
    return true
  end

  db.itemAutoEnabled = state
  saveScrollImbue()

  if db.itemAutoEnabled == true then
    itemUseState.nextScanAt = 0
    if not startScrollImbueItems(false) then
      scheduleNextItemScan(30000)
    end
  else
    itemUseState.nextScanAt = 0
    finishScrollItems("", 8000)
  end

  return true
end

function toggleScrollImbueItemsAuto()
  return setScrollImbueItemsAuto(not (db.itemAutoEnabled == true))
end

function debugScrollImbueItems()
  if type(db.entries) ~= "table" or #db.entries == 0 then
    return
  end

  for i = 1, #db.entries do
    local entry = db.entries[i]
    local itemId = tonumber(entry and entry.itemId or 0) or 0
    local itemObj, source = findTargetItemById(itemId)

    if entry and type(entry.scrollIds) == "table" then
      for s = 1, #entry.scrollIds do
        local sid = tonumber(entry.scrollIds[s]) or 0
        local scrollObj = findItemInContainersById(sid)
      end
    end
  end
end

end)

lnsRunBlock("IMBUEMENTS", function()

storage = storage or {}
storage.LNSImbuementsGlobal = storage.LNSImbuementsGlobal or {}

local imbuementsStorage = storage.LNSImbuementsGlobal

local function saveImbuementsGlobal()
  storage.LNSImbuementsGlobal = imbuementsStorage
end

local function saveImbuementChar()
  saveImbuementsGlobal()
end

setDefaultTab("Tools")

panelImbuiment = setupUI([[
MainWindow
  size: 450 337
  text: Panel Imbuement

  UIButton
    id: clickHere
    anchors.top: parent.top
    anchors.left: parent.left
    text: Click Here
    margin-top: -2
    margin-left: 100
    color: #FFD700
    text-auto-resize: true
    font: verdana-11px-rounded
    opacity: 1.00
    $hover:
      opacity: 0.80

  Label
    id: labelClick
    anchors.verticalCenter: clickHere.verticalCenter
    anchors.left: clickHere.right
    margin-left: 4
    margin-top: 0
    font: verdana-11px-rounded
    text: to manage auto imbuement

  FlatPanel
    id: flatP
    anchors.fill: parent
    margin: -8
    margin-top: 15
    margin-bottom: 20
    
    Label
      text: Clean Imbuements with:
      anchors.top: parent.top
      anchors.left: parent.left
      color: gray
      margin-top: 3
      margin-left: 5

    HorizontalScrollBar
      id: limparImbuements
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 5
      margin-right: 5
      minimum: 1
      maximum: 1200

      Label
        id: limparText
        anchors.centerIn: parent
        font: verdana-11px-rounded
        color: #d7c08a
        text-auto-resize: true
        text: "1 min"
        phantom: true

    Label
      text: Imbuement Mode:
      anchors.top: prev.bottom
      anchors.left: parent.left
      color: gray
      margin-top: 7
      margin-left: 5

    BotSwitch
      id: imbuingShrine
      anchors.left: limparImbuements.left
      anchors.verticalCenter: prev.verticalCenter
      text: Shrine
      width: 140
      font: verdana-11px-rounded
      $on:
        image-color: green
        color: green
      $!on:
        image-color: gray
        color: white

    BotSwitch
      id: portableShrine
      anchors.left: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Portable
      width: 140
      margin-top: 0
      margin-left: 1
      font: verdana-11px-rounded
      $on:
        image-color: green
        color: green
      $!on:
        image-color: gray
        color: white

    TextList
      id: imbueList
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin: 5
      margin-right: 15
      vertical-scrollbar: imbueListScrollBar

    VerticalScrollBar
      id: imbueListScrollBar
      anchors.top: imbueList.top
      anchors.bottom: imbueList.bottom
      anchors.left: imbueList.right
      step: 10
      pixels-scroll: true
      border: 1 #1f1f1f

  Button
    id: closePanel
    anchors.left: flatP.left
    anchors.right: flatP.right
    anchors.top: flatP.bottom
    margin-left: -1
    margin-top: 5
    text: Fechar
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
panelImbuiment:hide()

local panelImbuementManager = setupUI([[
MainWindow
  id: imbuementManager
  size: 420 410
  text: Auto Imbuement Manager

  FlatPanel
    id: bg
    anchors.fill: parent
    margin: -8
    margin-top: 0
    margin-bottom: 20

    FlatPanel
      id: leftBox
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 60
      margin-top: 8
      margin-left: 6
      margin-right: 6

      Label
        text: Item
        anchors.top: parent.top
        anchors.left: parent.left
        margin-left: 13
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      BotItem
        id: itemToImbue
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        margin-top: 0
        margin-left: 12
        border: 1 #d7c08a

      VerticalSeparator
        id: vsep
        anchors.top: parent.top
        anchors.left: prev.right
        anchors.bottom: parent.bottom
        margin-left: 13

      Label
        text: Slot Equipament
        anchors.top: parent.top
        anchors.left: prev.right
        margin-left: 60
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      UIItem
        id: head
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: vsep.right
        margin-left: 10
        image-source: /images/game/slots/head
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: body
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/body
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: legs
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/legs
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: feet
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/feet
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: left-hand
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/left-hand
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: right-hand
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/right-hand
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: back
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/back
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      VerticalSeparator
        id: vsep2
        anchors.top: parent.top
        anchors.left: prev.right
        anchors.bottom: parent.bottom
        margin-left: 13

      Label
        text: Qtd. Imbue
        anchors.top: parent.top
        anchors.left: prev.right
        margin-left: 13
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      SpinBox
        id: qtdimbue
        anchors.verticalCenter: back.verticalCenter
        anchors.left: vsep2.right
        anchors.right: parent.right
        margin-left: 10
        margin-right: 10
        text-align: center
        font: verdana-11px-rounded
        color: gray
        minimum: 1
        maximum: 3
  
    FlatPanel
      id: bottomBox
      anchors.top: leftBox.bottom
      anchors.left: leftBox.left
      anchors.right: leftBox.right
      anchors.bottom: parent.bottom
      margin-top: 5
      margin-bottom: 5

      Label
        text: Slot Imbue 1:
        anchors.top: parent.top
        anchors.left: parent.left
        margin-left: 6
        margin-top: 2
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList1
        anchors.top: prev.bottom
        anchors.left: parent.left
        height: 70
        width: 260
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll1
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll1
        anchors.top: imbueList1.top
        anchors.bottom: imbueList1.bottom
        anchors.left: prev.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel1
        anchors.top: prev.top
        anchors.left: imbueList1.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

      Label
        text: Slot Imbue 2:
        anchors.top: imbueList1.bottom
        anchors.left: parent.left
        margin-left: 6
        margin-top: 4
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList2
        anchors.top: prev.bottom
        anchors.left: parent.left
        height: 70
        width: 260
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll2
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll2
        anchors.top: imbueList2.top
        anchors.bottom: imbueList2.bottom
        anchors.left: imbueList2.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel2
        anchors.top: prev.top
        anchors.left: imbueList2.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

      Label
        text: Slot Imbue 3:
        anchors.top: imbueList2.bottom
        anchors.left: parent.left
        margin-left: 6
        margin-top: 4
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList3
        anchors.top: prev.bottom
        anchors.left: parent.left
        width: 260
        height: 70
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll3
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll3
        anchors.top: imbueList3.top
        anchors.bottom: imbueList3.bottom
        anchors.left: prev.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel3
        anchors.top: prev.top
        anchors.left: imbueList3.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

  Button
    id: cancelar
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 5
    width: 200
    text: Cancelar
    font: verdana-11px-rounded

  Button
    id: confirmar
    anchors.top: prev.top
    anchors.left: prev.right
    width: 200
    margin-left: 5
    text: Confirmar
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
panelImbuementManager:hide()

local function destroyImbuingPanel()
  if not g_ui or not g_ui.getRootWidget then return false end
  local root = g_ui.getRootWidget()
  if not root then return false end

  -- tente por ids comuns (se você souber o id exato, coloca aqui primeiro)
  local knownIds = { "imbuingWindow", "imbueWindow", "ImbuingWindow", "imbueItemWindow" }
  for i = 1, #knownIds do
    local w = root:recursiveGetChildById(knownIds[i])
    if w and w:isVisible() then
      w:hide()
      return true
    end
  end

  -- fallback: varre janelas procurando título "Imbue Item"
  local children = root:getChildren()
  for i = 1, #children do
    local w = children[i]
    if w and w.getClassName and w:getClassName() == "UIWindow" then
      local title = w:recursiveGetChildById("title")
      if title and title.getText and title:getText() == "Imbue Item" then
        w:hide()
        return true
      end
    end
  end

  return false
end

imbuementsStorage.autoImbuement = imbuementsStorage.autoImbuement or {
  enabled = false,
  limparMinutes = 60,
  shrineMode = "imbuing", -- "imbuing" / "portable"
  entries = {},
  nextUid = 0,
  timers = {},
  recentActions = {}
}

local db = imbuementsStorage.autoImbuement
saveImbuementChar()

db.entries = db.entries or {}
db.timers = db.timers or {}
db.recentActions = db.recentActions or {}

local panel = panelImbuiment
local manager = panelImbuementManager

-- =========================================================
-- CONST / MAPS
-- =========================================================
local IMBUE_OPTIONS = {
  "Life Leech", "Mana Leech", "Critical", "Magic Level", "Skill Boost",
  "Fire Protection", "Ice Protection", "Earth Protection", "Energy Protection",
  "Death Protection", "Holy Protection",
}

local IMBUE_LEVELS = { "Basic", "Intricate", "Powerful" }

local LOOK_NAME_TO_VISUAL = {
  ["Void"] = "Mana Leech",
  ["Vampirism"] = "Life Leech",
  ["Strike"] = "Critical",
  ["Epiphany"] = "Magic Level",

  ["Precision"] = "Skill Boost",
  ["Chop"] = "Skill Boost",
  ["Slash"] = "Skill Boost",
  ["Bash"] = "Skill Boost",

  ["Dragon Hide"] = "Fire Protection",
  ["Quara Scale"] = "Ice Protection",
  ["Snake Skin"] = "Earth Protection",
  ["Cloud Fabric"] = "Energy Protection",
  ["Lich Shroud"] = "Death Protection",
  ["Demon Presence"] = "Holy Protection",

  ["Featherweight"] = "Capacity",
  ["Swiftness"] = "Speed"
}

local IMBUE_VISUAL_TO_KIND = {
  ["Life Leech"]        = "Vampirism",
  ["Mana Leech"]        = "Void",
  ["Critical"]          = "Strike",
  ["Magic Level"]       = "Epiphany",
  ["Skill Boost"]       = "Precision",

  ["Fire Protection"]   = "Dragon Hide",
  ["Ice Protection"]    = "Quara Scale",
  ["Earth Protection"]  = "Snake Skin",
  ["Energy Protection"] = "Cloud Fabric",
  ["Death Protection"]  = "Lich Shroud",
  ["Holy Protection"]   = "Demon Presence",
}

local GROUP_TO_SHRINE_TEXT = {
  ["Void"]           = "Mana Leech",
  ["Vampirism"]      = "Hit Points Leech",
  ["Strike"]         = "Critical",
  ["Epiphany"]       = "Magic Level",
  ["Precision"]      = "Skillboost (Distance)",
  ["Lich Shroud"]    = "Elemental Protection (Death)",
  ["Snake Skin"]     = "Elemental Protection (Earth)",
  ["Demon Presence"] = "Elemental Protection (Holy)",
  ["Dragon Hide"]    = "Elemental Protection (Fire)",
  ["Quara Scale"]    = "Elemental Protection (Ice)",
  ["Cloud Fabric"]   = "Elemental Protection (Energy)",
}

local SHRINES = {25060, 25061, 25174, 25175, 25182, 25183}
local PORTABLE_SHRINE = 14513
local RECENT_ACTION_MS = 10000

local SLOT_TO_INV = {
  head = InventorySlotHead or 1,
  back = InventorySlotBack or 3,
  body = InventorySlotBody or 4,
  ["right-hand"] = InventorySlotRight or 5,
  ["left-hand"] = InventorySlotLeft or 6,
  legs = InventorySlotLeg or 7,
  feet = InventorySlotFeet or 8,
}

local SLOT_WIDGET_IDS = {"head", "body", "legs", "feet", "left-hand", "right-hand", "back"}

-- =========================================================
-- REFS
-- =========================================================
local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then
    return root:recursiveGetChildById(id)
  end
  if root.getChildById then
    return root:getChildById(id)
  end
  return nil
end

local refs = {
  item = W(manager, "itemToImbue"),
  qtd = W(manager, "qtdimbue"),
  confirm = W(manager, "confirmar"),
  cancel = W(manager, "cancelar"),

  open = W(panel, "clickHere"),
  close = W(panel, "closePanel"),
  list = W(panel, "imbueList"),
  limpar = W(panel, "limparImbuements"),
  limparText = W(panel, "limparText"),
  shrine = W(panel, "imbuingShrine"),
  portable = W(panel, "portableShrine"),

  leftBox = W(manager, "leftBox"),
  bottomBox = W(manager, "bottomBox"),
}

local imbueLists = { W(manager, "imbueList1"), W(manager, "imbueList2"), W(manager, "imbueList3") }
local levelLists = { W(manager, "imbueNivel1"), W(manager, "imbueNivel2"), W(manager, "imbueNivel3") }

local slotWidgets = {
  head = W(manager, "head"),
  body = W(manager, "body"),
  legs = W(manager, "legs"),
  feet = W(manager, "feet"),
  ["left-hand"] = W(manager, "left-hand"),
  ["right-hand"] = W(manager, "right-hand"),
  back = W(manager, "back"),
}

-- =========================================================
-- TEMPLATES
-- =========================================================
local selectRowTemplate = [[
selectRow < UIWidget
  id: root
  height: 13
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.85

  $focus:
    background-color: #2f6f3e
    opacity: 0.95

  Label
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    color: white
    text: ""
]]

local savedRowTemplate = [[
savedRow < UIWidget
  id: root
  height: 45
  focusable: true
  background-color: alpha
  margin-top: 2
  opacity: 1.00
  border: 1 alpha

  $hover:
    background-color: #2F2F2F
    opacity: 0.80
    border: 1 gray

  $focus:
    background-color: #404040
    border: 1 gray
    opacity: 0.90

  UIItem
    id: icon
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 4
    margin-top: 2
    size: 40 40

  Label
    id: text
    anchors.left: icon.right
    anchors.right: remove.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    margin-left: 6
    margin-right: 4
    text-align: center
    font: verdana-11px-rounded
    color: white
    text-wrap: true
    text-vertical-auto-resize: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 3
    text: X
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

g_ui.loadUIFromString(selectRowTemplate)
g_ui.loadUIFromString(savedRowTemplate)

-- =========================================================
-- HELPERS
-- =========================================================
local function clamp(v, a, b)
  v = tonumber(v) or a
  if v < a then return a end
  if v > b then return b end
  return v
end

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function lowerTrim(s)
  return trim(s):lower()
end

local function cloneTable(orig)
  if type(orig) ~= "table" then return orig end
  local copy = {}
  for k, v in pairs(orig) do
    if type(v) == "table" then
      copy[k] = cloneTable(v)
    else
      copy[k] = v
    end
  end
  return copy
end

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function later(ms, fn)
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end
  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end
  if g_dispatcher and g_dispatcher.scheduleEvent then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  return fn()
end

local function clearChildren(widget)
  if not widget or not widget.getChildren then return end
  local children = widget:getChildren()
  for i = #children, 1, -1 do
    local child = children[i]
    if child and (not child.isDestroyed or not child:isDestroyed()) then
      child:destroy()
    end
  end
end

local function getRowLabel(row)
  if not row then return nil end
  return row.text or (row.getChildById and row:getChildById("text")) or nil
end

local function getRowRemove(row)
  if not row then return nil end
  return row.remove or (row.getChildById and row:getChildById("remove")) or nil
end

local function getRowIcon(row)
  if not row then return nil end
  return row.icon or (row.getChildById and row:getChildById("icon")) or nil
end

local function clearRowFocus(listWidget)
  if not listWidget or not listWidget.getChildren then return end
  for _, child in ipairs(listWidget:getChildren()) do
    if child.setFocused then child:setFocused(false) end
    child._selected = false
  end
  listWidget._selectedRow = nil
  listWidget._selectedValue = nil
end

local function setRowFocus(listWidget, row, value)
  if not listWidget or not row then return end
  clearRowFocus(listWidget)
  if row.setFocused then row:setFocused(true) end
  row._selected = true
  listWidget._selectedRow = row
  listWidget._selectedValue = value
end

local function getSelectedRowValue(listWidget)
  if not listWidget then return "" end
  return tostring(listWidget._selectedValue or "")
end

local function createSelectRow(listWidget, text, onSelect)
  local row = g_ui.createWidget("selectRow", listWidget)
  local label = getRowLabel(row)
  row._value = tostring(text or "")

  if label then
    label:setText(row._value)
  end

  row.onClick = function(widget)
    if listWidget._locked then return end
    setRowFocus(listWidget, widget, widget._value)
    if onSelect then onSelect(widget._value, widget) end
  end

  return row
end

local function fillSelectList(listWidget, entries, onSelect)
  if not listWidget then return end
  clearChildren(listWidget)
  clearRowFocus(listWidget)
  for i = 1, #entries do
    createSelectRow(listWidget, entries[i], onSelect)
  end
end

local function selectListValue(listWidget, value)
  if not listWidget or not listWidget.getChildren then return false end
  value = tostring(value or "")
  for _, child in ipairs(listWidget:getChildren()) do
    if tostring(child._value or "") == value then
      setRowFocus(listWidget, child, child._value)
      return true
    end
  end
  clearRowFocus(listWidget)
  return false
end

local function nextUid()
  db.nextUid = (tonumber(db.nextUid) or 0) + 1
  return db.nextUid
end

local function itemTimerKey(itemId)
  return tostring(tonumber(itemId) or 0)
end

local function canonImbueName(name)
  name = trim(tostring(name or ""))
  if name == "" then return "" end

  if name == "Hit Points Leech" then return "Life Leech" end
  if name == "Mana Leech" then return "Mana Leech" end
  if name == "Critical" then return "Critical" end
  if name == "Magic Level" then return "Magic Level" end

  if name == "Skillboost (Distance)" or name == "Skillboost (Sword)" or name == "Skillboost (Club)" or name == "Skillboost (Axe)" then
    return "Skill Boost"
  end

  if name == "Elemental Protection (Fire)" then return "Fire Protection" end
  if name == "Elemental Protection (Ice)" then return "Ice Protection" end
  if name == "Elemental Protection (Earth)" then return "Earth Protection" end
  if name == "Elemental Protection (Energy)" then return "Energy Protection" end
  if name == "Elemental Protection (Death)" then return "Death Protection" end
  if name == "Elemental Protection (Holy)" then return "Holy Protection" end

  return LOOK_NAME_TO_VISUAL[name] or name
end

local function tierNameToNumber(name)
  name = lowerTrim(name)
  if name == "basic" then return 1 end
  if name == "intricate" then return 2 end
  return 3
end

local function getTierFromWindowName(name)
  name = lowerTrim(name)
  if name:find("basic", 1, true) then return 1 end
  if name:find("intricate", 1, true) then return 2 end
  if name:find("powerful", 1, true) then return 3 end
  return 3
end

local function uiItemSlotNameToType(slotId)
  if slotId == "head" then return "Helmet" end
  if slotId == "body" then return "Armor" end
  if slotId == "legs" then return "Legs" end
  if slotId == "feet" then return "Boots" end
  if slotId == "left-hand" then return "Weapon" end
  if slotId == "right-hand" then return "Shield/Book" end
  if slotId == "back" then return "Bag" end
  return ""
end

local function typeToSlotKey(typ)
  if typ == "Helmet" then return "head" end
  if typ == "Armor" then return "body" end
  if typ == "Legs" then return "legs" end
  if typ == "Boots" then return "feet" end
  if typ == "Weapon" then return "left-hand" end
  if typ == "Shield/Book" then return "right-hand" end
  if typ == "Bag" then return "back" end
  return nil
end

local function getDistance(a, b)
  return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function getChebyshevDistance(a, b)
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function isWalkablePos(pos)
  local tile = g_map.getTile(pos)
  if not tile then return false end
  if tile.isWalkable then
    return tile:isWalkable()
  end
  return true
end

local function getBestAdjacentShrinePos(shrinePos, playerPos)
  local candidates = {
    {x = shrinePos.x + 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y - 1, z = shrinePos.z},
  }

  local bestPos, bestDist = nil, 99999
  for _, pos in ipairs(candidates) do
    if isWalkablePos(pos) then
      local dist = getDistance(playerPos, pos)
      if dist < bestDist then
        bestDist = dist
        bestPos = pos
      end
    end
  end

  return bestPos
end

local function normalizeEntry(entry)
  entry = entry or {}
  entry.uid = tonumber(entry.uid or 0) or 0
  entry.itemId = tonumber(entry.itemId or 0) or 0
  entry.type = entry.type or ""
  entry.slotKey = entry.slotKey or typeToSlotKey(entry.type)
  entry.slots = clamp(entry.slots or 1, 1, 3)
  entry.imbues = entry.imbues or {}

  for i = 1, entry.slots do
    entry.imbues[i] = entry.imbues[i] or {name = "", level = "Basic"}
    entry.imbues[i].name = trim(entry.imbues[i].name or "")
    entry.imbues[i].level = trim(entry.imbues[i].level or "Basic")
  end

  return entry
end

local function formatImbText(imbs, qtd)
  local parts = {}
  qtd = tonumber(qtd or #imbs) or #imbs

  for i = 1, qtd do
    local n = tostring(imbs[i] and imbs[i].name or "")
    local l = tostring(imbs[i] and imbs[i].level or "")
    if n ~= "" and n ~= "nil" then
      if l ~= "" and l ~= "nil" then
        parts[#parts + 1] = n .. " (" .. l .. ")"
      else
        parts[#parts + 1] = n
      end
    end
  end

  if #parts == 0 then return "(Nenhum)" end
  return table.concat(parts, "\n")
end

-- =========================================================
-- STATE UI
-- =========================================================
local state = {
  slot = nil,
  imbues = { nil, nil, nil },
  levels = { "Basic", "Basic", "Basic" },
  editingUid = nil
}

local imbState = {
  active = false,
  queue = {},
  idx = 1,
  waitingWindow = false,
  waitingApply = false,
  currentEntry = nil,
  currentItem = nil,
  currentItemSource = nil,
  shrine = nil,
  shrinePos = nil,
  startedAt = 0,
  lastAction = 0,
  manualMode = false, -- true quando chamado por startImbueAllFromList(true); nao mexe no CaveBot
  actionToken = 0,
  reopenAfterClear = false
}

local IMBUE_MAX_RUNTIME_MS = 120000 -- 2 minutos para evitar CaveBot desligado caso bugue
local IMBUE_WAIT_WINDOW_TIMEOUT_MS = 15000
local IMBUE_WAIT_APPLY_TIMEOUT_MS = 15000

local function imbueCaveBotSetOn()
  if CaveBot and type(CaveBot.setOn) == "function" then
    pcall(function() CaveBot.setOn() end)
  end
end

local function imbueCaveBotSetOff()
  if CaveBot and type(CaveBot.setOff) == "function" then
    pcall(function() CaveBot.setOff() end)
  end
end

-- =========================================================
-- UI HELPERS
-- =========================================================
local function refreshSlotBorders()
  for name, widget in pairs(slotWidgets) do
    if widget and widget.setBorderWidth then widget:setBorderWidth(1) end
    if widget and widget.setBorderColor then
      widget:setBorderColor(name == state.slot and "#00ff66" or "#3a3a3a")
    end
    if widget and widget.setOpacity then
      widget:setOpacity(name == state.slot and 1.0 or 0.85)
    end
  end
end

local function setSectionEnabled(i, enabled)
  local a, b = imbueLists[i], levelLists[i]

  if a then
    a._locked = not enabled
    if a.setEnabled then a:setEnabled(enabled) end
    if a.setFocusable then a:setFocusable(enabled) end
    if a.setOpacity then a:setOpacity(enabled and 1.0 or 0.40) end
  end

  if b then
    b._locked = not enabled
    if b.setEnabled then b:setEnabled(enabled) end
    if b.setFocusable then b:setFocusable(enabled) end
    if b.setOpacity then b:setOpacity(enabled and 1.0 or 0.40) end
  end
end

local function getQtd()
  if refs.qtd and refs.qtd.getValue then
    return clamp(refs.qtd:getValue(), 1, 3)
  end
  return 1
end

local function updateLimparText(v)
  v = clamp(v or 1, 1, 1200)
  db.limparMinutes = v
  if refs.limparText then refs.limparText:setText(v .. " min") end
  saveImbuementChar()
end

local function setShrine(mode)
  db.shrineMode = (mode == "portable" and "portable" or "imbuing")
  if refs.shrine and refs.shrine.setOn then refs.shrine:setOn(db.shrineMode == "imbuing") end
  if refs.portable and refs.portable.setOn then refs.portable:setOn(db.shrineMode == "portable") end
  saveImbuementChar()
end

local function buildSelectList(listWidget, options, selected, enabled, setter)
  if not listWidget then return end
  clearChildren(listWidget)

  for _, value in ipairs(options) do
    local row = g_ui.createWidget("selectRow", listWidget)
    local label = getRowLabel(row)
    row._value = value

    if label then label:setText(value) end

    if enabled and selected == value then
      setRowFocus(listWidget, row, value)
    end

    row.onClick = function(widget)
      if listWidget._locked then return end
      setRowFocus(listWidget, widget, widget._value)
      if setter then setter(value) end
    end

    if not enabled then
      if row.setEnabled then row:setEnabled(false) end
      if row.setOpacity then row:setOpacity(0.40) end
    end
  end
end

local function refreshManagerLists()
  local qtd = getQtd()

  for i = 1, 3 do
    local enabled = i <= qtd
    if not enabled then
      state.imbues[i] = nil
      state.levels[i] = "Basic"
    end

    setSectionEnabled(i, enabled)

    buildSelectList(imbueLists[i], IMBUE_OPTIONS, state.imbues[i], enabled, function(v)
      state.imbues[i] = v
    end)

    buildSelectList(levelLists[i], IMBUE_LEVELS, state.levels[i], enabled, function(v)
      state.levels[i] = v
    end)
  end
end

local function resetManager()
  state.slot = nil
  state.editingUid = nil
  state.imbues = { nil, nil, nil }
  state.levels = { "Basic", "Basic", "Basic" }

  if refs.item and refs.item.setItemId then refs.item:setItemId(0) end
  if refs.qtd and refs.qtd.setValue then refs.qtd:setValue(1) end

  refreshSlotBorders()
  refreshManagerLists()
end

local function loadEntryToManager(entry)
  entry = normalizeEntry(cloneTable(entry))
  state.editingUid = tonumber(entry.uid) or nil
  state.slot = entry.slotKey or typeToSlotKey(entry.type)
  state.imbues = { nil, nil, nil }
  state.levels = { "Basic", "Basic", "Basic" }

  if refs.item and refs.item.setItemId then refs.item:setItemId(entry.itemId or 0) end
  if refs.qtd and refs.qtd.setValue then refs.qtd:setValue(entry.slots or 1) end

  for i = 1, entry.slots do
    state.imbues[i] = entry.imbues[i] and entry.imbues[i].name or nil
    state.levels[i] = entry.imbues[i] and entry.imbues[i].level or "Basic"
  end

  refreshSlotBorders()
  refreshManagerLists()
end

local function removeEntryByUid(uid)
  uid = tonumber(uid)
  if not uid then return end

  for i = #db.entries, 1, -1 do
    if tonumber(db.entries[i].uid) == uid then
      table.remove(db.entries, i)
      break
    end
  end

  saveImbuementChar()
  rebuildMainList()
end

local function createSavedRow(listWidget, entry, onRemove)
  local row = g_ui.createWidget("savedRow", listWidget)
  local icon = getRowIcon(row)
  local label = getRowLabel(row)
  local remove = getRowRemove(row)

  row._uid = tonumber(entry.uid)

  if icon and icon.setItemId then
    icon:setItemId(tonumber(entry.itemId) or 0)
    icon.onItemChange = function() icon:setItemId(tonumber(entry.itemId) or 0) end
    icon.onDrop = function() return false end
  end

  if label then
    label:setText(formatImbText(entry.imbues or {}, entry.slots))
  end

  row.onClick = function(widget)
    setRowFocus(listWidget, widget, widget._uid)
    for i = 1, #db.entries do
      if tonumber(db.entries[i].uid) == tonumber(widget._uid) then
        loadEntryToManager(db.entries[i])
        panel:hide()
        manager:show()
        manager:raise()
        manager:focus()
        break
      end
    end
  end

  if remove then
    remove.onClick = function()
      if onRemove then onRemove(entry, row) end
    end
  end

  return row
end

function rebuildMainList()
  if not refs.list then return end
  clearChildren(refs.list)
  clearRowFocus(refs.list)

  for i = 1, #db.entries do
    local entry = normalizeEntry(db.entries[i])
    db.entries[i] = entry
    createSavedRow(refs.list, entry, function(data)
      removeEntryByUid(data.uid)
    end)
  end
end

local function saveEntry()
  local itemId = refs.item and refs.item.getItemId and tonumber(refs.item:getItemId()) or 0
  local slotKey = state.slot
  local slots = getQtd()

  if itemId <= 0 then
    warn("[Imb] Selecione um item.")
    return false
  end

  if not slotKey or slotKey == "" then
    warn("[Imb] Selecione o slot do equipamento.")
    return false
  end

  local entry = {
    uid = state.editingUid or nextUid(),
    itemId = itemId,
    slotKey = slotKey,
    type = uiItemSlotNameToType(slotKey),
    slots = slots,
    imbues = {}
  }

  for i = 1, slots do
    local name = trim(state.imbues[i] or "")
    local level = trim(state.levels[i] or "Basic")

    if name == "" then
      warn("[Imb] Selecione o imbue do slot " .. i .. ".")
      return false
    end

    if level == "" then
      warn("[Imb] Selecione o nível do slot " .. i .. ".")
      return false
    end

    entry.imbues[i] = { name = name, level = level }
  end

  local replaced = false
  for i = 1, #db.entries do
    if tonumber(db.entries[i].uid) == tonumber(entry.uid) then
      db.entries[i] = normalizeEntry(entry)
      replaced = true
      break
    end
  end

  if not replaced then
    db.entries[#db.entries + 1] = normalizeEntry(entry)
  end

  saveImbuementChar()
  return true
end

-- =========================================================
-- UI BIND
-- =========================================================
db.enabled = true
function checkerImbuementsList()
  if db.enabled ~= true then
    imbueCaveBotSetOn()
    return true
  end

  if imbState.active then
    return "retry"
  end

  local started = startImbueAllFromList()
  if started == true then
    return "retry"
  end

  -- Se lista vazia, item nao encontrado, ou qualquer falha inicial, libera a cave.
  imbueCaveBotSetOn()
  return true
end

if refs.limpar then
  if refs.limpar.setMinimum then refs.limpar:setMinimum(1) end
  if refs.limpar.setMaximum then refs.limpar:setMaximum(1200) end
  if refs.limpar.setValue then refs.limpar:setValue(clamp(db.limparMinutes or 60, 1, 1200)) end
  refs.limpar.onValueChange = function()
    updateLimparText(refs.limpar:getValue())
  end
end
updateLimparText(db.limparMinutes or 60)

if refs.shrine then
  refs.shrine.onClick = function() setShrine("imbuing") end
end
if refs.portable then
  refs.portable.onClick = function() setShrine("portable") end
end
setShrine(db.shrineMode or "imbuing")

if refs.open then
  refs.open.onClick = function()
    resetManager()
    panel:hide()
    manager:show()
    manager:raise()
    manager:focus()
  end
end

if refs.close then
  refs.close.onClick = function()
    panel:hide()
    manager:hide()
  end
end

if refs.cancel then
  refs.cancel.onClick = function()
    manager:hide()
    panel:show()
    panel:raise()
    panel:focus()
    resetManager()
  end
end

if refs.confirm then
  refs.confirm.onClick = function()
    if not saveEntry() then return end
    rebuildMainList()
    manager:hide()
    panel:show()
    panel:raise()
    panel:focus()
    resetManager()
  end
end

if refs.qtd then
  refs.qtd.onValueChange = function()
    refreshManagerLists()
  end
  refs.qtd.onValueChanged = function()
    refreshManagerLists()
  end
end

for _, id in ipairs(SLOT_WIDGET_IDS) do
  local w = slotWidgets[id]
  if w then
    w.onClick = function()
      state.slot = id
      refreshSlotBorders()
    end
    w.onMouseRelease = function(widget, mousePos, button)
      if button ~= MouseLeftButton then return false end
      state.slot = id
      refreshSlotBorders()
      return true
    end
  end
end

refreshManagerLists()
refreshSlotBorders()
rebuildMainList()

-- =========================================================
-- ITEM FIND / LOOK
-- =========================================================
local function findItemInContainers(itemId)
  if not itemId or itemId <= 0 then return nil end
  if type(getContainers) ~= "function" then return nil end

  local conts = getContainers()
  if not conts then return nil end

  for c = 1, #conts do
    local cont = conts[c]
    if cont and cont.getItems then
      local items = cont:getItems()
      if items then
        for i = 1, #items do
          local it = items[i]
          if it and it.getId and it:getId() == itemId then
            return it
          end
        end
      end
    end
  end

  return nil
end

local function getInventoryItemBySlot(slotKey)
  local invSlot = SLOT_TO_INV[slotKey]
  if not invSlot then return nil end

  if getInventoryItem then
    return getInventoryItem(invSlot)
  end

  if g_game and g_game.getLocalPlayer and g_game.getLocalPlayer() and g_game.getLocalPlayer().getInventoryItem then
    return g_game.getLocalPlayer():getInventoryItem(invSlot)
  end

  return nil
end

local function findItemObject(itemId, typText, slotKey)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return nil end

  local equipped = slotKey and getInventoryItemBySlot(slotKey) or nil
  if equipped and equipped.getId and equipped:getId() == itemId then
    return equipped, "equip"
  end

  if type(findItem) == "function" then
    local any = findItem(itemId)
    if any and any.getId and any:getId() == itemId then
      return any, "findItem"
    end
  end

  local cont = findItemInContainers(itemId)
  if cont then return cont, "container" end

  return nil, nil
end

local function doLook(itemObj)
  if not itemObj then return false end
  if g_game and type(g_game.look) == "function" then
    g_game.look(itemObj)
    return true
  end
  if type(look) == "function" then
    look(itemObj)
    return true
  end
  return false
end

-- =========================================================
-- LOOK PARSE / TIMERS
-- =========================================================
local function parseTimeToSeconds(text)
  text = tostring(text or "")

  local hh, mm = text:match("(%d+):(%d+)%s*[hH]")
  if hh and mm then
    return (tonumber(hh) or 0) * 3600 + (tonumber(mm) or 0) * 60
  end

  hh, mm = text:match("(%d+):(%d+)")
  if hh and mm then
    return (tonumber(hh) or 0) * 3600 + (tonumber(mm) or 0) * 60
  end

  local h2, m2 = text:match("(%d+)%s*[hH]%s*(%d+)%s*[mM]")
  if h2 then
    return (tonumber(h2) or 0) * 3600 + (tonumber(m2) or 0) * 60
  end

  local h3 = text:match("(%d+)%s*[hH]")
  if h3 then
    return (tonumber(h3) or 0) * 3600
  end

  return nil
end

local function parseImbuesFromLookText(text)
  text = tostring(text or "")
  local imbBlock = text:match("Imbuements:%s*%((.-)%)")
  if not imbBlock or imbBlock == "" then return {} end

  local out = {}

  for part in imbBlock:gmatch("([^,]+)") do
    part = trim(part)
    if part ~= "" and not part:find("Free Slot", 1, true) then
      local tier, rest = part:match("^(Basic)%s+(.+)$")
      if not tier then tier, rest = part:match("^(Intricate)%s+(.+)$") end
      if not tier then tier, rest = part:match("^(Powerful)%s+(.+)$") end

      tier = trim(tier or "")
      rest = trim(rest or part)

      local timeToken = rest:match("(%d+:%d+%s*[hH])") or rest:match("(%d+%s*[hH]%s*%d+%s*[mM])")
      local rawName = rest
      if timeToken then
        rawName = trim(rest:gsub(timeToken, ""))
      end

      local visual = LOOK_NAME_TO_VISUAL[rawName] or rawName
      local sec = timeToken and parseTimeToSeconds(timeToken) or nil
      local timeStr = "--:--"

      if timeToken then
        local hh, mm = timeToken:match("(%d+):(%d+)")
        if hh and mm then
          timeStr = string.format("%02d:%02d", tonumber(hh) or 0, tonumber(mm) or 0)
        else
          local h2, m2 = timeToken:match("(%d+)%s*[hH]%s*(%d+)%s*[mM]")
          if h2 then
            timeStr = string.format("%02d:%02d", tonumber(h2) or 0, tonumber(m2) or 0)
          end
        end
      end

      out[#out + 1] = {
        tier = tier,
        raw = rawName,
        visual = visual,
        seconds = sec,
        timeStr = timeStr
      }
    end
  end

  return out
end

local function updateTimerFromLook(itemId, lookText)
  local key = tostring(tonumber(itemId) or 0)
  local detected = parseImbuesFromLookText(lookText)
  local updatedNow = nowMs()

  imbuementsStorage.autoImbuement = imbuementsStorage.autoImbuement or {}
  imbuementsStorage.autoImbuement.timers = imbuementsStorage.autoImbuement.timers or {}

  imbuementsStorage.autoImbuement.timers[key] = imbuementsStorage.autoImbuement.timers[key] or {}
  imbuementsStorage.autoImbuement.timers[key].detected = detected
  imbuementsStorage.autoImbuement.timers[key].updated = updatedNow

  db.timers = imbuementsStorage.autoImbuement.timers
  saveImbuementChar()

end

local function getDetectedImbueTimeByVisual(itemId, visualName)
  local info = db.timers[itemTimerKey(itemId)]
  if not info or type(info.detected) ~= "table" then return nil end

  visualName = tostring(visualName or "")
  for i = 1, #info.detected do
    local d = info.detected[i]
    if tostring(d.visual or "") == visualName then
      return tonumber(d.seconds or 0) or 0
    end
  end

  return nil
end

local function isRecentAction(itemId)
  local key = itemTimerKey(itemId)
  local t = tonumber(db.recentActions[key] or 0) or 0
  if t <= 0 then return false end

  local diff = nowMs() - t

  if diff < 0 then
    db.recentActions[key] = nil
    saveImbuementChar()
    return false
  end

  if diff >= RECENT_ACTION_MS then
    db.recentActions[key] = nil
    saveImbuementChar()
    return false
  end

  return true
end

local function markRecentAction(itemId)
  db.recentActions[itemTimerKey(itemId)] = nowMs()
  saveImbuementChar()
end

-- =========================================================
-- SHRINE / PORTABLE
-- =========================================================
local function findNearestShrine()
  if not player or not player.getPosition then return nil, nil end
  local playerPos = player:getPosition()
  local bestShrine, bestDist, bestPos = nil, 99999, nil

  for x = -7, 7 do
    for y = -5, 5 do
      local scanPos = {x = playerPos.x + x, y = playerPos.y + y, z = playerPos.z}
      local tile = g_map.getTile(scanPos)
      if tile then
        local items = tile:getItems()
        if items then
          for _, item in ipairs(items) do
            local itemId = item:getId()
            for _, shrineId in ipairs(SHRINES) do
              if itemId == shrineId then
                local dist = getDistance(playerPos, scanPos)
                if dist < bestDist then
                  bestDist = dist
                  bestShrine = item
                  bestPos = scanPos
                end
                break
              end
            end
          end
        end
      end
    end
  end

  return bestShrine, bestPos
end

local function isNearShrine(shrine)
  if not shrine or not shrine.getPosition or not player or not player.getPosition then return false end
  local playerPos = player:getPosition()
  local shrinePos = shrine:getPosition()
  return getChebyshevDistance(playerPos, shrinePos) <= 1
end

local function ensureNearShrine(shrine)
  if not shrine or not shrine.getPosition then return false end
  if isNearShrine(shrine) then return true end

  local playerPos = player:getPosition()
  local shrinePos = shrine:getPosition()
  local walkPos = getBestAdjacentShrinePos(shrinePos, playerPos)

  if not walkPos then
    return false
  end

  if getDistance(playerPos, walkPos) > 0 then
    autoWalk(walkPos, 20, {ignoreNonPathable = true, precision = 1})
  end

  return false
end

local function useThingWithSafe(a, b)
  -- No OTC/vBot algumas funcoes de useWith abrem a janela corretamente,
  -- mas retornam nil/false. Entao aqui o sucesso significa: conseguiu chamar
  -- a funcao sem erro. Quem confirma se abriu mesmo e o onImbuementWindow/timeout.
  if type(useThingWith) == "function" then
    local ok = pcall(function() useThingWith(a, b) end)
    return ok == true
  end

  if type(useWith) == "function" then
    local ok = pcall(function() useWith(a, b) end)
    return ok == true
  end

  if g_game and type(g_game.useWith) == "function" then
    local ok = pcall(function() g_game.useWith(a, b) end)
    return ok == true
  end

  return false
end

local function openShrineOnItem(itemObj)
  if not itemObj then return false end

  if db.shrineMode == "portable" then
    local portable = findItem and findItem(PORTABLE_SHRINE) or nil
    if not portable then
      return false
    end
    return useThingWithSafe(portable, itemObj)
  end

  local shrine, shrinePos = findNearestShrine()
  if not shrine then
    return false
  end

  imbState.shrine = shrine
  imbState.shrinePos = shrinePos

  if not isNearShrine(shrine) then
    ensureNearShrine(shrine)

    later(1800, function()
      if not imbState.active then return end
      if not imbState.currentItem then return end
      if not imbState.shrine then return end
      if not isNearShrine(imbState.shrine) then return end

      imbState.waitingWindow = true
      imbState.lastAction = nowMs()
      useThingWithSafe(imbState.shrine, imbState.currentItem)
    end)

    return true
  end

  return useThingWithSafe(shrine, itemObj)
end

-- =========================================================
-- IMB WINDOW MATCH
-- =========================================================
local function getTierFromEntryLevel(levelName)
  return tierNameToNumber(levelName)
end

local function findImbueFromWindow(windowImbuements, visualName, tierNum)
  if type(windowImbuements) ~= "table" then return nil end

  visualName = tostring(visualName or "")
  if visualName == "" then return nil end

  local groupInternal = IMBUE_VISUAL_TO_KIND[visualName]
  if not groupInternal then
    return nil
  end

  local shrineText = GROUP_TO_SHRINE_TEXT[groupInternal] or groupInternal
  tierNum = tonumber(tierNum) or 3

  for i = 1, #windowImbuements do
    local imb = windowImbuements[i]
    local groupName = tostring(imb.group or "")
    local windowName = tostring(imb.name or "")

    local okGroup =
      (groupName == shrineText) or
      (windowName:find(shrineText, 1, true) ~= nil) or
      (windowName:find(groupInternal, 1, true) ~= nil) or
      (windowName:find(visualName, 1, true) ~= nil)

    if okGroup then
      local tier = getTierFromWindowName(windowName)
      if tier == tierNum then
        return imb
      end
    end
  end

  return nil
end

local function tryClearImbuement(slotIdx)
  slotIdx = tonumber(slotIdx) or 0

  if g_game and type(g_game.clearImbuement) == "function" then
    g_game.clearImbuement(slotIdx, true)
    return true
  end

  if g_game and type(g_game.removeImbuement) == "function" then
    g_game.removeImbuement(slotIdx, true)
    return true
  end

  if g_game and type(g_game.clearImbuementSlot) == "function" then
    g_game.clearImbuementSlot(slotIdx, true)
    return true
  end

  if type(clearImbuement) == "function" then
    clearImbuement(slotIdx, true)
    return true
  end

  if type(removeImbuement) == "function" then
    removeImbuement(slotIdx, true)
    return true
  end

  return false
end

local function tryApplyImbuement(slotIdx, imbData)
  if not imbData then return false end

  if g_game and type(g_game.applyImbuement) == "function" then
    g_game.applyImbuement(slotIdx, imbData.id, true)
    return true
  end

  return false
end

local function buildActionsForEntry(entry, activeSlots, windowImbuements)
  local actions = {}
  local thresholdSec = (tonumber(db.limparMinutes or 0) or 0) * 60

  for slotIdx = 0, entry.slots - 1 do
    local cfg = entry.imbues[slotIdx + 1]
    if cfg and trim(cfg.name) ~= "" then
      local desiredVisual = canonImbueName(cfg.name)
      local desiredTier = getTierFromEntryLevel(cfg.level)

      local active = activeSlots and activeSlots[slotIdx] or nil
      local shouldApply = false

      if active then
        local activeInfo = active[1]
        local activeTime = tonumber(active[2] or 0) or 0
        local activeName = canonImbueName(activeInfo and (activeInfo.group or activeInfo.name) or "")

        if activeName == desiredVisual then
          if activeTime <= thresholdSec then
            actions[#actions + 1] = {
              kind = "clear",
              slotIdx = slotIdx,
              visualName = desiredVisual
            }
            shouldApply = true
          end
        else
          actions[#actions + 1] = {
            kind = "clear",
            slotIdx = slotIdx,
            visualName = desiredVisual
          }
          shouldApply = true
        end
      else
        shouldApply = true
      end

      if shouldApply then
        local imbData = findImbueFromWindow(windowImbuements, desiredVisual, desiredTier)
        if imbData then
          actions[#actions + 1] = {
            kind = "apply",
            slotIdx = slotIdx,
            visualName = desiredVisual,
            imbData = imbData
          }
        else
        end
      end
    end
  end

  return actions
end

local function runActions(actions, onDone)
  local idx = 1

  local function nextAction()
    if idx > #actions then
      if onDone then onDone() end
      return
    end

    local action = actions[idx]
    idx = idx + 1

    if action.kind == "clear" then
      if not tryClearImbuement(action.slotIdx) then
        later(500, nextAction)
        return
      end
      later(1800, nextAction)
      return
    end

    if action.kind == "apply" then
      if not tryApplyImbuement(action.slotIdx, action.imbData) then
        later(500, nextAction)
        return
      end
      later(2200, nextAction)
      return
    end

    later(200, nextAction)
  end

  nextAction()
end

-- =========================================================
-- RUNTIME QUEUE
-- =========================================================
local function resetImbState()
  imbState.active = false
  imbState.queue = {}
  imbState.idx = 1
  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.currentEntry = nil
  imbState.currentItem = nil
  imbState.currentItemSource = nil
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.startedAt = 0
  imbState.lastAction = 0
  imbState.manualMode = false
  imbState.actionToken = 0
  imbState.reopenAfterClear = false
end

local function closeCurrentImbuingWindow()
  if g_game and type(g_game.closeImbuingWindow) == "function" then
    pcall(function() g_game.closeImbuingWindow() end)
  end

  destroyImbuingPanel()
end

local function finishImbueAndResume(reason)
  local manualMode = imbState.manualMode == true

  if reason and reason ~= "" then
    warn(reason)
  end

  closeCurrentImbuingWindow()
  resetImbState()

  -- Se foi chamado manualmente com startImbueAllFromList(true), nao liga/desliga CaveBot.
  if not manualMode then
    imbueCaveBotSetOn()
  end
end

local function finishCurrentImbueItem(reason)
  -- Finaliza somente o item atual e continua a fila.
  -- Usado quando falta material, nao abriu janela, falhou apply/clear ou item ja esta OK.
  if reason and reason ~= "" then
    warn(reason)
  end

  closeCurrentImbuingWindow()

  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.currentEntry = nil
  imbState.currentItem = nil
  imbState.currentItemSource = nil
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.actionToken = (tonumber(imbState.actionToken or 0) or 0) + 1
  imbState.lastAction = nowMs()
end

local function buildAutoImbueQueue()
  local q = {}

  for i, entry in ipairs(db.entries or {}) do
    entry = normalizeEntry(entry)
    local itemObj, source = findItemObject(entry.itemId, entry.type, entry.slotKey)
    if itemObj and itemObj.getId and itemObj:getId() == entry.itemId then
      q[#q + 1] = {
        entry = entry,
        itemId = entry.itemId,
        typ = entry.type,
        slotKey = entry.slotKey,
        itemObj = itemObj,
        source = source
      }
    end
  end

  return q
end


function startImbueAllFromList(manualMode)
  manualMode = manualMode == true

  if db.enabled ~= true then
    warn("[Imb] Ative o BotSwitch 'Imbuiments' para usar.")
    if not manualMode then imbueCaveBotSetOn() end
    return false
  end

  if imbState.active then
    warn("[Imb] Já está processando.")
    return true
  end

  if type(db.entries) ~= "table" or #db.entries == 0 then
    warn("[Imb] Sua lista está vazia.")
    resetImbState()
    if not manualMode then imbueCaveBotSetOn() end
    return false
  end

  local q = buildAutoImbueQueue()
  if #q == 0 then
    warn("[Imb] Nenhum item configurado foi encontrado.")
    resetImbState()
    if not manualMode then imbueCaveBotSetOn() end
    return false
  end

  local t = nowMs()

  -- Modo automatico pelo CaveBot: pausa a cave e religa no final/timeout.
  -- Modo manual startImbueAllFromList(true): nao mexe no CaveBot.
  if not manualMode then
    imbueCaveBotSetOff()
  end

  imbState.active = true
  imbState.queue = q
  imbState.idx = 1
  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.currentEntry = nil
  imbState.currentItem = nil
  imbState.currentItemSource = nil
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.startedAt = t
  imbState.lastAction = t
  imbState.manualMode = manualMode
  imbState.actionToken = 0
  imbState.reopenAfterClear = false

  return true
end

-- =========================================================
-- WINDOW CALLBACK
-- =========================================================
local function onWindow(itemId, slots, activeSlots, windowImbuements, needItems)
  if not imbState.active then return end
  if not imbState.currentEntry then return end

  local entry = imbState.currentEntry
  if tonumber(entry.itemId) ~= tonumber(itemId) then
    return
  end

  imbState.waitingWindow = false
  imbState.waitingApply = true
  imbState.lastAction = nowMs()

  local actions = buildActionsForEntry(entry, activeSlots or {}, windowImbuements or {})
  
  -- Se não há mais nenhuma ação na fila, o item está perfeitamente imbuido.
  -- Finaliza só este item e segue para o próximo da lista.
  if #actions == 0 then
    later(300, function()
      if imbState.active and imbState.currentEntry and tonumber(imbState.currentEntry.uid) == tonumber(entry.uid) then
        finishCurrentImbueItem("")
      end
    end)
    return
  end

  -- Pega APENAS a primeira ação e manda para o servidor.
  -- Depois aguarda o servidor responder com a janela atualizada.
  local action = actions[1]
  local sent = false

  if action.kind == "clear" then
    sent = tryClearImbuement(action.slotIdx)
  elseif action.kind == "apply" then
    sent = tryApplyImbuement(action.slotIdx, action.imbData)
  end

  if not sent then
    finishCurrentImbueItem("[Imb] Falhou ao enviar acao de imbue para este item. Pulando item e seguindo lista.")
    return
  end

  local actionUid = entry.uid
  imbState.actionToken = (tonumber(imbState.actionToken or 0) or 0) + 1
  local actionToken = imbState.actionToken

  -- Timeout de segurança por ITEM: se faltar material, gold, item de imbue, ou o servidor
  -- nao atualizar a janela, pula somente este item e continua os próximos da lista.
  later(3500, function()
    if imbState.active
      and imbState.waitingApply
      and imbState.currentEntry
      and tonumber(imbState.currentEntry.uid) == tonumber(actionUid)
      and tonumber(imbState.currentEntry.itemId) == tonumber(itemId)
      and tonumber(imbState.actionToken or 0) == tonumber(actionToken) then
        finishCurrentImbueItem("[Imb] Falhou/nao confirmou imbue deste item. Pulando item e seguindo lista.")
    end
  end)
end

if type(onImbuementWindow) == "function" then
  onImbuementWindow(onWindow)
else
end

-- =========================================================
-- MAIN ENGINE
-- =========================================================
macro(200, function()
  if db.enabled ~= true then return end
  if not imbState.active then return end

  local t = nowMs()
  local startedAt = tonumber(imbState.startedAt or 0) or 0
  local lastAction = tonumber(imbState.lastAction or 0) or 0

  if startedAt > 0 and t - startedAt > IMBUE_MAX_RUNTIME_MS then
    finishImbueAndResume("[Imb] Timeout geral do imbuement. Processo finalizado por seguranca.")
    return
  end

  if imbState.waitingWindow then
    if lastAction > 0 and t - lastAction > IMBUE_WAIT_WINDOW_TIMEOUT_MS then
      finishCurrentImbueItem("[Imb] Timeout aguardando janela de imbue deste item. Pulando item e seguindo lista.")
    end
    return
  end

  if imbState.waitingApply then
    if lastAction > 0 and t - lastAction > IMBUE_WAIT_APPLY_TIMEOUT_MS then
      finishCurrentImbueItem("[Imb] Timeout aplicando/removendo imbue deste item. Pulando item e seguindo lista.")
    end
    return
  end

  if t - (imbState.lastAction or 0) < 800 then return end

  if imbState.idx > #imbState.queue then
    finishImbueAndResume("")
    return
  end

  local data = imbState.queue[imbState.idx]
  imbState.idx = imbState.idx + 1

  local entry = data.entry
  local itemObj, source = findItemObject(data.itemId, data.typ, data.slotKey)

  if not itemObj or not itemObj.getId or itemObj:getId() ~= data.itemId then
    imbState.lastAction = t
    return
  end

  imbState.currentEntry = entry
  imbState.currentItem = itemObj
  imbState.currentItemSource = source
  imbState.waitingWindow = true
  imbState.lastAction = t

  if not openShrineOnItem(itemObj) then
    finishCurrentImbueItem("[Imb] Nao conseguiu abrir shrine/portable para este item. Pulando item e seguindo lista.")
    return
  end
end)

-- =========================================================
-- LOOK UPDATE TIMER
-- =========================================================
local lookState = {
  waitingItemId = nil,
  waitingTextUntil = 0,
  queue = {},
  idx = 1,
  running = false
}
local lookSuppress = {
  active = false,
  untilTime = 0,
  lastClear = 0
}

local function startLookSuppress(ms)
  lookSuppress.active = true
  lookSuppress.untilTime = nowMs() + (ms or 1500)
end

local function stopLookSuppress()
  lookSuppress.active = false
  lookSuppress.untilTime = 0
end

local function isLookSuppressActive()
  if not lookSuppress.active then return false end
  if nowMs() > (lookSuppress.untilTime or 0) then
    stopLookSuppress()
    return false
  end
  return true
end

local function clearGreenLookMessage()
  local t = nowMs()
  if t - (lookSuppress.lastClear or 0) < 250 then return end
  lookSuppress.lastClear = t

  if modules and modules.game_textmessage and modules.game_textmessage.clearMessages then
    modules.game_textmessage.clearMessages()
  end
end

local function buildLookQueue()
  local q = {}
  local seen = {}

  for i = 1, #db.entries do
    local entry = normalizeEntry(db.entries[i])
    if entry.itemId > 0 and not seen[entry.itemId] then
      seen[entry.itemId] = true
      q[#q + 1] = cloneTable(entry)
    end
  end

  return q
end

local function processLookQueue()
  if lookState.running ~= true then return end
  if lookState.waitingItemId then return end

  if lookState.idx > #lookState.queue then
    lookState.running = false
    return
  end

  local entry = lookState.queue[lookState.idx]
  lookState.idx = lookState.idx + 1

  local itemObj = nil
  itemObj = getInventoryItemBySlot(entry.slotKey)
  if not itemObj or not itemObj.getId or itemObj:getId() ~= entry.itemId then
    itemObj = findItemInContainers(entry.itemId)
  end

  if not itemObj then
    later(150, processLookQueue)
    return
  end

  lookState.waitingItemId = tonumber(entry.itemId)
  lookState.waitingTextUntil = nowMs() + 3000

  startLookSuppress(1500)

    if not doLook(itemObj) then
      stopLookSuppress()
      lookState.waitingItemId = nil
      later(120, processLookQueue)
      return
    end
  end

macro(30000, function()
  if #db.entries == 0 then return end
  if imbState.active then return end
  if lookState.running then return end

  lookState.queue = buildLookQueue()
  lookState.idx = 1
  lookState.running = true
  lookState.waitingItemId = nil
  processLookQueue()
end)

macro(200, function()
  if not lookState.waitingItemId then return end
  if nowMs() > (lookState.waitingTextUntil or 0) then
    lookState.waitingItemId = nil
    later(50, processLookQueue)
  end
end)

-- =========================================================
-- STATUS MESSAGE HOOK
-- =========================================================
botserver = botserver or { __callbacks = {} }

if not onStatusMessage then
  botserver.__callbacks.onStatusMessage = {}

  onStatusMessage = function(callback)
    table.insert(botserver.__callbacks.onStatusMessage, function(...)
      callback(...)
    end)

    local cb = botserver.__callbacks.onStatusMessage[#botserver.__callbacks.onStatusMessage]
    return {
      remove = function()
        for i, cb2 in ipairs(botserver.__callbacks.onStatusMessage) do
          if cb == cb2 then
            table.remove(botserver.__callbacks.onStatusMessage, i)
            break
          end
        end
      end
    }
  end
end

if modules and modules.game_textmessage and not botserver.__imbHookInstalled then
  botserver.__imbHookInstalled = true
  local oldStatus = modules.game_textmessage.displayStatusMessage

  modules.game_textmessage.displayStatusMessage = function(text, color)
    if oldStatus then
      oldStatus(text, color)
    end

    local callbacks = botserver.__callbacks.onStatusMessage or {}
    for i = 1, #callbacks do
      callbacks[i](text)
    end
  end
end

onTextMessage(function(mode, text)
  if not lookState.waitingItemId then return end
  if type(text) ~= "string" then return end
  if not text:find("Imbuements:", 1, true) then return end

  updateTimerFromLook(lookState.waitingItemId, text)
  lookState.waitingItemId = nil

  if isLookSuppressActive() then
    later(1, clearGreenLookMessage)
    later(80, clearGreenLookMessage)
  end

  stopLookSuppress()
  later(250, processLookQueue)
end)

function cavebotCheckImbueByLook()
  local db = imbuementsStorage.autoImbuement or {}

  if db.enabled ~= true then
    return "Hunt"
  end

  if type(db.entries) ~= "table" or #db.entries == 0 then
    return "Hunt"
  end

  if type(db.timers) ~= "table" then
    return "retry"
  end

  local thresholdSec = (tonumber(db.limparMinutes or 0) or 0) * 60

  local LOOK_NAME_TO_VISUAL = {
    ["Void"] = "Mana Leech",
    ["Vampirism"] = "Life Leech",
    ["Strike"] = "Critical",
    ["Epiphany"] = "Magic Level",
    ["Precision"] = "Skill Boost",
    ["Chop"] = "Skill Boost",
    ["Slash"] = "Skill Boost",
    ["Bash"] = "Skill Boost",
    ["Dragon Hide"] = "Fire Protection",
    ["Quara Scale"] = "Ice Protection",
    ["Snake Skin"] = "Earth Protection",
    ["Cloud Fabric"] = "Energy Protection",
    ["Lich Shroud"] = "Death Protection",
    ["Demon Presence"] = "Holy Protection",
    ["Featherweight"] = "Capacity",
    ["Swiftness"] = "Speed"
  }

  local function trim(s)
    return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
  end

  local function canonImbueName(name)
    name = trim(name)
    if name == "" then return "" end

    if name == "Hit Points Leech" then return "Life Leech" end
    if name == "Mana Leech" then return "Mana Leech" end
    if name == "Critical" then return "Critical" end
    if name == "Magic Level" then return "Magic Level" end

    if name == "Skillboost (Distance)" or name == "Skillboost (Sword)" or name == "Skillboost (Club)" or name == "Skillboost (Axe)" then
      return "Skill Boost"
    end

    if name == "Elemental Protection (Fire)" then return "Fire Protection" end
    if name == "Elemental Protection (Ice)" then return "Ice Protection" end
    if name == "Elemental Protection (Earth)" then return "Earth Protection" end
    if name == "Elemental Protection (Energy)" then return "Energy Protection" end
    if name == "Elemental Protection (Death)" then return "Death Protection" end
    if name == "Elemental Protection (Holy)" then return "Holy Protection" end

    return LOOK_NAME_TO_VISUAL[name] or name
  end

  for i = 1, #db.entries do
    local entry = db.entries[i]
    local itemId = tonumber(entry.itemId or 0) or 0
    local slots = tonumber(entry.slots or 1) or 1
    local imbues = entry.imbues or {}

    if itemId > 0 then
      local info = db.timers[tostring(itemId)]

      -- ainda não recebeu look desse item
      if not info or type(info.detected) ~= "table" then
        return "retry"
      end

      for slot = 1, slots do
        local cfg = imbues[slot]
        if cfg and trim(cfg.name) ~= "" then
          local wanted = canonImbueName(cfg.name)
          local found = nil

          for j = 1, #info.detected do
            local d = info.detected[j]
            if tostring(d.visual or "") == wanted then
              found = d
              break
            end
          end

          if not found then
            return "REFRESH"
          end

          local sec = tonumber(found.seconds or 0) or 0
          if sec <= thresholdSec then
            return "REFRESH"
          end
        end
      end
    end
  end

  return "Hunt"
end
-- =========================================================
-- AUTO START / INIT
-- =========================================================
panel:hide()
manager:hide()

end)
