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

lnsRunBlock("ATTACKBOT", function()
----- ATTACKBOT
-- Storage global unico do AttackBot.
-- Usa somente storage.LNSAttackBotGlobal.
storage = storage or {}
storage.LNSAttackBotGlobal = type(storage.LNSAttackBotGlobal) == "table" and storage.LNSAttackBotGlobal or {}

local attackBotStorage = storage.LNSAttackBotGlobal

local function lnsAttackDeepCopy(t)
  if type(t) ~= "table" then return t end
  local r = {}
  for k, v in pairs(t) do
    r[k] = lnsAttackDeepCopy(v)
  end
  return r
end

local function lnsAttackNormalizeIdList(list)
  local out, seen = {}, {}
  for _, entry in ipairs(list or {}) do
    local id = type(entry) == "table" and tonumber(entry.id) or tonumber(entry)
    if id and not seen[id] then
      seen[id] = true
      table.insert(out, id)
    end
  end
  table.sort(out)
  return out
end

local function lnsAttackNormalizeContainerItems(items)
  local r = {}
  if type(items) ~= "table" then return r end

  for _, v in pairs(items) do
    local id = nil

    if type(v) == "table" then
      id = (v.getId and v:getId()) or v.id
    else
      id = v
    end

    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end

  return r
end

local function lnsAttackNowStorageTs()
  return tostring(os.time()) .. tostring(math.random(1000, 9999))
end

local function lnsAttackNormalizeSharedMap(mapOrList)
  if type(mapOrList) == "table" then
    for k, _ in pairs(mapOrList) do
      if type(k) == "string" then
        return mapOrList
      end
    end
  end

  local out = {}
  for _, id in ipairs(lnsAttackNormalizeIdList(mapOrList)) do
    out[tostring(id)] = { state = true, ts = "0" }
  end
  return out
end

local function lnsAttackSharedMapToList(map)
  local out = {}
  for k, v in pairs(map or {}) do
    local id = tonumber(k)
    if id and type(v) == "table" and v.state == true then
      table.insert(out, id)
    end
  end
  table.sort(out)
  return out
end

local function lnsAttackMergeSharedMaps(a, b)
  local out = {}
  a = lnsAttackNormalizeSharedMap(a)
  b = lnsAttackNormalizeSharedMap(b)

  for k, v in pairs(a) do
    out[k] = { state = v.state == true, ts = tostring(v.ts or "0") }
  end

  for k, v in pairs(b) do
    local cur = out[k]
    local newTs = tostring(v.ts or "0")
    if not cur or newTs > tostring(cur.ts or "0") then
      out[k] = { state = v.state == true, ts = newTs }
    end
  end

  return out
end

local normalizeIdList = lnsAttackNormalizeIdList
local normalizeContainerItems = lnsAttackNormalizeContainerItems
local nowStorageTs = lnsAttackNowStorageTs
local normalizeSharedMap = lnsAttackNormalizeSharedMap
local sharedMapToList = lnsAttackSharedMapToList
local mergeSharedMaps = lnsAttackMergeSharedMaps

attackBotStorage.attackBotShared = type(attackBotStorage.attackBotShared) == "table" and attackBotStorage.attackBotShared or {}

local function saveAttackBotStorage()
  storage.LNSAttackBotGlobal = attackBotStorage
end

local function saveAttackBotShared()
  attackBotStorage.attackBotShared = type(attackBotStorage.attackBotShared) == "table" and attackBotStorage.attackBotShared or {}
  storage.LNSAttackBotGlobal = attackBotStorage
end


switchCombo = "comboButton"
attackBotStorage[switchCombo] = attackBotStorage[switchCombo] or { enabled = false }

comboButton = setupUI([[
Panel
  height: 40
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: AttackBot
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

  Button
    id: 1
    anchors.top: prev.bottom
    anchors.left: parent.left
    text: 1
    margin-right: 2
    margin-top: 4
    size: 17 17

  Button
    id: 2
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 2
    margin-left: 4
    size: 17 17
    
  Button
    id: 3
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 3
    margin-left: 4
    size: 17 17

  Button
    id: 4
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 4
    margin-left: 4
    size: 17 17 
    
  Button
    id: 5
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 5
    margin-left: 4
    size: 17 17
    
  Label
    id: name
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: parent.right
    text-align: center
    margin-left: 4
    height: 17
    text: Prof.: #1
    background: #292A2A
]])
comboButton:setId(switchCombo)
comboButton.title:setOn(attackBotStorage[switchCombo].enabled)
comboButton.title.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  attackBotStorage[switchCombo].enabled = state
  saveAttackBotStorage()
end

comboInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 310 388
  text: Panel AttackBot
  margin-top: -50

  Button
    id: tabConfig
    checkable: true
    anchors.top: parent.top
    anchors.left: parent.left
    height: 33
    margin-left: -5
    width: 144
    text-align: center
    text: Config

    UIItem
      id: idConfig
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 0
      margin-right: 8
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: tabAntired
    checkable: true
    anchors.verticalCenter: tabConfig.verticalCenter
    anchors.left: tabConfig.right
    height: 33
    margin-left: 0
    width: 145
    text-align: center
    text: Antired

    UIItem
      id: idAntired
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 0
      margin-right: 8
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  FlatPanel
    id: flatConfig
    anchors.top: tabConfig.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-left: -5
    margin-top: 6
    margin-right: -5

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Configuration Spells & Runes
      margin-top: 6
      font: verdana-11px-rounded
      text-auto-resize: true

    HorizontalSeparator
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 8
      margin-right: 8

    TextList
      id: spellList
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-bottom: 33
      margin-top: 5
      margin-left: 8
      margin-right: 16
      padding: 1
      vertical-scrollbar: spellListScrollBar
      opacity: 0.95
      font: verdana-11px-rounded

    VerticalScrollBar
      id: spellListScrollBar
      anchors.top: spellList.top
      anchors.bottom: spellList.bottom
      anchors.left: spellList.right
      step: 10
      pixels-scroll: true
      visible: true
      border: 1 #1f1f1f
      image-color: #363636
      opacity: 0.90
      margin-left: 0

    Button
      id: adicionarSpell
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      margin-left: 8
      margin-bottom: 6
      width: 135
      height: 20
      text: Add Spell

    Button
      id: adicionarRuna
      anchors.right: parent.right
      anchors.verticalCenter: adicionarSpell.verticalCenter
      margin-right: 8
      width: 135
      height: 20
      text: Add Rune

  FlatPanel
    id: flatAntired
    anchors.top: flatConfig.top
    anchors.left: flatConfig.left
    anchors.right: flatConfig.right
    anchors.bottom: flatConfig.bottom

    HorizontalScrollBar
      id: minutosVoltarUnsafe
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      margin-left: 8
      margin-right: 8
      margin-top: 8
      minimum: 1
      maximum: 120
      step: 1

    Label
      id: labelReactiveUnsafe
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Reactive in: 5 min
      margin-top: -1
      text-align: center
      text: Reactive in:

    BotSwitch
      id: manterDist
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: prev.bottom
      margin-top: 5
      margin-left: 8
      margin-right: 8
      height: 18
      text: Pause Spells Unsafe

    HorizontalSeparator
      id: HsepFrags
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 8
      margin-left: 8
      margin-right: 8

    HorizontalScrollBar
      id: qtdeFrags
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: 8
      minimum: 1
      maximum: 8
      step: 1

    Label
      id: labelExitFrags
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Amount Frags: 1
      margin-top: -1
      text-align: center

    BotSwitch
      id: deslogarFrags
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: 5
      height: 18
      text: Exit on Frags

    HorizontalSeparator
      id: HsepFrags
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 8
      margin-left: 8
      margin-right: 8

    HorizontalScrollBar
      id: distSegura
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: prev.bottom
      margin-top: 6
      margin-left: 8
      margin-right: 8
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: labelDistSegura
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Dist Check Players: 0
      margin-top: -1
      text-align: center

    Panel
      id: checkPlayersLine
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: 5
      height: 20

      BotSwitch
        id: checkPlayers
        anchors.left: parent.left
        anchors.top: parent.top
        width: 132
        height: 18
        text: Check Players

      BotSwitch
        id: checkFloors
        anchors.left: checkPlayers.right
        anchors.right: parent.right
        anchors.top: parent.top
        margin-left: 4
        height: 18
        text: Other Floors

    HorizontalSeparator
      id: HsepFrags
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 8
      margin-left: 8
      margin-right: 8

    HorizontalScrollBar
      id: distStairs
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: 7
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: labelDistStairs
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Dist Check Stairs: 0
      margin-top: -1
      text-align: center

    Panel
      id: idsSafeAndares
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      height: 74

    BotSwitch
      id: checkStairs
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: -1
      height: 18
      text: Check Stairs

  Button
    id: closePanel
    anchors.left: flatConfig.left
    anchors.right: flatConfig.right
    anchors.top: flatConfig.bottom
    height: 20
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())
comboInterface:hide()

local function WAttackBotPanel(root, id)
  if not root or not id then return nil end

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
        local found = WAttackBotPanel(childs[i], id)
        if found then return found end
      end
    end
  end

  return nil
end

local function bindAttackBotPanelIds()
  local ids = {
    "tabConfig", "tabAntired", "flatConfig", "flatAntired",
    "spellList", "spellListScrollBar", "adicionarSpell", "adicionarRuna",
    "labelReactiveUnsafe", "minutosVoltarUnsafe", "manterDist", "labelExitFrags",
    "qtdeFrags", "deslogarFrags", "labelDistSegura", "distSegura",
    "checkPlayers", "checkFloors", "labelDistStairs", "distStairs",
    "idsSafeAndares", "checkStairs", "closePanel"
  }

  for i = 1, #ids do
    local id = ids[i]
    if not comboInterface[id] then
      comboInterface[id] = WAttackBotPanel(comboInterface, id)
    end
  end
end

local function showAttackBotWidget(widget, visible)
  if not widget then return end
  if visible then
    if widget.show then widget:show() end
  else
    if widget.hide then widget:hide() end
  end
end

local function setAttackBotTabPressed(button, pressed)
  if not button then return end
  showAttackBotWidget(WAttackBotPanel(button, "activeLine"), pressed)

  if button.setChecked then pcall(function() button:setChecked(pressed) end) end
  if button.setPressed then pcall(function() button:setPressed(pressed) end) end
  if button.setOn then pcall(function() button:setOn(pressed) end) end

  if button.setOpacity then button:setOpacity(pressed and 1.00 or 0.74) end
  if button.setColor then button:setColor(pressed and "#d7c08a" or "#d6d6d6") end
end

local function setAttackBotPanelTab(tab)
  if tab ~= "config" and tab ~= "antired" then tab = "config" end

  showAttackBotWidget(comboInterface.flatConfig, tab == "config")
  showAttackBotWidget(comboInterface.flatAntired, tab == "antired")

  setAttackBotTabPressed(comboInterface.tabConfig, tab == "config")
  setAttackBotTabPressed(comboInterface.tabAntired, tab == "antired")
end

bindAttackBotPanelIds()

local function setAttackBotIcon(widget, id)
  if widget and widget.setItemId then
    pcall(function() widget:setItemId(tonumber(id) or 0) end)
  end
end

if comboInterface.tabConfig and not comboInterface.tabConfig.idConfig then
  comboInterface.tabConfig.idConfig = WAttackBotPanel(comboInterface.tabConfig, "idConfig")
end

if comboInterface.tabAntired and not comboInterface.tabAntired.idAntired then
  comboInterface.tabAntired.idAntired = WAttackBotPanel(comboInterface.tabAntired, "idAntired")
end

-- Troque estes IDs se quiser outros icones nas abas.
setAttackBotIcon(comboInterface.tabConfig and comboInterface.tabConfig.idConfig, 3283)
setAttackBotIcon(comboInterface.tabAntired and comboInterface.tabAntired.idAntired, 37338)

if comboInterface.tabConfig then
  comboInterface.tabConfig.onClick = function()
    setAttackBotPanelTab("config")
  end
end

if comboInterface.tabAntired then
  comboInterface.tabAntired.onClick = function()
    setAttackBotPanelTab("antired")
  end
end

setAttackBotPanelTab("config")

if modules._G.g_app.isMobile() then
  comboInterface:setSize("350 505")
end

comboButton.settings.onClick = function()
  if not comboInterface:isVisible() then
    comboInterface:show()
    comboInterface:raise()
    comboInterface:focus()
  end
end
comboInterface.closePanel.onClick = function() comboInterface:hide() end

spellAddPanel = setupUI([=[
MainWindow
  id: spellAddPanel
  size: 260 310
  anchors.centerIn: parent
  margin-top: -50
  text: Insert Spell AttackBot

  ComboBox
    id: selectType
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-top: 0
    margin-left: -6
    margin-right: -6
    height: 22
    @onSetup: |
        self:addOption("Editable")
        self:addOption("Knight")
        self:addOption("Paladin")
        self:addOption("Monk")
        self:addOption("Mage")

  FlatPanel
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    height: 215
    margin: -6
    margin-top: 5

    Label
      id: magiaLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text: Spell Name:
      margin-left: 5
      margin-right: 5
      margin-top: 4
      font: verdana-11px-rounded

    TextEdit
      id: magia
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: Insert spell here
      visible: true

    ComboBox
      id: magiaSelect
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.top
      anchors.bottom: prev.bottom
      visible: false
      @onSetup: |
          self:addOption(" ")

    Label
      id: distanceLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Distance:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: distance
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: manaLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mana:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mana
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 0
      maximum: 1000
      step: 10

    Label
      id: mobsLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mobs:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mobs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 10
      step: 1

    Label
      id: cdLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Cooldown:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: cooldown
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      margin-right: 15
      minimum: 0
      maximum: 60000
      step: 1

    Button
      id: calculeCooldown
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: cdLabel.right
      text: T
      width: 10
      height: 13
      margin-left: 2
      font: verdana-11px-rounded

    CheckBox
      id: safe
      anchors.top: prev.bottom
      anchors.left: cdLabel.left
      margin-top: 10
      text: Spell Safe?
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: adicionarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Insert
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
spellAddPanel:hide()
if modules._G.g_app.isMobile() then
  spellAddPanel:setSize("260 325")
end

runeAddPanel = setupUI([=[
MainWindow
  id: runeAddPanel
  size: 220 210
  anchors.centerIn: parent
  margin-top: -50
  text: Insert Rune AttackBot

  FlatPanel
    id: panelMain
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    height: 150
    margin: -6
    margin-top: 0

    Label
      id: runaLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text: Rune ID:
      margin-left: 5
      margin-right: 5
      margin-top: 15
      font: verdana-11px-rounded

    BotItem
      id: runa
      anchors.top: prev.top
      anchors.right: parent.right
      margin-right: 8
      margin-top: -10

    Label
      id: distanceLabel
      anchors.top: prev.bottom
      anchors.left: runaLabel.left
      anchors.right: parent.right
      margin-top: 4
      margin-right: 5
      text: Distance:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: distance
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: mobsLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mobs:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mobs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 10
      step: 1

    CheckBox
      id: safe
      anchors.top: mobs.bottom
      anchors.left: distanceLabel.left
      margin-top: 14
      text: Rune Safe?
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 100
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: adicionarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 100
    margin-top: 5
    text: Insert
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
runeAddPanel:hide()
if modules._G.g_app.isMobile() then
  runeAddPanel:setSize("220 230")
end
 
profileNamePanel = setupUI([=[
MainWindow
  id: attackProfileNamePanel
  size: 260 120
  anchors.centerIn: parent
  margin-top: -50
  text: Rename AttackBot Profile

  FlatPanel
    id: panelMain
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 58
    margin: -6
    margin-top: 0

    Label
      id: info
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-left: 5
      margin-right: 5
      margin-top: 5
      text: Nome do profile:
      font: verdana-11px-rounded

    TextEdit
      id: profileName
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      placeholder: #N/D

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: salvarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Save
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
profileNamePanel:hide()


local sharedCfg = type(attackBotStorage.attackBotShared) == "table" and attackBotStorage.attackBotShared or {}
attackBotStorage.attackBotShared = sharedCfg

--==================================================
-- SHARED ATTACKBOT STAIRS STORAGE
-- Salva a lista de Stairs em: /bot/<config atual>/storage/shared/sharedAttackBot.json
-- Todos os chars que usam a mesma config leem a mesma lista.
--==================================================

local SHARED_ATTACK_DIR = nil
local SHARED_ATTACK_FILE = nil
local SharedAttackState = {
  loaded = false,
  lastSync = 0,
  lastJson = ""
}

local function getCurrentAttackBotConfigName()
  local panel = modules and modules.game_bot and modules.game_bot.contentsPanel
  local cfgPanel = panel and panel.config
  local opt = cfgPanel and cfgPanel.getCurrentOption and cfgPanel:getCurrentOption()

  if opt and opt.text and tostring(opt.text) ~= "" then
    return tostring(opt.text)
  end

  return nil
end

local function safeAttackDirExists(path)
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

local function safeAttackMakeDir(path)
  if not path or path == "" then return false end
  if safeAttackDirExists(path) then return true end
  if not g_resources or not g_resources.makeDir then return false end

  local ok = pcall(function()
    g_resources.makeDir(path)
  end)

  if not ok then return false end
  return safeAttackDirExists(path)
end

local function safeAttackFileExists(path)
  if not path or path == "" then return false end
  if not g_resources or not g_resources.fileExists then return false end

  local ok, exists = pcall(function()
    return g_resources.fileExists(path)
  end)

  return ok and exists == true
end

local function safeAttackWriteDefaultFile(path, defaultJson)
  if not path or path == "" then return false end
  if safeAttackFileExists(path) then return true end
  if not g_resources or not g_resources.writeFileContents then return false end

  local ok = pcall(function()
    g_resources.writeFileContents(path, defaultJson or "{}")
  end)

  if not ok then return false end
  return true
end

local function initSharedAttackPath()
  if SHARED_ATTACK_FILE then return true end

  local configName = getCurrentAttackBotConfigName()
  if not configName or configName == "" then
    return false
  end

  -- Cria primeiro a pasta pai, depois a pasta shared, e só então cria o .json.
  -- Isso evita debug em client que não aceita read/write em arquivo inexistente.
  local baseDir = "/bot/" .. configName .. "/storage/"
  local sharedDir = baseDir .. "shared/"
  local filePath = sharedDir .. "sharedAttackBot.json"

  if not safeAttackMakeDir(baseDir) then return false end
  if not safeAttackMakeDir(sharedDir) then return false end
  if not safeAttackWriteDefaultFile(filePath, "{\n  \"safeIdsAndares\": []\n}") then return false end

  SHARED_ATTACK_DIR = sharedDir
  SHARED_ATTACK_FILE = filePath
  return true
end

local function normalizeSharedStairsList(listOrMap)
  local out, used = {}, {}

  if type(listOrMap) == "table" then
    for k, v in pairs(listOrMap) do
      local id = nil

      -- Formato antigo em map: ["123"] = { state = true, ts = "..." }
      if type(k) == "string" and type(v) == "table" then
        if v.state == true then
          id = tonumber(k)
        end
      elseif type(v) == "table" then
        if v.getId then
          local ok, itemId = pcall(function() return v:getId() end)
          if ok then id = tonumber(itemId) end
        end
        id = id or tonumber(v.id)
      else
        id = tonumber(v)
      end

      if id and id > 0 and not used[id] then
        used[id] = true
        table.insert(out, id)
      end
    end
  end

  table.sort(out)
  return out
end

local function encodeAttackIdArray(list)
  local parts = {}
  for _, id in ipairs(normalizeSharedStairsList(list)) do
    table.insert(parts, tostring(id))
  end
  return "[" .. table.concat(parts, ",") .. "]"
end

local function encodeSharedAttack(data)
  data = data or {}
  return table.concat({
    "{\n",
    "  \"safeIdsAndares\": ", encodeAttackIdArray(data.safeIdsAndares), "\n",
    "}"
  })
end

local function decodeAttackArray(text, key)
  local result = {}
  text = tostring(text or "")
  key = tostring(key or "")

  local body = text:match('"' .. key .. '"%s*:%s*%[(.-)%]')
  if not body then return result end

  for value in body:gmatch("%-?%d+") do
    local id = tonumber(value)
    if id and id > 0 then
      table.insert(result, id)
    end
  end

  return result
end

local function decodeAttackMap(text, key)
  local result = {}
  text = tostring(text or "")
  key = tostring(key or "")

  local body = text:match('"' .. key .. '"%s*:%s*%{(.*)%}')
  if not body then return result end

  for idText, entryBody in body:gmatch('"(%-?%d+)"%s*:%s*%{(.-)%}') do
    local id = tonumber(idText)
    if id and id > 0 and entryBody:match('"state"%s*:%s*true') then
      table.insert(result, id)
    end
  end

  return result
end

local function decodeSharedAttack(text)
  text = tostring(text or "")

  local list = normalizeSharedStairsList(decodeAttackArray(text, "safeIdsAndares"))

  -- Compatibilidade com a versao antiga/bugada em formato map:
  -- { "safeIdsAndares": { "123": { "state": true } } }
  if #list == 0 then
    list = normalizeSharedStairsList(decodeAttackMap(text, "safeIdsAndares"))
  end

  return {
    safeIdsAndares = list
  }
end

local function readSharedAttackFile()
  if not initSharedAttackPath() then return nil end
  if not g_resources or not g_resources.readFileContents then return nil end

  local ok, data = pcall(function()
    return g_resources.readFileContents(SHARED_ATTACK_FILE)
  end)

  if ok and type(data) == "string" and data ~= "" then
    SharedAttackState.lastJson = data
    return decodeSharedAttack(data)
  end

  return nil
end

local function writeSharedAttackFile(data)
  if not initSharedAttackPath() then return false end
  if not g_resources or not g_resources.writeFileContents then return false end

  local jsonText = encodeSharedAttack(data)
  local ok = pcall(function()
    g_resources.writeFileContents(SHARED_ATTACK_FILE, jsonText)
  end)

  if ok then
    SharedAttackState.loaded = true
    SharedAttackState.lastSync = now or 0
    SharedAttackState.lastJson = jsonText
  end

  return ok == true
end

local function getSharedAttackFallback(localIds)
  return {
    safeIdsAndares = normalizeSharedStairsList(localIds)
  }
end

local function loadSharedAttackIds(localIds)
  local shared = readSharedAttackFile()

  if not shared then
    shared = getSharedAttackFallback(localIds)
    writeSharedAttackFile(shared)
  else
    shared.safeIdsAndares = normalizeSharedStairsList(shared.safeIdsAndares)
  end

  SharedAttackState.loaded = true
  return shared
end

local function saveSharedAttackIds(ids)
  ids = ids or {}

  local data = {
    safeIdsAndares = normalizeSharedStairsList(ids.safeIdsAndares)
  }

  writeSharedAttackFile(data)
  return data
end

local function applySharedAttackIdsToRuntime(data)
  if not data then return end

  sharedCfg.safeIdsAndares = normalizeSharedStairsList(data.safeIdsAndares)
  attackBotStorage.attackBotShared = sharedCfg
  saveAttackBotShared()
end

local function refreshSharedAttackIds(forceUpdateContainer)
  local data = readSharedAttackFile()
  if not data then return false end

  data.safeIdsAndares = normalizeSharedStairsList(data.safeIdsAndares)
  applySharedAttackIdsToRuntime(data)

  if forceUpdateContainer and idsSafeContainer then
    idsSafeContainer:setItems(sharedCfg.safeIdsAndares)
  end

  return true
end

sharedCfg.safeIdsAndares = loadSharedAttackIds(sharedCfg.safeIdsAndares).safeIdsAndares
saveAttackBotShared()

local function cleanAttackProfileName(text)
  text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if #text > 18 then
    text = text:sub(1, 18)
  end
  return text
end

local function defaultAttackBotProfile()
  return {
    name = "",
    main = {
      manterDist = false,
      checkPlayers = false,
      checkStairs = false,
      checkFloors = false,
      distSegura = 10,
      distStairs = 6,

      minutosVoltarUnsafe = 5,
      disabledByUnsafePK = {},
      reenableUnsafeAt = 0,
      qtdeFrags = 1,
      deslogarFrags = false,
      fragsAtual = 0
    },
    attacks = {}
  }
end

attackBotStorage.attackBotProfiles = attackBotStorage.attackBotProfiles or {
  activeProfile = 1,
  profiles = {}
}

for i = 1, 5 do
  attackBotStorage.attackBotProfiles.profiles[i] =
    attackBotStorage.attackBotProfiles.profiles[i] or defaultAttackBotProfile()
end

attackBotStorage.attackBotProfiles.activeProfile =
  math.max(1, math.min(5, tonumber(attackBotStorage.attackBotProfiles.activeProfile) or 1))

attackBotStorage.attackBotMonkHarmony = attackBotStorage.attackBotMonkHarmony or { points = 0 }

local function getActiveAttackProfileIndex()
  return math.max(1, math.min(5, tonumber(attackBotStorage.attackBotProfiles.activeProfile) or 1))
end

local function getActiveAttackProfile()
  local idx = getActiveAttackProfileIndex()
  attackBotStorage.attackBotProfiles.profiles[idx] =
    attackBotStorage.attackBotProfiles.profiles[idx] or defaultAttackBotProfile()

  local p = attackBotStorage.attackBotProfiles.profiles[idx]
  p.main = p.main or defaultAttackBotProfile().main
  p.attacks = p.attacks or {}

  p.main.minutosVoltarUnsafe = tonumber(p.main.minutosVoltarUnsafe) or 5
  p.main.disabledByUnsafePK = type(p.main.disabledByUnsafePK) == "table" and p.main.disabledByUnsafePK or {}
  p.main.reenableUnsafeAt = tonumber(p.main.reenableUnsafeAt) or 0
  p.main.qtdeFrags = tonumber(p.main.qtdeFrags) or 1
  p.main.deslogarFrags = p.main.deslogarFrags == true
  p.main.fragsAtual = tonumber(p.main.fragsAtual) or 0

  -- limpa sobras de versoes antigas que tinham logica antiga de pause por frag
  p.main.disabledByFrag = nil

  return p
end

local function getAttackProfile(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  attackBotStorage.attackBotProfiles.profiles[idx] =
    attackBotStorage.attackBotProfiles.profiles[idx] or defaultAttackBotProfile()

  local p = attackBotStorage.attackBotProfiles.profiles[idx]
  p.name = cleanAttackProfileName(p.name)
  p.main = p.main or defaultAttackBotProfile().main
  p.attacks = p.attacks or {}
  return p
end

local function getAttackProfileDisplayName(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  local p = getAttackProfile(idx)
  local name = cleanAttackProfileName(p.name)

  if name ~= "" then
    return name
  end

  return "#" .. idx
end

local cfg = getActiveAttackProfile()

local function refreshAttackProfileButtons()
  local active = getActiveAttackProfileIndex()

  for i = 1, 5 do
    local btn = comboButton and comboButton[tostring(i)]
    if btn then
      local isActive = (i == active)

      if btn.setOn then
        btn:setOn(isActive)
      end

      if btn.setColor then
        btn:setColor(isActive and "white" or "white")
      end

      if btn.setBackgroundColor then
        btn:setBackgroundColor(isActive and "alpha" or "alpha")
      end

      if btn.setImageColor then
        btn:setImageColor(isActive and "green" or "gray")
      end

      if btn.setOpacity then
        btn:setOpacity(isActive and 1.0 or 0.85)
      end

      if btn.setTooltip then
        btn:setTooltip("Profile " .. i .. ": " .. getAttackProfileDisplayName(i))
      end
    end
  end
end

local function refreshAttackProfileLabel()
  if comboButton and comboButton.name then
    comboButton.name:setText(getAttackProfileDisplayName(getActiveAttackProfileIndex()))
  end
  refreshAttackProfileButtons()
end

local function setActiveAttackProfile(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  attackBotStorage.attackBotProfiles.activeProfile = idx
  cfg = getActiveAttackProfile()

  if comboInterface and comboInterface.distSegura then
    comboInterface.distSegura:setValue(cfg.main.distSegura or 10)
  end
  if comboInterface and comboInterface.labelDistSegura then
    comboInterface.labelDistSegura:setText("Dist Check Players: " .. (cfg.main.distSegura or 10))
  end

  if comboInterface and comboInterface.distStairs then
    comboInterface.distStairs:setValue(cfg.main.distStairs or 6)
  end
  if comboInterface and comboInterface.labelDistStairs then
    comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. (cfg.main.distStairs or 6))
  end

  if comboInterface and comboInterface.manterDist then
    comboInterface.manterDist:setOn(cfg.main.manterDist == true)
  end
  if comboInterface and comboInterface.minutosVoltarUnsafe then
    comboInterface.minutosVoltarUnsafe:setValue(cfg.main.minutosVoltarUnsafe or 5)
  end
  if comboInterface and comboInterface.labelReactiveUnsafe then
    comboInterface.labelReactiveUnsafe:setText("Reactive in: " .. (cfg.main.minutosVoltarUnsafe or 5) .. " min")
  end
  if comboInterface and comboInterface.qtdeFrags then
    comboInterface.qtdeFrags:setValue(cfg.main.qtdeFrags or 1)
  end
  if comboInterface and comboInterface.labelExitFrags then
    comboInterface.labelExitFrags:setText("Amount Frags: " .. (cfg.main.qtdeFrags or 1))
  end
  if comboInterface and comboInterface.deslogarFrags then
    comboInterface.deslogarFrags:setOn(cfg.main.deslogarFrags == true)
  end
  if comboInterface and comboInterface.checkPlayers then
    comboInterface.checkPlayers:setOn(cfg.main.checkPlayers == true)
  end
  if comboInterface and comboInterface.checkStairs then
    comboInterface.checkStairs:setOn(cfg.main.checkStairs == true)
  end
  if comboInterface and comboInterface.checkFloors then
    comboInterface.checkFloors:setOn(cfg.main.checkFloors == true)
  end

  cfg.main.disabledByUnsafePK = type(cfg.main.disabledByUnsafePK) == "table" and cfg.main.disabledByUnsafePK or {}
  cfg.main.reenableUnsafeAt = tonumber(cfg.main.reenableUnsafeAt) or 0
  cfg.main.qtdeFrags = tonumber(cfg.main.qtdeFrags) or 1
  cfg.main.deslogarFrags = cfg.main.deslogarFrags == true
  cfg.main.fragsAtual = tonumber(cfg.main.fragsAtual) or 0
  cfg.main.disabledByFrag = nil

  refreshAttackProfileLabel()
  rebuildAttackList()
  saveAttackBotStorage()
end

local openAttackProfileNameEditor = nil

for i = 1, 5 do
  local btn = comboButton[tostring(i)]
  if btn then
    btn.onClick = function()
      setActiveAttackProfile(i)
    end

    btn.onDoubleClick = function()
      setActiveAttackProfile(i)
      if openAttackProfileNameEditor then
        openAttackProfileNameEditor(i)
      end
    end
  end
end

refreshAttackProfileLabel()


local function W(parent, id)
  if not parent then return nil end
  return (parent.getChildById and parent:getChildById(id)) or (parent.recursiveGetChildById and parent:recursiveGetChildById(id))
end

local function trimText(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end
local function trim(s) return trimText(s) end
local function clearChildren(w) if not w then return end for i = #w:getChildren(), 1, -1 do w:getChildren()[i]:destroy() end end
local function clamp(v, a, b)
  v = tonumber(v) or a
  if v < a then return a end
  if v > b then return b end
  return v
end

local profileNameInput = W(profileNamePanel, "profileName")
local profileNameSave = W(profileNamePanel, "salvarBt")
local profileNameCancel = W(profileNamePanel, "cancelarBt")
local renamingAttackProfileIndex = getActiveAttackProfileIndex()

openAttackProfileNameEditor = function(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or getActiveAttackProfileIndex()))
  renamingAttackProfileIndex = idx

  local p = getAttackProfile(idx)

  if profileNameInput then
    profileNameInput:setText(cleanAttackProfileName(p.name))
  end

  if profileNamePanel then
    profileNamePanel:setText("Rename Profile #" .. idx)
    profileNamePanel:show()
    profileNamePanel:raise()
    profileNamePanel:focus()
  end

  if profileNameInput and profileNameInput.focus then
    profileNameInput:focus()
  end
end

if comboButton and comboButton.name then
  comboButton.name.onDoubleClick = function()
    openAttackProfileNameEditor(getActiveAttackProfileIndex())
  end
end

if profileNameSave then
  profileNameSave.onClick = function()
    local p = getAttackProfile(renamingAttackProfileIndex)
    p.name = cleanAttackProfileName(profileNameInput and profileNameInput:getText() or "")
    saveAttackBotStorage()
    refreshAttackProfileLabel()

    if profileNamePanel then
      profileNamePanel:hide()
    end
  end
end

if profileNameCancel then
  profileNameCancel.onClick = function()
    if profileNamePanel then
      profileNamePanel:hide()
    end
  end
end
local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return (os.time() * 1000) + math.floor((os.clock() * 1000) % 1000)
end
local function setSafeLabel(w, v) if not w then return end w:setColor(v and "#00FF00" or "#FF4040") w:setText(v and "[Safe]" or "[Unsafe]") end
local function spellInfo(d,m) d=tonumber(d) or 1 m=tonumber(m) or 1 return "["..d.." Sqm | +"..m.." Mob(s)"..(m>1 and "s" or "").."]" end
local function runeInfo(d,m) d=tonumber(d) or 1 m=tonumber(m) or 1 return "["..d.." Sqm | +"..m.." Mob(s)"..(m>1 and "s" or "").."]" end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    local ok,id = pcall(function() return widget:getItemId() end)
    if ok and id and id > 0 then return id end
  end
  if widget.getItem then
    local ok,item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2,id = pcall(function() return item:getId() end)
      if ok2 and id and id > 0 then return id end
    end
  end
  return 0
end

local function setItemIcon(widget, itemId)
  itemId = tonumber(itemId)
  if not widget then return end
  if not itemId or itemId <= 0 then return widget:setVisible(false) end
  widget:setVisible(true)
  if widget.setItemId then return widget:setItemId(itemId) end
  if widget.setItem and Item and Item.create then widget:setItem(Item.create(itemId, 1)) end
end


--==================================================
-- SPELL ICONS
-- Puxa o sprite da magia direto do modulo game_spelllist,
-- igual ao Max Attack, usando o nome/words da spell.
--==================================================
local attackBotSpellIconFile = type(SpelllistSettings) == "table" and SpelllistSettings.Default and SpelllistSettings.Default.iconFile or "/images/game/spells/defaultspells"
local attackBotSpellIconCache = {}
local attackBotSpellWordsToName = {}
local attackBotSpellIconCacheReady = false

local function attackBotNormalizeSpellText(textValue)
  return tostring(textValue or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
end

local function refreshAttackBotSpellIconCache()
  attackBotSpellWordsToName = {}

  if type(SpellInfo) == "table" then
    for _, spellGroup in pairs(SpellInfo) do
      if type(spellGroup) == "table" then
        for spellName, spellInfo in pairs(spellGroup) do
          if type(spellInfo) == "table" and spellInfo.words then
            attackBotSpellWordsToName[attackBotNormalizeSpellText(spellInfo.words)] = spellName
          end
        end
      end
    end
  end

  attackBotSpellIconCache = {}

  local spellListModule = modules and modules.game_spelllist
  if spellListModule and spellListModule.spellList then
    pcall(function()
      if spellListModule.updateSpelllist then
        spellListModule.updateSpelllist()
      end
    end)

    local spellWidgets = {}
    pcall(function()
      spellWidgets = spellListModule.spellList:getChildren() or {}
    end)

    for _, spellWidget in ipairs(spellWidgets or {}) do
      local spellWidgetText = ""
      pcall(function()
        spellWidgetText = spellWidget:getText()
      end)

      local spellClip
      local clipWidth = 0
      pcall(function()
        spellClip = spellWidget:getImageClip()
        clipWidth = spellClip and spellClip.width or 0
      end)

      if spellWidgetText ~= "" and spellClip and clipWidth > 0 then
        attackBotSpellIconCache[#attackBotSpellIconCache + 1] = {
          text = attackBotNormalizeSpellText(spellWidgetText),
          clip = spellClip,
          x = spellClip.x or 0,
          y = spellClip.y or 0
        }
      end
    end

    if #attackBotSpellIconCache > 0 then
      attackBotSpellIconCacheReady = true
    end
  end
end

local function findAttackBotSpellIconClip(spellText)
  if not attackBotSpellIconCacheReady then
    refreshAttackBotSpellIconCache()
  end

  local normalizedSpellText = attackBotNormalizeSpellText(spellText)
  local fallbackClip

  for _, iconData in ipairs(attackBotSpellIconCache) do
    if iconData.text:find("'" .. normalizedSpellText .. "'", 1, true) then
      if iconData.x ~= 0 or iconData.y ~= 0 then
        return iconData.clip
      end

      fallbackClip = fallbackClip or iconData.clip
    end
  end

  if fallbackClip then
    return fallbackClip
  end

  local spellNameFromWords = attackBotSpellWordsToName[normalizedSpellText]
  if spellNameFromWords then
    local normalizedSpellName = attackBotNormalizeSpellText(spellNameFromWords)

    for _, iconDataByName in ipairs(attackBotSpellIconCache) do
      if iconDataByName.text:find(normalizedSpellName, 1, true) then
        if iconDataByName.x ~= 0 or iconDataByName.y ~= 0 then
          return iconDataByName.clip
        end

        fallbackClip = fallbackClip or iconDataByName.clip
      end
    end
  end

  return fallbackClip
end

local function setAttackBotSpellIcon(widget, spellText)
  if not widget then return end

  local spellClip = findAttackBotSpellIconClip(spellText)
  if not spellClip then
    if widget.hide then widget:hide() elseif widget.setVisible then widget:setVisible(false) end
    return
  end

  pcall(function()
    widget:setImageSource(attackBotSpellIconFile)
    widget:setImageClip(spellClip)
  end)

  if widget.show then widget:show() elseif widget.setVisible then widget:setVisible(true) end
end

local function bindSwitch(widget, key)
  widget:setOn(cfg.main[key])
  widget.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    cfg.main[key] = state
    saveAttackBotStorage()
  end
end

comboButton.title:setOn(attackBotStorage[switchCombo].enabled)
bindSwitch(comboInterface.manterDist, "manterDist")
bindSwitch(comboInterface.checkPlayers, "checkPlayers")
bindSwitch(comboInterface.checkStairs, "checkStairs")
bindSwitch(comboInterface.checkFloors, "checkFloors")

comboInterface.distSegura:setValue(cfg.main.distSegura or 0)
comboInterface.labelDistSegura:setText("Dist Check Players: " .. (cfg.main.distSegura or 0))
comboInterface.distSegura.onValueChange = function(_, value)
  cfg.main.distSegura = value
  comboInterface.labelDistSegura:setText("Dist Check Players: " .. value)
  saveAttackBotStorage()
end

comboInterface.distStairs:setValue(cfg.main.distStairs or 0)
comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. (cfg.main.distStairs or 0))
comboInterface.distStairs.onValueChange = function(_, value)
  cfg.main.distStairs = value
  comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. value)
  saveAttackBotStorage()
end

idsSafeContainer = UI.ContainerEx(function(_, items)
  sharedCfg.safeIdsAndares = normalizeSharedStairsList(normalizeContainerItems(items))
  sharedCfg = saveSharedAttackIds(sharedCfg)
  attackBotStorage.attackBotShared = sharedCfg
  saveAttackBotShared()
end, true, comboInterface.idsSafeAndares)

idsSafeContainer:setParent(comboInterface.idsSafeAndares)
idsSafeContainer:fill("parent")
idsSafeContainer:setOpacity(1.00)
idsSafeContainer:setItems(sharedCfg.safeIdsAndares)

macro(60000, function()
  -- Recarrega o sharedAttackBot.json para outros chars abertos pegarem alterações.
  -- Se o painel estiver aberto, não força setItems para não atrapalhar drag/drop.
  local updateContainer = comboInterface and comboInterface.isVisible and not comboInterface:isVisible()
  refreshSharedAttackIds(updateContainer)
end)

local spellRowTemplate = [[
UIWidget
  id: root
  height: 38
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 2
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    margin-top: 0
    width: 18
    height: 18
    text-align: center
    color: white
    image-source: /images/ui/button_rounded

  Panel
    id: iconSpell
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    size: 27 27
    visible: false
    phantom: true
    focusable: false

  Label
    id: spellName
    anchors.left: iconSpell.right
    anchors.top: parent.top
    margin-left: 8
    margin-top: 4
    color: orange
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Label
    id: distText
    anchors.left: spellName.left
    anchors.top: spellName.bottom
    margin-top: 2
    color: #c8c8c8
    text: ""
    font: cipsoftFont
    text-auto-resize: true

  Label
    id: safeText
    anchors.left: spellName.right
    anchors.verticalCenter: spellName.verticalCenter
    margin-left: 4
    color: #ff5a5a
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

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
    image-source: /images/ui/button_rounded
    image-color: red
    opacity: 1.00
    $hover:
      image-color: red
      color: #ffd0d0
      opacity: 0.95
]]

local runeRowTemplate = [[
UIWidget
  id: root
  height: 38
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 2
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    margin-top: 0
    width: 18
    height: 18
    text-align: center
    color: white
    image-source: /images/ui/button_rounded

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    size: 30 30
    visible: false

  Label
    id: distText
    anchors.left: icon.right
    anchors.bottom: prev.bottom
    margin-left: 4
    margin-bottom: 4
    color: #c8c8c8
    text: ""
    font: cipsoftFont
    text-auto-resize: true

  Label
    id: safeText
    anchors.left: icon.right
    anchors.top: icon.top
    margin-left: 4
    color: #ff5a5a
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

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
    image-source: /images/ui/button_rounded
    image-color: red
    opacity: 1.00
    $hover:
      image-color: red
      color: #ffd0d0
      opacity: 0.95
]]

local editingSpellIndex = nil
local editingRuneIndex = nil

local selectType = W(spellAddPanel, "selectType")
local magiaSelect = W(spellAddPanel, "magiaSelect")
local spellMagia = W(spellAddPanel,"magia")
local spellDistance = W(spellAddPanel,"distance")
local spellMana = W(spellAddPanel,"mana")
local spellMobs = W(spellAddPanel,"mobs")
local spellCooldown = W(spellAddPanel,"cooldown")
local spellSafe = W(spellAddPanel,"safe")
local spellCancelarBt = W(spellAddPanel,"cancelarBt")
local spellAdicionarBt = W(spellAddPanel,"adicionarBt")
local spellDistanceLabel = W(spellAddPanel,"distanceLabel")
local spellManaLabel = W(spellAddPanel,"manaLabel")
local spellMobsLabel = W(spellAddPanel,"mobsLabel")
local spellCooldownLabel = W(spellAddPanel,"cdLabel")
local spellCalcCooldownBtn = W(spellAddPanel, "calculeCooldown")

local runeItem = W(runeAddPanel,"runa")
local runeDistance = W(runeAddPanel,"distance")
local runeMobs = W(runeAddPanel,"mobs")
local runeSafe = W(runeAddPanel,"safe")
local runeCancelarBt = W(runeAddPanel,"cancelarBt")
local runeAdicionarBt = W(runeAddPanel,"adicionarBt")
local runeDistanceLabel = W(runeAddPanel,"distanceLabel")
local runeMobsLabel = W(runeAddPanel,"mobsLabel")
local unsafeMinutos = W(comboInterface, "minutosVoltarUnsafe")
local unsafeFrags = W(comboInterface, "qtdeFrags")
local unsafeDeslogar = W(comboInterface, "deslogarFrags")
local unsafeLabelMin = W(comboInterface, "labelReactiveUnsafe")
local unsafeLabelFrags = W(comboInterface, "labelExitFrags")

if unsafeMinutos then
  if unsafeMinutos.setMinimum then unsafeMinutos:setMinimum(1) end
  if unsafeMinutos.setMaximum then unsafeMinutos:setMaximum(120) end
  if unsafeMinutos.setStep then unsafeMinutos:setStep(1) end
end

if unsafeFrags then
  if unsafeFrags.setMinimum then unsafeFrags:setMinimum(1) end
  if unsafeFrags.setMaximum then unsafeFrags:setMaximum(8) end
  if unsafeFrags.setStep then unsafeFrags:setStep(1) end
end

local function refreshUnsafePanel()
  local min = tonumber(cfg.main.minutosVoltarUnsafe) or 5
  local frags = tonumber(cfg.main.qtdeFrags) or 1

  if unsafeMinutos then
    unsafeMinutos:setValue(min)
  end

  if unsafeLabelMin then
    unsafeLabelMin:setText("Reactive in: " .. min .. " min")
  end

  if unsafeFrags then
    unsafeFrags:setValue(frags)
  end

  if unsafeLabelFrags then
    unsafeLabelFrags:setText("Amount Frags: " .. frags)
  end

  if unsafeDeslogar then
    unsafeDeslogar:setOn(cfg.main.deslogarFrags == true)
  end
end

-- Tabela com as magias pré-configuradas {Nome, Distância, Mana, Mobs, CD, Safe}
local predefinedSpells = {
  ["Paladin"] = {
    {"Exevo mas san", 4, 160, 1, 4106, false},
    {"Exori san", 9, 20, 1, 2100, true},
    {"Exori con", 9, 25, 1, 2100, true},
    {"Exori gran con", 9, 55, 1, 6080, true}
  },
  ["Knight"] = {
    {"Exori gran", 1, 340, 1, 4106, false},
    {"Exori", 1, 115, 1, 2016, false},
    {"Exori min", 1, 200, 1, 4030, false},
    {"Exori mas", 2, 160, 1, 6100, false},
    {"Exori hur", 5, 40, 1, 4060, true},
    {"Exori ico", 1, 30, 1, 2070, true},
    {"Exori gran ico", 1, 300, 1, 15020, true}
  },
  ["Mage"] = {
    {"Exori frigo", 8, 20, 1, 2027, true},
    {"Exevo gran mas frigo", 7, 1000, 1, 15055, true},
    {"Exori vis", 8, 20, 1, 2027, true},
    {"Exevo gran mas vis", 7, 600, 1, 15055, true},
    {"Exori flam", 8, 20, 1, 2027, true},
    {"Exevo gran mas flam", 7, 1000, 1, 15055, true},
    {"Exori tera", 8, 20, 1, 2027, true},
    {"Exevo gran mas tera", 7, 600, 1, 15055, true}
  },
  -- SPELL, DISTANCIA, MANA, MOBS, COOLDOWN, SAFE
  ["Monk"] = {
    {"Exori Pug", 1, 35, 1, 4096, true},
    {"Exori Amp Pug", 1, 50, 1, 20090, false},
    {"Exori Med Pug", 1, 180, 1, 4074, false},
    {"Exori Mas Pug", 2, 125, 1, 4035, false},
    {"Exori Gran Pug", 1, 325, 1, 15103, false},
    {"Exori Gran Mas Pug", 1, 315, 1, 16015, false},
    {"Exori Nia", 1, 50, 1, 8074, true},
    {"Exori Mas Nia", 1, 195, 1, 8050, false},
    {"Exori Gran Nia", 1, 210, 1, 24103, true},
    {"Exori Gran Mas Nia", 1, 425, 1, 60081, false}
  }
}

local function updateSpellPanelLabels()
  if spellDistanceLabel and spellDistance then spellDistanceLabel:setText("Distance: " .. (spellDistance:getValue() or 0)) end
  if spellManaLabel and spellMana then spellManaLabel:setText("Mana: " .. (spellMana:getValue() or 0)) end
  if spellMobsLabel and spellMobs then spellMobsLabel:setText("Mobs: " .. (spellMobs:getValue() or 0)) end
  if spellCooldownLabel and spellCooldown then spellCooldownLabel:setText("Cooldown: " .. (spellCooldown:getValue() or 0)) end
end

local function updateRunePanelLabels()
  if runeDistanceLabel and runeDistance then runeDistanceLabel:setText("Distance: " .. (runeDistance:getValue() or 0)) end
  if runeMobsLabel and runeMobs then runeMobsLabel:setText("Mobs: " .. (runeMobs:getValue() or 0)) end
end

if spellDistance then spellDistance.onValueChange = function() updateSpellPanelLabels() end end
if spellMana then spellMana.onValueChange = function() updateSpellPanelLabels() end end
if spellMobs then spellMobs.onValueChange = function() updateSpellPanelLabels() end end
if spellCooldown then spellCooldown.onValueChange = function() updateSpellPanelLabels() end end
if runeDistance then runeDistance.onValueChange = function() updateRunePanelLabels() end end
if runeMobs then runeMobs.onValueChange = function() updateRunePanelLabels() end end

if unsafeMinutos then
  unsafeMinutos.onValueChange = function(_, value)
    local v = tonumber(value) or 5
    cfg.main.minutosVoltarUnsafe = v

    if unsafeLabelMin then
      unsafeLabelMin:setText("Reactive in: " .. v .. " min")
    end

    saveAttackBotStorage()
  end
end

if unsafeFrags then
  unsafeFrags.onValueChange = function(_, value)
    local v = tonumber(value) or 1
    cfg.main.qtdeFrags = v

    if unsafeLabelFrags then
      unsafeLabelFrags:setText("Amount Frags: " .. v)
    end

    saveAttackBotStorage()
  end
end

if unsafeDeslogar then
  unsafeDeslogar.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    cfg.main.deslogarFrags = state
    saveAttackBotStorage()
  end
end

if selectType and magiaSelect and spellMagia then
  selectType.onOptionChange = function(comboBox, option)
    if option == "Editable" then
      spellMagia:setVisible(true)
      magiaSelect:setVisible(false)
      spellDistance:setValue(0)
      spellMana:setValue(0)
      spellMobs:setValue(1)
      spellCooldown:setValue(0)
      spellSafe:setChecked(false)
    else
      spellMagia:setVisible(false)
      magiaSelect:setVisible(true)

      magiaSelect:clearOptions()
      local vocSpells = predefinedSpells[option] or {}
      if #vocSpells == 0 then
        magiaSelect:addOption("Nenhuma magia cadastrada")
      else
        for _, s in ipairs(vocSpells) do
          magiaSelect:addOption(s[1])
        end
        local first = vocSpells[1]
        spellDistance:setValue(first[2])
        spellMana:setValue(first[3])
        spellMobs:setValue(first[4] or 1)
        spellCooldown:setValue(first[5])
        spellSafe:setChecked(first[6])
        updateSpellPanelLabels()
      end
    end
  end

  magiaSelect.onOptionChange = function(comboBox, option)
    local currentType = selectType:getCurrentOption().text
    local vocSpells = predefinedSpells[currentType] or {}
    for _, s in ipairs(vocSpells) do
      if s[1] == option then
        spellDistance:setValue(s[2])
        spellMana:setValue(s[3])
        spellMobs:setValue(s[4] or 1)
        spellCooldown:setValue(s[5])
        spellSafe:setChecked(s[6])
        updateSpellPanelLabels()
        break
      end
    end
  end
end

local function resetSpellAddPanel()
  if selectType then selectType:setOption("Editable") end
  if spellMagia then 
    spellMagia:setText("") 
    spellMagia:setVisible(true)
  end
  if magiaSelect then magiaSelect:setVisible(false) end
  if spellDistance then spellDistance:setValue(1) end
  if spellMana then spellMana:setValue(0) end
  if spellMobs then spellMobs:setValue(1) end
  if spellCooldown then spellCooldown:setValue(0) end
  if spellSafe then spellSafe:setChecked(false) end
  updateSpellPanelLabels()
end

local function resetRuneAddPanel()
  if runeItem then
    if runeItem.setItemId then
      runeItem:setItemId(0)
    elseif runeItem.setItem then
      pcall(function() runeItem:setItem(nil) end)
    end
  end
  if runeDistance then runeDistance:setValue(1) end
  if runeMobs then runeMobs:setValue(1) end
  if runeSafe then runeSafe:setChecked(false) end
  updateRunePanelLabels()
end

local function setupDragAndDrop(row)
  row.onDragEnter = function(self, mousePos)
    self:setOpacity(0.4)
    return true
  end
  row.onDragLeave = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
  end
  row.onDrop = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
    droppedWidget:setOpacity(1.0)
    local parent = self:getParent()
    local children = parent:getChildren()
    local fromIndex, toIndex = 0, 0
    for i, child in ipairs(children) do
      if child == droppedWidget then fromIndex = i end
      if child == self then toIndex = i end
    end
    if fromIndex > 0 and toIndex > 0 and fromIndex ~= toIndex then
      local movedItem = table.remove(cfg.attacks, fromIndex)
      table.insert(cfg.attacks, toIndex, movedItem)
      saveAttackBotStorage()
      rebuildAttackList()
    end
    return true
  end
end

local function createSpellRow(data, index)
  local row = setupUI(spellRowTemplate, comboInterface.spellList)
  setupDragAndDrop(row) -- Aplica o Drag & Drop na Spell

  row.enabled:setOn(data.enabled == true)
  row.enabled.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    if cfg.attacks[index] then cfg.attacks[index].enabled = state end
    saveAttackBotStorage()
  end
  setAttackBotSpellIcon(row.iconSpell, data.spell)
  row.spellName:setText(tostring(data.spell or ""))
  row.distText:setText(spellInfo(data.distance, data.mobs))
  setSafeLabel(row.safeText, data.safe)
  row.remove.onClick = function()
    table.remove(cfg.attacks, index)
    saveAttackBotStorage()
    rebuildAttackList()
  end
  row.onDoubleClick = function()
    local data = cfg.attacks[index]
    if not data then return end
    editingIndex = index
    spellMagia:setText(data.spell or "")
    spellDistance:setValue(data.distance or 1)
    spellMana:setValue(data.mana or 0)
    spellMobs:setValue(data.mobs or 1)
    spellCooldown:setValue(data.cooldown or 0)
    spellSafe:setChecked(data.safe or false)
    updateSpellPanelLabels()
    comboInterface:hide()
    spellAddPanel:show()
    spellAddPanel:raise()
    spellAddPanel:focus()
  end
end

local function createRuneRow(data, index)
  local row = setupUI(runeRowTemplate, comboInterface.spellList)
  setupDragAndDrop(row) -- Aplica o Drag & Drop na Runa

  row.enabled:setOn(data.enabled == true)
  row.enabled.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    if cfg.attacks[index] then cfg.attacks[index].enabled = state end
    saveAttackBotStorage()
  end
  setItemIcon(row.icon, tonumber(data.id) or 0)
  row.distText:setText(runeInfo(data.distance, data.mobs))
  setSafeLabel(row.safeText, data.safe)
  row.remove.onClick = function()
    table.remove(cfg.attacks, index)
    saveAttackBotStorage()
    rebuildAttackList()
  end
  row.onDoubleClick = function()
    local data = cfg.attacks[index]
    if not data then return end
    editingIndex = index
    setItemIcon(runeItem, tonumber(data.id) or 0)
    if runeItem and runeItem.setItemId then runeItem:setItemId(tonumber(data.id) or 0) end
    runeDistance:setValue(data.distance or 1)
    runeMobs:setValue(data.mobs or 1)
    runeSafe:setChecked(data.safe or false)
    updateRunePanelLabels()
    comboInterface:hide()
    runeAddPanel:show()
    runeAddPanel:raise()
    runeAddPanel:focus()
  end
end

function rebuildAttackList()
  if not comboInterface or not comboInterface.spellList then return end
  clearChildren(comboInterface.spellList)
  for i, data in ipairs(cfg.attacks or {}) do 
    if data.type == "spell" then
      createSpellRow(data, i)
    elseif data.type == "rune" then
      createRuneRow(data, i)
    end
  end
end

comboInterface.adicionarSpell.onClick = function()
  editingIndex = nil
  resetSpellAddPanel()
  comboInterface:hide()
  spellAddPanel:show()
  spellAddPanel:focus()
  spellAddPanel:raise()
end

comboInterface.adicionarRuna.onClick = function()
  editingIndex = nil
  resetRuneAddPanel()
  comboInterface:hide()
  runeAddPanel:show()
  runeAddPanel:raise()
  runeAddPanel:focus()
end

spellAdicionarBt.onClick = function()
  local spellName = ""

  -- Verifica de onde pegar o nome da magia
  if selectType and selectType:getCurrentOption().text == "Editable" then
    spellName = trimText(spellMagia:getText())
  else
    spellName = trimText(magiaSelect:getCurrentOption().text)
    if spellName == "Nenhuma magia cadastrada" or spellName == "" then
       return warn("Nenhuma magia válida selecionada para esta vocação.")
    end
  end

  if spellName == "" then return warn("Insira ou selecione uma spell.") end

  local data = {
    type = "spell",
    enabled = true,
    spell = spellName,
    distance = spellDistance:getValue(),
    mana = spellMana:getValue(),
    mobs = spellMobs:getValue(),
    cooldown = spellCooldown:getValue(),
    safe = spellSafe:isChecked(),
    nextCast = 0
  }

  if editingIndex then
    data.enabled = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].enabled ~= false or true
    data.nextCast = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].nextCast or 0
    cfg.attacks[editingIndex] = data
    editingIndex = nil
  else
    table.insert(cfg.attacks, data)
  end

  saveAttackBotStorage()
  rebuildAttackList()
  spellAddPanel:hide()
  comboInterface:show()
end

runeAdicionarBt.onClick = function()
  local runeId = getBotItemId(runeItem)
  if not runeId or runeId <= 0 then return warn("Selecione uma rune.") end

  local data = {
    type = "rune",
    enabled = true,
    id = runeId,
    distance = runeDistance:getValue(),
    mobs = runeMobs:getValue(),
    safe = runeSafe:isChecked(),
    nextCast = 0
  }

  if editingIndex then
    data.enabled = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].enabled ~= false or true
    data.nextCast = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].nextCast or 0
    cfg.attacks[editingIndex] = data
    editingIndex = nil
  else
    table.insert(cfg.attacks, data)
  end

  saveAttackBotStorage()
  rebuildAttackList()
  runeAddPanel:hide()
  comboInterface:show()
end

spellCancelarBt.onClick = function()
  editingIndex = nil
  spellAddPanel:hide()
  comboInterface:show()
end

runeCancelarBt.onClick = function()
  editingIndex = nil
  comboInterface:show()
  runeAddPanel:hide()
end

setActiveAttackProfile(getActiveAttackProfileIndex())
refreshUnsafePanel()
updateSpellPanelLabels()
updateRunePanelLabels()

local SkullWhite = 3
local SkullRed = 4
local SkullBlack = 5

local PKSkulls = {
  [SkullWhite] = true,
  [SkullRed] = true,
  [SkullBlack] = true
}

local function getSafePlayerCheckDist()
  return math.max(1, tonumber(cfg.main.distSegura) or 1)
end

local function getSafeOtherFloorCheckDist()
  return math.max(1, tonumber(cfg.main.qtdePlayers) or 1)
end

local function getSafeStairsCheckDist()
  return math.max(1, tonumber(cfg.main.distStairs) or 1)
end

local function isPkSkulled(creature)
  if not creature or not creature.getSkull then return false end
  local skull = creature:getSkull()
  return PKSkulls[skull] == true
end

local function hasPartyShield(creature)
  if not creature then
    return false
  end

  if creature.isPartyMember and creature:isPartyMember() then
    return true
  end

  return false
end

local function isAttackBotFriend(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then
    return false
  end

  local cname = creature:getName()
  if not cname then return false end

  -- party real, somente pelo estado atual
  if creature.isPartyMember and creature:isPartyMember() then
    return true
  end

  local playerListStorage = storage and storage.playerList
  local friends = playerListStorage and playerListStorage.friendList

  if type(friends) == "table" then
    for _, friendName in ipairs(friends) do
      if trimText(friendName):lower() == trimText(cname):lower() then
        return true
      end
    end
  end

  if type(isFriend) == "function" and isFriend(cname) then
    return true
  end

  return false
end

local function isSpellProtectedPlayer(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then
    return false
  end

  if isAttackBotFriend(creature) then
    return false
  end

  return not isPkSkulled(creature)
end

local function getPlayerFloorScan()
  local result = {
    sameFloor = false,
    otherFloor = false
  }

  local myPos = pos()
  if not myPos then return result end

  local maxDist = getSafePlayerCheckDist()

  for _, spec in pairs(getSpectators(true)) do
    if isSpellProtectedPlayer(spec) then
      local sPos = spec:getPosition()

      if sPos then
        local dist = math.max(math.abs(myPos.x - sPos.x), math.abs(myPos.y - sPos.y))

        if sPos.z == myPos.z then
          if cfg.main.checkPlayers and dist <= maxDist then
            result.sameFloor = true
          end
        else
          if cfg.main.checkFloors and math.abs(sPos.z - myPos.z) == 1 and dist <= maxDist then
            result.otherFloor = true
          end
        end
      end
    end
  end

  return result
end

local function hasPlayerOnScreenSameFloor()
  return getPlayerFloorScan().sameFloor == true
end

local function hasPlayerOnOtherFloors()
  return getPlayerFloorScan().otherFloor == true
end

local MINIMAP_STAIRS_COLORS = {
  [210] = true,
  [211] = true,
  [212] = true,
  [213] = true,

}

local function isMinimapStairs(pos)
  if not pos or not g_map or not g_map.getMinimapColor then return false end

  local color = g_map.getMinimapColor(pos)
  color = tonumber(color)

  if not color then return false end

  return MINIMAP_STAIRS_COLORS[color] == true
end


local function hasConfiguredUnsafeId(tile)
  if not tile then return false end

  local ids = sharedCfg.safeIdsAndares or {}

  for _, item in pairs(tile:getItems() or {}) do
    if item and item.getId and table.find(ids, item:getId()) then
      return true
    end
  end

  return false
end

local function hasYellowMinimapStair(tile)
  if not tile then return false end
  return isMinimapStairs(tile:getPosition()) == true
end

local function isNearConfiguredStairs()
  if not cfg.main.checkStairs then return false end

  local myPos = pos()
  if not myPos then return false end

  local stairDist = getSafeStairsCheckDist()

  -- 1) ID configurado = UNSAFE direto, MAS SÓ NO ANDAR ATUAL
  for _, tile in pairs(g_map.getTiles(myPos.z) or {}) do
    local tPos = tile:getPosition()

    if tPos then
      local dist = math.max(math.abs(myPos.x - tPos.x), math.abs(myPos.y - tPos.y))

      if dist <= stairDist and hasConfiguredUnsafeId(tile) then
        return "id"
      end
    end
  end

  -- 2) Minimap amarelo = só sinalizador de escada/andar, também no andar atual
  for _, tile in pairs(g_map.getTiles(myPos.z) or {}) do
    local tPos = tile:getPosition()

    if tPos then
      local dist = math.max(math.abs(myPos.x - tPos.x), math.abs(myPos.y - tPos.y))

      if dist <= stairDist and hasYellowMinimapStair(tile) then
        return "yellow"
      end
    end
  end

  return false
end

local function hasPlayerOnOtherFloorsNearStairs()
  if not cfg.main.checkStairs then return false end

  local myPos = pos()
  if not myPos then return false end

  local maxPlayerDist = getSafePlayerCheckDist()

  for _, spec in pairs(getSpectators(true) or {}) do
    if spec and spec:isPlayer() and not spec:isLocalPlayer() and isSpellProtectedPlayer(spec) then
      local sPos = spec:getPosition()

      if sPos and sPos.z ~= myPos.z and math.abs(sPos.z - myPos.z) == 1 then
        local dist = math.max(math.abs(myPos.x - sPos.x), math.abs(myPos.y - sPos.y))

        if dist <= maxPlayerDist then
          return true
        end
      end
    end
  end

  return false
end

local function hasProtectedPlayerForUnsafe()
  local scan = getPlayerFloorScan()

  if scan.sameFloor then return true end
  if hasPlayerOnOtherFloorsNearStairs() then return true end
  if scan.otherFloor then return true end

  return false
end

function LNS_HAS_UNSAFE_CONDITION()
  local scan = getPlayerFloorScan()

  if scan.sameFloor then return true end

  local stairMode = isNearConfiguredStairs()

  if stairMode == "id" then
    return true
  end

  if stairMode == "yellow" then
    return hasPlayerOnOtherFloorsNearStairs() == true
  end

  if scan.otherFloor then return true end

  return false
end

macro(100, function()
  LNS_HAS_UNSAFE_CONDITION()
  local p = player
  if not p then return end

  local unsafe = false

  if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
    unsafe = LNS_HAS_UNSAFE_CONDITION() == true
  end

  if unsafe then
    if p:getText() ~= "UNSAFE" then
      p:setText("UNSAFE")
    end
  else
    if p:getText() == "UNSAFE" then
      p:setText("")
    end
  end
end)

local WORLD_COMBAT_LOCK = 300
local attackGroupReadyAt = 0
local EXTRA_GROUP_DELAY = 200

local combatGlobalUntil = 0
local lastRuneGlobal = 0

local function isAttackGroupCooldownActive()
  local isCooldownActive = false

  pcall(function()
    local cooldownModule = modules and modules.game_cooldown

    if cooldownModule and cooldownModule.isGroupCooldownIconActive then
      isCooldownActive = cooldownModule.isGroupCooldownIconActive(1) == true
    end
  end)

  return isCooldownActive
end


local runeCooldownIcon = {
  [3155] = 21,
  [3175] = 116,
  [3202] = 117,
  [3191] = 16,
  [3161] = 115
}

local function isRuneClientCooldownActive(runeId)
  runeId = tonumber(runeId) or 0

  local iconId = runeCooldownIcon[runeId]
  if not iconId then return false end

  return modules.game_cooldown
     and modules.game_cooldown.isCooldownIconActive
     and modules.game_cooldown.isCooldownIconActive(iconId) == true
end

local MONK_HARMONY_MAX = 5
local MONK_HARMONY_BUILDERS = {
  ["exori gran pug"] = true,
  ["exori amp pug"] = true,
  ["exori gran mas pug"] = true,
  ["exori mas pug"] = true,
  ["exori med pug"] = true
}
local MONK_HARMONY_FINISHERS = {
  ["exori mas nia"] = true,
  ["exori gran nia"] = true,
  ["exori gran mas nia"] =  true,
  ["exori infir nia"] = true,
  ["exori nia"] = true,
}

local function monkSpellKey(text)
  return trimText(text):lower()
end

local function isMonkHarmonyVocation()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  local voc = tonumber(p:getVocation()) or 0
  return voc == 5 or voc == 10
end

local function monkHarmonyGet()
  return math.max(0, math.min(MONK_HARMONY_MAX, tonumber(attackBotStorage.attackBotMonkHarmony.points) or 0))
end

local function monkHarmonySet(v)
  attackBotStorage.attackBotMonkHarmony.points = math.max(0, math.min(MONK_HARMONY_MAX, tonumber(v) or 0))
  saveAttackBotStorage()
end

local function monkHarmonyAdd(v)
  monkHarmonySet(monkHarmonyGet() + (tonumber(v) or 1))
end

local function monkHarmonyReset()
  monkHarmonySet(0)
end

local function isHarmonyBuilderSpell(spell)
  return MONK_HARMONY_BUILDERS[monkSpellKey(spell)] == true
end

local function isHarmonyFinisherSpell(spell)
  return MONK_HARMONY_FINISHERS[monkSpellKey(spell)] == true
end

local function hasConfiguredHarmonyFinisher()
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyFinisherSpell(attack.spell or "") then
      return true
    end
  end
  return false
end

local function monkHarmonyFlowActive()
  return isMonkHarmonyVocation() and hasConfiguredHarmonyFinisher()
end

local function resetComboCooldowns()
  for _, attack in ipairs(cfg.attacks or {}) do
    attack.nextCast = 0
  end
  combatGlobalUntil = 0
  lastRuneGlobal = 0
  monkHarmonyReset()
end

local function iAmPK()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  local skull = p.getSkull and p:getSkull() or 0
  return PKSkulls[skull] == true
end

local function iAmDead()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  if p.getHealthPercent then
    return (p:getHealthPercent() or 100) <= 0
  end
  return false
end

local function normalizeUnsafePKState()
  cfg.main.disabledByUnsafePK = type(cfg.main.disabledByUnsafePK) == "table" and cfg.main.disabledByUnsafePK or {}
  cfg.main.reenableUnsafeAt = tonumber(cfg.main.reenableUnsafeAt) or 0

  -- compatibilidade/limpeza de versoes antigas
  if type(cfg.main.disabledByFrag) == "table" then
    for _, idx in ipairs(cfg.main.disabledByFrag) do
      local attack = cfg.attacks and cfg.attacks[idx]
      if attack then
        attack.disabledByUnsafePK = true
      end
    end
    cfg.main.disabledByFrag = nil
  end
end

local function hasUnsafeDisabledByPK()
  normalizeUnsafePKState()

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack and attack.disabledByUnsafePK == true then
      return true
    end
  end

  return false
end

local function disableUnsafeAttacksByPK()
  normalizeUnsafePKState()

  local did = false

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack and attack.enabled ~= false and attack.safe ~= true then
      attack.enabled = false
      attack.disabledByUnsafePK = true
      did = true
    end
  end

  cfg.main.reenableUnsafeAt = 0

  if did then
    rebuildAttackList()
    saveAttackBotStorage()
    warn("[AttackBot] PK detectado - unsafe desligadas.")
  end
end

local function restoreUnsafeAttacksByPK()
  normalizeUnsafePKState()

  local did = false

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack and attack.disabledByUnsafePK == true then
      attack.enabled = true
      attack.disabledByUnsafePK = nil
      did = true
    end
  end

  cfg.main.disabledByUnsafePK = {}
  cfg.main.reenableUnsafeAt = 0

  if did then
    rebuildAttackList()
    warn("[AttackBot] Unsafe religadas.")
  end

  saveAttackBotStorage()
end

local function countAttackMonstersAround(centerPos, maxDist)
  if not centerPos then return 0 end

  local count = 0
  local specs = {}

  if g_map and g_map.getSpectators then
    local ok, res = pcall(function() return g_map.getSpectators(centerPos, false) end)
    if ok and type(res) == "table" then specs = res end
  elseif type(getSpectators) == "function" then
    local ok, res = pcall(function() return getSpectators(false) end)
    if ok and type(res) == "table" then specs = res end
  end

  for _, s in ipairs(specs) do
    if s and s.isMonster and s:isMonster() then
      local sPos = s:getPosition()
      if sPos and sPos.z == centerPos.z then
        local dist = math.max(math.abs(centerPos.x - sPos.x), math.abs(centerPos.y - sPos.y))
        if dist <= (maxDist or 7) then
          count = count + 1
        end
      end
    end
  end

  return count
end

local function isSafeAllowedForCurrentTarget(isSafe, targetIsPlayer)
  if targetIsPlayer then return true end
  if not hasProtectedPlayerForUnsafe() then return true end
  return isSafe == true
end

local function attackReady(attack)
  return now >= (tonumber(attack.nextCast) or 0)
end

local function canCastSpellAttack(attack, dist, targetIsPlayer, pPos)
  local maxDist = tonumber(attack.distance) or 8
  local manaOk = mana() >= (tonumber(attack.mana) or 0)
  local mobsOk = true
  local needMobs = tonumber(attack.mobs) or 0

  if (not targetIsPlayer) and needMobs > 0 then
    mobsOk = countAttackMonstersAround(pPos, 7) >= needMobs
  end

  return dist <= maxDist and manaOk and mobsOk and isSafeAllowedForCurrentTarget(attack.safe, targetIsPlayer)
end

local function canUseRuneAttack(attack, dist, targetIsPlayer, pPos)
  local runeId = tonumber(attack.id) or 0

  if isRuneClientCooldownActive(runeId) then
    return false
  end

  local maxDist = tonumber(attack.distance) or 8
  local mobsOk = true
  local needMobs = tonumber(attack.mobs) or 0

  if (not targetIsPlayer) and needMobs > 0 then
    mobsOk = countAttackMonstersAround(pPos, 7) >= needMobs
  end

  return dist <= maxDist and mobsOk and isSafeAllowedForCurrentTarget(attack.safe, targetIsPlayer)
end

local function isUnsafeNowForAttack(targetIsPlayer)
  if targetIsPlayer then return false end

  if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
    return LNS_HAS_UNSAFE_CONDITION() == true
  end

  return hasProtectedPlayerForUnsafe() == true
end

local function tryUseAttack(attack, dist, target, targetIsPlayer, pPos, unsafeNow)
  if not attack or not attack.enabled or not attackReady(attack) then return false end

  --==================================================
  -- MONK HARMONY LOCK
  -- Builder só usa com harmonia abaixo de 5/5.
  -- Finisher só usa com harmonia cheia 5/5.
  --==================================================
  if attack.type == "spell" and monkHarmonyFlowActive() then
    local spellName = attack.spell or ""
    local harmony = monkHarmonyGet()

    if isHarmonyFinisherSpell(spellName) and harmony < MONK_HARMONY_MAX then
      return false
    end

    if isHarmonyBuilderSpell(spellName) and harmony >= MONK_HARMONY_MAX then
      return false
    end
  end

  -- se estiver unsafe, ignora imediatamente spell/rune unsafe
  if unsafeNow and attack.safe ~= true then
    return false
  end

  local maxDist = tonumber(attack.distance) or 8
  if dist > maxDist then return false end

  if attack.type == "spell" then
    local manaOk = mana() >= (tonumber(attack.mana) or 0)
    if not manaOk then return false end

    if pausandoCombo and pausandoCombo >= now then return false end

    local needMobs = tonumber(attack.mobs) or 0
    if not targetIsPlayer and needMobs > 0 then
      if countAttackMonstersAround(pPos, 7) < needMobs then
        return false
      end
    end

    local words = trimText(attack.spell)
    if words == "" then return false end

    say(words)
    combatGlobalUntil = now + WORLD_COMBAT_LOCK
    return true
  end

  if attack.type == "rune" then
    local runeId = tonumber(attack.id) or 0

    if pauseForMw and pauseForMw > now then return false end
    if pausandoCombo and pausandoCombo >= now then return false end
    if runeId <= 0 then return false end
    if isRuneClientCooldownActive(runeId) then return false end

    local needMobs = tonumber(attack.mobs) or 0
    if not targetIsPlayer and needMobs > 0 then
      if countAttackMonstersAround(pPos, 7) < needMobs then
        return false
      end
    end

    local ok = pcall(function()
      useWith(runeId, target)
    end)

    if ok then
      combatGlobalUntil = now + 50
      return true
    end
  end

  return false
end

local function tryUseMonkBuilder(dist, target, targetIsPlayer, pPos)
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyBuilderSpell(attack.spell or "") then
      if tryUseAttack(attack, dist, target, targetIsPlayer, pPos) then
        return true
      end
    end
  end
  return false
end

local function tryUseMonkFinisher(dist, target, targetIsPlayer, pPos)
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyFinisherSpell(attack.spell or "") then
      if tryUseAttack(attack, dist, target, targetIsPlayer, pPos) then
        return true
      end
    end
  end
  return false
end

local monkHarmonyIcon = addIcon("lnsAttackBotMonkHarmony", {
  text = "Harmony",
  switchable = false,
  moveable = true
}, function() end)
monkHarmonyIcon:setSize({height = 52, width = 74})
monkHarmonyIcon.text:setFont("verdana-11px-rounded")
macro(100, function()
  if not isMonkHarmonyVocation() then
    monkHarmonyIcon:hide()
    return
  end

  monkHarmonyIcon:show()
  local points = monkHarmonyGet()

  if points >= MONK_HARMONY_MAX then
    monkHarmonyIcon.text:setColoredText({tostring(points) .. "/5", "green"})
  else
    monkHarmonyIcon.text:setColoredText({tostring(points) .. "/5", "orange"})
  end
end)

resetComboCooldowns()

if g_game and connect then
  connect(g_game, {
    onGameStart = function()
      resetComboCooldowns()
    end
  })
end

local cdSpell = { active = false, spell = "", lastTime = 0 }
local function stopSpellCalc()
  cdSpell.active = false
  cdSpell.spell = ""
  cdSpell.lastTime = 0
end

macro(100, function()
  if not cdSpell.active then return end
  if cdSpell.spell == "" then stopSpellCalc(); return end
  say(cdSpell.spell)
end)

onTalk(function(name, level, mode, text, channelId, pos)
  local player = g_game.getLocalPlayer()
  if not player then return end

  if cdSpell.active and name == player:getName() then
    local msg = trimText(text):lower()
    local expected = trimText(cdSpell.spell):lower()
    if expected ~= "" and msg == expected then
      local t = nowMs()
      if cdSpell.lastTime > 0 then
        local cd = math.floor(t - cdSpell.lastTime)
        local v = clamp(cd, 0, 60000)
        if spellCooldown and spellCooldown.setValue then
          spellCooldown:setValue(v)
          if spellCooldown.onValueChange then
            pcall(function() spellCooldown.onValueChange(spellCooldown, v) end)
          end
        end
        updateSpellPanelLabels()
        warn(string.format("[CD-SPELL] %d ms (%.1fs)", v, v / 1000))
        stopSpellCalc()
      else
        cdSpell.lastTime = t
      end
    end
  end

  if name ~= player:getName() then return end

  local spoken = trimText(text):lower()

  if isMonkHarmonyVocation() then
    if MONK_HARMONY_BUILDERS[spoken] then
      monkHarmonyAdd(1)
    elseif MONK_HARMONY_FINISHERS[spoken] then
      monkHarmonyReset()
    end
  end

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.type == "spell" and attack.enabled then
      local spellWords = trimText(attack.spell):lower()
      if spellWords ~= "" and spellWords == spoken then
        attack.nextCast = now + (tonumber(attack.cooldown) or WORLD_COMBAT_LOCK)
        combatGlobalUntil = now + WORLD_COMBAT_LOCK
        return
      end
    end
  end
end)

local function getSelectedSpellNameForCooldown()
  local spell = ""

  if selectType and selectType:getCurrentOption() then
    local currentType = selectType:getCurrentOption().text or ""

    if currentType == "Editable" then
      spell = trimText(spellMagia and spellMagia:getText() or "")
    else
      if magiaSelect and magiaSelect:getCurrentOption() then
        spell = trimText(magiaSelect:getCurrentOption().text or "")
      end
    end
  else
    spell = trimText(spellMagia and spellMagia:getText() or "")
  end

  if spell == "Nenhuma magia cadastrada" then
    spell = ""
  end

  return spell
end

if spellCalcCooldownBtn then
  spellCalcCooldownBtn.onClick = function()
    local spell = getSelectedSpellNameForCooldown()

    if spell == "" then
      warn("Digite ou selecione uma spell.")
      return
    end

    cdSpell.active = true
    cdSpell.spell = spell
    cdSpell.lastTime = 0

    warn("[CD-SPELL] Iniciado para: " .. spell .. ". Fale/caste a spell 2x para calcular.")
  end
end

macro(200, function()
  normalizeUnsafePKState()

  -- usa o botão original "Pause Spells Unsafe" do painel principal
  if cfg.main.manterDist ~= true then
    if hasUnsafeDisabledByPK() then
      restoreUnsafeAttacksByPK()
    else
      cfg.main.reenableUnsafeAt = 0
    end
    return
  end

  local pk = iAmPK()

  -- enquanto estiver PK, qualquer spell/rune unsafe que estiver ligada sera desligada.
  -- A contagem de reativacao NAO comeca enquanto o PK ainda estiver ativo.
  if pk then
    disableUnsafeAttacksByPK()
    return
  end

  -- Se morreu sem estar PK, libera as unsafe marcadas pela protecao.
  if hasUnsafeDisabledByPK() and iAmDead() then
    restoreUnsafeAttacksByPK()
    return
  end

  -- Perdeu o PK: agora sim inicia/continua o tempo escolhido em "Reactive in".
  if hasUnsafeDisabledByPK() then
    local mins = tonumber(cfg.main.minutosVoltarUnsafe) or 5
    if mins < 1 then mins = 1 end

    if cfg.main.reenableUnsafeAt <= 0 then
      cfg.main.reenableUnsafeAt = nowMs() + (mins * 60 * 1000)
      saveAttackBotStorage()
      warn("[AttackBot] PK removido - unsafe voltam em " .. mins .. " min.")
      return
    end

    if nowMs() >= cfg.main.reenableUnsafeAt then
      restoreUnsafeAttacksByPK()
      return
    end
  else
    cfg.main.reenableUnsafeAt = 0
  end
end)

-- =========================
-- EXIT ON FRAGS
-- =========================
cfg.main.fragsAtual = tonumber(cfg.main.fragsAtual) or 0

onTextMessage(function(mode, text)
  if not cfg or not cfg.main then return end
  if cfg.main.deslogarFrags ~= true then return end
  if type(text) ~= "string" then return end
  if not text:find("Warning! The murder of") then return end

  cfg.main.fragsAtual = tonumber(cfg.main.fragsAtual) or 0
  cfg.main.qtdeFrags = tonumber(cfg.main.qtdeFrags) or 1

  cfg.main.fragsAtual = cfg.main.fragsAtual + 1
  saveAttackBotStorage()

  if cfg.main.fragsAtual >= cfg.main.qtdeFrags then
    cfg.main.fragsAtual = 0
    saveAttackBotStorage()

    if modules and modules.game_interface and modules.game_interface.forceExit then
      modules.game_interface.forceExit()
    elseif g_game and g_game.safeLogout then
      g_game.safeLogout()
    end
  end
end)

macro(50, function()
  if not attackBotStorage[switchCombo] or attackBotStorage[switchCombo].enabled ~= true then return end
  if pausandoCombo and pausandoCombo >= now then return end

  local player = g_game.getLocalPlayer()
  local target = g_game.getAttackingCreature()

  if not player or not target then return end
  if player:isNpc() then return end

  local pPos = player:getPosition()
  local tPos = target:getPosition()

  if not pPos or not tPos or pPos.z ~= tPos.z then
    return
  end

  local dist = math.max(
    math.abs(pPos.x - tPos.x),
    math.abs(pPos.y - tPos.y)
  )

  local targetIsPlayer = (target.isPlayer and target:isPlayer()) or false

  local unsafeNow = false

  if not targetIsPlayer then
    if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
      unsafeNow = LNS_HAS_UNSAFE_CONDITION() == true
    else
      unsafeNow = hasProtectedPlayerForUnsafe() == true
    end
  end

  local groupCooldownActive = isAttackGroupCooldownActive()

  if groupCooldownActive then
    attackGroupReadyAt = now + EXTRA_GROUP_DELAY
    return
  end

  if now < attackGroupReadyAt then
    return
  end

  if combatGlobalUntil > now then
    return
  end

  -- monk system
  if monkHarmonyFlowActive() and not unsafeNow then
    if monkHarmonyGet() >= MONK_HARMONY_MAX then
      if tryUseMonkFinisher(dist, target, targetIsPlayer, pPos) then
        return
      end
    else
      if tryUseMonkBuilder(dist, target, targetIsPlayer, pPos) then
        return
      end
    end
  end

  --==================================================
  -- UNSAFE = somente magias SAFE
  --==================================================
  if unsafeNow then
    for _, attack in ipairs(cfg.attacks or {}) do
      if attack
      and attack.enabled
      and attack.safe == true then

        if tryUseAttack(
          attack,
          dist,
          target,
          targetIsPlayer,
          pPos,
          true
        ) then
          return
        end
      end
    end

    return
  end

  --==================================================
  -- SAFE = fluxo normal
  --==================================================
  for _, attack in ipairs(cfg.attacks or {}) do
    if tryUseAttack(
      attack,
      dist,
      target,
      targetIsPlayer,
      pPos,
      false
    ) then
      return
    end
  end
end)
end)

lnsRunBlock("HEALING", function()
  storage = storage or {}
storage.LNSHealingGlobal = type(storage.LNSHealingGlobal) == "table" and storage.LNSHealingGlobal or {}

local healingStorage = storage.LNSHealingGlobal

local function saveHealingGlobal()
  storage.LNSHealingGlobal = healingStorage
end

local switchHealing = "healingButton"

healingStorage[switchHealing] = healingStorage[switchHealing] or { enabled = false }

healingButton = setupUI([[
Panel
  height: 19
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Healing
    color: white
    height: 18

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

healingButton:setId(switchHealing)
healingButton.title:setOn(healingStorage[switchHealing].enabled == true)

healingButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  healingStorage[switchHealing].enabled = newState
  saveHealingGlobal()
end

local PROFILE = "Default"
local MAX_ROWS = 3

healingStorage.healingPanel = healingStorage.healingPanel or {}
healingStorage.healingPanel[PROFILE] = healingStorage.healingPanel[PROFILE] or {
  spells = {},
  hp = {},
  mp = {},
  counts = {
    spells = 0,
    hp = 0,
    mp = 0
  }
}

local db = healingStorage.healingPanel[PROFILE]
db.spells = db.spells or {}
db.hp = db.hp or {}
db.mp = db.mp or {}
db.counts = db.counts or {}

if db.counts.spells == nil then db.counts.spells = math.min(#db.spells, MAX_ROWS) end
if db.counts.hp == nil then db.counts.hp = math.min(#db.hp, MAX_ROWS) end
if db.counts.mp == nil then db.counts.mp = math.min(#db.mp, MAX_ROWS) end

local function clampCount(n)
  n = tonumber(n) or 0
  if n < 0 then return 0 end
  if n > MAX_ROWS then return MAX_ROWS end
  return n
end

local function realCount(kind)
  db.counts = db.counts or {}
  db.counts[kind] = clampCount(db.counts[kind])
  return db.counts[kind]
end

local function forceSaveKind(kind, list)
  list = list or {}

  local clean = {}
  for i = 1, math.min(#list, MAX_ROWS) do
    clean[#clean + 1] = list[i]
  end

  db[kind] = clean
  db.counts[kind] = #clean

  healingStorage.healingPanel[PROFILE][kind] = clean
  healingStorage.healingPanel[PROFILE].counts = db.counts

  saveHealingGlobal()
end

local panelHealing = setupUI([[
MainWindow
  size: 550 337
  text: Panel Healing
  margin-top: -50

  FlatPanel
    id: flatP
    anchors.fill: parent
    margin: -8
    margin-top: -5
    margin-bottom: 20

    Panel
      id: col1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      width: 171
      margin: 6

      Label
        text: Spells
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list1
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls1.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add1
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count1
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem1
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

    Panel
      id: col2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: col1.right
      width: 171
      margin-top: 6
      margin-bottom: 6
      margin-left: 6

      Label
        text: HP
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list2
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls2.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add2
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count2
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem2
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

    Panel
      id: col3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: col2.right
      width: 172
      margin: 6

      Label
        text: MP
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list3
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls3.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls3
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add3
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count3
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem3
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

  Button
    id: closePanel
    anchors.left: flatP.left
    anchors.right: flatP.right
    anchors.top: flatP.bottom
    margin-left: -1
    margin-top: 5
    text: Close
]], g_ui.getRootWidget())

panelHealing:hide()

if modules._G.g_app.isMobile() then
  panelHealing:setSize("550 357")
end

panelHealing.closePanel.onClick = function()
  panelHealing:hide()
end

healingButton.settings.onClick = function()
  panelHealing:show()
  panelHealing:raise()
  panelHealing:focus()
end

g_ui.loadUIFromString([[
SpellRow < Panel
  id: root
  height: 70
  focusable: true
  background-color: #4a4a4a
  border: 1 #2a2a2a
  opacity: 1.00
  margin-top: 2

  $hover:
    background-color: #555555
    border: 1 #6a6a6a

  $focus:
    background-color: #5d5d5d
    border: 1 #808080

  BotTextEdit
    id: spellText
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    font: verdana-11px-rounded
    margin-left: 4
    margin-right: 4
    margin-top: 3
    tooltip: Insert Spell Here

  HorizontalScrollBar
    id: hpScroll
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 0
    maximum: 100
    step: 1
    value: 80

  BotSwitch
    id: activeSwitch
    anchors.right: parent.right
    anchors.top: hpScroll.bottom
    margin-right: 5
    margin-top: 4
    size: 35 25
    text: OFF
    font: verdana-9px

  Label
    id: hpText
    anchors.left: hpScroll.left
    anchors.top: hpScroll.bottom
    margin-top: 2
    color: white
    text: HP <= 80%
    text-auto-resize: true

  Label
    id: manaText
    anchors.left: hpScroll.left
    anchors.top: hpText.bottom
    margin-top: 2
    color: white
    text: Mana: 0
    text-auto-resize: true
]])

g_ui.loadUIFromString([[
PotionRow < Panel
  id: root
  height: 70
  focusable: true
  background-color: #4a4a4a
  border: 1 #2a2a2a
  opacity: 1.00
  margin-top: 2

  $hover:
    background-color: #5d5d5d
    border: 1 #808080

  BotItem
    id: image
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 4
    margin-top: 25
    size: 37 37

  HorizontalScrollBar
    id: Scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-left: 4
    margin-right: 4
    margin-top: 3
    minimum: 0
    maximum: 100
    step: 1
    value: 80

  BotSwitch
    id: activeBox
    anchors.right: parent.right
    anchors.verticalCenter: image.verticalCenter
    margin-right: 5
    margin-top: 4
    size: 35 25
    text: OFF
    font: verdana-9px

  Label
    id: hpText
    anchors.left: image.right
    anchors.verticalCenter: image.verticalCenter
    margin-left: 10
    margin-top: -1
    color: white
    font: verdana-11px-rounded
    text: HP <= 80%
]])

local selectedRows = {
  spells = nil,
  hp = nil,
  mp = nil
}

local SPELL_MANA_COST = {
  ["exura"] = 20,
  ["exura ico"] = 40,
  ["exura gran"] = 70,
  ["exura vita"] = 160,
  ["exura gran ico"] = 200,
  ["exura med ico"] = 90,
  ["exura infir ico"] = 160,
  ["exura san"] = 160,
  ["exura gran san"] = 210,
  ["utura"] = 60,
  ["utura gran"] = 100,
  ["utura mas sio"] = 140,
  ["exura sio"] = 140,
  ["exura gran sio"] = 200,
  ["exura mas res"] = 160,
  ["exura gran mas res"] = 250
}

local function trimText(text)
  return tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function resolveSpellMana(spellName)
  spellName = trimText(spellName):lower()
  if spellName == "" then return 0 end
  return SPELL_MANA_COST[spellName] or 0
end

local function getList(kind)
  if kind == "spells" then return panelHealing.flatP.col1.list1 end
  if kind == "hp" then return panelHealing.flatP.col2.list2 end
  return panelHealing.flatP.col3.list3
end

local function getCounter(kind)
  if kind == "spells" then return panelHealing.flatP.col1.controls1.count1 end
  if kind == "hp" then return panelHealing.flatP.col2.controls2.count2 end
  return panelHealing.flatP.col3.controls3.count3
end

local function refreshCounter(kind)
  getCounter(kind):setText(tostring(realCount(kind)) .. "/" .. MAX_ROWS)
end

local function refreshAllCounters()
  refreshCounter("spells")
  refreshCounter("hp")
  refreshCounter("mp")
end

local function setRowSelected(kind, row)
  selectedRows[kind] = row

  local list = getList(kind)
  for _, child in ipairs(list:getChildren()) do
    if child.setFocused then
      child:setFocused(child == row)
    end
  end
end

local function clearRowSelected(kind)
  selectedRows[kind] = nil
end

local function makeSpellEntry(data)
  data = data or {}

  local spell = tostring(data.spell or "")
  local hpValue = tonumber(data.hp) or 80
  local manaValue = tonumber(data.mana)

  if manaValue == nil then
    manaValue = resolveSpellMana(spell)
  end

  return {
    spell = spell,
    hp = hpValue,
    mana = manaValue or 0,
    enabled = data.enabled == true
  }
end

local function makePotionEntry(data, defaultItem)
  data = data or {}

  return {
    itemId = tonumber(data.itemId) or defaultItem,
    hp = tonumber(data.hp) or 80,
    enabled = data.enabled == true
  }
end

local function formatSpellName(text)
  text = trimText(text)
  text = text:gsub("%s+", " ")

  if text == "" then return "" end

  local words = {}
  for word in text:gmatch("%S+") do
    local first = word:sub(1, 1):upper()
    local rest = word:sub(2):lower()
    table.insert(words, first .. rest)
  end

  return table.concat(words, " ")
end

local function bindSpellRow(row, entry, kind)
  row._entry = entry

  row.spellText:setText(entry.spell or "")
  row.hpScroll:setValue(entry.hp or 80)
  row.hpText:setText("HP <= " .. tostring(entry.hp or 80) .. "%")
  row.manaText:setText("Mana: " .. tostring(entry.mana or 0))
  row.activeSwitch:setOn(entry.enabled == true)
  row.activeSwitch:setText(entry.enabled and "ON" or "OFF")

  row.onClick = function(widget)
    setRowSelected(kind, widget)
  end

  row.spellText.onTextChange = function(widget, text)
    local formatted = formatSpellName(text)

    if text ~= formatted then
      widget:setText(formatted)
      return
    end

    entry.spell = formatted
    entry.mana = resolveSpellMana(formatted)
    row.manaText:setText("Mana: " .. tostring(entry.mana))
    saveHealingGlobal()
  end

  row.hpScroll.onValueChange = function(widget, value)
    entry.hp = tonumber(value) or 80
    row.hpText:setText("HP <= " .. tostring(entry.hp) .. "%")
    saveHealingGlobal()
  end

  row.activeSwitch.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    widget:setText(state and "ON" or "OFF")
    entry.enabled = state
    saveHealingGlobal()
  end
end

local function bindPotionRow(row, entry, kind)
  row._entry = entry

  row.Scroll:setValue(entry.hp or 80)

  if kind == "mp" then
    row.hpText:setText("MP <= " .. tostring(entry.hp or 80) .. "%")
  else
    row.hpText:setText("HP <= " .. tostring(entry.hp or 80) .. "%")
  end

  row.activeBox:setOn(entry.enabled == true)
  row.activeBox:setText(entry.enabled and "ON" or "OFF")

  if row.image and row.image.setItemId then
    row.image:setItemId(entry.itemId or 0)
  end

  row.onClick = function(widget)
    setRowSelected(kind, widget)
  end

  row.Scroll.onValueChange = function(widget, value)
    entry.hp = tonumber(value) or 80

    if kind == "mp" then
      row.hpText:setText("MP <= " .. tostring(entry.hp) .. "%")
    else
      row.hpText:setText("HP <= " .. tostring(entry.hp) .. "%")
    end

    saveHealingGlobal()
  end

  row.activeBox.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    widget:setText(state and "ON" or "OFF")
    entry.enabled = state
    saveHealingGlobal()
  end

  if row.image then
    row.image.onItemChange = function(widget)
      local id = 0

      if widget.getItemId then
        id = tonumber(widget:getItemId()) or 0
      elseif widget.getItem and widget:getItem() and widget:getItem().getId then
        id = tonumber(widget:getItem():getId()) or 0
      end

      if id > 0 then
        entry.itemId = id
        saveHealingGlobal()
      end
    end

    row.image.onItemIdChange = function(widget, itemId)
      itemId = tonumber(itemId) or 0

      if itemId > 0 then
        entry.itemId = itemId
        saveHealingGlobal()
      end
    end
  end
end

local function createSpellRow(kind, entry)
  local row = g_ui.createWidget("SpellRow", getList(kind))
  bindSpellRow(row, entry, kind)
  return row
end

local function createPotionRow(kind, entry)
  local row = g_ui.createWidget("PotionRow", getList(kind))
  bindPotionRow(row, entry, kind)
  return row
end

local function clearList(kind)
  local list = getList(kind)

  for _, child in ipairs(list:getChildren()) do
    child:destroy()
  end

  clearRowSelected(kind)
end

local function normalizeInitialStorage()
  local kinds = {"spells", "hp", "mp"}

  for _, kind in ipairs(kinds) do
    local count = realCount(kind)
    local clean = {}

    for i = 1, count do
      local row = db[kind] and db[kind][i]

      if row then
        if kind == "spells" then
          clean[#clean + 1] = makeSpellEntry(row)
        elseif kind == "hp" then
          clean[#clean + 1] = makePotionEntry(row, 266)
        else
          clean[#clean + 1] = makePotionEntry(row, 268)
        end
      end
    end

    forceSaveKind(kind, clean)
  end
end

local function loadRows()
  clearList("spells")
  clearList("hp")
  clearList("mp")

  for i = 1, realCount("spells") do
    local entry = db.spells[i]
    if entry then
      db.spells[i] = makeSpellEntry(entry)
      createSpellRow("spells", db.spells[i])
    end
  end

  for i = 1, realCount("hp") do
    local entry = db.hp[i]
    if entry then
      db.hp[i] = makePotionEntry(entry, 266)
      createPotionRow("hp", db.hp[i])
    end
  end

  for i = 1, realCount("mp") do
    local entry = db.mp[i]
    if entry then
      db.mp[i] = makePotionEntry(entry, 268)
      createPotionRow("mp", db.mp[i])
    end
  end

  refreshAllCounters()
end

local function addRow(kind)
  local count = realCount(kind)
  if count >= MAX_ROWS then return end

  local clean = {}

  for i = 1, count do
    if db[kind][i] then
      clean[#clean + 1] = db[kind][i]
    end
  end

  local entry

  if kind == "spells" then
    entry = makeSpellEntry()
  elseif kind == "hp" then
    entry = makePotionEntry(nil, 266)
  else
    entry = makePotionEntry(nil, 268)
  end

  clean[#clean + 1] = entry

  forceSaveKind(kind, clean)
  loadRows()
end

local function removeRow(kind)
  local count = realCount(kind)
  if count <= 0 then return end

  local list = getList(kind)
  local children = list:getChildren()
  if #children == 0 then return end

  local row = selectedRows[kind] or children[#children]
  local removeIndex = nil

  for i, child in ipairs(children) do
    if child == row then
      removeIndex = i
      break
    end
  end

  if not removeIndex then return end

  local clean = {}

  for i = 1, count do
    if i ~= removeIndex and db[kind][i] then
      clean[#clean + 1] = db[kind][i]
    end
  end

  forceSaveKind(kind, clean)
  loadRows()
end

panelHealing.flatP.col1.controls1.add1.onClick = function()
  addRow("spells")
end

panelHealing.flatP.col1.controls1.rem1.onClick = function()
  removeRow("spells")
end

panelHealing.flatP.col2.controls2.add2.onClick = function()
  addRow("hp")
end

panelHealing.flatP.col2.controls2.rem2.onClick = function()
  removeRow("hp")
end

panelHealing.flatP.col3.controls3.add3.onClick = function()
  removeRow("mp")
end

panelHealing.flatP.col3.controls3.add3.onClick = function()
  addRow("mp")
end

panelHealing.flatP.col3.controls3.rem3.onClick = function()
  removeRow("mp")
end

normalizeInitialStorage()
loadRows()

local healProfile = PROFILE
local healSpellCooldown = 900
local healPotionCooldown = 250
local lastHealSpellCast = 0
local lastHealPotionUse = 0
local lastHealMpPotionUse = 0
local spellLock = false

local function nowMs()
  if g_clock and g_clock.millis then
    return g_clock.millis()
  end
  return now or 0
end

local function getHealDB()
  healingStorage.healingPanel = healingStorage.healingPanel or {}
  healingStorage.healingPanel[healProfile] = healingStorage.healingPanel[healProfile] or {
    spells = {},
    hp = {},
    mp = {},
    counts = {
      spells = 0,
      hp = 0,
      mp = 0
    }
  }

  healingStorage.healingPanel[healProfile].spells = healingStorage.healingPanel[healProfile].spells or {}
  healingStorage.healingPanel[healProfile].hp = healingStorage.healingPanel[healProfile].hp or {}
  healingStorage.healingPanel[healProfile].mp = healingStorage.healingPanel[healProfile].mp or {}
  healingStorage.healingPanel[healProfile].counts = healingStorage.healingPanel[healProfile].counts or {}

  return healingStorage.healingPanel[healProfile]
end

local function getHealCount(hdb, kind)
  hdb.counts = hdb.counts or {}
  local n = tonumber(hdb.counts[kind]) or 0

  if n < 0 then return 0 end
  if n > MAX_ROWS then return MAX_ROWS end

  return n
end

local function normalizeSpellRow(row)
  if not row then return nil end
  if row.enabled ~= true then return nil end

  local spell = tostring(row.spell or row.words or "")
  local hpValue = tonumber(row.hp) or 0
  local manaValue = tonumber(row.mana) or 0

  if spell == "" then return nil end

  return {
    spell = spell,
    hp = hpValue,
    mana = manaValue
  }
end

local function normalizePotionRow(row, mode)
  if not row then return nil end
  if row.enabled ~= true then return nil end

  local itemId = tonumber(row.itemId) or 0
  local threshold = tonumber(row.hp) or tonumber(row.mp) or 0

  if itemId <= 0 then return nil end

  return {
    itemId = itemId,
    threshold = threshold,
    mode = mode
  }
end

local function getBestHealSpell()
  local hdb = getHealDB()
  local currentHp = hppercent()
  local currentMana = mana()
  local candidates = {}
  local count = getHealCount(hdb, "spells")

  for i = 1, count do
    local row = normalizeSpellRow(hdb.spells[i])
    if row and currentHp <= row.hp then
      candidates[#candidates + 1] = row
    end
  end

  if #candidates == 0 then return nil end

  table.sort(candidates, function(a, b)
    if a.hp ~= b.hp then
      return a.hp < b.hp
    end
    return a.mana > b.mana
  end)

  for _, row in ipairs(candidates) do
    if g_game.getClientVersion() >= 960 and currentMana >= row.mana then
      return row
    elseif g_game.getClientVersion() < 960 then
      return row
    end
  end

  return nil
end

local function getBestHpPotion()
  local hdb = getHealDB()
  local currentHp = hppercent()
  local best = nil
  local count = getHealCount(hdb, "hp")

  for i = 1, count do
    local row = normalizePotionRow(hdb.hp[i], "hp")
    if row and currentHp <= row.threshold then
      if not best or row.threshold < best.threshold then
        best = row
      end
    end
  end

  return best
end

local function getBestMpPotion()
  local hdb = getHealDB()
  local currentMp = manapercent()
  local best = nil
  local count = getHealCount(hdb, "mp")

  for i = 1, count do
    local row = normalizePotionRow(hdb.mp[i], "mp")
    if row and currentMp <= row.threshold then
      if not best or row.threshold < best.threshold then
        best = row
      end
    end
  end

  return best
end

onTalk(function(name, level, mode, text, channelId, pos)
  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer or name ~= localPlayer:getName() then return end

  local hdb = getHealDB()
  local msg = tostring(text or ""):lower()
  local count = getHealCount(hdb, "spells")

  for i = 1, count do
    local row = normalizeSpellRow(hdb.spells[i])
    if row then
      local words = row.spell:lower()

      if words ~= "" and msg:find(words, 1, true) then
        spellLock = true
        lastHealSpellCast = nowMs()

        schedule(healSpellCooldown, function()
          spellLock = false
        end)

        return
      end
    end
  end
end)

macro(100, function()
  if not healingStorage.healingButton or healingStorage.healingButton.enabled ~= true then return end
  if spellLock then return end

  local t = nowMs()
  if t - lastHealSpellCast < healSpellCooldown then return end

  local best = getBestHealSpell()
  if not best then return end

  spellLock = true
  lastHealSpellCast = t
  pauseFriendHeal = now + 500
  say(best.spell)

  schedule(healSpellCooldown, function()
    spellLock = false
  end)
end)

macro(100, function()
  if not healingStorage.healingButton or healingStorage.healingButton.enabled ~= true then return end
  if pauseForMw and pauseForMw > now then return end

  local t = nowMs()
  if t - lastHealPotionUse < healPotionCooldown then return end

  local best = getBestHpPotion()
  if not best then return end

  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer then return end

  lastHealPotionUse = t
  useWith(best.itemId, localPlayer)
end)

macro(100, function()
  if not healingStorage.healingButton or healingStorage.healingButton.enabled ~= true then return end
  if pauseForMw and pauseForMw > now then return end

  local t = nowMs()
  if t - lastHealMpPotionUse < healPotionCooldown then return end

  local best = getBestMpPotion()
  if not best then return end

  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer then return end

  lastHealMpPotionUse = t
  useWith(best.itemId, localPlayer)
end)

saveHealingGlobal()

-- Prioridade absoluta para Healing próprio
macro(50, function()
  if not healingStorage.healingButton or healingStorage.healingButton.enabled ~= true then return end

  local critical = false

  local hdb = getHealDB()

  for i = 1, getHealCount(hdb, "spells") do
    local row = normalizeSpellRow(hdb.spells[i])
    if row and hppercent() <= row.hp then
      critical = true
      break
    end
  end

  for i = 1, getHealCount(hdb, "hp") do
    local row = normalizePotionRow(hdb.hp[i], "hp")
    if row and hppercent() <= row.threshold then
      critical = true
      break
    end
  end

  if critical then
    pauseFriendHeal = now + 700
  end
end)
end)

lnsRunBlock("CONDITIONS", function()
  storage = storage or {}
storage.LNSConditionsGlobal = storage.LNSConditionsGlobal or {}

local conditionsStorage = storage.LNSConditionsGlobal

local function saveConditionsGlobal()
  storage.LNSConditionsGlobal = conditionsStorage
end

local function saveConditionsChar()
  saveConditionsGlobal()
end

local switchConditions = "conditionsButton"
local panelName = "conditionsInterface"

conditionsStorage[switchConditions] = conditionsStorage[switchConditions] or { enabled = false }
conditionsStorage[panelName] = conditionsStorage[panelName] or {
  switches = {},
  combos = {},
  texts = {}
}

if conditionsStorage[panelName].switches == nil and type(conditionsStorage[panelName].checks) == "table" then
  conditionsStorage[panelName].switches = conditionsStorage[panelName].checks
  conditionsStorage[panelName].checks = nil
end

conditionsStorage[panelName].switches = conditionsStorage[panelName].switches or {}
conditionsStorage[panelName].combos   = conditionsStorage[panelName].combos or {}
conditionsStorage[panelName].texts    = conditionsStorage[panelName].texts or {}

if storage[panelName] and not conditionsStorage[panelName .. "_migrated"] then
  local old = storage[panelName]
  if type(old.switches) == "table" then
    for k, v in pairs(old.switches) do
      if conditionsStorage[panelName].switches[k] == nil then
        conditionsStorage[panelName].switches[k] = v
      end
    end
  end
  if type(old.combos) == "table" then
    for k, v in pairs(old.combos) do
      if conditionsStorage[panelName].combos[k] == nil then
        conditionsStorage[panelName].combos[k] = v
      end
    end
  end
  if type(old.texts) == "table" then
    for k, v in pairs(old.texts) do
      if conditionsStorage[panelName].texts[k] == nil then
        conditionsStorage[panelName].texts[k] = v
      end
    end
  end
  conditionsStorage[panelName .. "_migrated"] = true
  saveConditionsChar()
end

if storage[switchConditions] and conditionsStorage[switchConditions] and conditionsStorage[switchConditions].enabled == nil then
  conditionsStorage[switchConditions].enabled = storage[switchConditions].enabled == true
  saveConditionsChar()
end


conditionsButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Conditions
    color: white
    height: 18

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

conditionsButton:setId(switchConditions)
conditionsButton.title:setOn(conditionsStorage[switchConditions].enabled == true)

conditionsButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  conditionsStorage[switchConditions].enabled = newState
  saveConditionsChar()
end

conditionsInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 350 270
  text: Perfect Conditions
  margin-top: -50

  FlatPanel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 115
    margin-left: -4
    margin-right: -4

    BotSwitch
      id: spellHaste
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 8
      margin-left: 8
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblHaste
      anchors.left: spellHaste.right
      anchors.verticalCenter: spellHaste.verticalCenter
      margin-left: 5
      text: Haste
      font: verdana-11px-rounded
      text-auto-resize: true

    ComboBox
      id: comboHaste
      anchors.right: parent.right
      anchors.verticalCenter: spellHaste.verticalCenter
      margin-right: 8
      width: 150
      @onSetup: |
        self:addOption("")
        self:addOption("Utani Hur")
        self:addOption("Utani Gran Hur")
        self:addOption("Utani Tempo Hur")
        self:addOption("Utamo Tempo San")

    BotSwitch
      id: spellBuff
      anchors.top: spellHaste.bottom
      anchors.left: spellHaste.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblBuff
      anchors.left: spellBuff.right
      anchors.verticalCenter: spellBuff.verticalCenter
      margin-left: 5
      text: Buff
      font: verdana-11px-rounded
      text-auto-resize: true

    ComboBox
      id: comboBuff
      anchors.right: comboHaste.right
      anchors.verticalCenter: spellBuff.verticalCenter
      width: 150
      @onSetup: |
        self:addOption("")
        self:addOption("Utito Tempo")
        self:addOption("Utamo Tempo")
        self:addOption("Utito Tempo San")
        self:addOption("Utito Virtu")
        self:addOption("Utori Virtu")

    BotSwitch
      id: spellAntilyze
      anchors.top: spellBuff.bottom
      anchors.left: spellBuff.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblAntiLyze
      anchors.left: spellAntilyze.right
      anchors.verticalCenter: spellAntilyze.verticalCenter
      margin-left: 5
      text: Anti-Lyze
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: comboAntilyze
      anchors.right: comboBuff.right
      anchors.verticalCenter: spellAntilyze.verticalCenter
      width: 150
      height: 20
      placeholder: Insert anti-lyze spell

    BotSwitch
      id: spellUtura
      anchors.top: spellAntilyze.bottom
      anchors.left: spellAntilyze.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtura
      anchors.left: spellUtura.right
      anchors.verticalCenter: spellUtura.verticalCenter
      margin-left: 5
      text: Utura Gran
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: textUturaGran
      anchors.right: comboAntilyze.right
      anchors.verticalCenter: spellUtura.verticalCenter
      width: 150
      height: 20
      placeholder: Insert utura spell

  FlatPanel
    id: infolist2
    anchors.top: infolist1.bottom
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    height: 178
    margin-top: 8
    margin-bottom: 20
    margin-left: -4
    margin-right: -4

    BotSwitch
      id: spellUtamo
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 8
      margin-left: 8
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtamo
      anchors.left: spellUtamo.right
      anchors.verticalCenter: spellUtamo.verticalCenter
      margin-left: 5
      text: Auto Magic Shield
      font: verdana-11px-rounded
      text-auto-resize: true

    BotSwitch
      id: spellUtana
      anchors.top: spellUtamo.bottom
      anchors.left: spellUtamo.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtana
      anchors.left: spellUtana.right
      anchors.verticalCenter: spellUtana.verticalCenter
      margin-left: 5
      text: Auto Invisible
      font: verdana-11px-rounded
      text-auto-resize: true

    BotSwitch
      id: cureStatus
      anchors.top: spellUtana.bottom
      anchors.left: spellUtana.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblCureStatus
      anchors.left: cureStatus.right
      anchors.verticalCenter: cureStatus.verticalCenter
      margin-left: 5
      text: Cure Status
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: closePanel
    anchors.left: infolist2.left
    anchors.right: infolist2.right
    anchors.top: infolist2.bottom
    margin-top: 5
    text: Close

]=], g_ui.getRootWidget())

conditionsInterface:hide()

local function getConditionWidget(id)
  if not conditionsInterface then return nil end
  return conditionsInterface:recursiveGetChildById(id)
end

if modules._G.g_app.isMobile() then
  conditionsInterface:setSize("350 290")
end

local closeBtn = getConditionWidget("closePanel")
if closeBtn then
  closeBtn.onClick = function()
    conditionsInterface:hide()
  end
end

conditionsButton.settings.onClick = function()
  if not conditionsInterface:isVisible() then
    conditionsInterface:show()
    conditionsInterface:raise()
    conditionsInterface:focus()
  end
end

local function bindSwitch(id)
  local w = getConditionWidget(id)
  if not w then
    warn("bindSwitch nao encontrou widget: " .. tostring(id))
    return
  end

  local saved = conditionsStorage[panelName].switches[id]
  if saved ~= nil then
    w:setOn(saved == true)
  else
    conditionsStorage[panelName].switches[id] = w:isOn() == true
    saveConditionsChar()
  end

  w.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    conditionsStorage[panelName].switches[id] = newState
    saveConditionsChar()
  end
end

local function bindCombo(id)
  local combo = getConditionWidget(id)
  if not combo then
    warn("bindCombo nao encontrou widget: " .. tostring(id))
    return
  end

  if conditionsStorage[panelName].combos[id] ~= nil then
    combo:setCurrentOption(conditionsStorage[panelName].combos[id])
  else
    conditionsStorage[panelName].combos[id] = combo:getCurrentOption()
    saveConditionsChar()
  end

  combo.onOptionChange = function(widget, option)
    conditionsStorage[panelName].combos[id] = option
    saveConditionsChar()
  end
end

local function bindText(id)
  local w = getConditionWidget(id)
  if not w then
    warn("bindText nao encontrou widget: " .. tostring(id))
    return
  end

  if conditionsStorage[panelName].texts[id] ~= nil then
    w:setText(tostring(conditionsStorage[panelName].texts[id]))
  else
    conditionsStorage[panelName].texts[id] = w:getText() or ""
    saveConditionsChar()
  end

  w.onTextChange = function(widget, text)
    conditionsStorage[panelName].texts[id] = tostring(text or "")
    saveConditionsChar()
  end
end

bindSwitch("spellHaste")
bindCombo("comboHaste")

bindSwitch("spellBuff")
bindCombo("comboBuff")

bindSwitch("spellAntilyze")
bindText("comboAntilyze")

bindSwitch("spellUtura")
bindText("textUturaGran")

bindSwitch("spellUtamo")
bindSwitch("spellUtana")
bindSwitch("cureStatus")

local userUturaTimer = 0
local userBuffTimer = 0
local utanaCast = 0

local function _trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function conditionsEnabled()
  return conditionsStorage[switchConditions] and conditionsStorage[switchConditions].enabled == true
end

local function getCondCfg()
  local cfg = conditionsStorage[panelName]
  if not cfg then return nil end
  cfg.switches = cfg.switches or {}
  cfg.combos = cfg.combos or {}
  cfg.texts = cfg.texts or {}
  return cfg
end

onTalk(function(name, level, mode, text, channelId, pos)
  local player = g_game.getLocalPlayer()
  if not player then return end
  if name ~= player:getName() then return end

  text = tostring(text or ""):lower()

  local cfg = getCondCfg()
  if not cfg then return end

  local buffSpell = _trim(cfg.combos["comboBuff"]):lower()
  if buffSpell ~= "" and text == buffSpell then
    userBuffTimer = now + 10000
  end

  local uturaSpell = _trim(cfg.texts["textUturaGran"]):lower()
  if uturaSpell ~= "" and text == uturaSpell then
    userUturaTimer = now + 60500
  end
end)

local _lastMovePos = nil
local _lastMoveMs = 0

local function isMovingRecently(ms)
  ms = ms or 250
  local p = pos()
  if not p then return false end

  if not _lastMovePos then
    _lastMovePos = {x = p.x, y = p.y, z = p.z}
    return false
  end

  if p.x ~= _lastMovePos.x or p.y ~= _lastMovePos.y or p.z ~= _lastMovePos.z then
    _lastMovePos = {x = p.x, y = p.y, z = p.z}
    _lastMoveMs = now
    return true
  end

  return _lastMoveMs > 0 and now - _lastMoveMs <= ms
end

-- ANTI-LYZE
macro(100, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellAntilyze"] then return end
  if not isParalyzed() then return end

  local spell = _trim(cfg.texts["comboAntilyze"])
  if spell == "" then return end

  say(spell)
end)

-- HASTE
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellHaste"] then return end
  if hasHaste() then return end
  if isParalyzed() then return end
  if isInPz() then return end
  if not isMovingRecently(250) then return end

  local spell = _trim(cfg.combos["comboHaste"])
  if spell == "" then return end

  say(spell)
end)

-- BUFF / UTITO / UTAMO TEMPO / ETC
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellBuff"] then return end
  if userBuffTimer and userBuffTimer >= now then return end
  if not g_game.isAttacking() then return end

  local spell = _trim(cfg.combos["comboBuff"])
  if spell == "" then return end

  say(spell)
  userBuffTimer = now + 10000
end)

-- UTURA GRAN / REGEN
macro(500, function()
  if not conditionsEnabled() then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtura"] then return end
  if userUturaTimer and userUturaTimer >= now then return end
  if player:getMana() < 200 then return end

  local spell = _trim(cfg.texts["textUturaGran"])
  if spell == "" then spell = "utura gran" end

  say(spell)
  userUturaTimer = now + 60500
end)

-- CURE STATUS
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["cureStatus"] then return end
  if g_game.isAttacking() then return end

  if isPoisioned() then
    say("exana pox")
    return
  end

  if isBurning() then
    say("exana flam")
    return
  end

  if isEnergized() then
    say("exana vis")
    return
  end

  if isCursed() then
    say("exana mort")
    return
  end

  if isBleeding() then
    say("exana kor")
    return
  end
end)

-- AUTO MAGIC SHIELD
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtamo"] then return end
  if hasManaShield() then return end

  say("utamo vita")
end)

-- AUTO INVISIBLE
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtana"] then return end
  if mana() < 441 then return end
  if utanaCast > 0 and now - utanaCast < 120000 then return end

  say("utana vid")
  utanaCast = now
end)
end)

lnsRunBlock("HEALFRIEND", function()
  storage = storage or {}
storage.LNSHealFriendGlobal = storage.LNSHealFriendGlobal or {}

local healFriendStorage = storage.LNSHealFriendGlobal

local function saveHealFriendGlobal()
  storage.LNSHealFriendGlobal = healFriendStorage
end

local function saveHealFriendChar()
  saveHealFriendGlobal()
end

local function trimText(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function lowerTrim(s)
  return trimText(s):lower()
end

local function getBotItemId(widget)
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

-- ===============================
-- BUTTON
-- ===============================
switchSio = "sioButton"
healFriendStorage[switchSio] = healFriendStorage[switchSio] or { enabled = false }

sioButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Healing Friend
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
sioButton:setId(switchSio)
sioButton.title:setOn(healFriendStorage[switchSio].enabled)

sioButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  healFriendStorage[switchSio].enabled = newState
  saveHealFriendChar()
end

local prioRowTemplate = [[
UIWidget
  height: 19
  margin-top: 1
  background-color: #2a2a2a
  border: 1 #3a3a3a

  Label
    id: voc
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    color: white
    text: ""

  Button
    id: down
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: v
    color: white

  Button
    id: up
    anchors.right: down.left
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: ^
    color: white
]]

sioInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 380 390
  border: 1 black
  text: Panel Heal-Friend
  anchors.centerIn: parent
  margin-top: -50

  Panel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    size: 270 200
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-left: -4
    margin-right: -4

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Settings for Heal Friend
      margin-top: 2

  Label
    id: labelSelectType
    anchors.top: infolist1.top
    anchors.left: infolist1.left
    margin-top: 25
    margin-left: 10
    text: Mode Healing:
    text-auto-resize: true

  BotSwitch
    id: UseSpell
    anchors.verticalCenter: labelSelectType.verticalCenter
    anchors.left: labelSelectType.right
    margin-left: 10
    size: 125 19
    text: Health Spell

  BotSwitch
    id: UsePotion
    anchors.verticalCenter: labelSelectType.verticalCenter
    anchors.left: UseSpell.right
    margin-left: 1
    size: 125 19
    text: Health Item

  Label
    id: hpCura
    anchors.top: UseSpell.bottom
    anchors.left: labelSelectType.left
    text: Friend HP%:
    margin-top: 6

  HorizontalScrollBar
    id: percentHp
    anchors.verticalCenter: hpCura.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: percentHpValue
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 80%
    color: white

  Label
    id: distancePotion
    anchors.top: hpCura.bottom
    anchors.left: labelSelectType.left
    text: Distance Item:
    margin-top: 8

  HorizontalScrollBar
    id: distUsePot
    anchors.verticalCenter: distancePotion.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 10

  Label
    id: distUsePotValue
    anchors.verticalCenter: distUsePot.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 3 Sqm
    color: white

  Label
    id: labelSolicitar
    anchors.top: distancePotion.bottom
    anchors.left: labelSelectType.left
    text: Ask Mana:
    margin-top: 8

  HorizontalScrollBar
    id: percentMp
    anchors.verticalCenter: labelSolicitar.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: percentMpValue
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 50%
    color: white

  HorizontalSeparator
    id: sepHor
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Label
    id: HealingSpells
    anchors.top: sepHor.bottom
    anchors.left: distancePotion.left
    margin-top: 10
    text: Healing Spells:

  CheckBox
    id: exuraSio
    anchors.top: HealingSpells.bottom
    anchors.left: HealingSpells.left
    margin-top: 5
    text: Exura Sio
    text-auto-resize: true
    color: gray
    $checked:
      color: green

  CheckBox
    id: masRes
    anchors.top: exuraSio.bottom
    anchors.left: exuraSio.left
    margin-top: 8
    text: Mas Res
    text-auto-resize: true
    color: gray
    $checked:
      color: green

  CheckBox
    id: checkOtherSpell
    anchors.top: masRes.bottom
    anchors.left: masRes.left
    margin-top: 8

  TextEdit
    id: otherSpell
    anchors.verticalCenter: checkOtherSpell.verticalCenter
    anchors.left: checkOtherSpell.right
    size: 110 19
    margin-left: 7
    placeholder: Other Spell

  Label
    id: labelPotion
    anchors.top: HealingSpells.top
    anchors.left: otherSpell.right
    margin-left: 40
    text: Health Potion:

  BotItem
    id: potionID
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 58
    margin-top: 2

  Label
    id: labelPotionMP
    anchors.top: labelPotion.top
    anchors.left: labelPotion.left
    margin-top: 45
    text: Mana Potion:

  BotItem
    id: potionMPID
    anchors.left: potionID.left
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 3

  Panel
    id: infolist2
    anchors.top: infolist1.bottom
    anchors.left: infolist1.left
    size: 200 130
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-top: 5

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Heal Toggles
      margin-top: 2

  BotSwitch
    id: friendList
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin: 10
    margin-top: 22
    width: 18
    text: Friend List

  BotSwitch
    id: partyMembers
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Party Members

  BotSwitch
    id: guildMembers
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Guild Members

  BotSwitch
    id: cureMPFriend
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Request Mana

  ComboBox
    id: selectChat
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    height: 20
    @onSetup: |
      self:addOption("Default")
      self:addOption("Party Channel")

  Panel
    id: infolist3
    anchors.top: infolist2.top
    anchors.left: infolist2.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 7
    image-source: /images/ui/miniwindow
    image-border: 20
    height: 130

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Priority List
      margin-top: 2

  TextList
    id: prioList
    anchors.top: infolist3.top
    anchors.left: infolist3.left
    anchors.right: infolist3.right
    margin-top: 20
    margin-left: 5
    margin-right: 5
    height: 105
    image-source: ""

  BotSwitch
    id: listPrio
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    width: 18
    margin-top: 83
    text: Priority Vocation

  Button
    id: closePanel
    anchors.left: infolist2.left
    anchors.right: infolist3.right
    anchors.top: prioList.bottom
    size: 35 20
    margin-top: 9
    text: Close
]], g_ui.getRootWidget())

sioInterface:hide()

if modules._G.g_app.isMobile() then
  sioInterface:setSize("380 410")
end

sioInterface.closePanel.onClick = function()
  sioInterface:hide()
end

sioButton.settings.onClick = function()
  if sioInterface:isVisible() then
    sioInterface:hide()
  else
    sioInterface:show()
    sioInterface:raise()
    sioInterface:focus()
  end
end

-- ===============================
-- MIGRACAO STORAGE ANTIGO -> CHARSTORAGE
-- ===============================
if storage and storage.healFriend and not healFriendStorage.healFriendMigrated then
  healFriendStorage.healFriend = healFriendStorage.healFriend or {}
  for k, v in pairs(storage.healFriend) do
    if healFriendStorage.healFriend[k] == nil then
      healFriendStorage.healFriend[k] = v
    end
  end
  healFriendStorage.healFriendMigrated = true
  saveHealFriendChar()
end

if storage and storage[switchSio] and not healFriendStorage.sioButtonMigrated then
  healFriendStorage[switchSio] = healFriendStorage[switchSio] or {}
  if healFriendStorage[switchSio].enabled == nil then
    healFriendStorage[switchSio].enabled = storage[switchSio].enabled == true
  end
  healFriendStorage.sioButtonMigrated = true
  saveHealFriendChar()
end

if not healFriendStorage.healFriend then
  healFriendStorage.healFriend = {
    useSpell = false,
    usePotion = false,
    percentHp = 80,
    distUsePot = 3,
    percentMp = 50,
    exuraSio = true,
    masRes = false,
    checkOtherSpell = false,
    otherSpell = "",
    potionID = 0,
    potionMPID = 0,
    friendList = false,
    partyMembers = false,
    guildMembers = false,
    listPrio = false,
    cureMPFriend = false,
    selectChat = "Default",
    prioOrder = { "Knight", "Paladin", "Monk", "Mage" }
  }
end

local config = healFriendStorage.healFriend
config.prioOrder = config.prioOrder or { "Knight", "Paladin", "Monk", "Mage" }

local function saveConfig()
  saveHealFriendChar()
end

sioInterface.selectChat:setCurrentOption(config.selectChat)

sioInterface.selectChat.onOptionChange = function(widget, option)
  config.selectChat = option
  saveConfig()
end

local function setScrollLabel(label, value, suffix)
  label:setText(tostring(value) .. (suffix or ""))
end

local function clearChildren(w)
  if not w then return end
  local ch = w:getChildren() or {}
  for i = #ch, 1, -1 do
    local c = ch[i]
    if c and not c:isDestroyed() then c:destroy() end
  end
end

local function swap(t, i, j)
  if type(t) ~= "table" then return end
  if i < 1 or j < 1 or i > #t or j > #t then return end
  t[i], t[j] = t[j], t[i]
end

local function rebuildPrioList()
  clearChildren(sioInterface.prioList)

  local fixed = { "Knight", "Paladin", "Monk", "Mage" }

  if type(config.prioOrder) ~= "table" or #config.prioOrder ~= 4 then
    config.prioOrder = fixed
    saveConfig()
  end

  for i = 1, #config.prioOrder do
    local voc = config.prioOrder[i]
    local row = setupUI(prioRowTemplate, sioInterface.prioList)

    row.voc:setText(voc)

    row.up.onClick = function()
      swap(config.prioOrder, i, i - 1)
      saveConfig()
      rebuildPrioList()
    end

    row.down.onClick = function()
      swap(config.prioOrder, i, i + 1)
      saveConfig()
      rebuildPrioList()
    end

    if i == 1 then row.up:setEnabled(false) end
    if i == #config.prioOrder then row.down:setEnabled(false) end
  end
end

rebuildPrioList()

sioInterface.UseSpell.onClick = function(widget)
  config.useSpell = not config.useSpell
  widget:setOn(config.useSpell)
  if config.useSpell then
    config.usePotion = false
    sioInterface.UsePotion:setOn(false)
  end
  saveConfig()
end
sioInterface.UseSpell:setOn(config.useSpell)

sioInterface.UsePotion.onClick = function(widget)
  config.usePotion = not config.usePotion
  widget:setOn(config.usePotion)
  if config.usePotion then
    config.useSpell = false
    sioInterface.UseSpell:setOn(false)
  end
  saveConfig()
end
sioInterface.UsePotion:setOn(config.usePotion)

sioInterface.percentHp.onValueChange = function(scroll, value)
  config.percentHp = value
  setScrollLabel(sioInterface.percentHpValue, value, "%")
  saveConfig()
end
sioInterface.percentHp:setValue(config.percentHp)
setScrollLabel(sioInterface.percentHpValue, config.percentHp, "%")

sioInterface.distUsePot.onValueChange = function(scroll, value)
  config.distUsePot = value
  setScrollLabel(sioInterface.distUsePotValue, value, " Sqm")
  saveConfig()
end
sioInterface.distUsePot:setValue(config.distUsePot)
setScrollLabel(sioInterface.distUsePotValue, config.distUsePot, " Sqm")

sioInterface.percentMp.onValueChange = function(scroll, value)
  config.percentMp = value
  setScrollLabel(sioInterface.percentMpValue, value, "%")
  saveConfig()
end
sioInterface.percentMp:setValue(config.percentMp)
setScrollLabel(sioInterface.percentMpValue, config.percentMp, "%")

sioInterface.exuraSio.onClick = function(widget)
  config.exuraSio = not config.exuraSio
  widget:setChecked(config.exuraSio)
  saveConfig()
end
sioInterface.exuraSio:setChecked(config.exuraSio)

sioInterface.masRes.onClick = function(widget)
  config.masRes = not config.masRes
  widget:setChecked(config.masRes)
  saveConfig()
end
sioInterface.masRes:setChecked(config.masRes)

sioInterface.checkOtherSpell.onClick = function(widget)
  config.checkOtherSpell = not config.checkOtherSpell
  widget:setChecked(config.checkOtherSpell)
  saveConfig()
end
sioInterface.checkOtherSpell:setChecked(config.checkOtherSpell)

sioInterface.otherSpell.onTextChange = function(widget, text)
  config.otherSpell = text
  saveConfig()
end
sioInterface.otherSpell:setText(config.otherSpell)

sioInterface.potionID.onItemChange = function(widget)
  config.potionID = getBotItemId(widget)
  saveConfig()
end
sioInterface.potionID:setItemId(config.potionID)

sioInterface.potionMPID.onItemChange = function(widget)
  config.potionMPID = getBotItemId(widget)
  saveConfig()
end
sioInterface.potionMPID:setItemId(config.potionMPID)

local toggles = {"friendList", "partyMembers", "guildMembers", "listPrio", "cureMPFriend"}
for _, id in ipairs(toggles) do
  sioInterface[id].onClick = function(widget)
    config[id] = not config[id]
    widget:setOn(config[id])
    saveConfig()
  end
  sioInterface[id]:setOn(config[id])
end

saveConfig()

-----------------------------
-- MACRO DE PEDIR MP
-----------------------------
macro(200, function()
  if not healFriendStorage[switchSio] or not healFriendStorage[switchSio].enabled then
    return
  end
  if not config or not config.cureMPFriend then
    return
  end

  local manaPercent = config.percentMp
  local chatSelecionado = config.selectChat
  if manapercent() <= manaPercent then
    if chatSelecionado == "Default" then
      say("p")
      delay(4000)
    elseif chatSelecionado == "Party Channel" then
      sayChannel(1, "p")
      delay(4000)
    end
  end
end)

macro(100, function()
  if pauseFriendHeal and pauseFriendHeal > now then return end
  if not healFriendStorage[switchSio] or not healFriendStorage[switchSio].enabled then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local spectators = getSpectators()
  if not spectators then return end

  local targets = {}
  local minHp = config.percentHp or 80

  -- =========================
  -- COLETA PLAYERS
  -- =========================
  for _, creature in ipairs(spectators) do
    if creature:isPlayer() and creature:getName() ~= player:getName() then
      local hp = 100
      if creature.getHealthPercent then
        hp = creature:getHealthPercent()
      end

      if hp and hp > 0 and hp <= minHp then
        table.insert(targets, {
          creature = creature,
          hp = hp
        })
      end
    end
  end

  if #targets == 0 then return end

  -- =========================
  -- FILTRO (SAFE)
  -- =========================
  local function isFriendName(n)
    if storage.playerList and type(storage.playerList.friendList) == "table" then
      for _, fName in ipairs(storage.playerList.friendList) do
        if lowerTrim(fName) == lowerTrim(n) then return true end
      end
    end
    return false
  end

  local function canHeal(creature)
    local name = creature:getName()

    if config.friendList and type(isFriend) == "function" and isFriend(name) then return true end
    if config.friendList and isFriendName(name) then return true end
    if config.partyMembers and creature.isPartyMember and creature:isPartyMember() then return true end
    if config.guildMembers and creature.getEmblem then
      local emblem = creature:getEmblem()
      if emblem == 1 or emblem == 4 then return true end
    end

    if not config.friendList and not config.partyMembers and not config.guildMembers then
      return true
    end

    return false
  end

  local valid = {}
  for _, t in ipairs(targets) do
    if canHeal(t.creature) then
      table.insert(valid, t)
    end
  end

  if #valid == 0 then return end

  -- =========================
  -- PRIORIDADE
  -- =========================
  local rankMap = {}
  if config.listPrio then
    local order = config.prioOrder or { "Knight", "Paladin", "Monk", "Mage" }
    for i = 1, #order do
      rankMap[order[i]:upper()] = i
    end
  end

  local function getVocCodeFromCheckText(creature)
    if not creature or not creature.getText then return nil end
    local t = creature:getText() or ""
    if t == "" then return nil end

    local code = t:match("%d+%s*(%u%u)")
    if not code then code = t:match("(%u%u)") end
    return code
  end

  local function vocGroupFromCode(code)
    if code == "EK" then return "KNIGHT" end
    if code == "RP" then return "PALADIN" end
    if code == "EM" then return "MONK" end
    if code == "MS" or code == "ED" then return "MAGE" end
    return nil
  end

  local function getPrioRankForCreature(creature)
    local code = getVocCodeFromCheckText(creature)
    local group = vocGroupFromCode(code)
    if not group then return 9999 end
    return rankMap[group] or 9999
  end

  table.sort(valid, function(a, b)
    if not config.listPrio then
      return a.hp < b.hp
    end

    local pa = getPrioRankForCreature(a.creature)
    local pb = getPrioRankForCreature(b.creature)

    if pa == pb then
      return a.hp < b.hp
    end

    return pa < pb
  end)

  local target = valid[1]
  if not target then return end

  local t = target.creature
  local tName = t:getName()

  -- =========================
  -- SPELL HEAL
  -- =========================
  if config.useSpell then
    if config.exuraSio then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say('exura sio "' .. tName)
      end
      delay(500)
      return
    end

    if config.masRes then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say("exura gran mas res")
      end
      delay(500)
      return
    end

    if config.checkOtherSpell and trimText(config.otherSpell) ~= "" then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say(config.otherSpell .. ' "' .. tName)
      end
      delay(500)
      return
    end
  end

  -- =========================
  -- POTION HEAL
  -- =========================
  if config.usePotion and config.potionID and config.potionID > 0 then
    local dist = getDistanceBetween(player:getPosition(), t:getPosition())

    if dist <= (config.distUsePot or 3) then
      if g_game.useInventoryItemWith then
        g_game.useInventoryItemWith(config.potionID, t)
      else
        useWith(config.potionID, t)
      end
      return
    end
  end
end)

-- =========================================
-- LISTENER: DAR MANA PARA QUEM PEDIR "P"
-- =========================================
onTalk(function(name, level, mode, text, channelId, pos)
  text = lowerTrim(text)
  if text ~= "p" then return end

  if not healFriendStorage[switchSio] or not healFriendStorage[switchSio].enabled then
    return
  end

  local mpId = config.potionMPID
  if not mpId or mpId <= 100 then
    return
  end

  local player = g_game.getLocalPlayer()
  if not player or name == player:getName() then return end

  local targetCreature = nil
  for _, creature in ipairs(getSpectators()) do
    if creature:isPlayer() and lowerTrim(creature:getName()) == lowerTrim(name) then
      targetCreature = creature
      break
    end
  end

  if not targetCreature then
    return
  end

  local dist = getDistanceBetween(player:getPosition(), targetCreature:getPosition())
  if dist > 1 then
    return
  end

  local function isFriendName(n)
    if storage.playerList and type(storage.playerList.friendList) == "table" then
      for _, fName in ipairs(storage.playerList.friendList) do
        if lowerTrim(fName) == lowerTrim(n) then return true end
      end
    end
    return false
  end

  local validTarget = false
  if config.friendList and type(isFriend) == "function" and isFriend(name) then validTarget = true end
  if config.friendList and isFriendName(name) then validTarget = true end
  if config.partyMembers and targetCreature.isPartyMember and targetCreature:isPartyMember() then validTarget = true end

  if config.guildMembers and targetCreature.getEmblem then
    local emblem = targetCreature:getEmblem()
    if emblem == 1 or emblem == 4 then
      validTarget = true
    end
  end

  if validTarget then

    schedule(50, function()
      if g_game.useInventoryItemWith then
        g_game.useInventoryItemWith(mpId, targetCreature)
      else
        useWith(mpId, targetCreature)
      end
    end)
  else
  end
end)
end)

lnsRunBlock("CONTROL_FOLLOW", function()
  local PANEL_NAME = "lnsFollow"
local FOLLOW_SWITCH_ID = "followButton"

local category = "lns"
local MW_RUNE_ID = 3180
local WG_RUNE_ID = 3156
local SD_RUNE_ID = 3155
local ATTACKBOT_SWITCH_ID = "comboButton"
local MINI_WINDOW_NAME = "ingameScriptWindow"
local HOLD_STORAGE_KEY = "lnsLeaderHoldMwWg"

local leaderCommandDelay = 200
local lastLeaderCommand = 0
local sendLeaderCommand

pausandoCombo = 0

storage = storage or {}
storage.LNSControlFollowGlobal = storage.LNSControlFollowGlobal or {}

local controlFollowStorage = storage.LNSControlFollowGlobal

local function saveLeaderControl()
  storage.LNSControlFollowGlobal = controlFollowStorage
end

controlFollowStorage[PANEL_NAME] = controlFollowStorage[PANEL_NAME] or {
  texts = {},
  switches = {}
}

controlFollowStorage.follow2Panel = controlFollowStorage.follow2Panel or {
  leaderName = "",
  followerName = "",
  ueSpell = ""
}

controlFollowStorage[HOLD_STORAGE_KEY] = controlFollowStorage[HOLD_STORAGE_KEY] or {
  enabled = { mw = false, wg = false },
  marks = {}
}

controlFollowStorage[MINI_WINDOW_NAME] = controlFollowStorage[MINI_WINDOW_NAME] or {}
controlFollowStorage[ATTACKBOT_SWITCH_ID] = controlFollowStorage[ATTACKBOT_SWITCH_ID] or { enabled = false }
controlFollowStorage[FOLLOW_SWITCH_ID] = controlFollowStorage[FOLLOW_SWITCH_ID] or { enabled = false }

if modules.game_interface and modules.game_interface.removeMenuHook then
  modules.game_interface.removeMenuHook(category)
end

local function normalizeText(s)
  s = tostring(s or "")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function lowerText(s)
  return normalizeText(s):lower()
end

local function getPanelDb()
  controlFollowStorage[PANEL_NAME] = controlFollowStorage[PANEL_NAME] or {}
  controlFollowStorage[PANEL_NAME].texts = controlFollowStorage[PANEL_NAME].texts or {}
  controlFollowStorage[PANEL_NAME].switches = controlFollowStorage[PANEL_NAME].switches or {}
  return controlFollowStorage[PANEL_NAME]
end

local function getFollow2Db()
  controlFollowStorage.follow2Panel = controlFollowStorage.follow2Panel or {}
  return controlFollowStorage.follow2Panel
end

local function getLeaderNameFromFollow2()
  return lowerText(getFollow2Db().leaderName or "")
end

local function getUeSpellFromFollow2()
  return normalizeText(getFollow2Db().ueSpell or "")
end

local function findWidgetById(id)
  local root = g_ui and g_ui.getRootWidget and g_ui.getRootWidget()
  if not root or not root.recursiveGetChildById then return nil end
  return root:recursiveGetChildById(id)
end

local function getHookPos(pos, lookThing, useThing, creatureThing)
  if pos and pos.x and pos.y and pos.z then return pos end

  for _, thing in ipairs({lookThing, useThing, creatureThing}) do
    if thing and thing.getPosition then
      local p = thing:getPosition()
      if p and p.x and p.y and p.z then return p end
    end
  end

  return nil
end

local function parseCommandPos(text, prefix)
  local pattern = "^" .. prefix .. "%s*:%s*(%-?%d+)%s*,%s*(%-?%d+)%s*,%s*(%-?%d+)%s*$"
  local x, y, z = normalizeText(text):match(pattern)
  if not x then return nil end
  return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

local function sayHookPos(prefix, pos, lookThing, useThing, creatureThing)
  local p = getHookPos(pos, lookThing, useThing, creatureThing)
  if not p then return end

  local command = string.format("%s: %d,%d,%d", prefix, p.x, p.y, p.z)

  if sendLeaderCommand then
    sendLeaderCommand(command)
  else
    sayChannel(1, command)
  end
end

local function safeUseWithItem(itemId, target)
  if not itemId or not target then return false end

  local item = findItem(itemId)
  if not item then return false end

  return useWith(item, target) and true or false
end

local function useRuneOnPos(itemId, pos)
  if not itemId or not pos then return false end

  local tile = g_map.getTile(pos)
  if not tile then return false end

  local topThing = tile:getTopUseThing()
  if not topThing then return false end

  return safeUseWithItem(itemId, topThing)
end

local function syncSwitchVisual(panelGlobal, switchId, state)
  if panelGlobal and panelGlobal.title and panelGlobal.title.setOn then
    panelGlobal.title:setOn(state)
    return
  end

  local panel = findWidgetById(switchId)
  if not panel then return end

  local title = panel.getChildById and panel:getChildById("title")
  if not title then return end

  title:setOn(state)
end

local function setAttackBotState(state)
  state = state == true

  controlFollowStorage[ATTACKBOT_SWITCH_ID] = controlFollowStorage[ATTACKBOT_SWITCH_ID] or {}
  controlFollowStorage[ATTACKBOT_SWITCH_ID].enabled = state
  saveLeaderControl()

  if comboButton and comboButton.title and comboButton.title.setOn then
    comboButton.title:setOn(state)
  else
    syncSwitchVisual(comboButton, ATTACKBOT_SWITCH_ID, state)
  end
end

local function setFollowState(state)
  state = state == true

  controlFollowStorage.follow2Panel = controlFollowStorage.follow2Panel or {}
  controlFollowStorage.follow2Panel.enabled = state

  controlFollowStorage[FOLLOW_SWITCH_ID] = controlFollowStorage[FOLLOW_SWITCH_ID] or {}
  controlFollowStorage[FOLLOW_SWITCH_ID].enabled = state

  if not state then
    g_game.cancelFollow()

    if g_game.cancelAttack then
      -- não cancela ataque, só follow
    end

    if player and player.stopAutoWalk then
      pcall(function() player:stopAutoWalk() end)
    end
  end

  if followButton and followButton.title and followButton.title.setOn then
    followButton.title:setOn(state)
  else
    syncSwitchVisual(followButton, FOLLOW_SWITCH_ID, state)
  end

  saveLeaderControl()
end

local function getHoldDb()
  controlFollowStorage[HOLD_STORAGE_KEY] = controlFollowStorage[HOLD_STORAGE_KEY] or {}
  controlFollowStorage[HOLD_STORAGE_KEY].enabled = controlFollowStorage[HOLD_STORAGE_KEY].enabled or { mw = false, wg = false }
  controlFollowStorage[HOLD_STORAGE_KEY].marks = controlFollowStorage[HOLD_STORAGE_KEY].marks or {}
  return controlFollowStorage[HOLD_STORAGE_KEY]
end

local function holdPosKey(pos)
  return string.format("%d,%d,%d", pos.x, pos.y, pos.z)
end

local function splitHoldPosKey(key)
  local x, y, z = tostring(key):match("^(%-?%d+),(%-?%d+),(%-?%d+)$")
  if not x then return nil end
  return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

local function isHoldMwEnabled()
  return getHoldDb().enabled.mw == true
end

local function isHoldWgEnabled()
  return getHoldDb().enabled.wg == true
end

local function addHoldMark(pos, text)
  if not pos or not text then return end
  getHoldDb().marks[holdPosKey(pos)] = text
  saveLeaderControl()
end

local function clearHoldMarksByText(text)
  local db = getHoldDb()
  local keep = {}

  for key, value in pairs(db.marks or {}) do
    local pos = splitHoldPosKey(key)
    local tile = pos and g_map.getTile(pos)

    if value == text then
      if tile and tile.getText and tile:getText() == text then
        pcall(function()
          tile:setText("")
        end)
      end
    else
      keep[key] = value
    end
  end

  db.marks = keep
  controlFollowStorage[HOLD_STORAGE_KEY].marks = keep
  saveLeaderControl()
end

local function setHoldMwState(state)
  local db = getHoldDb()
  db.enabled.mw = state == true

  if db.enabled.mw ~= true then
    clearHoldMarksByText("HOLD MW")
    db = getHoldDb()
    db.enabled.mw = false
    db.marks = db.marks or {}
  end

  saveLeaderControl()
end

local function setHoldWgState(state)
  local db = getHoldDb()
  db.enabled.wg = state == true

  if db.enabled.wg ~= true then
    clearHoldMarksByText("HOLD WG")
    db = getHoldDb()
    db.enabled.wg = false
    db.marks = db.marks or {}
  end

  saveLeaderControl()
end

local function tileHasHoldField(tile)
  if not tile then return false end

  local items = tile:getItems()
  if not items then return false end

  for i = 1, #items do
    local item = items[i]
    if item and item.getId then
      local id = item:getId()
      if id == 2129 or id == 2130 then
        return true
      end
    end
  end

  return false
end

local function canUseHoldOnTile(tile)
  if not tile then return false end
  if isInPz() then return false end
  if not tile:canShoot() then return false end
  if not tile:isWalkable() then return false end

  local top = tile:getTopUseThing()
  if not top then return false end
  if top:getId() == 2130 then return false end

  local ppos = player and player:getPosition()
  local tpos = tile:getPosition()
  if not ppos or not tpos then return false end
  if ppos.z ~= tpos.z then return false end
  if math.abs(ppos.x - tpos.x) >= 8 or math.abs(ppos.y - tpos.y) >= 6 then return false end

  return true
end

local HOLD_CAST_COOLDOWN_MS = 200
local HOLD_TILE_COOLDOWN_MS = 200
local HOLD_FAIL_COOLDOWN_MS = 100
local HOLD_REMOVE_DEBOUNCE_MS = 170
local lastHoldCastAt = 0
local lastHoldCastByTile = {}

local function tryUseHold(tile, holdText)
  if not tile or not holdText then return false end

  local runeId = nil

  if holdText == "HOLD MW" then
    if not isHoldMwEnabled() then return false end
    runeId = MW_RUNE_ID
  elseif holdText == "HOLD WG" then
    if not isHoldWgEnabled() then return false end
    runeId = WG_RUNE_ID
  else
    return false
  end

  if tileHasHoldField(tile) then return false end
  if not canUseHoldOnTile(tile) then return false end
  if now - lastHoldCastAt < HOLD_CAST_COOLDOWN_MS then return false end

  local pos = tile:getPosition()
  local key = holdPosKey(pos)
  local lastTileCast = lastHoldCastByTile[key] or 0

  if lastTileCast > now then return false end
  if now - lastTileCast < HOLD_TILE_COOLDOWN_MS then return false end

  local used = safeUseWithItem(runeId, tile:getTopUseThing())
  lastHoldCastAt = now

  if used then
    lastHoldCastByTile[key] = now
    return true
  end

  lastHoldCastByTile[key] = now + HOLD_FAIL_COOLDOWN_MS
  return false
end

--==================================================
-- COMBO SIMPLES
-- pause runtime: pausandoCombo = now + 3000
--==================================================

local comboExecutando = false

local function setComboPause(ms)
  pausandoCombo = now + (ms or 3000)
end

local function clearComboPause()
  pausandoCombo = 0
end

local function triggerComboUE()
  if comboExecutando then return false end

  local ueSpell = getUeSpellFromFollow2()
  if ueSpell == "" then return false end

  comboExecutando = true
  pausandoCombo = now + 3000

  if type(startComboCountdown) == "function" then
    startComboCountdown("ue")
  end

  schedule(3000, function()
    local spell = getUeSpellFromFollow2()

    if spell ~= "" then
      say(spell)
    end

    schedule(300, function()
      comboExecutando = false
      clearComboPause()
    end)
  end)

  return true
end

local function triggerComboSD()
  if comboExecutando then return false end

  local currentTarget = g_game.getAttackingCreature()
  if not currentTarget then return false end
  if not findItem(SD_RUNE_ID) then return false end

  local targetId = currentTarget:getId()

  comboExecutando = true
  pausandoCombo = now + 3000

  if type(startComboCountdown) == "function" then
    startComboCountdown("sd")
  end

  schedule(3000, function()
    if not findItem(SD_RUNE_ID) then
      comboExecutando = false
      clearComboPause()
      return
    end

    local target = getCreatureById(targetId) or g_game.getAttackingCreature()
    if target then
      useWith(SD_RUNE_ID, target)
    end

    schedule(300, function()
      comboExecutando = false
      clearComboPause()
    end)
  end)

  return true
end

local function safeNpcSay(text)
  text = normalizeText(text)
  if text == "" then return end

  if NPC and NPC.say then
    NPC.say(text)
    return
  end

  if npc and npc.say then
    npc.say(text)
    return
  end

  say(text)
end

local function npcSaySequence(words, delayMs)
  if type(words) ~= "table" then return false end

  delayMs = tonumber(delayMs) or 500
  if delayMs < 500 then delayMs = 500 end

  for i = 1, #words do
    local word = normalizeText(words[i])

    if word ~= "" then
      schedule((i - 1) * delayMs, function()
        safeNpcSay(word)
      end)
    end
  end

  return true
end

local function formatTaskCommand(text)
  text = lowerText(text)
  if text == "" then return "" end

  text = text:gsub("%s+", " ")

  if not text:match("s$") then
    text = text .. "s"
  end

  text = text:gsub("(%a)([%w%-']*)", function(first, rest)
    return first:upper() .. rest
  end)

  return text
end

local function executeLeaderCommand(text)
  local msg = normalizeText(text)
  local msgLower = msg:lower()

  if msgLower == "set: attackbot [on]" then
    setAttackBotState(true)
    return true
  end

  if msgLower == "set: attackbot [off]" then
    setAttackBotState(false)
    return true
  end

  if msgLower == "set: follow [on]" then
    setFollowState(true)
    return true
  end

  if msgLower == "set: follow [off]" then
    setFollowState(false)
    return true
  end

  if msgLower == "set: targetbot [on]" then
    if TargetBot and TargetBot.setOn then TargetBot.setOn() end
    return true
  end

  if msgLower == "set: targetbot [off]" then
    if TargetBot and TargetBot.setOff then TargetBot.setOff() end
    return true
  end

  if msgLower == "set: cavebot [on]" then
    if CaveBot and CaveBot.setOn then CaveBot.setOn() end
    return true
  end

  if msgLower == "set: cavebot [off]" then
    if CaveBot and CaveBot.setOff then CaveBot.setOff() end
    return true
  end

  if msgLower == "set: combo ue [on]" then
    triggerComboUE()
    return true
  end

  if msgLower == "set: combo sd [on]" then
    triggerComboSD()
    return true
  end

  if msgLower == "set: stop attack" then
    g_game.cancelAttack()
    oldTarget = nil
    targetID = nil
    return true
  end

  if msgLower == "set: hold mw [on]" or msgLower == "hold mw on" then
    setHoldMwState(true)
    return true
  end

  if msgLower == "set: hold mw [off]" or msgLower == "hold mw off" then
    setHoldMwState(false)
    return true
  end

  if msgLower == "set: hold wg [on]" or msgLower == "hold wg on" then
    setHoldWgState(true)
    return true
  end

  if msgLower == "set: hold wg [off]" or msgLower == "hold wg off" then
    setHoldWgState(false)
    return true
  end

  if msgLower == "report task" then
    npcSaySequence({"hi", "report", "yes", "bye"}, 500)
    return true
  end

  local taskName = msg:match("^[Tt][Aa][Ss][Kk]%s*:%s*(.+)$")
  if taskName then
    taskName = lowerText(taskName)

    if taskName ~= "" then
      npcSaySequence({"hi", taskName, "yes", "bye"}, 500)
    end

    return true
  end

  local movePos = parseCommandPos(msg, "MOVE POS")
  if movePos then
    if movePos.z ~= posz() then return true end
    autoWalk(movePos, 100, {ignoreNonPathable = true, ignoreCreatures = true, precision = 1})
    return true
  end

  local mwPos = parseCommandPos(msg, "MW IN")
  if mwPos then
    useRuneOnPos(MW_RUNE_ID, mwPos)
    return true
  end

  local wgPos = parseCommandPos(msg, "WG IN")
  if wgPos then
    useRuneOnPos(WG_RUNE_ID, wgPos)
    return true
  end

  local travelCity = msg:match("Travel to:%s*(.+)")
  if travelCity then
    travelCity = normalizeText(travelCity)

    schedule(200, function()
      NPC.say("hi")
      schedule(200, function()
        NPC.say(travelCity)
        schedule(200, function()
          NPC.say("yes")
          schedule(200, function()
            NPC.say("yes")
          end)
        end)
      end)
    end)

    return true
  end

  return false
end

sendLeaderCommand = function(text, runLocal)
  local msg = normalizeText(text)
  if msg == "" then return false end

  if runLocal ~= false then
    executeLeaderCommand(msg)

    -- evita executar duas vezes no client que enviou, caso o onTalk também capture a própria fala
    lastLeaderCommand = now + leaderCommandDelay
  end

  sayChannel(1, msg)
  return true
end

local hooks = {
  {label = "LNS | MC Use Here", prefix = "USE TO"},
  {label = "LNS | Move Pos", prefix = "MOVE POS"},
  {label = "LNS | MC Use MW", prefix = "MW IN"},
  {label = "LNS | MC Use WG", prefix = "WG IN"},
}

for i = 1, #hooks do
  local hook = hooks[i]
  modules.game_interface.addMenuHook(category, hook.label, function(pos, lookThing, useThing, creatureThing)
    sayHookPos(hook.prefix, pos, lookThing, useThing, creatureThing)
  end, function() return true end)
end

--==================================================
-- MC LÊ COMANDOS DO LEADER
-- se o Leader Name estiver vazio, aceita somente textos com cara de comando
-- isso evita o bug de MC não executar quando o campo de leader não está preenchido
--==================================================

local function isControlCommandText(text)
  local msg = normalizeText(text)
  if msg == "" then return false end

  local low = msg:lower()

  if low:match("^set:%s*") then return true end
  if low == "report task" then return true end
  if low:match("^task%s*:") then return true end
  if low:match("^move pos%s*:") then return true end
  if low:match("^mw in%s*:") then return true end
  if low:match("^wg in%s*:") then return true end
  if msg:match("^[Tt]ravel to:%s*") then return true end

  return false
end

local function canReadLeaderCommand(name, text)
  if not isControlCommandText(text) then return false end

  local leaderName = getLeaderNameFromFollow2()

  -- se não configurou leader no follow, ainda assim os MCs vão obedecer os comandos do painel
  if leaderName == "" then return true end

  return lowerText(name) == leaderName
end

onTalk(function(name, level, mode, text, channelId, pos)
  -- alguns OTCs retornam o default/sayChannel como 1, outros como 0/nil
  if channelId ~= 1 and channelId ~= 0 and channelId ~= nil then return end
  if not canReadLeaderCommand(name, text) then return end

  if now < lastLeaderCommand then return end
  lastLeaderCommand = now + leaderCommandDelay

  executeLeaderCommand(text)
end)

onUseWith(function(pos, itemId, target)
  if not target or not target.getPosition then return end

  if itemId == MW_RUNE_ID then
    if not isHoldMwEnabled() then return end

    local tpos = target:getPosition()
    if not tpos then return end

    local tile = g_map.getTile(tpos)
    if not tile then return end

    tile:setText("HOLD MW")
    addHoldMark(tpos, "HOLD MW")
    return
  end

  if itemId == WG_RUNE_ID then
    if not isHoldWgEnabled() then return end

    local tpos = target:getPosition()
    if not tpos then return end

    local tile = g_map.getTile(tpos)
    if not tile then return end

    tile:setText("HOLD WG")
    addHoldMark(tpos, "HOLD WG")
    return
  end
end)

onRemoveThing(function(tile, thing)
  if not tile or not thing or not thing.getId then return end

  local id = thing:getId()
  if id ~= 2129 and id ~= 2130 then return end

  local txt = tile:getText()
  if txt ~= "HOLD MW" and txt ~= "HOLD WG" then return end

  local pos = tile:getPosition()
  if not pos then return end

  local key = holdPosKey(pos)
  local current = lastHoldCastByTile[key] or 0
  lastHoldCastByTile[key] = math.max(current, now + HOLD_REMOVE_DEBOUNCE_MS)
end)

macro(20, function()
  local db = getHoldDb()

  for key, holdText in pairs(db.marks or {}) do
    local enabled = false

    if holdText == "HOLD MW" then
      enabled = isHoldMwEnabled()
    elseif holdText == "HOLD WG" then
      enabled = isHoldWgEnabled()
    end

    if enabled then
      local pos = splitHoldPosKey(key)
      if pos then
        local tile = g_map.getTile(pos)
        if tile then
          if tile:getText() ~= holdText then
            tile:setText(holdText)
          end

          if tryUseHold(tile, holdText) then
            return
          end
        end
      end
    end
  end
end)

toolsScripts = setupUI([[
MiniWindow
  id: toolsScripts
  text: Leader Control
  height: 290
  width: 175
  icon: /images/topbuttons/combatcontrols
  icon-size: 15 15

  Panel
    id: panelScripts
    anchors.fill: parent
    margin-top: 20
    margin-left: 5
    margin-right: 5
    margin-bottom: 5
    layout:
      type: verticalBox
]], g_ui.getRootWidget())
toolsScripts:hide()

g_ui.loadUIFromString([[
LeaderRow < Panel
  height: 22
  margin-top: 2

  HorizontalSeparator
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left

  Label
    id: label
    anchors.left: parent.left
    anchors.top: prev.top
    margin-top: 5
    width: 110
    color: white
    font: verdana-11px-rounded
    text: Command

  Button
    id: onBtn
    anchors.right: offBtn.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 40
    height: 18
    font: verdana-11px-rounded
    text: ON
    color: #98FB98

  Button
    id: offBtn
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 40
    height: 18
    font: verdana-11px-rounded
    text: OFF
    color: #CD5C5C

TaskCommandRow < Panel
  height: 24
  margin-top: 0

  BotTextEdit
    id: taskText
    anchors.left: parent.left
    anchors.right: sendBtn.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 4
    height: 19
    font: verdana-11px-rounded
    color: white

  Button
    id: sendBtn
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 45
    height: 18
    font: verdana-11px-rounded
    text: SEND
    color: #98FB98
    tooltip: Enviar Nome da Task para os Mcs.
]])

local saved = controlFollowStorage[MINI_WINDOW_NAME]
saved.minimized = saved.minimized == true

if saved.x and saved.y then
  toolsScripts:setX(saved.x)
  toolsScripts:setY(saved.y)
end

local normalHeight = math.max(tonumber(saved.normalHeight) or 300, 300)
local minimizedHeight = 25

local function setLeaderWindowMinimized(state)
  state = state == true

  saved.minimized = state
  saved.normalHeight = normalHeight

  if state then
    normalHeight = toolsScripts:getHeight() > minimizedHeight and toolsScripts:getHeight() or normalHeight
    saved.normalHeight = normalHeight
    toolsScripts.panelScripts:hide()
    toolsScripts:setHeight(minimizedHeight)
  else
    toolsScripts:setHeight(math.max(saved.normalHeight or 300, 300))
    toolsScripts.panelScripts:show()
  end

  saveLeaderControl()
end

toolsScripts.onGeometryChange = function(widget, oldRect, newRect)
  if oldRect.width == 0 and oldRect.height == 0 then return end

  saved.x = widget:getX()
  saved.y = widget:getY()

  if not saved.minimized then
    normalHeight = widget:getHeight()
    saved.normalHeight = normalHeight
  end

  saveLeaderControl()
end

schedule(100, function()
  setLeaderWindowMinimized(saved.minimized)
end)

local scrollBar = toolsScripts:getChildById("miniwindowScrollBar")
if scrollBar then scrollBar:hide() end

toolsScripts.closeButton.onClick = function()
  toolsScripts:hide()
end

toolsScripts.minimizeButton:setMarginLeft(23)
toolsScripts.minimizeButton.onClick = function()
  setLeaderWindowMinimized(not saved.minimized)
end

toolsScripts.lockButton:hide()

local scriptsLeaderControl = toolsScripts.panelScripts

local controls = {
  {text = "AttackBot", on = "set: AttackBot [ON]", off = "set: AttackBot [OFF]"},
  {text = "Follow",    on = "set: Follow [ON]",    off = "set: Follow [OFF]"},
  {text = "TargetBot", on = "set: TargetBot [ON]", off = "set: TargetBot [OFF]"},
  {text = "CaveBot",   on = "set: CaveBot [ON]",   off = "set: CaveBot [OFF]"},
  {text = "Hold MW",   on = "set: Hold MW [ON]",   off = "set: Hold MW [OFF]"},
  {text = "Hold WG",   on = "set: Hold WG [ON]",   off = "set: Hold WG [OFF]"},
  -- {text = "No Escape", on = "set: No Escape [ON]", off = "set: No Escape [OFF]"},
}

for i = 1, #controls do
  local cfg = controls[i]
  local row = g_ui.createWidget("LeaderRow", scriptsLeaderControl)

  row.label:setText(cfg.text)

  row.onBtn.onClick = function()
    sendLeaderCommand(cfg.on)
  end

  row.offBtn.onClick = function()
    sendLeaderCommand(cfg.off)
  end
end

local comboCountdownWidget = nil
local comboCountdownRunning = false

local function getComboCountdownWidget()
  if comboCountdownWidget and not comboCountdownWidget:isDestroyed() then
    return comboCountdownWidget
  end

  local root = g_ui.getRootWidget()
  if not root then return nil end

  comboCountdownWidget = g_ui.loadUIFromString([[
Panel
  id: comboCountdownWidget
  size: 90 21
  anchors.centerIn: parent
  margin-top: -180
  margin-left: -17

  Label
    id: text
    anchors.fill: parent
    text-align: center
    font: verdana-11px-rounded
    color: #EEC900
    text: COMBO
]], root)

  return comboCountdownWidget
end

local function showComboCountdownText(text, color)
  local widget = getComboCountdownWidget()
  if not widget then return end

  local label = widget:getChildById("text")
  if not label then return end

  label:setText(text)

  if color then
    label:setColor(color)
  end

  widget:show()
  widget:raise()
end

function startComboCountdown(kind)
  if comboCountdownRunning then return end
  comboCountdownRunning = true

  local prefix = kind == "sd" and "EXEC SD: " or "EXEC UE: "
  local lastText = kind == "sd" and "SD!!!" or "BUUUM!!!"
  local color = kind == "sd" and "#AAAAAA" or "#EEC900"
  local finalColor = kind == "sd" and "white" or "red"

  showComboCountdownText(prefix .. "3", color)

  schedule(1000, function()
    showComboCountdownText(prefix .. "2", color)

    schedule(1000, function()
      showComboCountdownText(prefix .. "1", color)

      schedule(1000, function()
        showComboCountdownText(lastText, finalColor)

        schedule(1200, function()
          if comboCountdownWidget and not comboCountdownWidget:isDestroyed() then
            comboCountdownWidget:hide()
          end
          comboCountdownRunning = false
        end)
      end)
    end)
  end)
end

local butSD = g_ui.createWidget("Button", scriptsLeaderControl)
butSD:setText("Combo SD")
butSD:setMarginTop(3)
butSD.onClick = function()
  sendLeaderCommand("set: Combo SD [ON]")
  startComboCountdown("sd")
end
butSD:setHeight(20)
butSD:setFont("verdana-11px-rounded")
butSD:setColor("#696969")

local butUE = g_ui.createWidget("Button", scriptsLeaderControl)
butUE:setText("Combo UE")
butUE.onClick = function()
  sendLeaderCommand("set: Combo UE [ON]")
  startComboCountdown("ue")
end
butUE:setHeight(20)
butUE:setMarginTop(1)
butUE:setFont("verdana-11px-rounded")
butUE:setColor("#EEC900")

local butCancelAtk = g_ui.createWidget("Button", scriptsLeaderControl)
butCancelAtk:setText("Stop Attack")
butCancelAtk.onClick = function()
  sendLeaderCommand("set: Stop Attack")
end
butCancelAtk:setHeight(20)
butCancelAtk:setMarginTop(1)
butCancelAtk:setFont("verdana-11px-rounded")
butCancelAtk:setColor("white")

local taskSeparator = g_ui.createWidget("HorizontalSeparator", scriptsLeaderControl)
taskSeparator:setHeight(2)
taskSeparator:setMarginTop(5)
taskSeparator:setMarginBottom(2)

local taskRow = g_ui.createWidget("TaskCommandRow", scriptsLeaderControl)

local taskPanelDb = getPanelDb()
taskRow.taskText:setText(taskPanelDb.texts.taskCommand or "")

taskRow.taskText.onTextChange = function(widget, text)
  local db = getPanelDb()
  db.texts.taskCommand = tostring(text or widget:getText() or "")
  saveLeaderControl()
end

taskRow.sendBtn.onClick = function()
  local taskName = formatTaskCommand(taskRow.taskText:getText())
  if taskName == "" then return end

  sendLeaderCommand("Task: " .. taskName)

  taskRow.taskText:setText("")

  local db = getPanelDb()
  db.texts.taskCommand = ""
  saveLeaderControl()
end

local butReportTask = g_ui.createWidget("Button", scriptsLeaderControl)
butReportTask:setText("Report Task")
butReportTask.onClick = function()
  sendLeaderCommand("Report Task")
end
butReportTask:setHeight(19)
butReportTask:setMarginTop(0)
butReportTask:setFont("verdana-11px-rounded")
butReportTask:setColor("#EEC900")

end)

lnsRunBlock("FOLLOW", function()
  setDefaultTab("Main")

PANEL_NAME = "lnsFollow"
SWITCH_FOLLOW = "followButton"

storage = storage or {}
storage.LNSControlFollowGlobal = storage.LNSControlFollowGlobal or {}

local followStorage = storage.LNSControlFollowGlobal

local function trim(str)
  str = tostring(str or "")
  return str:match("^%s*(.-)%s*$")
end

local defaultStrings = {386, 12202, 21965, 21966}
local defaultUse = {1948, 5542, 7771, 20475, 20573, 31262, 21297, 1968, 31130, 31129, 435, 21298}
local defaultDoors = {8265, 7727, 5111, 8261, 8259, 5113, 1646, 9567, 9558, 5287, 5289, 6260, 22506, 5122, 1112, 7712, 7721, 7723, 6258}
local defaultTeleports = {22761, 32176, 34111, 1949, 1959}

local function copyList(t)
  local r = {}
  for i, v in ipairs(t or {}) do r[i] = v end
  return r
end

local function applyDefaultIfEmpty(target, default)
  if type(target) ~= "table" or #target == 0 then
    return copyList(default)
  end
  return target
end


--==================================================
-- SHARED FOLLOW IDS STORAGE
-- Salva os IDs em: /bot/<config atual>/storage/shared/sharedFollow.json
-- Assim todos os chars que usam a mesma config leem os mesmos IDs.
--==================================================

local SHARED_FOLLOW_DIR = nil
local SHARED_FOLLOW_FILE = nil
local SharedFollowState = {
  loaded = false,
  lastSync = 0,
  lastJson = ""
}

local function getCurrentBotConfigName()
  local panel = modules and modules.game_bot and modules.game_bot.contentsPanel
  local cfg = panel and panel.config
  local opt = cfg and cfg.getCurrentOption and cfg:getCurrentOption()

  if opt and opt.text and tostring(opt.text) ~= "" then
    return tostring(opt.text)
  end

  return nil
end

local function safeFollowDirExists(path)
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

local function safeFollowMakeDir(path)
  if not path or path == "" then return false end
  if safeFollowDirExists(path) then return true end
  if not g_resources or not g_resources.makeDir then return false end

  local ok = pcall(function()
    g_resources.makeDir(path)
  end)

  if not ok then return false end
  return safeFollowDirExists(path)
end

local function safeFollowFileExists(path)
  if not path or path == "" then return false end
  if not g_resources or not g_resources.fileExists then return false end

  local ok, exists = pcall(function()
    return g_resources.fileExists(path)
  end)

  return ok and exists == true
end

local function safeFollowWriteDefaultFile(path, defaultJson)
  if not path or path == "" then return false end
  if safeFollowFileExists(path) then return true end
  if not g_resources or not g_resources.writeFileContents then return false end

  local ok = pcall(function()
    g_resources.writeFileContents(path, defaultJson or "{}")
  end)

  if not ok then return false end
  return true
end

local function initSharedFollowPath()
  if SHARED_FOLLOW_FILE then return true end

  local configName = getCurrentBotConfigName()
  if not configName or configName == "" then
    return false
  end

  -- Cria primeiro a pasta pai, depois a pasta shared, e só então cria o .json.
  -- Isso evita debug em client que não aceita read/write em arquivo inexistente.
  local baseDir = "/bot/" .. configName .. "/storage/"
  local sharedDir = baseDir .. "shared/"
  local filePath = sharedDir .. "sharedFollow.json"

  if not safeFollowMakeDir(baseDir) then return false end
  if not safeFollowMakeDir(sharedDir) then return false end
  if not safeFollowWriteDefaultFile(filePath, "{\n  \"strings\": [],\n  \"use\": [],\n  \"doorsClosed\": [],\n  \"teleports\": []\n}") then return false end

  SHARED_FOLLOW_DIR = sharedDir
  SHARED_FOLLOW_FILE = filePath
  return true
end

local function normalizeIdList(list, defaultList)
  local result = {}
  local used = {}

  if type(list) == "table" then
    for _, entry in ipairs(list) do
      local id = nil
      if type(entry) == "table" then
        id = tonumber(entry.id)
      else
        id = tonumber(entry)
      end

      if id and id > 0 and not used[id] then
        table.insert(result, id)
        used[id] = true
      end
    end
  end

  if #result == 0 and type(defaultList) == "table" then
    for _, entry in ipairs(defaultList) do
      local id = tonumber(entry)
      if id and id > 0 and not used[id] then
        table.insert(result, id)
        used[id] = true
      end
    end
  end

  return result
end

local function encodeIdArray(list)
  local result = {}
  for _, id in ipairs(normalizeIdList(list, {})) do
    table.insert(result, tostring(id))
  end
  return "[" .. table.concat(result, ",") .. "]"
end

local function encodeSharedFollow(data)
  data = data or {}
  return table.concat({
    "{\n",
    "  \"strings\": ", encodeIdArray(data.strings), ",\n",
    "  \"use\": ", encodeIdArray(data.use), ",\n",
    "  \"doorsClosed\": ", encodeIdArray(data.doorsClosed), ",\n",
    "  \"teleports\": ", encodeIdArray(data.teleports), "\n",
    "}"
  })
end

local function decodeSharedArray(text, key)
  local result = {}
  text = tostring(text or "")
  key = tostring(key or "")

  local body = text:match('"' .. key .. '"%s*:%s*%[(.-)%]')
  if not body then return result end

  for value in body:gmatch("%-?%d+") do
    local id = tonumber(value)
    if id and id > 0 then
      table.insert(result, id)
    end
  end

  return result
end

local function decodeSharedFollow(text)
  text = tostring(text or "")
  return {
    strings = decodeSharedArray(text, "strings"),
    use = decodeSharedArray(text, "use"),
    doorsClosed = decodeSharedArray(text, "doorsClosed"),
    teleports = decodeSharedArray(text, "teleports")
  }
end

local function readSharedFollowFile()
  if not initSharedFollowPath() then return nil end
  if not g_resources or not g_resources.readFileContents then return nil end

  local ok, data = pcall(function()
    return g_resources.readFileContents(SHARED_FOLLOW_FILE)
  end)

  if ok and type(data) == "string" and data ~= "" then
    SharedFollowState.lastJson = data
    return decodeSharedFollow(data)
  end

  return nil
end

local function writeSharedFollowFile(data)
  if not initSharedFollowPath() then return false end
  if not g_resources or not g_resources.writeFileContents then return false end

  local jsonText = encodeSharedFollow(data)
  local ok = pcall(function()
    g_resources.writeFileContents(SHARED_FOLLOW_FILE, jsonText)
  end)

  if ok then
    SharedFollowState.loaded = true
    SharedFollowState.lastSync = now or 0
    SharedFollowState.lastJson = jsonText
  end

  return ok == true
end

local function getSharedFollowFallback(localIds)
  localIds = localIds or {}

  return {
    strings = normalizeIdList(localIds.strings, defaultStrings),
    use = normalizeIdList(localIds.use, defaultUse),
    doorsClosed = normalizeIdList(localIds.doorsClosed, defaultDoors),
    teleports = normalizeIdList(localIds.teleports, defaultTeleports)
  }
end

local function loadSharedFollowIds(localIds)
  local shared = readSharedFollowFile()

  if not shared then
    shared = getSharedFollowFallback(localIds)
    writeSharedFollowFile(shared)
  else
    shared.strings = normalizeIdList(shared.strings, defaultStrings)
    shared.use = normalizeIdList(shared.use, defaultUse)
    shared.doorsClosed = normalizeIdList(shared.doorsClosed, defaultDoors)
    shared.teleports = normalizeIdList(shared.teleports, defaultTeleports)
  end

  SharedFollowState.loaded = true
  return shared
end

local function saveSharedFollowIds(ids)
  ids = ids or {}

  local data = {
    strings = normalizeIdList(ids.strings, defaultStrings),
    use = normalizeIdList(ids.use, defaultUse),
    doorsClosed = normalizeIdList(ids.doorsClosed, defaultDoors),
    teleports = normalizeIdList(ids.teleports, defaultTeleports)
  }

  writeSharedFollowFile(data)
  return data
end

local function applySharedFollowIdsToRuntime(data)
  if not data or not followCfg then return end

  followCfg.idsToFollow = followCfg.idsToFollow or {}
  followCfg.idsToFollow.strings = normalizeIdList(data.strings, defaultStrings)
  followCfg.idsToFollow.use = normalizeIdList(data.use, defaultUse)
  followCfg.idsToFollow.doorsClosed = normalizeIdList(data.doorsClosed, defaultDoors)
  followCfg.idsToFollow.teleports = normalizeIdList(data.teleports, defaultTeleports)

  if S then
    S.ropeIDS = followCfg.idsToFollow.strings
    S.useIDS = followCfg.idsToFollow.use
    S.doorsIDS = followCfg.idsToFollow.doorsClosed
    S.teleportIDS = followCfg.idsToFollow.teleports
  end
end

local function refreshSharedFollowIds(forceUpdateContainers)
  local data = readSharedFollowFile()
  if not data then return false end

  data.strings = normalizeIdList(data.strings, defaultStrings)
  data.use = normalizeIdList(data.use, defaultUse)
  data.doorsClosed = normalizeIdList(data.doorsClosed, defaultDoors)
  data.teleports = normalizeIdList(data.teleports, defaultTeleports)

  applySharedFollowIdsToRuntime(data)

  if forceUpdateContainers and follow2 then
    if follow2.stringsContainer then follow2.stringsContainer:setItems(followCfg.idsToFollow.strings) end
    if follow2.useContainer then follow2.useContainer:setItems(followCfg.idsToFollow.use) end
    if follow2.doorsContainer then follow2.doorsContainer:setItems(followCfg.idsToFollow.doorsClosed) end
    if follow2.teleportsContainer then follow2.teleportsContainer:setItems(followCfg.idsToFollow.teleports) end
  end

  return true
end

followStorage.follow2Panel = followStorage.follow2Panel or {
  leaderName = "",
  followerName = "",
  ueSpell = "",
  openPt = false,
  commandAttack = false,
  selectChat = "Default",
  idsToFollow = {
    strings = {},
    use = {},
    doorsClosed = {},
    teleports = {}
  }
}

followCfg = followStorage.follow2Panel
followCfg.leaderName = tostring(followCfg.leaderName or "")
followCfg.followerName = tostring(followCfg.followerName or "")
followCfg.ueSpell = tostring(followCfg.ueSpell or "")
followCfg.openPt = followCfg.openPt == true
followCfg.commandAttack = followCfg.commandAttack == true
followCfg.selectChat = tostring(followCfg.selectChat or "Default")
followCfg.enabled = followCfg.enabled == true
followCfg.isLeader = followCfg.isLeader == true
local localFollowIds = followCfg.idsToFollow or {}
followCfg.idsToFollow = loadSharedFollowIds(localFollowIds)

storage[SWITCH_FOLLOW] = storage[SWITCH_FOLLOW] or {}
storage[SWITCH_FOLLOW].enabled = followCfg.enabled
storage[SWITCH_FOLLOW].leader = followCfg.isLeader

local S = followCfg
S.texts = S.texts or {}
S.switches = S.switches or {}
S.stairIDS = S.stairIDS or {484, 17394, 1977, 414}
S.buracoIDS = S.buracoIDS or {1959}

local function syncCompat()
  S.texts.navAttack = tostring(followCfg.leaderName or "")
  S.texts.navLeader = tostring(followCfg.followerName or "")
  S.texts.UESpell = tostring(followCfg.ueSpell or "")
  S.texts.ropeID = tostring(S.texts.ropeID or "3003")

  S.switches.attackCheck = followCfg.enabled == true
  S.switches.followCheck = followCfg.enabled == true
  S.switches.useUEcheck = S.switches.useUEcheck == true
  S.switches.abrirChatParty = followCfg.openPt == true
  S.switches.debug = S.switches.debug == true

  S.ropeIDS = followCfg.idsToFollow.strings or {}
  S.useIDS = followCfg.idsToFollow.use or {}
  S.doorsIDS = followCfg.idsToFollow.doorsClosed or {}
  S.teleportIDS = followCfg.idsToFollow.teleports or {}

  storage[SWITCH_FOLLOW].enabled = followCfg.enabled == true
  storage[SWITCH_FOLLOW].leader = followCfg.isLeader == true
end

local function saveFollow2()
  syncCompat()
  storage.LNSControlFollowGlobal = followStorage
end

syncCompat()

local State = {
  leader = nil,
  leaderPositions = {},
  leaderDirections = {},
  leaderUsePositions = {},
  lastLeaderFloor = nil,
  standTime = now,
  fecharChannel = 0,
  leaderWait = 0,
  lastTarget = nil,
  lastDoorUse = 0,
  lastRopeUse = 0,
  lastUseTry = 0,
  lastWalkTry = 0,
  lastFollowTry = 0,
  lastFloorTry = 0,
  lastLeaderSeenAt = 0,
}

-- FOLLOW AGRESSIVO ENQUANTO ATACA
-- Baseado na lógica da script 2: não usa g_game.follow(),
-- só autoWalk rápido para o melhor sqm em volta do leader.
local ATTACK_WALK_INTERVAL = 180
local IDLE_FOLLOW_RETRY_MS = 900
local IDLE_AUTOWALK_RETRY_MS = 550
local IDLE_RECOVERY_RETRY_MS = 1000
local IDLE_STUCK_MS = 900

local AttackFollow = {
  lastWalk = 0,
  lastPath = 0,
  stuckCount = 0,
  lastPosKey = ""
}

local IdleFollow = {
  lastAutoWalk = 0,
  lastRecovery = 0
}

local function dbg(msg)
  if S.switches.debug then
    print("[LNS FOLLOW] " .. msg)
  end
end

local function getLeaderName()
  return trim(tostring(followCfg.followerName or ""))
end

local function getAttackLeaderName()
  return trim(tostring(followCfg.leaderName or ""))
end

local function saveFollowSetting(key, value)
  S.texts[key] = value
  saveFollow2()
end

local function safeText(id, default)
  if S.texts[id] == nil then
    S.texts[id] = default
  end
  return S.texts[id]
end

local function containsId(list, id)
  if not list then return false end
  local wanted = tonumber(id)
  if not wanted then return false end

  for _, entry in ipairs(list) do
    local entryId = nil
    if type(entry) == "table" then
      entryId = tonumber(entry.id)
    else
      entryId = tonumber(entry)
    end
    if entryId == wanted then
      return true
    end
  end
  return false
end

local function isPartyReady()
  return player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2
end

local function canRetry(lastTime, delayMs)
  return now >= (lastTime + delayMs)
end

local function resetLeaderCache()
  State.leader = nil
  State.leaderPositions = {}
  State.leaderDirections = {}
  State.leaderUsePositions = {}
  State.lastLeaderFloor = nil
  State.lastLeaderSeenAt = 0
end

local function setFollowEnabled(value)
  storage[SWITCH_FOLLOW].enabled = value
  if not value then
    g_game.cancelFollow()
    resetLeaderCache()
    dbg("Follow desligado e cache resetado.")
  end
end

local function updateToolsScripts()
  if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].leader then
    if toolsScripts then toolsScripts:show() end
  else
    if toolsScripts then toolsScripts:hide() end
  end
end

local function distanceManhattan(pos1, pos2)
  pos2 = pos2 or player:getPosition()
  return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function matchPos(p1, p2)
  return p1 and p2 and p1.x == p2.x and p1.y == p2.y and p1.z == p2.z
end

local function getVisibleLeader()
  local name = getLeaderName()
  if name == "" then return nil end

  local c = getCreatureByName(name)
  if c and c:getPosition().z == posz() then
    return c
  end
  return nil
end

local function handleUse(pos)
  if not canRetry(State.lastUseTry, 200) then return false end
  State.lastUseTry = now

  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() then
    g_game.use(tile:getTopUseThing())
    dbg("Usando tile em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
    return true
  end
  return false
end

local function handleRope(pos)
  if not canRetry(State.lastRopeUse, 300) then return false end
  State.lastRopeUse = now

  local ropeIdd = tonumber(S.texts.ropeID or "3003")
  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() and ropeIdd then
    useWith(ropeIdd, tile:getTopUseThing())
    dbg("Usando rope em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
    return true
  end
  return false
end

local function handleStep(pos)
  if not canRetry(State.lastWalkTry, 200) then return false end
  State.lastWalkTry = now
  autoWalk(pos, 40, {ignoreNonPathable=true, precision=1})
  return true
end

local function executeClosest(possibilities)
  local referencePos = State.leaderPositions[posz()] or player:getPosition()
  local closest, closestDistance = nil, 99999

  for _, data in ipairs(possibilities) do
    local dist = distanceManhattan(data.pos, referencePos)
    if dist < closestDistance then
      closest = data
      closestDistance = dist
    end
  end

  if closest then
    return closest.action(closest.pos)
  end
  return false
end

local function handleFloorChange()
  if not canRetry(State.lastFloorTry, 600) then return false end
  State.lastFloorTry = now

  local p = player:getPosition()
  local possibleChangers = {}

  local actionMap = {
    { ids = S.useIDS,      action = handleUse  },
    { ids = S.ropeIDS,     action = handleRope },
    { ids = S.stairIDS,    action = handleStep },
    { ids = S.buracoIDS,   action = handleStep },
    { ids = S.teleportIDS, action = handleStep }
  }

  for _, mapEntry in ipairs(actionMap) do
    if mapEntry.ids and #mapEntry.ids > 0 then
      for x = -2, 2 do
        for y = -2, 2 do
          local checkPos = {x = p.x + x, y = p.y + y, z = p.z}
          local tile = g_map.getTile(checkPos)
          if tile then
            local topThing = tile:getTopUseThing()
            local ground = nil
            if tile.getGround then
              ground = tile:getGround()
            end

            if (topThing and containsId(mapEntry.ids, topThing:getId())) or
               (ground and containsId(mapEntry.ids, ground:getId())) then
              table.insert(possibleChangers, {action = mapEntry.action, pos = checkPos})
            end
          end
        end
      end
    end
  end

  if #possibleChangers > 0 then
    dbg("Floor changer encontrado.")
    return executeClosest(possibleChangers)
  end

  return false
end

local function useRopeNear(pos)
  if not pos then return false end

  for x = -1, 1 do
    for y = -1, 1 do
      local tpos = {x = pos.x + x, y = pos.y + y, z = posz()}
      local tile = g_map.getTile(tpos)
      if tile and tile:getGround() and containsId(S.ropeIDS, tile:getGround():getId()) then
        if handleRope(tpos) then
          delay(getDistanceBetween(player:getPosition(), tpos) * 60)
          return true
        end
      end
    end
  end
  return false
end

local function handleUsing()
  local usePos = State.leaderUsePositions[posz()]
  if not usePos then return false end

  local useTile = g_map.getOrCreateTile(usePos)
  if useTile and useTile:getTopUseThing() then
    g_game.use(useTile:getTopUseThing())
    dbg("Usando posição do leader.")
    return true
  end
  return false
end

local function getStandTime()
  return now - State.standTime
end

local function levitate(dir)
  if not dir then return false end
  turn(dir)
  schedule(200, function()
    say('exani hur "down')
    say('exani hur "up')
  end)
  dbg("Tentando levitate.")
  return true
end

local function handleDoors()
  if not canRetry(State.lastDoorUse, 850) then return false end

  local doorIds = S.doorsIDS or {}
  local ppos = player:getPosition()
  local lpos = State.leader and State.leader:getPosition() or State.leaderPositions[posz()]
  local bestDoor = nil
  local bestLeaderDist = 99999
  local bestPlayerDist = 99999

  for x = ppos.x - 4, ppos.x + 4 do
    for y = ppos.y - 4, ppos.y + 4 do
      local pos = {x = x, y = y, z = ppos.z}
      local tile = g_map.getTile(pos)

      if tile and tile:getTopUseThing() and containsId(doorIds, tile:getTopUseThing():getId()) then
        local playerDist = getDistanceBetween(ppos, pos)
        if playerDist <= 4 then
          local leaderDist = lpos and getDistanceBetween(lpos, pos) or 99999

          if not bestDoor
            or leaderDist < bestLeaderDist
            or (leaderDist == bestLeaderDist and playerDist < bestPlayerDist) then
            bestDoor = {thing = tile:getTopUseThing(), pos = pos}
            bestLeaderDist = leaderDist
            bestPlayerDist = playerDist
          end
        end
      end
    end
  end

  if not bestDoor then return false end

  State.lastDoorUse = now
  g_game.use(bestDoor.thing)
  dbg("Abrindo porta em " .. bestDoor.pos.x .. "," .. bestDoor.pos.y .. "," .. bestDoor.pos.z)

  if lpos then
    local around = {
      {x = lpos.x + 1, y = lpos.y, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y, z = lpos.z},
      {x = lpos.x, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x, y = lpos.y - 1, z = lpos.z},
      {x = lpos.x + 1, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x + 1, y = lpos.y - 1, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y - 1, z = lpos.z},
    }

    for i = 1, #around do
      local testPos = around[i]
      local path = findPath(player:getPosition(), testPos, 20, {ignoreNonPathable=true, precision=1, ignoreCreatures=false})
      if path then
        autoWalk(testPos, 200, {ignoreNonPathable=true, precision=1})
        break
      end
    end
  end

  delay(200)
  return true
end

local function handleLeaderInteraction()
  local l = State.leader
  if not l then return false end

  local lpos = l:getPosition()
  local useIds = S.useIDS or {}

  for x = -1, 1 do
    for y = -1, 1 do
      local tpos = {x = lpos.x + x, y = lpos.y + y, z = lpos.z}
      local tile = g_map.getTile(tpos)
      if tile and tile:getTopUseThing() and containsId(useIds, tile:getTopUseThing():getId()) then
        if handleUse(tpos) then
          delay(100)
          return true
        end
      end
    end
  end

  return false
end

local function tryRecoverLeaderPath()
  local leaderPos = State.leaderPositions[posz()]
  if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
    autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=5})
    delay(300)
    dbg("Andando para última posição do leader.")
    return true
  end

  if handleLeaderInteraction() then return true end
  if handleFloorChange() then return true end

  local dir = State.leaderDirections[posz()]
  if dir then
    return levitate(dir)
  end

  if useRopeNear(leaderPos) then return true end
  if handleUsing() then return true end

  return false
end

local function ensureFollow(creature)
  if not creature then return false end

  -- Nao fica cancelando/reiniciando follow toda macro.
  -- Isso era uma das causas do boneco travar no modo sem atacar.
  if g_game.isFollowing() and g_game.getFollowingCreature() == creature then
    return false
  end

  if not canRetry(State.lastFollowTry, IDLE_FOLLOW_RETRY_MS) then return false end
  State.lastFollowTry = now

  if g_game.isFollowing() then
    g_game.cancelFollow()
  end

  g_game.follow(creature)
  dbg("Follow nativo ajustado no leader.")
  return true
end

local function idleAutoWalkTo(targetPos, precision)
  if not targetPos then return false end
  if not canRetry(IdleFollow.lastAutoWalk, IDLE_AUTOWALK_RETRY_MS) then return false end

  IdleFollow.lastAutoWalk = now
  autoWalk(targetPos, 40, {
    ignoreNonPathable = true,
    precision = tonumber(precision) or 1,
    ignoreCreatures = false
  })
  return true
end

local function followVisibleLeader(creature)
  if not creature then return false end

  local lpos = creature:getPosition()
  local myPos = player:getPosition()
  if not lpos or not myPos or lpos.z ~= myPos.z then return false end

  local dist = getDistanceBetween(myPos, lpos)
  local standMs = getStandTime()

  -- Idle usa follow nativo como base. AutoWalk so entra como catch-up,
  -- e nunca fica cancelando/religando o follow em loop.
  ensureFollow(creature)

  if dist <= 2 then
    return false
  end

  if dist >= 7 then
    idleAutoWalkTo(lpos, 2)
    return true
  end

  -- Se ficou parado e afastado, tenta destravar com porta/use/floor changer.
  -- findPath so roda nessa janela de recovery, nao a cada 200ms.
  if standMs >= IDLE_STUCK_MS and dist > 2 and canRetry(IdleFollow.lastRecovery, IDLE_RECOVERY_RETRY_MS) then
    IdleFollow.lastRecovery = now

    local path = findPath(myPos, lpos, 30, {
      ignoreNonPathable = true,
      precision = 1,
      ignoreCreatures = false
    })

    if not path then
      if handleUsing() then return true end
      if handleDoors() then return true end
      if handleFloorChange() then return true end
    end

    idleAutoWalkTo(lpos, 1)
    return true
  end

  return false
end

local function getBestAttackFollowPos(leaderPos)
  if not leaderPos or leaderPos.z ~= posz() then return nil end

  local myPos = player:getPosition()
  if not myPos then return leaderPos end

  local candidates = {
    leaderPos,
    {x = leaderPos.x + 1, y = leaderPos.y, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y, z = leaderPos.z},
    {x = leaderPos.x, y = leaderPos.y + 1, z = leaderPos.z},
    {x = leaderPos.x, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x + 1, y = leaderPos.y + 1, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x + 1, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y + 1, z = leaderPos.z}
  }

  local best = nil
  local bestDist = 999

  -- Nao usa findPath em 9 tiles a cada ciclo. Isso pesa muito.
  -- Escolhe o melhor tile walkable perto do leader e deixa o autoWalk resolver.
  for _, p in ipairs(candidates) do
    local tile = g_map.getTile(p)
    if tile and tile:isWalkable() then
      local d = getDistanceBetween(myPos, p) or 999
      if d < bestDist then
        best = p
        bestDist = d
      end
    end
  end

  return best or leaderPos
end

local function attackDoWalkTo(targetPos, precision)
  local myPos = player:getPosition()
  if not myPos or not targetPos or myPos.z ~= targetPos.z then return false end

  precision = tonumber(precision) or 1

  if getDistanceBetween(myPos, targetPos) <= precision then
    AttackFollow.stuckCount = 0
    return true
  end

  if now - AttackFollow.lastWalk < ATTACK_WALK_INTERVAL then
    return true
  end

  AttackFollow.lastWalk = now

  local walkPos = getBestAttackFollowPos(targetPos) or targetPos

  autoWalk(walkPos, 70, {
    ignoreNonPathable = true,
    ignoreCreatures = false,
    precision = 1
  })

  return false
end

local function followVisibleLeaderWhileAttacking(creature)
  if not creature then return false end

  -- IMPORTANTE: atacando não usa follow nativo.
  -- Isso evita quebrar target e deixa o MC andar agressivo igual a script 2.
  if g_game.isFollowing() then
    g_game.cancelFollow()
  end

  local lpos = creature:getPosition()
  if not lpos or lpos.z ~= posz() then return false end

  local dist = getDistanceBetween(player:getPosition(), lpos)
  if dist > 3 and canRetry(AttackFollow.lastPath, 450) then
    AttackFollow.lastPath = now
    local path = findPath(player:getPosition(), lpos, 70, {
      ignoreNonPathable = true,
      ignoreCreatures = false,
      precision = 1
    })

    if not path then
      if handleDoors() then return true end
      if handleUsing() then return true end
      if handleFloorChange() then return true end
    end
  end

  attackDoWalkTo(lpos, 1)
  dbg("Attack follow agressivo no leader.")
  return true
end

local function runFollowLogicIdle()
  if not storage[SWITCH_FOLLOW] or storage[SWITCH_FOLLOW].enabled ~= true then return end
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if g_game.isAttacking() then return end

  local leaderName = getLeaderName()
  if leaderName == "" then return end

  local c = getVisibleLeader()
  State.leader = c

  -- aqui pode usar follow normal
  if c then
    return followVisibleLeader(c)
  else
    return tryRecoverLeaderPath()
  end
end

local function runFollowLogicAttacking()
  if not storage[SWITCH_FOLLOW] or storage[SWITCH_FOLLOW].enabled ~= true then return end
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if not g_game.isAttacking() then return end

  local leaderName = getLeaderName()
  if leaderName == "" then return end

  local c = getVisibleLeader()
  State.leader = c

  -- sem leader visível: tenta recuperar caminho / floor / door
  if not c then
    local leaderPos = State.leaderPositions[posz()]
    if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
      attackDoWalkTo(leaderPos, 1)
      dbg("Andando para última posição do leader enquanto ataca.")
      return true
    end

    if handleDoors() then return true end
    if handleLeaderInteraction() then return true end
    if handleFloorChange() then return true end

    local dir = State.leaderDirections[posz()]
    if dir then
      return levitate(dir)
    end

    if useRopeNear(leaderPos) then return true end
    if handleUsing() then return true end

    return false
  end

  -- com leader visível, só reposiciona sem follow bruto
  return followVisibleLeaderWhileAttacking(c)
end


followButton = setupUI([[
Panel
  height: 35

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Follow
    color: white
    height: 18

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

  CheckBox
    id: lider
    anchors.left: title.left
    anchors.top: title.bottom
    margin-top: 2
    image-source: /images/ui/checkbox_round
    text: I'm Leader
    text-auto-resize: true
]])

followButton.title:setOn(followCfg.enabled)
followButton.lider:setChecked(followCfg.isLeader)

followButton.title.onClick = function(widget)
  followCfg.enabled = not widget:isOn()
  widget:setOn(followCfg.enabled)

  followStorage.follow2Panel.enabled = followCfg.enabled
  followStorage.followButton = followStorage.followButton or {}
  followStorage.followButton.enabled = followCfg.enabled
  storage[SWITCH_FOLLOW].enabled = followCfg.enabled

  if not followCfg.enabled then
    g_game.cancelFollow()
    if player and player.stopAutoWalk then
      pcall(function() player:stopAutoWalk() end)
    end
  end

  saveFollow2()
end

followButton.lider.onClick = function(widget)
  followCfg.isLeader = not widget:isChecked()
  widget:setChecked(followCfg.isLeader)

  if toolsScripts and not toolsScripts:isDestroyed() then
    if followCfg.isLeader then
      toolsScripts:show()
      toolsScripts:raise()
      toolsScripts:focus()
    else
      toolsScripts:hide()
    end
  end

  storage[SWITCH_FOLLOW].leader = followCfg.isLeader
  saveFollow2()
end

schedule(500, function()
  if toolsScripts and not toolsScripts:isDestroyed() then
    if followCfg.isLeader then
      toolsScripts:show()
    else
      toolsScripts:hide()
    end
  end
end)

followButton.settings.onClick = function()
  if follow2 then
    follow2:show()
    follow2:raise()
    follow2:focus()
  end
end

local function getContainerItems(widget)
  if not widget or not widget.getItems then return {} end
  local ok, items = pcall(function() return widget:getItems() end)
  if ok and type(items) == "table" then return items end
  return {}
end

--==================================================
-- MAIN FOLLOW PANEL
--==================================================

follow2 = setupUI([=[
MainWindow
  id: mainPanel
  size: 310 395
  text: Panel Follow
  margin-top: -50

  Button
    id: tabConfig
    checkable: true
    anchors.top: parent.top
    anchors.left: parent.left
    height: 33
    margin-left: -5
    width: 144
    text-align: center
    text: Follow

    UIItem
      id: idConfig
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 0
      margin-right: 8
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: tabAntired
    checkable: true
    anchors.verticalCenter: tabConfig.verticalCenter
    anchors.left: tabConfig.right
    height: 33
    margin-left: 0
    width: 145
    text-align: center
    text: IDs Follow

    UIItem
      id: idAntired
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 0
      margin-right: 8
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  FlatPanel
    id: flatConfig
    anchors.top: tabConfig.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-left: -5
    margin-top: 6
    margin-right: -5

    Label
      id: liderLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 6
      margin-left: 8
      margin-right: 8
      text: Leader Name:  

    BotTextEdit
      id: lidername
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    Label
      id: followLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Follower Name:  

    BotTextEdit
      id: followname
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    Label
      id: ueLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: UE Spell Name:  

    BotTextEdit
      id: uespell
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    HorizontalSeparator
      id: sep1
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8

    BotSwitch
      id: abrirPt
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 6
      height: 18
      text: Open PT Channel

    Panel
      id: commandLine
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 1
      height: 35

      BotSwitch
        id: comandoAttack
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 18
        text: Command Attack
        tooltip: Use this to send the attack command in the chat defined to the side (for knights or monks only).

      ComboBox
        id: selectChat
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        height: 18
        @onSetup: |
          self:addOption("Default")
          self:addOption("Party Channel")

  FlatPanel
    id: flatAntired
    anchors.top: flatConfig.top
    anchors.left: flatConfig.left
    anchors.right: flatConfig.right
    anchors.bottom: flatConfig.bottom

    FlatPanel
      id: stringsPanel
      anchors.top: parent.top
      anchors.left: parent.left
      width: 137
      height: 136
      margin-top: 6
      margin-left: 8

      Label
        id: labelStrings
        anchors.top: parent.top
        anchors.left: parent.left
        width: 82
        margin-left: 4
        margin-top: -5
        text-align: center
        color: #d7c08a
        font: verdana-11px-rounded
        text: Strings:

      BotContainer
        id: stringsContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 2
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

    FlatPanel
      id: usePanel
      anchors.top: stringsPanel.top
      anchors.left: stringsPanel.right
      anchors.right: parent.right
      height: 136
      margin-left: 6
      margin-right: 8

      Label
        id: labelUse
        anchors.top: parent.top
        anchors.left: parent.left
        width: 82
        margin-left: 4
        margin-top: -5
        text-align: center
        font: verdana-11px-rounded
        color: #d7c08a
        text: Use Ids:

      BotContainer
        id: useContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 2
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

    FlatPanel
      id: doorsPanel
      anchors.top: stringsPanel.bottom
      anchors.left: stringsPanel.left
      width: 137
      anchors.bottom: parent.bottom
      margin-top: 6
      margin-bottom: 8

      Label
        id: labelDoors
        anchors.top: parent.top
        anchors.left: parent.left
        width: 82
        margin-left: 4
        margin-top: -5
        text-align: center
        font: verdana-11px-rounded
        color: #d7c08a
        text: Doors:

      BotContainer
        id: doorsContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 2
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

    FlatPanel
      id: teleportsPanel
      anchors.top: usePanel.bottom
      anchors.left: usePanel.left
      anchors.right: usePanel.right
      anchors.bottom: parent.bottom
      margin-top: 6
      margin-bottom: 8

      Label
        id: labelTeleports
        anchors.top: parent.top
        anchors.left: parent.left
        width: 90
        margin-left: 4
        margin-top: -5
        text-align: center
        color: #d7c08a
        font: verdana-11px-rounded
        text: Teleports:

      BotContainer
        id: teleportsContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 2
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

  Button
    id: closePanel
    anchors.left: flatConfig.left
    anchors.right: flatConfig.right
    anchors.top: flatConfig.bottom
    height: 20
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())
follow2:hide()

local function WFollowPanel(root, id)
  if not root or not id then return nil end

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
        local found = WFollowPanel(childs[i], id)
        if found then return found end
      end
    end
  end

  return nil
end

local function bindFollowPanelIds()
  local ids = {
    "tabConfig", "tabAntired", "flatConfig", "flatAntired", "closePanel",
    "lidername", "followname", "uespell", "abrirPt", "comandoAttack", "selectChat",
    "stringsContainer", "useContainer", "doorsContainer", "teleportsContainer"
  }

  for i = 1, #ids do
    local id = ids[i]
    if not follow2[id] then
      follow2[id] = WFollowPanel(follow2, id)
    end
  end
end

local function showFollowWidget(widget, visible)
  if not widget then return end
  if visible then
    if widget.show then widget:show() end
  else
    if widget.hide then widget:hide() end
  end
end

local function setFollowTabPressed(button, pressed)
  if not button then return end
  showFollowWidget(WFollowPanel(button, "activeLine"), pressed)

  if button.setChecked then pcall(function() button:setChecked(pressed) end) end
  if button.setPressed then pcall(function() button:setPressed(pressed) end) end
  if button.setOn then pcall(function() button:setOn(pressed) end) end

  if button.setOpacity then button:setOpacity(pressed and 1.00 or 0.74) end
  if button.setColor then button:setColor(pressed and "#d7c08a" or "#d6d6d6") end
end

local function setFollowPanelTab(tab)
  if tab ~= "config" and tab ~= "antired" then tab = "config" end

  showFollowWidget(follow2.flatConfig, tab == "config")
  showFollowWidget(follow2.flatAntired, tab == "antired")

  setFollowTabPressed(follow2.tabConfig, tab == "config")
  setFollowTabPressed(follow2.tabAntired, tab == "antired")
end

local function setFollowIcon(widget, id)
  if widget and widget.setItemId then
    pcall(function() widget:setItemId(tonumber(id) or 0) end)
  end
end

bindFollowPanelIds()

if follow2.tabConfig and not follow2.tabConfig.idConfig then
  follow2.tabConfig.idConfig = WFollowPanel(follow2.tabConfig, "idConfig")
end

if follow2.tabAntired and not follow2.tabAntired.idAntired then
  follow2.tabAntired.idAntired = WFollowPanel(follow2.tabAntired, "idAntired")
end

setFollowIcon(follow2.tabConfig and follow2.tabConfig.idConfig, 44051)
setFollowIcon(follow2.tabAntired and follow2.tabAntired.idAntired, 1977)

if follow2.tabConfig then
  follow2.tabConfig.onClick = function()
    setFollowPanelTab("config")
  end
end

if follow2.tabAntired then
  follow2.tabAntired.onClick = function()
    setFollowPanelTab("antired")
  end
end

setFollowPanelTab("config")

if modules._G.g_app.isMobile() then
  follow2:setSize("350 505")
end

--==================================================
-- BIND MAIN PANEL
--==================================================

follow2.lidername:setText(followCfg.leaderName)
follow2.followname:setText(followCfg.followerName)
follow2.uespell:setText(followCfg.ueSpell)
follow2.abrirPt:setOn(followCfg.openPt)
follow2.comandoAttack:setOn(followCfg.commandAttack)

if follow2.selectChat.setOption then
  follow2.selectChat:setOption(followCfg.selectChat)
end

follow2.lidername.onTextChange = function(_, text)
  followCfg.leaderName = tostring(text or "")
  saveFollow2()
end

follow2.followname.onTextChange = function(_, text)
  followCfg.followerName = tostring(text or "")
  saveFollow2()
end

follow2.uespell.onTextChange = function(_, text)
  followCfg.ueSpell = tostring(text or "")
  saveFollow2()
end

follow2.abrirPt.onClick = function(widget)
  followCfg.openPt = not widget:isOn()
  widget:setOn(followCfg.openPt)
  saveFollow2()
end

follow2.comandoAttack.onClick = function(widget)
  followCfg.commandAttack = not widget:isOn()
  widget:setOn(followCfg.commandAttack)
  saveFollow2()
end

follow2.selectChat.onOptionChange = function(_, option)
  followCfg.selectChat = tostring(option or "Default")
  saveFollow2()
end

follow2.closePanel.onClick = function()
  follow2:hide()
end

--==================================================
-- BIND IDS CONTAINERS
--==================================================

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.strings = normalizeIdList(items or {}, defaultStrings)
  followCfg.idsToFollow = saveSharedFollowIds(followCfg.idsToFollow)
  saveFollow2()
end, true, nil, follow2.stringsContainer)

follow2.stringsContainer:setItems(followCfg.idsToFollow.strings)

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.use = normalizeIdList(items or {}, defaultUse)
  followCfg.idsToFollow = saveSharedFollowIds(followCfg.idsToFollow)
  saveFollow2()
end, true, nil, follow2.useContainer)

follow2.useContainer:setItems(followCfg.idsToFollow.use)

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.doorsClosed = normalizeIdList(items or {}, defaultDoors)
  followCfg.idsToFollow = saveSharedFollowIds(followCfg.idsToFollow)
  saveFollow2()
end, true, nil, follow2.doorsContainer)

follow2.doorsContainer:setItems(followCfg.idsToFollow.doorsClosed)

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.teleports = normalizeIdList(items or {}, defaultTeleports)
  followCfg.idsToFollow = saveSharedFollowIds(followCfg.idsToFollow)
  saveFollow2()
end, true, nil, follow2.teleportsContainer)

follow2.teleportsContainer:setItems(followCfg.idsToFollow.teleports)

macro(60000, function()
  -- Recarrega o sharedFollow.json para outros chars abertos pegarem alterações.
  -- Se o painel estiver aberto, não força setItems para não atrapalhar drag/drop.
  local updateContainers = follow2 and follow2.isVisible and not follow2:isVisible()
  refreshSharedFollowIds(updateContainers)
end)

macro(200, function()
  runFollowLogicIdle()
end)

macro(120, function()
  runFollowLogicAttacking()
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end

  if creature:getName() == player:getName() then
    State.standTime = now
    return
  end

  if creature:getName():lower() ~= getLeaderName():lower() then return end

  if newPos then
    State.leaderPositions[newPos.z] = newPos
    State.lastLeaderFloor = newPos.z
    State.lastLeaderSeenAt = now
    if newPos.z == posz() then
      State.leader = creature
      if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true and g_game.isAttacking() then
        attackDoWalkTo(newPos, 1)
      end
    else
      State.leader = nil
    end
  else
    State.leader = nil
  end

  if oldPos and newPos and oldPos.z ~= newPos.z then
    State.leaderDirections[oldPos.z] = creature:getDirection()
  end
end)

onCreatureAppear(function(creature)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if creature:getName():lower() == getLeaderName():lower() and creature:getPosition().z == posz() then
    State.leader = creature
    State.lastLeaderSeenAt = now
  end
end)

onCreatureDisappear(function(creature)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if creature:getName():lower() == getLeaderName():lower() then
    State.leader = nil
  end
end)

onMissle(function(missle)
  local src = missle:getSource()
  if src.z ~= posz() then return end

  local from = g_map.getTile(src)
  local to = g_map.getTile(missle:getDestination())
  if not from or not to then return end

  local fromCreatures = from:getCreatures()
  local toCreatures = to:getCreatures()
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end

  local c1 = fromCreatures[1]
  local t1 = toCreatures[1]

  local navAttack = getAttackLeaderName():lower()
  if navAttack == "" then return end
  if t1:getName():lower() == navAttack then return end

  if c1:getName():lower() == navAttack then
    if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true then
      local currentTarget = g_game.getAttackingCreature()
      if not currentTarget or currentTarget ~= t1 then
        g_game.attack(t1)
      end
    end
  end
end)

macro(1000, function()
  syncCompat()
  if S.switches.abrirChatParty ~= true then return end
  if not isPartyReady() then return end

  if not modules.game_console.getTab("Party") then
    g_game.requestChannels()
    g_game.joinChannel(1)
    State.fecharChannel = now + 2000
  end

  if State.fecharChannel > 0 and now >= State.fecharChannel then
    local w = nil

    if modules and modules.game_console then
      w = modules.game_console.channelsWindow
    end

    if not w then
      local root = g_ui.getRootWidget()
      if root and root.recursiveGetChildById then
        w = root:recursiveGetChildById("channelsWindow")
      end
    end

    if w then
      w:destroy()
      if modules and modules.game_console then
        modules.game_console.channelsWindow = nil
      end
    end

    State.fecharChannel = 0
  end
end)

local function encodeTargetId(id)
  local s = tostring(id)
  if #s >= 8 then
    local p1 = s:sub(1,1)
    local p2 = s:sub(2,3)
    local p3 = s:sub(4,4)
    local p4 = s:sub(5,6)
    local p5 = s:sub(7,8)
    local p6 = s:sub(9,10)
    return "." .. p1 .. "@" .. p2 .. "#" .. p3 .. "!" .. p4 .. "+" .. p5 .. "[" .. p6 .. "]"
  end
  return "." .. s
end

local function decodeTargetId(text)
  local digits = (text or ""):gsub("%D", "")
  if digits == "" then return nil end
  return tonumber(digits)
end

local function isKnight()
  local voc = player:getVocation()
  return voc == 1 or voc == 6
end

macro(500, function()
  if followCfg.commandAttack ~= true then return end

  if not isKnight() then return end
  if not isPartyReady() then return end

  local t = g_game.getAttackingCreature()
  if not t then return end
  if t:getPosition().z ~= posz() then return end

  if State.leaderWait >= now and State.lastTarget == t then return end
  State.lastTarget = t

  local msg = "ATACAR: " .. encodeTargetId(t:getId())

  -- só usa party channel se estiver selecionado Party Channel
  if tostring(followCfg.selectChat or "Default") == "Party Channel" then
    sayChannel(1, msg)
  else
    say(msg)
  end

  State.leaderWait = now + 8000
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId ~= 1 then return end

  local leaderName = getAttackLeaderName():lower()
  if leaderName == "" then return end
  if name:lower() ~= leaderName then return end

  local id = decodeTargetId(text)
  if not id then return end

  local target = getCreatureById(id)
  if not target then return end
  if target:getPosition().z ~= posz() then return end
  if g_game.getAttackingCreature() == target then return end

  g_game.attack(target)
end)

end)
