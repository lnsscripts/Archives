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

lnsRunBlock("SETTINGS", function()

setDefaultTab("Main")

settingsButton = setupUI([[
Panel
  height: 19
  
  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Settings and Tools
]])
settingsButton:setId(switchTravel)
    
settingsInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 220 280
  anchors.centerIn: parent
  margin-top: -50
  text: Panel Settings
  opacity: 1.00

  FlatPanel
    id: panel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -3
    margin-bottom: 20

    Button
      id: PlayerList
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 22
      margin-left: 4
      margin-right: 4
      margin-top: 5
      text: PLAYER LIST
      font: cipsoftFont

    Button
      id: vBotSettings
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: VBOT SETTINGS
      font: cipsoftFont

    Button
      id: FastTravel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: FAST TRAVEL
      font: cipsoftFont

    Button
      id: BuyMarket
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: BUYING MARKET
      font: cipsoftFont

    Button
      id: AutoImbue
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: AUTO IMBUEMENT
      font: cipsoftFont

    Button
      id: ImbueScroll
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: IMBUE SCROLL
      font: cipsoftFont

    Button
      id: HUD
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: HUD
      font: cipsoftFont

  Button
    id: closePanel
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-left: -1
    margin-top: 5
    text: Close
    color: gray

]=], g_ui.getRootWidget())
settingsInterface:hide()

if modules._G.g_app.isMobile() then
  settingsInterface:setSize("220 300")
end

settingsButton.settings.onClick = function()
  if settingsInterface:isVisible() then
    settingsInterface:hide()
  else
    settingsInterface:show()
    settingsInterface:raise()
    settingsInterface:focus()
  end
end
settingsInterface.panel.FastTravel.onClick = function()
  travelInterface:show()
  travelInterface:raise()
  travelInterface:focus()
end
settingsInterface.panel.vBotSettings.onClick = function()
  extrasWindow:show()
  extrasWindow:raise()
  extrasWindow:focus()
end
settingsInterface.panel.PlayerList.onClick = function()
  ListWindow:show()
  ListWindow:raise()
  ListWindow:focus()
end
settingsInterface.panel.AutoImbue.onClick = function()
  rebuildMainList()
  panelImbuiment:show()
  panelImbuiment:raise()
  panelImbuiment:focus()
end
settingsInterface.panel.ImbueScroll.onClick = function()
  panelScrollImbue:show()
  panelScrollImbue:raise()
  panelScrollImbue:focus()
end
settingsInterface.panel.BuyMarket.onClick = function()
  marketInterface:show()
  marketInterface:raise()
  marketInterface:focus()
end
settingsInterface.panel.HUD.onClick = function()
  hudInterface:show()
  hudInterface:raise()
  hudInterface:focus()
end
settingsInterface.closePanel.onClick = function()
  settingsInterface:hide()
end


------------------------------
--------UTILITARIOS
------------------------------

settingsButton = setupUI([[
Panel
  height: 19
  
  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Utilitys Scripts
]])
settingsButton:setId(switchTravel)

-- ============================================================
-- UTILITYS PANEL + STORAGE GLOBAL
-- ============================================================

storage = storage or {}
storage.LNSSettingsGlobal = storage.LNSSettingsGlobal or {}

local settingsStorage = storage.LNSSettingsGlobal

local UTILITY_STORAGE = "utilityPanel"

settingsStorage[UTILITY_STORAGE] = settingsStorage[UTILITY_STORAGE] or {
  proximaBp = false,

  HoldTarget = false,
  SummonF = false,
  SuperDash = false,
  Dancing = false,
  HoldPosition = false,
  SleepMode = false,
  EsconderSprites = false,
  EsconderTextos = false,
  AutoMount = false,
  AutoBan = false,
  ExetaRes = false,
  ExetaLoot = false,
  AmpRes = false,
  WallHugger = false,
  autoAol = false,
  esconderAndares = false,
  dashMouse = false,
  utevoLux = false,
  manaTrain = false,
  manaTrainMage = false,

  textutevoLux = "Utevo Lux",
  textManaTrain = "",
  textManaTrainMage = "23373",

  proximaBpID = {{id = 2854}},

  LootChest = false,
  lootAll = false,
  lootBackpackId = 2854,
  rewardChestId = 19250,
  rewardContainerId = 19202,
  maxOpennedContainers = 5,
  lootRewardDelay = 50,
  itemsToLoot = {3031, 3043}
}

local utilCfg = settingsStorage[UTILITY_STORAGE]

local function saveUtilitys()
  storage.LNSSettingsGlobal = settingsStorage
end

local function normalizeContainerItems(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = type(entry) == "table" and entry.id or entry
    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, {id = id})
    end
  end
  return r
end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = type(entry) == "table" and entry.id or entry
    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end
  return r
end

local function safeSetItem(widget, id)
  if not widget then return end
  id = tonumber(id) or 0
  if id > 0 and widget.setItemId then
    widget:setItemId(id)
  elseif id > 0 and widget.setItem then
    widget:setItem(id)
  end
end

local function safeGetItem(widget)
  if not widget then return 0 end
  if widget.getItemId then
    return tonumber(widget:getItemId()) or 0
  end
  if widget.getItem then
    local it = widget:getItem()
    if it and it.getId then
      return tonumber(it:getId()) or 0
    end
  end
  return 0
end

-- ============================================================
-- UI
-- ============================================================

utilityInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 478 335
  border: 1 black
  anchors.centerIn: parent
  margin-top: -50
  text: LNS Custom | Utilitys

  FlatPanel
    id: flatp2
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: closePanel.top
    width: 292
    margin: -5
    margin-top: 2
    margin-bottom: 6
    padding: 6

    BotSwitch
      id: HoldTarget
      anchors.top: parent.top
      anchors.left: parent.left
      size: 135 18
      text: Hold Target
      margin-top: 2

    BotSwitch
      id: SummonF
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Summon Familiar
      margin-top: 5

    BotSwitch
      id: SuperDash
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Super Dash
      margin-top: 5

    BotSwitch
      id: Dancing
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Dancing
      margin-top: 5

    BotSwitch
      id: HoldPosition
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hold Position
      margin-top: 5

    BotSwitch
      id: SleepMode
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Sleep Mode
      margin-top: 5

    BotSwitch
      id: EsconderSprites
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Sprites
      margin-top: 5

    BotSwitch
      id: EsconderTextos
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Texts
      margin-top: 5

    BotSwitch
      id: AutoMount
      anchors.top: parent.top
      anchors.left: HoldTarget.right
      size: 135 18
      text: Auto Mount
      margin-left: 10
      margin-top: 2

    BotSwitch
      id: AutoBan
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Ban Cast
      margin-top: 5

    BotSwitch
      id: ExetaRes
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Exeta Res
      margin-top: 5

    BotSwitch
      id: ExetaLoot
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Exeta Loot
      margin-top: 5

    BotSwitch
      id: AmpRes
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Amp Res
      margin-top: 5

    BotSwitch
      id: WallHugger
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Wall Hugger
      margin-top: 5

    BotSwitch
      id: esconderAndares
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Floors
      margin-top: 5

    BotSwitch
      id: dashMouse
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Dash Mouse
      margin-top: 5

    BotSwitch
      id: autoAol
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Auto Aol
      margin-top: 5

    BotSwitch
      id: utevoLux
      anchors.top: autoAol.bottom
      anchors.left: autoAol.left
      size: 135 18
      text: Utevo Lux
      margin-top: 5

    BotTextEdit
      id: textutevoLux
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      text: Utevo Lux

    BotSwitch
      id: manaTrain
      anchors.top: EsconderTextos.bottom
      anchors.left: EsconderTextos.left
      size: 135 18
      text: Mana Train
      margin-top: 5

    BotTextEdit
      id: textManaTrain
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      tooltip: Exura gran san

    BotSwitch
      id: manaTrainMage
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Trainer ED/MS
      margin-top: 5

    BotTextEdit
      id: textManaTrainMage
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      text: 23373

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.left: flatp2.right
    anchors.right: parent.right
    anchors.bottom: closePanel.top
    margin-top: 2
    margin-left: 8
    margin-right: -5
    margin-bottom: 6
    padding: 6

    BotSwitch
      id: proximaBp
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 18
      text: Open Next BP
      margin-top: 2
      text-align: center

    Panel
      id: containersBp
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 70
      margin-top: 5
      border: 1 #444444
      background-color: #111111
      opacity: 0.85

    HorizontalSeparator
      id: hsep
      anchors.top: prev.bottom
      anchors.left: proximaBp.left
      anchors.right: proximaBp.right
      margin-top: 5

    BotSwitch
      id: LootChest
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      height: 18
      margin-right: 40
      text: Loot Chest
      margin-top: 8
      text-align: center

    BotSwitch
      id: lootAll
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: hsep.right
      height: 18
      text: All
      margin-top: 0
      margin-left: 2
      text-align: center

    Label
      id: idlootbp
      anchors.top: prev.bottom
      anchors.left: LootChest.left
      text: ID Backpack:
      margin-top: 10
      text-auto-resize: true

    BotItem
      id: lootBp
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: lootAll.right
      margin-top: 2
      size: 30 30

    Label
      id: idReward
      anchors.top: idlootbp.bottom
      anchors.left: idlootbp.left
      text: ID Reward Bag:
      margin-top: 18
      text-auto-resize: true

    BotItem
      id: rewardChest
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: lootAll.right
      margin-top: 2
      size: 30 30

    Panel
      id: containerItemstoloot
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 68
      margin-top: 2
      border: 1 #444444
      background-color: #111111
      opacity: 0.85

  Button
    id: closePanel
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 20
    margin-left: -5
    margin-right: -5
    margin-bottom: -2
    text: Close
    color: gray
]], g_ui.getRootWidget())

utilityInterface:hide()

if modules._G.g_app.isMobile() then
  utilityInterface:setSize("478 355")
end

utilityInterface.closePanel.onClick = function()
  utilityInterface:hide()
end

settingsButton.settings.onClick = function()
  utilityInterface:show()
  utilityInterface:raise()
  utilityInterface:focus()
end

-- ============================================================
-- BINDS
-- ============================================================

local function bindSwitch(widget, key)
  if not widget then return end
  utilCfg[key] = utilCfg[key] == true
  widget:setOn(utilCfg[key])

  widget.onClick = function(w)
    utilCfg[key] = not utilCfg[key]
    w:setOn(utilCfg[key])
    saveUtilitys()
  end
end

local function bindText(widget, key, defaultText)
  if not widget then return end
  if utilCfg[key] == nil then utilCfg[key] = defaultText or "" end
  widget:setText(tostring(utilCfg[key] or ""))

  widget.onTextChange = function(_, text)
    utilCfg[key] = tostring(text or "")
    saveUtilitys()
  end
end

local function bindBotItem(widget, key, defaultId)
  if not widget then return end

  local id = tonumber(utilCfg[key] or 0) or 0
  if id <= 0 then
    id = tonumber(defaultId or 0) or 0
    utilCfg[key] = id
    saveUtilitys()
  end

  safeSetItem(widget, id)

  widget.onItemChange = function(w)
    utilCfg[key] = safeGetItem(w)
    saveUtilitys()
  end
end

bindSwitch(utilityInterface.flatp.proximaBp, "proximaBp")
bindSwitch(utilityInterface.flatp.LootChest, "LootChest")
bindSwitch(utilityInterface.flatp.lootAll, "lootAll")

bindSwitch(utilityInterface.flatp2.HoldTarget, "HoldTarget")
bindSwitch(utilityInterface.flatp2.SummonF, "SummonF")
bindSwitch(utilityInterface.flatp2.SuperDash, "SuperDash")
bindSwitch(utilityInterface.flatp2.Dancing, "Dancing")
bindSwitch(utilityInterface.flatp2.HoldPosition, "HoldPosition")
bindSwitch(utilityInterface.flatp2.SleepMode, "SleepMode")
bindSwitch(utilityInterface.flatp2.EsconderSprites, "EsconderSprites")
bindSwitch(utilityInterface.flatp2.EsconderTextos, "EsconderTextos")
bindSwitch(utilityInterface.flatp2.AutoMount, "AutoMount")
bindSwitch(utilityInterface.flatp2.AutoBan, "AutoBan")
bindSwitch(utilityInterface.flatp2.ExetaRes, "ExetaRes")
bindSwitch(utilityInterface.flatp2.ExetaLoot, "ExetaLoot")
bindSwitch(utilityInterface.flatp2.AmpRes, "AmpRes")
bindSwitch(utilityInterface.flatp2.WallHugger, "WallHugger")
bindSwitch(utilityInterface.flatp2.autoAol, "autoAol")
bindSwitch(utilityInterface.flatp2.esconderAndares, "esconderAndares")
bindSwitch(utilityInterface.flatp2.dashMouse, "dashMouse")
bindSwitch(utilityInterface.flatp2.utevoLux, "utevoLux")
bindSwitch(utilityInterface.flatp2.manaTrain, "manaTrain")
bindSwitch(utilityInterface.flatp2.manaTrainMage, "manaTrainMage")

bindText(utilityInterface.flatp2.textutevoLux, "textutevoLux", "Utevo Lux")
bindText(utilityInterface.flatp2.textManaTrain, "textManaTrain", "")
bindText(utilityInterface.flatp2.textManaTrainMage, "textManaTrainMage", "23373")

bindBotItem(utilityInterface.flatp.lootBp, "lootBackpackId", 2854)
bindBotItem(utilityInterface.flatp.rewardChest, "rewardContainerId", 19202)

-- ============================================================
-- CONTAINER: OPEN NEXT BP
-- ============================================================

utilCfg.proximaBpID = normalizeContainerItems(utilCfg.proximaBpID or {{id = 2854}})

local nextBpContainer = UI.ContainerEx(function(_, items)
  utilCfg.proximaBpID = normalizeContainerItems(items)
  saveUtilitys()
end, true, utilityInterface.flatp.containersBp)

nextBpContainer:setHeight(46)
nextBpContainer:setItems(utilCfg.proximaBpID)
nextBpContainer:setParent(utilityInterface.flatp.containersBp)
nextBpContainer:fill('parent')

local function getNextBpIdList()
  return properTable(utilCfg.proximaBpID or {})
end

-- ============================================================
-- CONTAINER: ITEMS TO LOOT
-- ============================================================

utilCfg.itemsToLoot = normalizeContainerItems(utilCfg.itemsToLoot or {3031, 3043})

local itemsToLootContainer = UI.ContainerEx(function(_, items)
  utilCfg.itemsToLoot = normalizeContainerItems(items)
  saveUtilitys()
end, true, utilityInterface.flatp.containerItemstoloot)

itemsToLootContainer:setHeight(55)
itemsToLootContainer:setItems(utilCfg.itemsToLoot)
itemsToLootContainer:setParent(utilityInterface.flatp.containerItemstoloot)
itemsToLootContainer:fill('parent')

local function getLootItemsIds()
  return properTable(utilCfg.itemsToLoot or {})
end

-- ============================================================
-- MACRO: OPEN NEXT BP
-- ============================================================
macro(1000, function()
  if utilCfg.proximaBp ~= true then return end

  local containerIds = getNextBpIdList()
  if #containerIds == 0 then return end

  for _, container in pairs(getContainers()) do
    local containerItem = container:getContainerItem()
    if containerItem and table.contains(containerIds, containerItem:getId()) then
      if container:getCapacity() == #container:getItems() then
        for _, item in ipairs(container:getItems()) do
          if table.contains(containerIds, item:getId()) then
            g_game.open(item, container)
            delay(200)
            return
          end
        end
      end
    end
  end
end)

-- ============================================================
-- LOOT REWARD CHEST
-- ============================================================

local containerItemlist = {}

local function printMessage(msg)
  modules.game_textmessage.displayGameMessage(msg)
end

local function closeAll()
  for _, container in pairs(getContainers()) do
    g_game.close(container)
  end
end

local function getRewardChestContainer()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      return container
    end
  end
  return nil
end

local function pushContainer(containerItem)
  table.insert(containerItemlist, containerItem)
end

local function popContainer()
  table.remove(containerItemlist, 1)
end

local function openNext()
  local cItem = containerItemlist[1]
  if cItem then
    popContainer()
    g_game.open(cItem)
    return true
  end
  return false
end

local function isContainerInLastPage(container)
  if not container then return true end
  local currentPage = 1 + math.floor(container:getFirstIndex() / container:getCapacity())
  local pages = 1 + math.floor(math.max(0, (container:getSize() - 1)) / container:getCapacity())
  return currentPage == pages
end

local function nextContainerPage(container)
  if not container or not container.window then return end
  local nextPageButton = container.window:recursiveGetChildById('nextPageButton')
  if nextPageButton and nextPageButton.onClick then
    nextPageButton.onClick()
  end
end

local function canCloseRewardContainer(container)
  local lootItemsIds = getLootItemsIds()

  if utilCfg.lootAll == true then
    if #container:getItems() >= 1 then
      return false
    end
  end

  for _, item in ipairs(container:getItems()) do
    if table.find(lootItemsIds, item:getId()) then
      return false
    end
  end

  if container:hasPages() and not isContainerInLastPage(container) then
    nextContainerPage(container)
    return false
  end

  container:getContainerItem().isChecked = true
  container:getContainerItem():hide()
  return true
end

local function closeCheckedContainers()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardContainerId or 19202) and canCloseRewardContainer(container) then
      g_game.close(container)
    end
  end
end

local function addContainersTolist()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      for _, item in ipairs(container:getItems()) do
        if item:isContainer() and not item.isAdded then
          item.isAdded = true
          pushContainer(item)
        end
      end
    end
  end
end

local function hasLootedAll()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardContainerId or 19202) then
      if utilCfg.lootAll == true and #container:getItems() > 1 then
        return false
      else
        for _, item in ipairs(container:getItems()) do
          if table.find(getLootItemsIds(), item:getId()) then
            return false
          end
        end
      end
    end
  end
  return true
end

local function finished()
  return #containerItemlist == 0 and hasLootedAll()
end

local function isRewardChestOpen()
  return getRewardChestContainer()
end

local function findAndOpenRewardChest()
  for _, tile in ipairs(g_map.getTiles(posz())) do
    local topT = tile:getTopThing()
    if topT and topT.getId and topT:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      g_game.open(topT)
      return true
    end
  end
  return false
end

local function openBack()
  if getBack() then
    g_game.open(getBack())
  end
end

local function getMainBPId()
  local back = getBack()
  return back and back:getId() or 0
end

local function isContainerOpen(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == id then
      return true
    end
  end
  return false
end

local function openContainerId(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    for _, item in ipairs(container:getItems()) do
      if item:getId() == id then
        return g_game.open(item)
      end
    end
  end
end

local function isContainerFull(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == id then
      return #container:getItems() == container:getCapacity()
    end
  end
  return false
end

local function openNextBag()
  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854

  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == lootBp then
      for _, item in ipairs(container:getItems()) do
        if item:getId() == lootBp then
          g_game.open(item)
          schedule(100, function()
            g_game.close(container)
          end)
          return true
        end
      end
    end
  end

  return false
end

local lootMainDelay = 1000 + (g_game.getPing and g_game.getPing() or 0)

local m_lootReward = macro(lootMainDelay, function(m)
  if utilCfg.LootChest ~= true then return end

  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854
  local maxOpen = tonumber(utilCfg.maxOpennedContainers or 5) or 5

  if not isRewardChestOpen() then
    closeAll()
    findAndOpenRewardChest()
    delay(2000)
    return
  end

  local mainBpId = getMainBPId()
  if mainBpId > 0 and not isContainerOpen(mainBpId) then
    return openBack()
  end

  if not isContainerOpen(lootBp) then
    return openContainerId(lootBp)
  end

  if isContainerFull(lootBp) then
    if not openNextBag() then
      utilCfg.LootChest = false
      utilityInterface.flatp.LootChest:setOn(false)
      saveUtilitys()
      printMessage("Finished Looting!.")
    end
    return
  end

  closeCheckedContainers()
  addContainersTolist()

  if #getContainers() >= maxOpen then
    return
  end

  if openNext() then
    return
  elseif not isContainerInLastPage(getRewardChestContainer()) then
    return nextContainerPage(getRewardChestContainer())
  end

  if finished() then
    closeAll()
    utilCfg.LootChest = false
    utilityInterface.flatp.LootChest:setOn(false)
    saveUtilitys()
    printMessage("Finished Looting!")
  end
end)

onContainerOpen(function(container, previousContainer)
  if utilCfg.LootChest == true and container and container.window then
    container.window:setHeight(55)
  end
end)

macro(tonumber(utilCfg.lootRewardDelay or 50) or 50, function()
  if utilCfg.LootChest ~= true then return end

  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854
  local rewardBag = tonumber(utilCfg.rewardContainerId or 19202) or 19202
  local lootItemsIds = getLootItemsIds()

  local itemToMove = nil

  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == rewardBag then
      for _, item in ipairs(container:getItems()) do
        if utilCfg.lootAll == true then
          itemToMove = item
          break
        elseif table.find(lootItemsIds, item:getId()) then
          itemToMove = item
          break
        end
      end
    end
    if itemToMove then break end
  end

  if itemToMove then
    for _, container in pairs(getContainers()) do
      local cItem = container:getContainerItem()
      if cItem and cItem:getId() == lootBp then
        g_game.move(itemToMove, container:getSlotPosition(container:getItemsCount()), itemToMove:getCount())
        return
      end
    end
  end
end)

macro(50, function()
  if utilCfg.dashMouse ~= true then return end

  local tile = getTileUnderCursor()
  if not tile then return end

  local player = g_game.getLocalPlayer()
  if tile:getTopThing() == player then
    return
  end

  local thing = tile:getTopUseThing()
  if thing then
    g_game.use(thing)
  end
end)


local lastEsconderAndaresState = nil

local function getMapPanelSafe()
  if modules and modules.game_interface then
    if modules.game_interface.getMapPanel then
      return modules.game_interface.getMapPanel()
    end

    if modules.game_interface.gameMapPanel then
      return modules.game_interface.gameMapPanel
    end
  end

  return nil
end

local function applyEsconderAndares()
  local gameMapPanel = getMapPanelSafe()
  if not gameMapPanel then return end

  if utilCfg.esconderAndares == true then
    gameMapPanel:lockVisibleFloor(posz())
  else
    gameMapPanel:unlockVisibleFloor()
  end
end

onPlayerPositionChange(function(pos)
  if utilCfg.esconderAndares ~= true then return end

  local gameMapPanel = getMapPanelSafe()
  if gameMapPanel then
    gameMapPanel:lockVisibleFloor(pos.z)
  end
end)

macro(250, function()
  if lastEsconderAndaresState == utilCfg.esconderAndares then return end

  lastEsconderAndaresState = utilCfg.esconderAndares
  applyEsconderAndares()
end)

macro(30000, function()
  if utilCfg.utevoLux ~= true then return end

  local spell = tostring(utilCfg.textutevoLux or "")
  if spell == "" then return end

  say(spell)
end)

macro(500, function()
  if utilCfg.Dancing ~= true then return end
  turn(math.random(0,3))
end)

local posToHold = nil

macro(500, function()
  posToHold = posToHold or pos()
  schedule(50, function() if utilCfg.HoldPosition ~= true then posToHold = nil end end)
  if utilCfg.HoldPosition ~= true then return end
  if table.equals(posToHold, pos()) then return end
  autoWalk(posToHold, 127, {ignoreNonPathable=true, precision=2, ignoreStairs=true})
end)

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function parseTwoSpells(text)
  text = tostring(text or "")
  local a, b = text:match("^%s*([^,]+)%s*,%s*([^,]+)%s*$")
  if a then
    return trim(a), trim(b or "")
  end
  return trim(text), ""
end

local mtStep = 1
macro(1000, function()
  if utilCfg.manaTrain ~= true then return end

  local s1, s2 = parseTwoSpells(utilCfg.textManaTrain)
  if s1 == "" then return end

  if s2 == "" then
    say(s1)
    delay(500)
    return
  end

  if mtStep == 1 then
    say(s1)
    mtStep = 2
    delay(500)
  else
    say(s2)
    mtStep = 1
    delay(500)
  end
end)

local manaPercent = 30
local heal1 = "Utana Vid"
local heal2 = "Exura vita"

local train = macro(200, function()
  if utilCfg.manaTrainMage ~= true then return end

  local manaPotionId = tonumber(utilCfg.textManaTrainMage or 0) or 0
  if manaPotionId <= 0 then return end

  for i, npc in ipairs(getSpectators()) do
    if npc:isNpc() and (getDistanceBetween(pos(), npc:getPosition()) <= 5) then
      say(heal1)
      say(heal2)
    end

    if manapercent() <= manaPercent then
      usewith(manaPotionId, player)
    end
  end
end)

onTextMessage(function(mode, text)
  if utilCfg.manaTrainMage ~= true then return end

  local mp = 'Using one of ([0-9]*)'
  local re1 = regexMatch(text, mp)
  local tmp = ""

  if #re1 ~= 0 then
    tmp = tonumber(re1[1][2])

    for i, npc2 in ipairs(getSpectators()) do
      if npc2:isNpc() and (getDistanceBetween(pos(), npc2:getPosition()) <= 3) then
        if tmp <= 10 then
          local manaPotionId = tonumber(utilCfg.textManaTrainMage or 0) or 0
          if manaPotionId <= 0 then return end

          NPC.say("hi")
          schedule(1000, function() NPC.say("trade") end)
          schedule(1000, function() NPC.say("potions") end)
          schedule(1500, function() NPC.buy(manaPotionId, 300) end)
          schedule(2000, function() NPC.say("bye") end)
          schedule(2500, function() NPC.closeTrade() end)
        end
      end
    end
  end
end)

local targetID = nil

onKeyPress(function(keys)
  if keys == "Escape" and targetID then
    targetID = nil
  end
end)

macro(100, function()
  if utilCfg.HoldTarget ~= true then return end

  if target() and target():getPosition().z == posz() and not target():isNpc() then
    targetID = target():getId()
  elseif not target() then
    if not targetID then return end

    for i, spec in ipairs(getSpectators()) do
      local sameFloor = spec:getPosition().z == posz()
      local oldTarget = spec:getId() == targetID

      if sameFloor and oldTarget then
        attack(spec)
      end
    end
  end
end)

local vocationsMap = {
  [1] = "Knight", [2] = "Paladin", [3] = "Sorcerer", [4] = "Druid",
  [5] = "Monk",
  [6] = "Elite Knight", [7] = "Royal Paladin", [8] = "Master Sorcerer", [9] = "Elder Druid",
  [10] = "Exalted Monk"
}

local function getVocationType(playerObj)
  if not playerObj then return "knight" end
  local vocId = playerObj:getVocation()
  local vocName = vocationsMap[vocId] or "Unknown"

  if vocName == "Knight" or vocName == "Elite Knight" then
    return "knight"
  elseif vocName == "Paladin" or vocName == "Royal Paladin" then
    return "paladin"
  elseif vocName == "Sorcerer" or vocName == "Master Sorcerer" then
    return "sorcerer"
  elseif vocName == "Druid" or vocName == "Elder Druid" then
    return "druid"
  elseif vocName == "Monk" or vocName == "Exalted Monk" then
    return "monk"
  end

  return "knight"
end

local familiarSpellByVoc = {
  knight   = "utevo gran res eq",
  paladin  = "utevo gran res sac",
  sorcerer = "utevo gran res ven",
  druid    = " utevo gran res dru",
  monk     = "utevo gran res tio"
}

local lastSummon = 0
local summonCooldown = 1 * 60 * 1000

macro(500, function()
  if utilCfg.SummonF ~= true then return end
  if isInPz() then return end

  local playerObj = g_game.getLocalPlayer()
  if not playerObj then return end

  local vocType = getVocationType(playerObj)
  local spell = familiarSpellByVoc[vocType]
  if not spell or spell == "" then return end

  say(spell)
  delay(10000)
end)

macro(500, function()
  if utilCfg.AutoMount ~= true then return end
  if isInPz() then return end

  local outfit = player:getOutfit()
  local isMounted = outfit.mount ~= nil and outfit.mount > 0

  if not isMounted then
    player:mount()
  end
end)

local secondsToIdle = 5
local activeFPS = 60
local afkFPS = 5

function botPrintMessage(message)
  modules.game_textmessage.displayGameMessage(message)
end

local function isSameMousePos(p1, p2)
  return p1.x == p2.x and p1.y == p2.y
end

local function setAfk()
  modules.client_options.setOption("backgroundFrameRate", afkFPS)
  modules.game_interface.gameMapPanel:hide()
end

local function setActive()
  modules.client_options.setOption("backgroundFrameRate", activeFPS)
  modules.game_interface.gameMapPanel:show()
end

local lastMousePos = nil
local finalMousePos = nil
local idleCount = 0
local maxIdle = secondsToIdle * 4

macro(250, function()
  if utilCfg.SleepMode ~= true then return end

  local currentMousePos = g_window.getMousePosition()

  if finalMousePos then
    if isSameMousePos(finalMousePos, currentMousePos) then return end
    setActive()
    finalMousePos = nil
  end

  if lastMousePos and isSameMousePos(lastMousePos, currentMousePos) then
    idleCount = idleCount + 1
  else
    lastMousePos = currentMousePos
    idleCount = 0
  end

  if idleCount == maxIdle then
    setAfk()
    finalMousePos = currentMousePos
    idleCount = 0
  end
end)

onAddThing(function(tile, thing)
  if utilCfg.EsconderSprites ~= true then return end
  if thing:isEffect() then
    thing:hide()
  end
end)

onStaticText(function(thing, text)
  if utilCfg.EsconderTextos ~= true then return end
  if not text:find('says:') then
    g_map.cleanTexts()
  end
end)

onTextMessage(function(mode, text)
  if utilCfg.EsconderTextos ~= true then return end
  modules.game_textmessage.clearMessages()
  g_map.cleanTexts()
end)

macro(5000, function()
  if utilCfg.AutoBan ~= true then return end

  for _, child in ipairs(g_ui.getRootWidget():recursiveGetChildren()) do
    if child:getId() and child:getId():find("consoleLabel") then
      local text = child:getText():lower()
      text = string.sub(text, 6, #text)

      if text:find("spectator") and text:find("joined") then
        talkChannel(9, "!cast ban," .. getFirstNumberInText(text))
        child:destroy()
      end
    end
  end
end)

local wallHuggerConfig = {
  mobs = 2,
  mobDist = 7,
  chase = true,
  wallDist = 8,
  maxNearWalkableTiles = 3,

  ignoreIds = {
    [1949] = true,
  }
}

local function isIgnoredTile(tile)
  if not tile then return false end

  local things = tile:getThings()
  if not things then return false end

  for _, thing in ipairs(things) do
    if wallHuggerConfig.ignoreIds[thing:getId()] then
      return true
    end
  end

  return false
end

local s = {}

s.getNearTiles = function(pos)
  if type(pos) ~= "table" then pos = pos:getPosition() end

  local tiles = {}
  local dirs = {
      {-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}
  }

  for i = 1, #dirs do
      local tile = g_map.getTile({
          x = pos.x - dirs[i][1],
          y = pos.y - dirs[i][2],
          z = pos.z
      })
      if tile then table.insert(tiles, tile) end
  end

  return tiles
end

s.getMonsters = function(pos, range)
  if not pos or not range then return 0 end

  local monsters = 0
  for _, spec in pairs(getSpectators()) do
    if spec:isMonster() and getDistanceBetween(pos, spec:getPosition()) < range then
      monsters = monsters + 1
    end
  end

  return monsters
end

s.getWallTiles = function()
  local tiles = {}

  for _, t in ipairs(g_map.getTiles(posz())) do
    local tPos = t:getPosition()
    local dist = getDistanceBetween(pos(), tPos)

    if dist <= wallHuggerConfig.wallDist and not t:isWalkable() and not isIgnoredTile(t) then
      table.insert(tiles, t)
    end
  end

  return tiles
end

s.getNearWalkableTilesCount = function(tile)
  local c = 0

  for _, t in ipairs(s.getNearTiles(tile:getPosition())) do
    if t and t:isWalkable() then
      c = c + 1
    end
  end

  return c
end

s.getActualWalkPos = function(tile)
  local madeByVivoDibra = true
  if not tile then return nil end

  local tiles = {}
  if not madeByVivoDibra then return end

  for _, tt in ipairs(s.getNearTiles(tile:getPosition())) do
    local ttPos = tt:getPosition()

    if tt and tt:isWalkable() and not tt:getCreatures()[1] and findPath(pos(), ttPos, 50) then
      for _, t in ipairs(s.getNearTiles(ttPos)) do
        if t and t:isWalkable() then
          tt.sqmCount = (tt.sqmCount and tt.sqmCount + 1) or 1
        end
      end

      table.insert(tiles, tt)
    end
  end

  table.sort(tiles, function(x, y)
    return x.sqmCount < y.sqmCount
  end)

  local p = tiles[1] and tiles[1]:getPosition()

  for _, t in ipairs(tiles) do
    t.sqmCount = nil
  end

  return p
end

s.currentGotoPos = nil

s.setCurrentGotoPos = function()
  if s.currentGotoPos then return end

  local wallTiles = s.getWallTiles()

  for i, t in ipairs(wallTiles) do
    local c = s.getNearWalkableTilesCount(t)
    if c > wallHuggerConfig.maxNearWalkableTiles then
      table.remove(wallTiles, i)
    end
  end

  table.sort(wallTiles, function(x, y)
    local distX = getDistanceBetween(x:getPosition(), pos())
    local distY = getDistanceBetween(y:getPosition(), pos())
    return distX < distY
  end)
  
  s.currentGotoPos = s.getActualWalkPos(wallTiles[1])
end

s.walkToGoto = function()
  if s.currentGotoPos then
    local t = g_map.getTile(s.currentGotoPos)
    if t then
      t:setTimer(1000, "yellow")
    end

    autoWalk(s.currentGotoPos, 20, {precision=0, ignoreLastCreature=true})
  end
end

s.setChase = function(on)
  if wallHuggerConfig.chase then
    g_game.setChaseMode(on and 1 or 0)
  end
end

s.gotoWall = function()
  s.setChase(false)
  s.setCurrentGotoPos()
  s.walkToGoto()
end

s.proceedHunting = function()
  s.setChase(true)
  s.currentGotoPos = nil
end

s.reset = function(m)
  schedule(1000, function()
    if m.isOff() then
      s.currentGotoPos = nil
    end
  end)
end

macro(1000, function(m)
  if utilCfg.WallHugger ~= true then
    s.currentGotoPos = nil
    return
  end

  local mobs = s.getMonsters(pos(), wallHuggerConfig.mobDist)

  if mobs >= wallHuggerConfig.mobs then
    s.gotoWall()
  else
    s.proceedHunting()
  end

  s.reset(m)
end)

local exetaLootDelay = 1000
local nextExeta = 0

onCreatureDisappear(function(creature)
  if utilCfg.ExetaLoot ~= true then return end
  if nextExeta > now then return end
  if isInPz() then return end
  if not creature:isMonster() then return end

  local pos = player:getPosition()
  local mpos = creature:getPosition()

  if pos.z ~= mpos.z or getDistanceBetween(pos, mpos) > 1 then return end

  schedule(100, function()
    local tile = g_map.getTile(mpos)
    if not tile then return end

    local container = tile:getTopUseThing()
    if not container or not container:isContainer() then return end

    nextExeta = now + exetaLootDelay
    say("exeta loot")
  end)
end)

local autoAolConfig = {
  AOLId = 3057
}

macro(200, function()
  if utilCfg.autoAol ~= true then return end

  local hasAol = getNeck() and getNeck():getId() == autoAolConfig.AOLId
  if hasAol then return end

  local aol = findItem(autoAolConfig.AOLId)
  if aol then
    moveToSlot(aol, SlotNeck, 1)
  else
    say("!aol")
    delay(1000)
  end
end)


local pushKina = 0
local pushPallyMonk = 0
local exetaCD = 0

local function getVocType()
  local vocId = player:getVocation()
  if vocId == 1 or vocId == 6 then
    return "knight"
  elseif vocId == 2 or vocId == 7 then
    return "paladin"
  elseif vocId == 5 or vocId == 10 then
    return "monk"
  end

  return ""
end
local vocType = getVocType()

macro(200, function()
  if utilCfg.AmpRes ~= true then return end
  if isInPz() then return end
  if g_game.isAttacking() then

    if vocType == "knight" and (not pushKina or pushKina <= now) and mana() >= 200 then
      say("exeta amp res")
    elseif vocType == "paladin" and (not pushPallyMonk or pushPallyMonk <= now) and mana() >= 200 then
      say("exana amp res")
    elseif vocType == "monk" and (not pushPallyMonk or pushPallyMonk <= now) and mana() >= 200 then
      say("exori mas res")
    end
  end
end)

macro(200, function()
  if utilCfg.ExetaRes ~= true then return end
  if not g_game.isAttacking() then return end

  local target = g_game.getAttackingCreature()
  if not target then return end

  if distanceFromPlayer(target:getPosition()) <= 1 and manapercent() > 30 and (not exetaCD or exetaCD <= now) then
    say("exeta res")
  end
end)

onTalk(function(name, _, _, text)
  if name ~= player:getName() then return end
  text = tostring(text or ""):lower()
  if text == "exeta amp res" then
    pushKina = now + 6100
  end
  if text == "exana amp res" or text == "exori mas res" then
    pushPallyMonk = now + 15200
  end
  if text == "exeta res" or text == "Exeta Res" then
    exetaCD = now + 2500
  end
end)

BugMap = {}

local consoleTextEdit = g_ui.getRootWidget():recursiveGetChildById('consoleTextEdit')

local availableKeys = {
  ['W'] = { 0, -3 },
  ['S'] = { 0, 3 },
  ['A'] = { -3, 0 },
  ['D'] = { 3, 0 },
  ['C'] = { 3, 3 },
  ['Z'] = { -3, 3 },
  ['Q'] = { -3, -3 },
  ['E'] = { 3, -3 }
}

local function safeIsMobile()
  if g_app and type(g_app.isMobile) == "function" then
    local ok, res = pcall(function() return g_app:isMobile() end)
    if ok then return res == true end
  end
  return false
end

local isMobile = safeIsMobile()

macro(100, function()
  if utilCfg.SuperDash ~= true or isMobile then return end
  if modules.game_console:isChatEnabled() then return end

  local playerPos = pos()
  local tile

  for key, value in pairs(availableKeys) do
    if modules.corelib.g_keyboard.isKeyPressed(key) then
      playerPos.x = playerPos.x + value[1]
      playerPos.y = playerPos.y + value[2]
      tile = g_map.getTile(playerPos)
      break
    end
  end

  if not tile then return end

  g_game.use(tile:getTopUseThing())

  local item = tile:getTopUseThing()
  if item then
    g_game.useWith(item, g_game.getLocalPlayer())
    g_game.use(item)
  end
end)

local function checkPos(x, y)
  local xyz = g_game.getLocalPlayer():getPosition()
  xyz.x = xyz.x + x
  xyz.y = xyz.y + y

  local tile = g_map.getTile(xyz)
  if tile then
    return g_game.use(tile:getTopUseThing())
  end

  return false
end

macro(200, function()
  if utilCfg.SuperDash ~= true then return end

  if modules.corelib.g_keyboard.isKeyPressed('W') then
    turn(0)
  elseif modules.corelib.g_keyboard.isKeyPressed('S') then
    turn(2)
  elseif modules.corelib.g_keyboard.isKeyPressed('A') then
    turn(3)
  elseif modules.corelib.g_keyboard.isKeyPressed('D') then
    turn(1)
  end
end)

local cursorWidget = g_ui.getRootWidget():recursiveGetChildById('pointer')
if cursorWidget then
  local initialPos = {
    x = cursorWidget:getPosition().x / cursorWidget:getWidth(),
    y = cursorWidget:getPosition().y / cursorWidget:getHeight()
  }

  local availableKeys2 = {
    Up    = { 0, -6 },
    Down  = { 0,  6 },
    Left  = { -7, 0 },
    Right = { 7,  0 }
  }

  macro(100, function()
    if utilCfg.SuperDash ~= true then return end

    local myPos = pos()
    if not myPos then return end

    local keypadPos = {
      x = cursorWidget:getPosition().x / cursorWidget:getWidth(),
      y = cursorWidget:getPosition().y / cursorWidget:getHeight()
    }

    local diffPos = {
      x = initialPos.x - keypadPos.x,
      y = initialPos.y - keypadPos.y
    }

    if diffPos.y < 0.46 and diffPos.y > -0.46 then
      if diffPos.x > 0 then
        myPos.x = myPos.x + availableKeys2.Left[1]
      elseif diffPos.x < 0 then
        myPos.x = myPos.x + availableKeys2.Right[1]
      else
        return
      end
    elseif diffPos.x < 0.46 and diffPos.x > -0.46 then
      if diffPos.y > 0 then
        myPos.y = myPos.y + availableKeys2.Up[2]
      elseif diffPos.y < 0 then
        myPos.y = myPos.y + availableKeys2.Down[2]
      else
        return
      end
    else
      return
    end

    local tile = g_map.getTile(myPos)
    if not tile then return end

    local top = tile:getTopUseThing()
    if not top then return end

    g_game.use(top)
  end)
end

end)

lnsRunBlock("FAST TRAVEL", function()
setDefaultTab("Main")

storage = storage or {}
storage.LNSFastTravelGlobal = storage.LNSFastTravelGlobal or {}

local fastTravelStorage = storage.LNSFastTravelGlobal

switchTravel = "travelButton"
fastTravelStorage[switchTravel] = fastTravelStorage[switchTravel] or { enabled = false }

local STKEY = "lnsFastTravel"
fastTravelStorage[STKEY] = fastTravelStorage[STKEY] or {
  selectedNpc = "",
  npcs = {}
}
local st = fastTravelStorage[STKEY]

local function saveFastTravelGlobal()
  storage.LNSFastTravelGlobal = fastTravelStorage
  storage[switchTravel] = fastTravelStorage[switchTravel]
end

saveFastTravelGlobal()

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim(s)
end

local function sameText(a, b)
  return normalizeText(a) == normalizeText(b)
end

local function containsText(hay, needle)
  hay = normalizeText(hay)
  needle = normalizeText(needle)
  if needle == "" then return true end
  return hay:find(needle, 1, true) ~= nil
end

local function ensureNpc(name)
  name = trim(name)
  if name == "" then return nil end
  st.npcs[name] = st.npcs[name] or { cities = {} }
  st.npcs[name].cities = st.npcs[name].cities or {}
  return name
end

local function cityExists(cities, cityName)
  for _, c in ipairs(cities) do
    if sameText(c, cityName) then return true end
  end
  return false
end

local function addCityToNpc(npcName, cityName)
  npcName = trim(npcName)
  cityName = trim(cityName)
  if npcName == "" or cityName == "" then return false end
  if not st.npcs[npcName] then return false end
  local cities = st.npcs[npcName].cities
  if cityExists(cities, cityName) then return false end
  table.insert(cities, cityName)
  saveFastTravelGlobal()
  return true
end

local defaultNpcs = {
  ["Captain Bluebear"] = { cities = { "Carlin", "Ab'dendriel", "Edron", "Venore", "Port Hope", "Liberty Bay", "Yalahar", "Roshamuul", "Krailos", "Oramond", "Rangiroa", "Svargrond", "Arcadia" } },
  ["Captain Fearless"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Port Hope", "Edron", "Darashia", "Liberty Bay", "Svargrond", "Yalahar", "Gray Island", "Ankrahmun", "Issavi", "Arcadia", "Rangiroa" } },
  ["Captain Greyhound"] = { cities = { "Thais", "Ab'dendriel", "Venore", "Svargrond", "Yalahar", "Rangiroa", "Arcadia", "Edron" } },
  ["Captain Seahorse"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Venore", "Port Hope", "Ankrahmun", "Liberty Bay", "Gray Island", "Cormaya" } },
  ["Karith"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Ankrahmun", "Darashia", "Venore", "Port Hope", "Liberty Bay", "Arcadia" } },
  ["Captain Sinbeard"] = { cities = { "Darashia", "Venore", "Liberty Bay", "Port Hope", "Yalahar", "Edron" } },
  ["Petros"] = { cities = { "Venore", "Port Hope", "Liberty Bay", "Ankrahmun", "Yalahar", "Issavi", "Gray Island" } },
  ["Charles"] = { cities = { "Thais", "Darashia", "Venore", "Liberty Bay", "Ankrahmun", "Yalahar", "Edron" } },
  ["Jack Fate"] = { cities = { "Edron", "Thais", "Venore", "Darashia", "Ankrahmun", "Yalahar", "Port Hope", "Goroma", "Liberty Bay" } },
  ["Captain Seagull"] = { cities = { "Thais", "Carlin", "Venore", "Yalahar", "Edron", "Gray Island" } },
  ["Scrutinon"] = { cities = { "Ab'dendriel", "Darashia", "Edron", "Venore" } },
  ["Captain Harava"] = { cities = { "Darashia", "Krailos", "Oramond", "Venore" } },
  ["Captain Gulliver"] = { cities = { "Thais", "Edron", "Venore", "Port Hope", "Issavi", "Krailos" } },
  ["Captain Pelagia"] = { cities = { "Venore", "Edron", "Oramond", "Issavi", "Darashia" } },
  ["Captain Chelop"] = { cities = { "Thais" } },
  ["Captain Breezelda"] = { cities = { "Carlin", "Thais", "Venore", "Arcadia" } },
  ["Captain Frank"] = { cities = { "Venore" } },
  ["Captain Grenald"] = { cities = { "Carlin", "Thais", "Venore", "Yalahar", "Svargrond" } },
  ["Pemaret"] = { cities = { "Edron" } },
  ["Maris"] = { cities = { "Fenrock", "Mistrock", "Yalahar" } },
  ["Captain Cookie"] = { cities = { "Liberty Bay" } },
  ["Chemar"] = { cities = { "Farmine" } },
  ["Melian"] = { cities = { "Darashia", "Femor Hills", "Svargrond", "Issavi", "Marapur", "Edron" } },
  ["Imbul"] = { cities = { "East" } },
  ["Lorek"] = { cities = { "Banuta", "West" } },
  ["Buddel"] = { cities = { "Helheim", "Svargrond" } },
  ["Gurbasch"] = { cities = { "Gnomprona" } },
  ["Urks The Mute"] = { cities = { "Cormaya" } },
  ["Thorgrin"] = { cities = { "Cormaya" } },
  ["Eustacio"] = { cities = { "Shortcut" } },
  ["Captain Jack Rat"] = { cities = { "Sail", "Safe" } },
  ["Harlow"] = { cities = { "Yalahar", "Vengoth" } },
}

st.npcs = st.npcs or {}

for npcName, data in pairs(defaultNpcs) do
  st.npcs[npcName] = st.npcs[npcName] or { cities = {} }
  st.npcs[npcName].cities = st.npcs[npcName].cities or {}

  for _, city in ipairs(data.cities or {}) do
    if not cityExists(st.npcs[npcName].cities, city) then
      table.insert(st.npcs[npcName].cities, city)
      saveFastTravelGlobal()
    end
  end
end


travelInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 388 322
  anchors.centerIn: parent
  margin-top: -50
  text: Panel Fast-Travel
  opacity: 1.00

  FlatPanel
    id: fpanel
    anchors.fill: parent
    margin: -3
    margin-bottom: 18

  TextEdit
    id: pesquisarNPC
    anchors.top: prev.top
    anchors.left: prev.left
    width: 170
    margin-left: 5
    margin-top: 5
    placeholder: Search Npc Name

  TextList
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: prev.right
    anchors.left: prev.left
    margin-right: 10
    margin-top: 2
    height: 205
    opacity: 0.95
    vertical-scrollbar: panelMainScroll

  VerticalScrollBar
    id: panelMainScroll
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirNpcName
    anchors.top: panelMain.bottom
    anchors.left: panelMain.left
    width: 140
    margin-top: 2
    placeholder: Insert Npc Name
  
  Button
    id: buttonAdd
    anchors.top: prev.top
    anchors.right: panelMainScroll.right
    anchors.left: prev.right
    anchors.bottom: prev.bottom
    margin-left: 2
    text: +
    font: sans-bold-16px

  VerticalSeparator
    id: vertsep
    anchors.top: pesquisarNPC.top
    anchors.left: pesquisarNPC.right
    margin-left: 5
    anchors.bottom: buttonAdd.bottom

  TextList
    id: configLista
    anchors.top: pesquisarNPC.top
    anchors.right: fpanel.right
    anchors.left: prev.right
    margin-left: 3
    margin-top: 0
    margin-right: 17
    height: 230
    vertical-scrollbar: ConfigListaScroll

  VerticalScrollBar
    id: ConfigListaScroll
    anchors.top: configLista.top
    anchors.bottom: configLista.bottom
    anchors.left: configLista.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirCityName
    anchors.top: configLista.bottom
    anchors.left: configLista.left
    width: 140
    margin-top: 2
    placeholder: Insert City Name
  
  Button
    id: buttonCity
    anchors.top: prev.top
    anchors.right: ConfigListaScroll.right
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    margin-left: 2
    text: +
    font: sans-bold-16px

  Button
    id: closePanel
    anchors.left: fpanel.left
    anchors.right: fpanel.right
    anchors.top: fpanel.bottom
    margin-top: 5
    text: Close

]=], g_ui.getRootWidget())
travelInterface:hide()

travelInterface.closePanel.onClick = function()
  travelInterface:hide()
end

local npcRowTemplate = [[
UIWidget
  id: root
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
    id: npcName
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

local cityRowTemplate = [[
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
    id: cityName
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

local npcRows = {}
local cityRows = {}

local function sortNpcNames()
  local names = {}
  for npcName, _ in pairs(st.npcs) do
    table.insert(names, npcName)
  end
  table.sort(names, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
  return names
end

local function refreshCitiesForSelectedNpc()
  local list = travelInterface.configLista
  if not list then return end

  if list.destroyChildren then list:destroyChildren() end
  cityRows = {}

  local npcName = trim(st.selectedNpc or "")
  if npcName == "" or not st.npcs[npcName] then return end

  local cities = st.npcs[npcName].cities or {}
  table.sort(cities, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)

  for _, cityName in ipairs(cities) do
    local row = g_ui.loadUIFromString(cityRowTemplate, list)
    row.cityName:setText(cityName)

    row.remove.onClick = function()
      local npc = st.npcs[npcName]
      if not npc or not npc.cities then return end

      for i = #npc.cities, 1, -1 do
        if sameText(npc.cities[i], cityName) then
          table.remove(npc.cities, i)
        end
      end

      refreshCitiesForSelectedNpc()
      saveFastTravelGlobal()
    end

    table.insert(cityRows, {
      root = row,
      nameLabel = row.cityName,
      removeBtn = row.remove
    })
  end
end

local function selectNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" then
    st.selectedNpc = ""
    saveFastTravelGlobal()
    refreshCitiesForSelectedNpc()
    return
  end
  if not st.npcs[npcName] then return end

  st.selectedNpc = npcName
  saveFastTravelGlobal()
  refreshCitiesForSelectedNpc()

  for name, pack in pairs(npcRows) do
    if pack and pack.root and name == npcName then
      pack.root:focus()
    end
  end
end

local function bindNpcRowClick(row, npcName)
  row.onMouseRelease = function(widget, mousePos, button)
    if button ~= MouseLeftButton then return end
    selectNpc(npcName)
  end

  if row.npcName then
    row.npcName.onMouseRelease = function(widget, mousePos, button)
      if button ~= MouseLeftButton then return end
      selectNpc(npcName)
    end
  end

  row.onClick = function()
    selectNpc(npcName)
  end
end

local function matchesNpc(npcName, q)
  if q == "" then return true end
  return containsText(npcName, q)
end

local function filterNpcRows(query)
  local q = normalizeText(query)
  for npcName, pack in pairs(npcRows) do
    if pack and pack.root then
      if matchesNpc(npcName, q) then
        pack.root:show()
      else
        pack.root:hide()
      end
    end
  end
end

local function refreshNpcList()
  local list = travelInterface.panelMain
  if not list then return end

  if list.destroyChildren then list:destroyChildren() end
  npcRows = {}

  local names = sortNpcNames()
  for _, npcName in ipairs(names) do
    local row = g_ui.loadUIFromString(npcRowTemplate, list)
    row.npcName:setText(npcName)

    npcRows[npcName] = {
      root = row,
      nameLabel = row.npcName,
      removeBtn = row.remove
    }

    bindNpcRowClick(row, npcName)

    row.remove.onClick = function()
      if st.npcs[npcName] then st.npcs[npcName] = nil end
      if sameText(st.selectedNpc, npcName) then st.selectedNpc = "" end
      saveFastTravelGlobal()

      local currentFilter = travelInterface.pesquisarNPC and travelInterface.pesquisarNPC:getText() or ""
      refreshNpcList()
      filterNpcRows(currentFilter or "")
      refreshCitiesForSelectedNpc()
    end
  end

  if st.selectedNpc ~= "" and npcRows[st.selectedNpc] and npcRows[st.selectedNpc].root then
    npcRows[st.selectedNpc].root:focus()
  end
end

travelInterface.pesquisarNPC.onTextChange = function(_, text)
  filterNpcRows(text or "")
end

travelInterface.buttonAdd.onClick = function()
  local name = travelInterface.inserirNpcName:getText() or ""
  name = trim(name)
  if name == "" then return end

  ensureNpc(name)
  travelInterface.inserirNpcName:setText("")
  refreshNpcList()

  local q = travelInterface.pesquisarNPC:getText() or ""
  filterNpcRows(q)

  selectNpc(name)
end

travelInterface.buttonCity.onClick = function()
  local npcName = trim(st.selectedNpc or "")
  if npcName == "" then return end

  local cityName = travelInterface.inserirCityName:getText() or ""
  cityName = trim(cityName)
  if cityName == "" then return end

  local ok = addCityToNpc(npcName, cityName)
  if ok then
    travelInterface.inserirCityName:setText("")
    refreshCitiesForSelectedNpc()
  end
end

refreshNpcList()
refreshCitiesForSelectedNpc()

do
  local q = travelInterface.pesquisarNPC and travelInterface.pesquisarNPC:getText() or ""
  filterNpcRows(q or "")
end

local function nowMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function distSqm(a, b)
  if not a or not b then return 999 end
  if a.z ~= b.z then return 999 end
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function sortCities(cities)
  table.sort(cities, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
end

local function findNpcOnScreenByName(name)
  name = trim(name)
  if name == "" then return nil end

  local specs = getSpectators() or {}

  for _, cr in ipairs(specs) do
    if cr and cr.getName and cr.getPosition then
      if sameText(cr:getName(), name) then
        return cr
      end
    end
  end

  return nil
end

local function isNpcNear(name, maxDist)
  local me = g_game.getLocalPlayer()
  if not me then return false end
  local myPos = me:getPosition()
  if not myPos then return false end

  local npc = findNpcOnScreenByName(name)
  if not npc then return false end

  local npcPos = npc:getPosition()
  return distSqm(myPos, npcPos) <= (maxDist or 3)
end

local travelUII = setupUI([[
Panel
  id: travelUII
  size: 280 60
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.top: parent.top
  margin-top: 100

  MainWindow
    id: panelTravelUII
    anchors.fill: parent
    text: Fast-Travel

    Label
      id: labelTraveUII
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      margin-top: 4
      margin-left: -5
      text: Select City:
      font: verdana-11px-rounded
      text-auto-resize: true

  ComboBox
    id: TravelOptions
    anchors.top: panelTravelUII.top
    anchors.right: panelTravelUII.right
    margin-right: 15
    margin-top: 25
    width: 155
    height: 22
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
travelUII:hide()

local uiNpcName = ""
local lastCitiesKey = ""
local travelCooldownMs = 1200
local lastTravelAt = 0
local lockTravel = false

local function buildCitiesKey(cities)
  if not cities then return "" end
  local tmp = {}
  for i = 1, #cities do
    tmp[#tmp + 1] = normalizeText(cities[i])
  end
  table.sort(tmp)
  return table.concat(tmp, "|")
end

local function fillCitiesCombo(cities)
  travelUII.TravelOptions:clearOptions()
  travelUII.TravelOptions:addOption("")

  if cities and #cities > 0 then
    for i = 1, #cities do
      travelUII.TravelOptions:addOption(cities[i])
    end
  end

  if travelUII.TravelOptions.setCurrentOption then
    travelUII.TravelOptions:setCurrentOption(1)
  end
  if travelUII.TravelOptions.setText then
    travelUII.TravelOptions:setText("")
  end
end

local function showTravelUIForNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" or not st.npcs[npcName] then return end

  local cities = st.npcs[npcName].cities or {}
  sortCities(cities)

  local key = buildCitiesKey(cities)
  if uiNpcName ~= npcName or lastCitiesKey ~= key then
    fillCitiesCombo(cities)
    uiNpcName = npcName
    lastCitiesKey = key
  end

  if not travelUII:isVisible() then
    travelUII:show()
  end
end

local function hideTravelUI()
  if travelUII:isVisible() then
    travelUII:hide()
  end
  uiNpcName = ""
  lastCitiesKey = ""
end

local function doNpcTravel(npcName, city)
  npcName = trim(npcName)
  city = trim(city)

  if npcName == "" or city == "" then return end
  if lockTravel then return end

  local t = nowMs()
  if (t - lastTravelAt) < travelCooldownMs then return end
  if not isNpcNear(npcName, 3) then return end

  lockTravel = true
  lastTravelAt = t

  local nameCopy = npcName
  local cityCopy = city

  NPC.say("hi")

  schedule(250, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say(cityCopy)
    if (player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2) then
      sayChannel(1, "Travel to: " .. cityCopy)
    end
  end)

  schedule(500, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say("yes")
  end)

  schedule(750, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say("yes")
    lockTravel = false
  end)
end

local function onCitySelected(_, text)
  local city = trim(text or "")
  if city == "" then return end
  if uiNpcName == "" then return end
  doNpcTravel(uiNpcName, city)
end

travelUII.TravelOptions.onOptionChange = onCitySelected
travelUII.TravelOptions.onSelectionChange = onCitySelected
travelUII.TravelOptions.onTextChange = onCitySelected

local function isKnownTravelNpc(creature)
  if not creature or not creature.getName or not creature.getPosition then return false end

  local cname = trim(creature:getName() or "")
  if cname == "" then return false end

  for npcName, _ in pairs(st.npcs or {}) do
    if sameText(cname, npcName) then
      return npcName
    end
  end

  return false
end

macro(200, function()
  local me = g_game.getLocalPlayer()
  if not me then
    hideTravelUI()
    return
  end

  local myPos = me:getPosition()
  if not myPos then
    hideTravelUI()
    return
  end

  local bestName = ""
  local bestDist = 999

  local specs = getSpectators() or {}

  for _, cr in ipairs(specs) do
    local npcName = isKnownTravelNpc(cr)

    if npcName then
      local d = distSqm(myPos, cr:getPosition())

      if d <= 4 and d < bestDist then
        bestDist = d
        bestName = npcName
      end
    end
  end

  if bestName ~= "" then
    showTravelUIForNpc(bestName)
  else
    hideTravelUI()
  end
end)

end)

lnsRunBlock("TOOLS", function()
setDefaultTab("Tools")

UI.Separator():setMarginTop(0)

storage = storage or {}
storage.LNSToolsGlobal = storage.LNSToolsGlobal or {}

local toolsStorage = storage.LNSToolsGlobal

local function saveToolsGlobal()
  storage.LNSToolsGlobal = toolsStorage
end

local function saveMoneyTrade()
  saveToolsGlobal()
end
local function saveTradeMsg()
  saveToolsGlobal()
end
local function saveDropperItens()
  saveToolsGlobal()
end

toolsStorage.moneySystem = toolsStorage.moneySystem or {
  exchangeMoney = false,
  sendTrade = false,
  dropperEnabled = false,
  moneyItems = {3031, 3035, 3043},
  autoTradeMessage = "I'm using LNS CUSTOM | Disc: https://discord.gg/6xUheuXSak",
  dropper = {
    trashItems = {283, 284, 285},
    useItems = {21203, 14758},
    capItems = {21175}
  }
}

local cfg = toolsStorage.moneySystem

cfg.moneyItems = type(cfg.moneyItems) == "table" and cfg.moneyItems or {3031, 3035, 3043}
cfg.autoTradeMessage = cfg.autoTradeMessage or "I'm using LNS CUSTOM | Disc: https://discord.gg/6xUheuXSak"
cfg.dropper = cfg.dropper or {}
cfg.dropper.trashItems = type(cfg.dropper.trashItems) == "table" and cfg.dropper.trashItems or {283, 284, 285}
cfg.dropper.useItems = type(cfg.dropper.useItems) == "table" and cfg.dropper.useItems or {21203, 14758}
cfg.dropper.capItems = type(cfg.dropper.capItems) == "table" and cfg.dropper.capItems or {21175}

-- =========================
-- EXCHANGE MONEY
-- =========================
exchangeButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: exchangeMoney
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Exchange Money
    height: 18
    color: white
]])

exchangeButton.exchangeMoney:setOn(cfg.exchangeMoney)

exchangeButton.exchangeMoney.onClick = function(widget)
  cfg.exchangeMoney = not widget:isOn()
  widget:setOn(cfg.exchangeMoney)
  saveMoneyTrade()
end

macro(20, function()
  if not cfg.exchangeMoney then return end
  if not cfg.moneyItems[1] then return end

  for _, container in pairs(g_game.getContainers()) do
    if not container.lootContainer then
      for _, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for _, moneyId in ipairs(cfg.moneyItems) do
            local id = type(moneyId) == "table" and moneyId.id or moneyId
            if item:getId() == tonumber(id) then
              return g_game.use(item)
            end
          end
        end
      end
    end
  end
end)

local moneyContainer = UI.Container(function(widget, items)
  cfg.moneyItems = items
  saveMoneyTrade()
end, true)

moneyContainer:setHeight(35)
moneyContainer:setItems(cfg.moneyItems)

UI.Separator()

-- =========================
-- SEND TRADE MESSAGE
-- =========================
sendTrade = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Send message on trade
    height: 18
    color: white
]])

sendTrade.title:setOn(cfg.sendTrade)

sendTrade.title.onClick = function(widget)
  cfg.sendTrade = not widget:isOn()
  widget:setOn(cfg.sendTrade)
  saveTradeMsg()
end

macro(1000, function()
  if not cfg.sendTrade then return end

  local msg = tostring(cfg.autoTradeMessage or "")
  if msg:len() <= 0 then return end

  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end

  if trade then
    sayChannel(trade, msg)
    delay(30000)
  end
end)

UI.TextEdit(cfg.autoTradeMessage, function(widget, text)
  cfg.autoTradeMessage = text
  saveTradeMsg()
end)

UI.Separator()

-- =========================
-- DROPPER
-- =========================
dropper = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Dropper
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

local edit = setupUI([[
Panel
  height: 150
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Trash:

  BotContainer
    id: TrashItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Use:

  BotContainer
    id: UseItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Drop if below 150 cap:

  BotContainer
    id: CapItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32   
]])

edit:hide()

local showEdit = false
dropper.settings.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end

dropper.title:setOn(cfg.dropperEnabled)

dropper.title.onClick = function(widget)
  cfg.dropperEnabled = not widget:isOn()
  widget:setOn(cfg.dropperEnabled)
  saveDropperItens()
end

UI.Container(function()
  cfg.dropper.trashItems = edit.TrashItems:getItems()
  saveDropperItens()
end, true, nil, edit.TrashItems)
edit.TrashItems:setItems(cfg.dropper.trashItems)

UI.Container(function()
  cfg.dropper.useItems = edit.UseItems:getItems()
  saveDropperItens()
end, true, nil, edit.UseItems)
edit.UseItems:setItems(cfg.dropper.useItems)

UI.Container(function()
  cfg.dropper.capItems = edit.CapItems:getItems()
  saveDropperItens()
end, true, nil, edit.CapItems)
edit.CapItems:setItems(cfg.dropper.capItems)

local function properTable(t)
  local r = {}

  for _, entry in pairs(t or {}) do
    local id = type(entry) == "table" and entry.id or entry
    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end

  return r
end

macro(200, function()
  if not cfg.dropperEnabled then return end

  local tables = {
    properTable(cfg.dropper.capItems),
    properTable(cfg.dropper.useItems),
    properTable(cfg.dropper.trashItems)
  }

  local containers = getContainers()
  for i = 1, 3 do
    for _, container in pairs(containers) do
      for _, item in ipairs(container:getItems()) do
        for _, userItem in ipairs(tables[i]) do
          if item:getId() == userItem then
            return i == 1 and freecap() < 150 and dropItem(item) or
                   i == 2 and use(item) or
                   i == 3 and dropItem(item)
          end
        end
      end
    end
  end
end)

UI.Separator()

-- =========================
-- PARTY
-- =========================
setDefaultTab("Tools")

local panelPartyName = "autoParty"

toolsStorage[panelPartyName] = toolsStorage[panelPartyName] or {
  leaderName = "Leader",
  autoPartyList = {},
  enabled = false,
  onMove = false,
  soulider = false,
  autoShare = false,

  palavraInvite = "",
  soulider2 = false,
  minLevel = "",
  maxLevel = "",
  palavraPedirPT = "",
  pedirParty = false,
  aceitarParty = false,
  banListPlayers = {},
  selectedTab = "invite",
  maxPartyPlayers = 30,

  -- Posicao onde o char deve pedir party
  pedirPartyPos = nil,
  pedirPartyDist = 5
}

local cfgParty = toolsStorage[panelPartyName]

local function clampMaxPartyPlayers(value)
  value = tonumber(value) or 30
  value = math.floor(value)
  if value < 1 then value = 1 end
  if value > 30 then value = 30 end
  return value
end

local function clampAskPartyDist(value)
  value = tonumber(value) or 5
  value = math.floor(value)
  if value < 1 then value = 1 end
  if value > 30 then value = 30 end
  return value
end

local function getMaxPartyPlayers()
  cfgParty.maxPartyPlayers = clampMaxPartyPlayers(cfgParty.maxPartyPlayers)
  return cfgParty.maxPartyPlayers
end

local function saveAutoParty()
  saveToolsGlobal()
end

if cfgParty.onMove == nil then cfgParty.onMove = false end
if cfgParty.soulider == nil then cfgParty.soulider = false end
if cfgParty.autoShare == nil then cfgParty.autoShare = false end
if cfgParty.leaderName == nil then cfgParty.leaderName = "" end
if not cfgParty.autoPartyList then cfgParty.autoPartyList = {} end
if cfgParty.enabled == nil then cfgParty.enabled = true end

if cfgParty.palavraInvite == nil then cfgParty.palavraInvite = "" end
if cfgParty.soulider2 == nil then cfgParty.soulider2 = false end
if cfgParty.minLevel == nil then cfgParty.minLevel = "" end
if cfgParty.maxLevel == nil then cfgParty.maxLevel = "" end
if cfgParty.palavraPedirPT == nil then cfgParty.palavraPedirPT = "" end
if cfgParty.pedirParty == nil then cfgParty.pedirParty = false end
if cfgParty.aceitarParty == nil then cfgParty.aceitarParty = false end
if not cfgParty.banListPlayers then cfgParty.banListPlayers = {} end
if cfgParty.selectedTab == nil then cfgParty.selectedTab = "invite" end
if cfgParty.maxPartyPlayers == nil then cfgParty.maxPartyPlayers = 30 end
cfgParty.maxPartyPlayers = clampMaxPartyPlayers(cfgParty.maxPartyPlayers)

if cfgParty.pedirPartyDist == nil then cfgParty.pedirPartyDist = 5 end
cfgParty.pedirPartyDist = clampAskPartyDist(cfgParty.pedirPartyDist)
if type(cfgParty.pedirPartyPos) ~= "table" then
  cfgParty.pedirPartyPos = nil
else
  cfgParty.pedirPartyPos.x = tonumber(cfgParty.pedirPartyPos.x)
  cfgParty.pedirPartyPos.y = tonumber(cfgParty.pedirPartyPos.y)
  cfgParty.pedirPartyPos.z = tonumber(cfgParty.pedirPartyPos.z)
  if not cfgParty.pedirPartyPos.x or not cfgParty.pedirPartyPos.y or not cfgParty.pedirPartyPos.z then
    cfgParty.pedirPartyPos = nil
  end
end

saveAutoParty()

autopartyui = setupUI([[
Panel
  height: 18

  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    margin-right: 45
    text: Auto Party
    color: white

  Button
    id: editPlayerList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Config
    color: white

]], parent)

g_ui.loadUIFromString([[
AutoPartyName < Label
  height: 20
  focusable: true
  background-color: alpha
  opacity: 1.00
  margin-top: 1
  margin-left: 2
  padding-left: 4
  color: white
  font: verdana-11px-rounded

  $hover:
    background-color: #2F2F2F
    opacity: 0.85

  $focus:
    background-color: #404040
    opacity: 0.95

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

AutoPartyBanName < Label
  height: 20
  focusable: true
  background-color: alpha
  opacity: 1.00
  margin-top: 1
  margin-left: 2
  padding-left: 4
  color: white
  font: verdana-11px-rounded

  $hover:
    background-color: #2F2F2F
    opacity: 0.85

  $focus:
    background-color: #404040
    opacity: 0.95

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

AutoPartyListWindow < MainWindow
  text: Panel Auto Party
  size: 430 385
  anchors.centerIn: parent
  margin-top: -60

  Button
    id: tabInvite
    checkable: true
    anchors.top: parent.top
    anchors.left: parent.left
    height: 33
    margin-left: -5
    width: 134
    text-align: center
    text: Invite List

    UIItem
      id: idInvite
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -3
      margin-left: -10
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 35
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: tabSay
    checkable: true
    anchors.verticalCenter: tabInvite.verticalCenter
    anchors.left: tabInvite.right
    height: 33
    margin-left: 0
    width: 134
    text-align: center
    text: Say PT

    UIItem
      id: idSay
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -9
      margin-left: -13
      size: 36 36
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 38
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: tabBan
    checkable: true
    anchors.verticalCenter: tabSay.verticalCenter
    anchors.left: tabSay.right
    height: 33
    margin-left: 0
    width: 134
    text-align: center
    text: Ban List

    UIItem
      id: idBan
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -2
      margin-left: -8
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 35
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  FlatPanel
    id: flatInvite
    anchors.top: tabInvite.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-left: -5
    margin-top: 6
    margin-right: -5

    Label
      id: labeltxtLeader
      text: Leader Name
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: txtLeader
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 3
      margin-left: 8
      margin-right: 8
      height: 20
      placeholder: Leader name

    CheckBox
      id: soulider
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 6
      margin-left: 8
      text: I'm Leader
      text-auto-resize: true

    CheckBox
      id: creatureMove
      anchors.top: soulider.top
      anchors.left: soulider.right
      margin-left: 28
      text: Automatic Invite
      text-auto-resize: true

    CheckBox
      id: autoShare
      anchors.top: soulider.top
      anchors.left: creatureMove.right
      margin-left: 28
      text: Auto Share
      text-auto-resize: true

    HorizontalSeparator
      anchors.top: soulider.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 7
      margin-left: 8
      margin-right: 8

    Label
      text: Party Invite List
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 6
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextList
      id: lstAutoParty
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 4
      margin-left: 8
      margin-right: 15
      height: 162
      padding: 1
      vertical-scrollbar: AutoPartyListListScrollBar
      font: verdana-11px-rounded

    VerticalScrollBar
      id: AutoPartyListListScrollBar
      anchors.top: lstAutoParty.top
      anchors.bottom: lstAutoParty.bottom
      anchors.left: lstAutoParty.right
      step: 14
      pixels-scroll: true
      visible: true

    TextEdit
      id: playerName
      anchors.top: lstAutoParty.bottom
      anchors.left: parent.left
      anchors.right: addPlayer.left
      margin-top: 7
      margin-left: 8
      margin-right: 5
      height: 20
      placeholder: Player Name

    Button
      id: addPlayer
      text: +
      anchors.right: parent.right
      anchors.top: lstAutoParty.bottom
      margin-top: 7
      width: 45
      height: 20
      margin-right: 8

  FlatPanel
    id: flatSay
    anchors.top: flatInvite.top
    anchors.left: flatInvite.left
    anchors.right: flatInvite.right
    anchors.bottom: flatInvite.bottom

    Label
      text: Party Say Keyword
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: palavraInvite
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 3
      margin-left: 8
      margin-right: 8
      height: 20
      placeholder: Keyword

    CheckBox
      id: soulider2
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 6
      margin-left: 8
      text: I'm Leader
      text-auto-resize: true

    HorizontalSeparator
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 7
      margin-left: 8
      margin-right: 8

    Label
      id: lvlminimolabel
      text: Level Minimo:
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: textMinLevel
      anchors.top: prev.bottom
      anchors.left: parent.left
      width: 195
      margin-top: 3
      margin-left: 8
      height: 20
      placeholder: Level Minimum

    Label
      text: Level Maximo:
      anchors.top: lvlminimolabel.top
      anchors.left: parent.horizontalCenter
      margin-top: 0
      margin-left: 8
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: textMaxLevel
      anchors.top: prev.bottom
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 3
      margin-left: 8
      margin-right: 8
      height: 20
      placeholder: Level Maximum

    Label
      id: maxPartyPlayersLabel
      text: Max Party Players: 30
      anchors.top: textMinLevel.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    HorizontalScrollBar
      id: maxPartyPlayersScroll
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 4
      margin-left: 8
      margin-right: 8
      minimum: 1
      maximum: 30
      step: 1

    HorizontalSeparator
      anchors.top: maxPartyPlayersScroll.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 8
      margin-left: 8
      margin-right: 8

    Label
      text: Ask Party Message
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: palavraPedirPT
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 3
      margin-left: 8
      margin-right: 8
      height: 20
      placeholder: Ask for party

    CheckBox
      id: pedirParty
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 8
      text: Request Party
      text-auto-resize: true

    CheckBox
      id: aceitarParty
      anchors.top: pedirParty.top
      anchors.left: pedirParty.right
      margin-left: 36
      text: Accept Party
      text-auto-resize: true

    Label
      id: askPartyPosTitle
      text: Reference Position:
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: pedirPartyDist
      anchors.top: askPartyPosTitle.top
      anchors.right: parent.right
      margin-right: 48
      width: 120
      height: 20
      text-align: center
      font: verdana-11px-rounded
      text: 5

    Label
      id: askPartySqm
      text: sqm
      anchors.top: pedirPartyDist.top
      anchors.left: pedirPartyDist.right
      margin-left: 5
      margin-top: 3
      font: verdana-11px-rounded
      text-auto-resize: true

    Label
      id: askPartyPosText
      text: X:- Y:- Z:-
      anchors.top: askPartyPosTitle.bottom
      anchors.left: askPartyPosTitle.left
      margin-top: 4
      font: verdana-11px-rounded
      color: white
      text-auto-resize: true

    Button
      id: savePartyPos
      text: Save Position
      anchors.top: askPartyPosText.bottom
      anchors.left: askPartyPosText.left
      margin-top: 5
      width: 180
      height: 20

    Button
      id: clearPartyPos
      text: Clear Position
      anchors.top: savePartyPos.top
      anchors.left: savePartyPos.right
      anchors.right: parent.right
      margin-left: 6
      margin-right: 8
      height: 20

  FlatPanel
    id: flatBan
    anchors.top: flatInvite.top
    anchors.left: flatInvite.left
    anchors.right: flatInvite.right
    anchors.bottom: flatInvite.bottom

    Label
      text: Players Banidos
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 7
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
      id: lstBan
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 6
      margin-left: 8
      margin-right: 15
      height: 222
      padding: 1
      vertical-scrollbar: AutoPartyBanListScrollBar
      font: verdana-11px-rounded

    VerticalScrollBar
      id: AutoPartyBanListScrollBar
      anchors.top: lstBan.top
      anchors.bottom: lstBan.bottom
      anchors.left: lstBan.right
      step: 14
      pixels-scroll: true
      visible: true

    TextEdit
      id: txtBan
      anchors.left: parent.left
      anchors.top: lstBan.bottom
      anchors.right: btnAddBan.left
      margin-top: 7
      margin-left: 8
      margin-right: 5
      height: 20
      placeholder: Player Name

    Button
      id: btnAddBan
      text: +
      anchors.right: parent.right
      anchors.top: lstBan.bottom
      margin-top: 7
      width: 45
      height: 20
      margin-right: 8

  Button
    id: closePanel
    anchors.left: flatInvite.left
    anchors.right: flatInvite.right
    anchors.top: flatInvite.bottom
    margin-top: 5
    height: 20
    text: Close
]])

local rootWidget = g_ui.getRootWidget()
if rootWidget then
  tcAutoParty = autopartyui.status

  autoPartyListWindow = UI.createWindow("AutoPartyListWindow", rootWidget)
  autoPartyListWindow:hide()

  if modules._G.g_app.isMobile() then
    autoPartyListWindow:setSize("430 405")
  end

  local function WParty(root, id)
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
          local child = childs[i]
          if child and child.getId then
            local okId, childId = pcall(function() return child:getId() end)
            if okId and childId == id then return child end
          end

          local found = WParty(child, id)
          if found then return found end
        end
      end
    end

    return nil
  end

  local function showPartyWidget(widget, visible)
    if not widget then return end
    if visible then
      if widget.show then widget:show() end
    else
      if widget.hide then widget:hide() end
    end
  end

  local function setPartyTabPressed(button, pressed)
    if not button then return end
    showPartyWidget(WParty(button, "activeLine"), pressed)

    if button.setChecked then pcall(function() button:setChecked(pressed) end) end
    if button.setPressed then pcall(function() button:setPressed(pressed) end) end
    if button.setOn then pcall(function() button:setOn(pressed) end) end
    if button.setOpacity then button:setOpacity(pressed and 1.00 or 0.74) end
    if button.setColor then button:setColor(pressed and "#d7c08a" or "#d6d6d6") end
  end

  local function setPartyTab(tab)
    if tab ~= "invite" and tab ~= "say" and tab ~= "ban" then tab = "invite" end

    cfgParty.selectedTab = tab

    showPartyWidget(autoPartyListWindow.flatInvite, tab == "invite")
    showPartyWidget(autoPartyListWindow.flatSay, tab == "say")
    showPartyWidget(autoPartyListWindow.flatBan, tab == "ban")

    setPartyTabPressed(autoPartyListWindow.tabInvite, tab == "invite")
    setPartyTabPressed(autoPartyListWindow.tabSay, tab == "say")
    setPartyTabPressed(autoPartyListWindow.tabBan, tab == "ban")

    saveAutoParty()
  end

  local function setPartyIcon(widget, id)
    if widget and widget.setItemId then
      pcall(function() widget:setItemId(tonumber(id) or 0) end)
    end
  end

  local function bindPartyWindowIds()
    local ids = {
      "tabInvite", "tabSay", "tabBan",
      "flatInvite", "flatSay", "flatBan",
      "txtLeader", "soulider", "creatureMove", "autoShare",
      "lstAutoParty", "playerName", "addPlayer",
      "palavraInvite", "soulider2", "textMinLevel", "textMaxLevel",
      "palavraPedirPT", "pedirParty", "aceitarParty",
      "pedirPartyDist", "askPartyPosText", "savePartyPos", "clearPartyPos",
      "maxPartyPlayersLabel", "maxPartyPlayersScroll",
      "lstBan", "txtBan", "btnAddBan", "closePanel"
    }

    for i = 1, #ids do
      local id = ids[i]
      if not autoPartyListWindow[id] then
        autoPartyListWindow[id] = WParty(autoPartyListWindow, id)
      end
    end

    if autoPartyListWindow.tabInvite and not autoPartyListWindow.tabInvite.idInvite then
      autoPartyListWindow.tabInvite.idInvite = WParty(autoPartyListWindow.tabInvite, "idInvite")
    end

    if autoPartyListWindow.tabSay and not autoPartyListWindow.tabSay.idSay then
      autoPartyListWindow.tabSay.idSay = WParty(autoPartyListWindow.tabSay, "idSay")
    end

    if autoPartyListWindow.tabBan and not autoPartyListWindow.tabBan.idBan then
      autoPartyListWindow.tabBan.idBan = WParty(autoPartyListWindow.tabBan, "idBan")
    end
  end

  bindPartyWindowIds()

  -- Troque estes IDs se quiser outros icones nas abas.
  setPartyIcon(autoPartyListWindow.tabInvite and autoPartyListWindow.tabInvite.idInvite, 31717)
  setPartyIcon(autoPartyListWindow.tabSay and autoPartyListWindow.tabSay.idSay, 24432)
  setPartyIcon(autoPartyListWindow.tabBan and autoPartyListWindow.tabBan.idBan, 3547)

  if autoPartyListWindow.tabInvite then
    autoPartyListWindow.tabInvite.onClick = function()
      setPartyTab("invite")
    end
  end

  if autoPartyListWindow.tabSay then
    autoPartyListWindow.tabSay.onClick = function()
      setPartyTab("say")
    end
  end

  if autoPartyListWindow.tabBan then
    autoPartyListWindow.tabBan.onClick = function()
      setPartyTab("ban")
    end
  end

  setPartyTab(cfgParty.selectedTab or "invite")

  autopartyui.status.onMouseRelease = function(widget, mousePos, mouseButton)
    if mouseButton == 2 then
      if not autoPartyListWindow:isVisible() then
        autoPartyListWindow:show()
        autoPartyListWindow:raise()
        autoPartyListWindow:focus()
      else
        autoPartyListWindow:hide()
      end
    end
  end

  autopartyui.editPlayerList.onClick = function()
    autoPartyListWindow:show()
    autoPartyListWindow:raise()
    autoPartyListWindow:focus()
  end

  if autoPartyListWindow.closePanel then
    autoPartyListWindow.closePanel.onClick = function()
      autoPartyListWindow:hide()
    end
  end

  -- =========================
  -- LISTA
  -- =========================
  if cfgParty.autoPartyList and #cfgParty.autoPartyList > 0 then
    for _, pName in ipairs(cfgParty.autoPartyList) do
      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function()
        table.removevalue(cfgParty.autoPartyList, label:getText())
        label:destroy()
        saveAutoParty()
      end
      label:setText(pName)
    end
  end

  autoPartyListWindow.addPlayer.onClick = function()
    local pName = autoPartyListWindow.playerName:getText()
    if pName:len() > 0 and not (table.contains(cfgParty.autoPartyList, pName, true) or cfgParty.leaderName == pName) then
      table.insert(cfgParty.autoPartyList, pName)
      saveAutoParty()

      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function()
        table.removevalue(cfgParty.autoPartyList, label:getText())
        label:destroy()
        saveAutoParty()
      end
      label:setText(pName)
      autoPartyListWindow.playerName:setText("")
    end
  end

  autoPartyListWindow.playerName.onKeyPress = function(_, keyCode)
    if keyCode ~= 5 then return false end
    autoPartyListWindow.addPlayer.onClick()
    return true
  end

  autoPartyListWindow.playerName.onTextChange = function(_, text)
    if table.contains(cfgParty.autoPartyList, text, true) then
      autoPartyListWindow.addPlayer:setColor("#FF0000")
    else
      autoPartyListWindow.addPlayer:setColor("#FFFFFF")
    end
  end

  -- =========================
  -- ENABLE
  -- =========================
  tcAutoParty:setOn(cfgParty.enabled == true)
  tcAutoParty.onClick = function(widget)
    cfgParty.enabled = not (cfgParty.enabled == true)
    widget:setOn(cfgParty.enabled)
    saveAutoParty()
  end

  -- =========================
  -- AUTOMATIC INVITE
  -- =========================
  autoPartyListWindow.creatureMove:setChecked(cfgParty.onMove == true)
  autoPartyListWindow.creatureMove.onClick = function(widget)
    cfgParty.onMove = not (cfgParty.onMove == true)
    widget:setChecked(cfgParty.onMove)
    saveAutoParty()
  end

  -- =========================
  -- TXT LEADER
  -- =========================
  autoPartyListWindow.txtLeader.onTextChange = function(_, text)
    cfgParty.leaderName = text
    saveAutoParty()
  end
  autoPartyListWindow.txtLeader:setText(cfgParty.leaderName or "")

  -- =========================
  -- SOU LIDER
  -- =========================
  autoPartyListWindow.soulider:setChecked(cfgParty.soulider == true)

  local function applySouLider()
    if cfgParty.soulider then
      local myName = player:getName()
      cfgParty.leaderName = myName
      autoPartyListWindow.txtLeader:setText(myName)
    else
      cfgParty.leaderName = ""
      autoPartyListWindow.txtLeader:setText("")
    end
    saveAutoParty()
  end

  autoPartyListWindow.soulider.onClick = function(widget)
    cfgParty.soulider = not (cfgParty.soulider == true)
    widget:setChecked(cfgParty.soulider)
    applySouLider()
  end

  applySouLider()

  -- =========================
  -- AUTO SHAREAR
  -- =========================
  autoPartyListWindow.autoShare:setChecked(cfgParty.autoShare == true)
  autoPartyListWindow.autoShare.onClick = function(widget)
    cfgParty.autoShare = not (cfgParty.autoShare == true)
    widget:setChecked(cfgParty.autoShare)
    saveAutoParty()
  end

  macro(2000, function()
    if not tcAutoParty:isOn() then return end
    if cfgParty.autoShare then
      if player:isPartyLeader() then
        if not player:isPartySharedExperienceActive() then
          g_game.partyShareExperience(true)
        end
      end
    end
  end)

  -- =========================
  -- LADO DIREITO
  -- =========================
  autoPartyListWindow.palavraInvite:setText(cfgParty.palavraInvite or "")
  autoPartyListWindow.palavraInvite.onTextChange = function(_, text)
    cfgParty.palavraInvite = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.soulider2:setChecked(cfgParty.soulider2 == true)
  autoPartyListWindow.soulider2.onClick = function(widget)
    cfgParty.soulider2 = not (cfgParty.soulider2 == true)
    widget:setChecked(cfgParty.soulider2)
    saveAutoParty()
  end

  autoPartyListWindow.textMinLevel:setText(tostring(cfgParty.minLevel or ""))
  autoPartyListWindow.textMinLevel.onTextChange = function(_, text)
    cfgParty.minLevel = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.textMaxLevel:setText(tostring(cfgParty.maxLevel or ""))
  autoPartyListWindow.textMaxLevel.onTextChange = function(_, text)
    cfgParty.maxLevel = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.palavraPedirPT:setText(cfgParty.palavraPedirPT or "")
  autoPartyListWindow.palavraPedirPT.onTextChange = function(_, text)
    cfgParty.palavraPedirPT = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.pedirParty:setChecked(cfgParty.pedirParty == true)
  autoPartyListWindow.pedirParty.onClick = function(widget)
    cfgParty.pedirParty = not (cfgParty.pedirParty == true)
    widget:setChecked(cfgParty.pedirParty)
    saveAutoParty()
  end

  autoPartyListWindow.aceitarParty:setChecked(cfgParty.aceitarParty == true)
  autoPartyListWindow.aceitarParty.onClick = function(widget)
    cfgParty.aceitarParty = not (cfgParty.aceitarParty == true)
    widget:setChecked(cfgParty.aceitarParty)
    saveAutoParty()
  end

  -- =========================
  -- POSICAO PARA PEDIR PARTY
  -- =========================
  local loadingAskPartyDist = false

  local function getAskPartyPosText()
    local p = cfgParty.pedirPartyPos
    if type(p) == "table" and p.x and p.y and p.z then
      return "X:" .. p.x .. " Y:" .. p.y .. " Z:" .. p.z
    end
    return "X:- Y:- Z:-"
  end

  local function refreshAskPartyPositionUI()
    if autoPartyListWindow.askPartyPosText then
      autoPartyListWindow.askPartyPosText:setText(getAskPartyPosText())
    end

    if autoPartyListWindow.pedirPartyDist then
      loadingAskPartyDist = true
      autoPartyListWindow.pedirPartyDist:setText(tostring(clampAskPartyDist(cfgParty.pedirPartyDist)))
      loadingAskPartyDist = false
    end
  end

  if autoPartyListWindow.pedirPartyDist then
    autoPartyListWindow.pedirPartyDist.onTextChange = function(_, text)
      if loadingAskPartyDist then return end
      cfgParty.pedirPartyDist = clampAskPartyDist(text)
      saveAutoParty()
    end
  end

  if autoPartyListWindow.savePartyPos then
    autoPartyListWindow.savePartyPos.onClick = function()
      local p = player and player:getPosition()
      if not p then return end

      cfgParty.pedirPartyPos = {x = p.x, y = p.y, z = p.z}
      cfgParty.pedirPartyDist = clampAskPartyDist(cfgParty.pedirPartyDist)
      saveAutoParty()
      refreshAskPartyPositionUI()
    end
  end

  if autoPartyListWindow.clearPartyPos then
    autoPartyListWindow.clearPartyPos.onClick = function()
      cfgParty.pedirPartyPos = nil
      saveAutoParty()
      refreshAskPartyPositionUI()
    end
  end

  refreshAskPartyPositionUI()

  -- =========================
  -- MAX PARTY PLAYERS
  -- =========================
  local loadingMaxPartyPlayers = false

  local function updateMaxPartyPlayersLabel()
    if autoPartyListWindow.maxPartyPlayersLabel then
      autoPartyListWindow.maxPartyPlayersLabel:setText("Max Party Players: " .. getMaxPartyPlayers())
    end
  end

  local function setMaxPartyScrollValue(value)
    local scroll = autoPartyListWindow.maxPartyPlayersScroll
    if not scroll then return end

    if scroll.setMinimum then pcall(function() scroll:setMinimum(1) end) end
    if scroll.setMaximum then pcall(function() scroll:setMaximum(30) end) end
    if scroll.setStep then pcall(function() scroll:setStep(1) end) end
    if scroll.setValue then pcall(function() scroll:setValue(clampMaxPartyPlayers(value)) end) end
  end

  local function readMaxPartyScrollValue(widget, value)
    local v = tonumber(value)
    if not v and widget and widget.getValue then
      local ok, result = pcall(function() return widget:getValue() end)
      if ok then v = tonumber(result) end
    end
    return clampMaxPartyPlayers(v)
  end

  local function saveMaxPartyPlayersFromScroll(widget, value)
    if loadingMaxPartyPlayers then return end
    cfgParty.maxPartyPlayers = readMaxPartyScrollValue(widget, value)
    updateMaxPartyPlayersLabel()
    saveAutoParty()
  end

  loadingMaxPartyPlayers = true
  setMaxPartyScrollValue(getMaxPartyPlayers())
  loadingMaxPartyPlayers = false
  updateMaxPartyPlayersLabel()

  if autoPartyListWindow.maxPartyPlayersScroll then
    autoPartyListWindow.maxPartyPlayersScroll.onValueChange = saveMaxPartyPlayersFromScroll
    autoPartyListWindow.maxPartyPlayersScroll.onValueChanged = saveMaxPartyPlayersFromScroll
  end

  -- =========================
  -- BAN LIST
  -- =========================
  local function reloadBanList()
    if not autoPartyListWindow.lstBan then return end
    autoPartyListWindow.lstBan:destroyChildren()

    for _, name in ipairs(cfgParty.banListPlayers or {}) do
      local row = g_ui.createWidget("AutoPartyBanName", autoPartyListWindow.lstBan)
      row:setText(name)
      row.remove.onClick = function()
        table.removevalue(cfgParty.banListPlayers, row:getText())
        row:destroy()
        saveAutoParty()
      end
    end
  end

  reloadBanList()

  autoPartyListWindow.btnAddBan.onClick = function()
    local name = autoPartyListWindow.txtBan:getText()
    if not name or name:len() == 0 then return end

    if not table.contains(cfgParty.banListPlayers, name, true) then
      table.insert(cfgParty.banListPlayers, name)
      saveAutoParty()
      reloadBanList()
    end

    autoPartyListWindow.txtBan:setText("")
  end

  autoPartyListWindow.txtBan.onKeyPress = function(_, keyCode)
    if keyCode ~= 5 then return false end
    autoPartyListWindow.btnAddBan.onClick()
    return true
  end

  -- =========================
  -- MENSAGENS
  -- =========================
  onTextMessage(function(mode, text)
    if not tcAutoParty:isOn() then return end
    if mode ~= 20 then return end

    if text:find("has joined the party") then
      local data = regexMatch(text, "([a-z A-Z-]*) has joined the party")[1][2]
      if data and table.contains(cfgParty.autoPartyList, data, true) then
        if cfgParty.autoShare and not player:isPartySharedExperienceActive() then
          g_game.partyShareExperience(true)
        end
      end
      return
    end

    if text:find("has invited you") then
      if player:getName():lower() == (cfgParty.leaderName or ""):lower() then
        return
      end

      local data = regexMatch(text, "([a-z A-Z-]*) has invited you")[1][2]
      if data and (cfgParty.leaderName or ""):lower() == data:lower() then
        local leader = getCreatureByName(data, true)
        if leader then
          g_game.partyJoin(leader:getId())
          return
        end
      end
    end
  end)

  -- =========================
  -- INVITES
  -- =========================
  local function creatureInvites(creature)
    if not creature:isPlayer() or creature == player then return end

    if creature:getName():lower() == (cfgParty.leaderName or ""):lower() then
      if creature:getShield() == 1 then
        g_game.partyJoin(creature:getId())
        return
      end
    end

    if player:getName():lower() ~= (cfgParty.leaderName or ""):lower() then return end
    if not table.contains(cfgParty.autoPartyList, creature:getName(), true) then return end
    if creature:isPartyMember() or creature:getShield() == 2 then return end

    g_game.partyInvite(creature:getId())
  end

  onCreatureAppear(function(creature)
    if tcAutoParty:isOn() then
      creatureInvites(creature)
    end
  end)

  onCreaturePositionChange(function(creature)
    if tcAutoParty:isOn() and cfgParty.onMove then
      creatureInvites(creature)
    end
  end)
end

-- =====================================================
-- == LÓGICA COMPLETA AUTO PARTY
-- =====================================================
local infoTime = 0
local talkTime = 0
local justForInfo = true
local canSeeInfo = true
local partyMembersCount = 0

local lastInfoAt = 0
local lastUnlockAt = 0

local lastCloseAt = 0

macro(1000, function()
  if not cfgParty.enabled then return end

  local now = os.time()

  if fecharPaineis and fecharPaineis > 0 and now <= fecharPaineis then
    if lastCloseAt == 0 or (now - lastCloseAt) >= 3 then
      local root = g_ui.getRootWidget()
      if root then
        for _, widget in ipairs(root:recursiveGetChildren()) do
          if widget:getStyleName() == 'MessageBoxLabel' then
            local parent = widget:getParent()
            if parent and parent.destroy then
              parent:destroy()
            end
            lastCloseAt = now
            break
          end
        end
      end
    end
  end

  if not cfgParty.soulider2 then
    justForInfo = true
    partyMembersCount = 0
    infoTime = 0
    lastInfoAt = 0
    canSeeInfo = true
    return
  end

  if not player:isPartyLeader() then
    justForInfo = true
    partyMembersCount = 0
    infoTime = 0
    lastInfoAt = 0
    canSeeInfo = true
    return
  end

  if not canSeeInfo then
    if lastUnlockAt == 0 then lastUnlockAt = now end
    if (now - lastUnlockAt) >= 3 then
      canSeeInfo = true
      lastUnlockAt = 0
    end
  end

  if justForInfo and canSeeInfo then
    local partyId = getChannelId("party")
    if partyId then
      sayChannel(partyId, "!party info")
    else
      say("!party info")
    end

    fecharPaineis = now + 5
    lastInfoAt = now
    return
  end

  if canSeeInfo and (lastInfoAt == 0 or (now - lastInfoAt) >= 15) then
    local partyId = getChannelId("party")
    if partyId then
      sayChannel(partyId, "!party info")
    else
      say("!party info")
    end

    fecharPaineis = now + 5
    lastInfoAt = now
    return
  end

  if talkTime > 0 then
    talkTime = talkTime - 1
  end
end)

onLoginAdvice(function(text)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if not player:isPartyLeader() then return end

  local explode1 = string.explode(text, "*")
  local explode2 = string.explode(explode1[8], ":")[2]

  local rawMax = tonumber(string.explode(explode1[4], ":")[2]) or 0
  local rawMin = tonumber(string.explode(explode1[3], ":")[2]) or 0
  
  local calcMax = math.ceil(rawMax * 1.5)
  local calcMin = math.ceil(rawMin * 0.66)

  cfgParty.maxLevel = tostring(calcMax)
  cfgParty.minLevel = tostring(calcMin)
  saveAutoParty()

  autoPartyListWindow.textMaxLevel:setText(cfgParty.maxLevel)
  autoPartyListWindow.textMinLevel:setText(cfgParty.minLevel)

  partyMembersCount = tonumber(string.explode(explode1[2], ":")[2]) or 0
  if justForInfo then
    justForInfo = false
    return
  end

  if explode2:find(",") then
    local names = string.explode(explode2, ",")
    for i = 1, #names do
      canSeeInfo = false
      schedule(10 * i, function()
        if i == #names then
          canSeeInfo = true
        end
        sayChannel(getChannelId("party"), "!party kick," .. names[i])
      end)
    end
  elseif explode2 ~= "" then
    schedule(10, function() sayChannel(getChannelId("party"), "!party kick," .. explode2) end)
  end
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if name == player:getName() then return end

  local keyword = cfgParty.palavraInvite:lower()
  if keyword == "" then return end

  if text:lower():find(keyword) then
    if table.contains(cfgParty.banListPlayers, name, true) then
      g_game.talkPrivate(5, name, "You are banned from my party.")
      return
    end

    local minL = tonumber(cfgParty.minLevel) or 0
    local maxL = tonumber(cfgParty.maxLevel) or 9999
    if level < minL or level > maxL then
      g_game.talkPrivate(5, name, "Min level: " .. minL .. " | Max level: " .. maxL)
      return
    end

    local maxPartyPlayers = getMaxPartyPlayers()
    if partyMembersCount >= maxPartyPlayers then
      g_game.talkPrivate(5, name, "Party is full (" .. maxPartyPlayers .. " members).")
      return
    end

    local spec = getCreatureByName(name)
    if spec then
      if spec:isPartyMember() or spec:getShield() == 2 then return end
      g_game.partyInvite(spec:getId())
    end
  end
end)

local lastAppearTalk = 0
onCreatureAppear(function(creature)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if not creature:isPlayer() or creature:isLocalPlayer() then return end

  if creature:isPartyMember() or creature:getShield() == 2 then return end

  local now = os.time()

  if partyMembersCount < getMaxPartyPlayers() and (lastAppearTalk == 0 or (now - lastAppearTalk) >= 10) then
    local key = cfgParty.palavraInvite
    if key and key ~= "" then
      say("Fale '" .. key .. "' para ser invitado na party!")
      lastAppearTalk = now
    end
  end
end)

onTextMessage(function(mode, text)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  
  local t = text:lower()
  if t:find("you are now the leader") or t:find("has joined the party") or (t:find("has left the party") and canSeeInfo) then
    justForInfo = true
  end

  if t:find("level para compartilhamento") then
    local lMax, lMin = text:match("de (%d+) até (%d+)")
    if lMin and lMax then
      cfgParty.minLevel = lMin
      cfgParty.maxLevel = lMax
      saveAutoParty()

      autoPartyListWindow.textMinLevel:setText(lMin)
      autoPartyListWindow.textMaxLevel:setText(lMax)
    end
  end
end)

local lastsayparty = 0

local function isPlayerInParty()
  if player:isPartyMember() or player:isPartyLeader() then return true end
  return player:getShield() > 2
end

local function isValidAskPartyPosition()
  local p = cfgParty.pedirPartyPos
  return type(p) == "table" and tonumber(p.x) and tonumber(p.y) and tonumber(p.z)
end

local function isNearAskPartyPosition()
  if not isValidAskPartyPosition() then return false end

  local myPos = player:getPosition()
  local ref = cfgParty.pedirPartyPos
  if not myPos then return false end
  if tonumber(myPos.z) ~= tonumber(ref.z) then return false end

  local dist = nil
  if type(getDistanceBetween) == "function" then
    dist = getDistanceBetween(myPos, ref)
  end

  if not dist then
    dist = math.max(math.abs(myPos.x - ref.x), math.abs(myPos.y - ref.y))
  end

  return dist <= clampAskPartyDist(cfgParty.pedirPartyDist)
end

macro(200, function()
  if not cfgParty.enabled then return end
  if not cfgParty.pedirParty then return end
  if isPlayerInParty() then return end
  if not isNearAskPartyPosition() then return end

  local frase = cfgParty.palavraPedirPT
  if not frase or frase == "" then return end

  local now = os.time()

  if (lastsayparty == 0 or (now - lastsayparty) >= 10) then
    say(frase)
    lastsayparty = now
  end
end)

macro(200, function()
  if not cfgParty.enabled then return end
  if not cfgParty.aceitarParty then return end

  if player:getShield() > 2 then return end

  for _, spec in pairs(getSpectators(false)) do
    if spec:isPlayer() and spec:getShield() == 1 then
      g_game.partyJoin(spec:getId())
      return
    end
  end
end)


-- =========================
-- EATFOOD
-- =========================

UI.Separator()

local function saveEatFood()
  saveToolsGlobal()
end

toolsStorage.eatFoodSystem = toolsStorage.eatFoodSystem or {
  enabled = false,
  foodItems = {3582, 3577}
}

local foodCfg = toolsStorage.eatFoodSystem

if type(foodCfg.foodItems) ~= "table" then
  foodCfg.foodItems = {3582, 3577}
  saveEatFood()
end

eatFood = setupUI([[
Panel
  height: 19

  BotSwitch
    id: eatFood
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Eat Food
    height: 18
    color: white
]])

eatFood.eatFood:setOn(foodCfg.enabled)

eatFood.eatFood.onClick = function(widget)
  foodCfg.enabled = not widget:isOn()
  widget:setOn(foodCfg.enabled)
  saveEatFood()
end

local foodContainer = UI.Container(function(widget, items)
  foodCfg.foodItems = items
  saveEatFood()
end, true)

foodContainer:setHeight(35)
foodContainer:setItems(foodCfg.foodItems)

local function getFoodIds()
  local ids = {}

  for _, entry in pairs(foodCfg.foodItems or {}) do
    local id = nil

    if type(entry) == "table" then
      id = tonumber(entry.id)
    else
      id = tonumber(entry)
    end

    if id and id > 0 then
      table.insert(ids, id)
    end
  end

  return ids
end

local nextFoodUse = 0

macro(500, function()
  if not foodCfg.enabled then return end

  local isOldClient = g_game.getClientVersion() <= 960

  if isOldClient then
    if nextFoodUse > now then
      return
    end
  else
    if player:getRegenerationTime() > 400 then
      return
    end
  end

  local foodIds = getFoodIds()
  if #foodIds == 0 then return end

  for _, foodId in ipairs(foodIds) do
    use(foodId)

    -- fallback antigo
    local item = findItem(foodId)
    if item then
      use(item)

      if isOldClient then
        nextFoodUse = now + 60000
      end

      return
    end
  end
end)

----------------------------------
--------STAMINA
----------------------------------
UI.Separator()

toolsStorage.staminaUse = toolsStorage.staminaUse or {
  enabled = false,
  itemId = 36725,
  value = 18
}

local staminaCfg = toolsStorage.staminaUse

local function saveStaminaUse()
  saveToolsGlobal()
end

stamina = setupUI([[
Panel
  height: 55

  BotItem
    id: staminaId
    anchors.top: parent.top
    anchors.left: parent.left

  Label
    id: Labelstamina
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 8
    height: 18
    text-align: center
    text: Stamina: 1h
    color: gray

  HorizontalScrollBar
    id: stamina
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 2
    minimum: 1
    maximum: 43

  BotSwitch
    id: staminacheck
    anchors.top: staminaId.bottom
    anchors.left: staminaId.left
    anchors.right: prev.right
    height: 18
    text: Use Stamina
    color: white
    margin-top: 5
]])

local function updateStaminaLabel()
  stamina.Labelstamina:setText("Stamina: " .. tostring(staminaCfg.value or 1) .. ":00 h")
end

if stamina.staminaId.setItemId then
  stamina.staminaId:setItemId(staminaCfg.itemId or 0)
end

stamina.staminaId.onItemChange = function(widget)
  staminaCfg.itemId = widget:getItemId()
  saveStaminaUse()
end

stamina.stamina:setValue(staminaCfg.value or 1)
updateStaminaLabel()

stamina.stamina.onValueChange = function(widget, value)
  staminaCfg.value = value
  updateStaminaLabel()
  saveStaminaUse()
end

stamina.staminacheck:setOn(staminaCfg.enabled == true)

stamina.staminacheck.onClick = function(widget)
  staminaCfg.enabled = not widget:isOn()
  widget:setOn(staminaCfg.enabled)
  saveStaminaUse()
end

macro(1000, function()
  if staminaCfg.enabled ~= true then return end

  local itemId = tonumber(staminaCfg.itemId or 0)
  if itemId <= 0 then return end

  local minStamina = (tonumber(staminaCfg.value) or 1) * 60

  if player:getStamina() <= minStamina then
    use(itemId)
    delay(5000)
  end
end)

------------------------------
--- VIPWARD / WARN DISCORD
------------------------------
UI.Separator()

toolsStorage.warnDiscord = toolsStorage.warnDiscord or {
  enabled = false,
  location = "",
  webhook = "",
  warnGuild = false,
  warnPlayer = false,
  delayWarn = 5,
  sayGuild = false,
  discordWarn = false,
  guildList = "",
  playerList = ""
}

local warnCfg = toolsStorage.warnDiscord

warnCfg.enabled = warnCfg.enabled == true
warnCfg.location = tostring(warnCfg.location or "")
warnCfg.webhook = tostring(warnCfg.webhook or "")
warnCfg.warnGuild = warnCfg.warnGuild == true
warnCfg.warnPlayer = warnCfg.warnPlayer == true
warnCfg.delayWarn = tonumber(warnCfg.delayWarn) or 5
warnCfg.sayGuild = warnCfg.sayGuild == true
warnCfg.discordWarn = warnCfg.discordWarn == true
warnCfg.guildList = tostring(warnCfg.guildList or "")
warnCfg.playerList = tostring(warnCfg.playerList or "")

local function saveWarn()
  saveToolsGlobal()
end

local cachedPlayerList = {}
local cachedGuildList = {}

local function trimWarn(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function splitList(text)
  local t = {}
  for v in tostring(text or ""):gmatch("[^,]+") do
    v = trimWarn(v):lower()
    if v ~= "" then
      t[v] = true
    end
  end
  return t
end

local function rebuildLists()
  cachedPlayerList = splitList(warnCfg.playerList)
  cachedGuildList = splitList(warnCfg.guildList)
end

rebuildLists()

warnButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Warn Discord
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

warnInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 260 315
  text: Warn Discord
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.fill: parent
    margin: -6
    margin-top: 2
    margin-bottom: 20

    Label
      id: labelLocation
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 5
      text: Location to Warn:

    BotTextEdit
      id: Location
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-right: 5
      margin-top: 5
      placeholder: Insert Text Location
      text-align: left

    Label
      id: labelDiscord
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: Link Webhook:

    BotTextEdit
      id: Webhook
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      placeholder: Insert Link Discord Webhook
      text-align: left
      
    HorizontalSeparator
      id: sep1
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5

    Button
      id: filtroGuild
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      text: List Guilds
      height: 18

    Button
      id: filtroPlayers
      anchors.top: prev.bottom
      margin-top: 2
      anchors.left: prev.left
      anchors.right: prev.right
      text: List Players
      height: 18

    BotSwitch
      id: WarnGuild
      anchors.top: prev.bottom
      anchors.left: prev.left
      margin-top: 5
      width: 115
      text: Warn Guild

    BotSwitch
      id: WarnPlayer
      anchors.top: filtroPlayers.bottom
      anchors.right: filtroPlayers.right
      margin-top: 5
      width: 115
      text: Warn Players

    HorizontalSeparator
      id: sep2
      anchors.top: prev.bottom
      anchors.left: filtroPlayers.left
      anchors.right: filtroPlayers.right
      margin-top: 5

    Label
      id: LabelDelay
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      text: Delay to Warn: 5s
      text-align: center

    HorizontalScrollBar
      id: delayWarn
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      step: 1
      minimum: 1
      maximum: 30

    BotSwitch
      id: ativarGuild
      anchors.top: prev.bottom
      anchors.right: prev.right
      anchors.left: prev.left
      margin-top: 5
      text: Say Guild Chat

    BotSwitch
      id: ativarDiscord
      anchors.top: prev.bottom
      anchors.right: prev.right
      anchors.left: prev.left
      margin-top: 5
      text: Active Discord Warn
    
  Button
    id: closePanel
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 20
    margin-left: -5
    margin-right: -5
    margin-bottom: -2
    text: Close
]=], g_ui.getRootWidget())

warnInterface:hide()

if modules._G.g_app.isMobile() then
  equipInterface:setSize("430 425")
end

local function updateDelay()
  warnInterface.flatp.LabelDelay:setText("Delay to Warn: " .. tostring(warnCfg.delayWarn or 5) .. "s")
end

warnInterface.flatp.Location:setText(warnCfg.location)
warnInterface.flatp.Webhook:setText(warnCfg.webhook)
warnInterface.flatp.delayWarn:setValue(warnCfg.delayWarn)
warnInterface.flatp.WarnGuild:setOn(warnCfg.warnGuild)
warnInterface.flatp.WarnPlayer:setOn(warnCfg.warnPlayer)
warnInterface.flatp.ativarGuild:setOn(warnCfg.sayGuild)
warnInterface.flatp.ativarDiscord:setOn(warnCfg.discordWarn)
warnButton.title:setOn(warnCfg.enabled)

updateDelay()

warnInterface.flatp.Location.onTextChange = function(_, text)
  warnCfg.location = tostring(text or "")
  saveWarn()
end

warnInterface.flatp.Webhook.onTextChange = function(_, text)
  warnCfg.webhook = tostring(text or "")
  saveWarn()
end

warnInterface.flatp.delayWarn.onValueChange = function(_, value)
  warnCfg.delayWarn = tonumber(value) or 5
  updateDelay()
  saveWarn()
end

warnInterface.flatp.WarnGuild.onClick = function(widget)
  warnCfg.warnGuild = not widget:isOn()
  widget:setOn(warnCfg.warnGuild)
  saveWarn()
end

warnInterface.flatp.WarnPlayer.onClick = function(widget)
  warnCfg.warnPlayer = not widget:isOn()
  widget:setOn(warnCfg.warnPlayer)
  saveWarn()
end

warnInterface.flatp.ativarGuild.onClick = function(widget)
  warnCfg.sayGuild = not widget:isOn()
  widget:setOn(warnCfg.sayGuild)
  saveWarn()
end

warnInterface.flatp.ativarDiscord.onClick = function(widget)
  warnCfg.discordWarn = not widget:isOn()
  widget:setOn(warnCfg.discordWarn)
  saveWarn()
end

warnButton.title.onClick = function(widget)
  warnCfg.enabled = not widget:isOn()
  widget:setOn(warnCfg.enabled)
  saveWarn()
end

warnButton.settings.onClick = function()
  if warnInterface:isVisible() then
    warnInterface:hide()
  else
    warnInterface:show()
    warnInterface:raise()
    warnInterface:focus()
  end
end

warnInterface.closePanel.onClick = function()
  warnInterface:hide()
end

g_ui.loadUIFromString([[
LnsWarnListWindow < MainWindow
  id: mainPanel
  size: 420 300
  text: Setup List
  anchors.centerIn: parent
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: ok.top
    margin: -6
    margin-top: 2
    margin-bottom: 5

    Label
      id: titleLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 7
      margin-left: 8
      margin-right: 8
      text-align: center
      color: #d7c08a
      font: verdana-11px-rounded
      text: Lista

    Label
      id: descLabel
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 8
      margin-right: 8
      text-align: center
      text-wrap: true
      height: 30
      text: Insira os nomes separados por virgula ou um por linha.

    TextEdit
      id: listText
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-top: 8
      margin-left: 8
      margin-right: 8
      margin-bottom: 8
      color: white
      text-wrap: true

  Button
    id: ok
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.bottom: parent.bottom
    height: 20
    margin-left: -5
    margin-right: 2
    margin-bottom: -2
    text: OK

  Button
    id: cancel
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 20
    margin-left: 2
    margin-right: -5
    margin-bottom: -2
    text: Cancel
]])

local warnListWindow = nil

local function cleanListText(text)
  text = tostring(text or "")
  text = text:gsub("\r", "")
  text = text:gsub("\n", ",")
  text = text:gsub(",+", ",")
  text = text:gsub("^,", "")
  text = text:gsub(",$", "")
  return text
end

local function storageListToText(text)
  return tostring(text or ""):gsub(",", "\n")
end

local function openWarnListWindow(title, desc, storageKey)
  if warnListWindow then
    warnListWindow:destroy()
    warnListWindow = nil
  end

  warnListWindow = UI.createWindow("LnsWarnListWindow", g_ui.getRootWidget())
  warnListWindow:setText(title)
  warnListWindow.flatp.titleLabel:setText(title)
  warnListWindow.flatp.descLabel:setText(desc)
  warnListWindow.flatp.listText:setText(storageListToText(warnCfg[storageKey]))

  warnListWindow:show()
  warnListWindow:raise()
  warnListWindow:focus()

  warnListWindow.ok.onClick = function()
    warnCfg[storageKey] = cleanListText(warnListWindow.flatp.listText:getText())
    rebuildLists()
    saveWarn()

    warnListWindow:destroy()
    warnListWindow = nil

    if modules.game_textmessage then
      modules.game_textmessage.displayBroadcastMessage(title .. " salva com sucesso!", "#00FF00")
    end
  end

  warnListWindow.cancel.onClick = function()
    warnListWindow:destroy()
    warnListWindow = nil
  end
end

warnInterface.flatp.filtroGuild.onClick = function()
  openWarnListWindow(
    "LIST GUILDS",
    "Insira uma guild por linha ou separada por virgula.",
    "guildList"
  )
end

warnInterface.flatp.filtroPlayers.onClick = function()
  openWarnListWindow(
    "LIST PLAYERS",
    "Insira um player por linha ou separado por virgula.",
    "playerList"
  )
end

local playerInfos = {}
local lastWarnCheck = 0
local lastLookCheck = 0
local foundLook = 0

local function getVoc(text)
  text = tostring(text or ""):lower()

  if text:find("sorcerer") then return "MS" end
  if text:find("druid") then return "ED" end
  if text:find("knight") then return "EK" end
  if text:find("paladin") then return "RP" end
  if text:find("monk") then return "EM" end

  return ""
end

local function getWarnPlayersOnScreen()
  local list = {}

  for _, spec in ipairs(getSpectators() or {}) do
    if spec and spec:isPlayer() and spec ~= player and spec:getPosition().z == posz() then
      table.insert(list, spec)
    end
  end

  return list
end

local function requestLookPlayers(force)
  if not force and now - lastLookCheck < 3000 then return end
  lastLookCheck = now

  for _, spec in ipairs(getWarnPlayersOnScreen()) do
    local name = spec:getName()
    if name then
      local info = playerInfos[name:lower()]
      if force or not info or now - (info.updated or 0) > 10000 then
        g_game.look(spec)
        foundLook = now
      end
    end
  end
end

local lookRegex = [[You see ([^\(]*) \(Level ([0-9]*)\)((?:.)* of the ([\w ]*),|)]]

onTextMessage(function(mode, text)
  if not warnCfg.enabled then return end

  local re = regexMatch(text, lookRegex)
  if #re == 0 then return end

  local name = trimWarn(re[1][2])
  local level = trimWarn(re[1][3])
  local guild = trimWarn(re[1][5] or "")
  local voc = getVoc(text)

  if name == "" then return end

  playerInfos[name:lower()] = {
    name = name,
    level = level,
    guild = guild,
    voc = voc,
    updated = now
  }

  local creature = getCreatureByName(name)
  if creature then
    local showGuild = guild
    if showGuild:len() > 10 then
      showGuild = showGuild:sub(1, 10) .. "..."
    end
    creature:setText("\n" .. level .. voc .. "\n" .. showGuild)
  end

  if foundLook and now - foundLook < 500 and modules.game_textmessage then
    modules.game_textmessage.clearMessages()
  end
end)

onCreatureAppear(function(creature)
  if not warnCfg.enabled then return end
  if not creature or not creature:isPlayer() then return end
  if creature == player then return end
  if creature:getPosition().z ~= posz() then return end

  schedule(200, function()
    if creature and creature:isPlayer() and creature:getPosition().z == posz() then
      local name = creature:getName()
      if name and not playerInfos[name:lower()] then
        g_game.look(creature)
        foundLook = now
      end
    end
  end)
end)

onPlayerPositionChange(function(newPos, oldPos)
  if not warnCfg.enabled then return end
  if not newPos or not oldPos then return end

  if newPos.z ~= oldPos.z then
    schedule(500, function()
      requestLookPlayers(true)
    end)
  end
end)

local function isTarget(info)
  if not info then return false end

  local name = tostring(info.name or ""):lower()
  local guild = tostring(info.guild or ""):lower()

  if warnCfg.warnPlayer == true and cachedPlayerList[name] then return true end
  if warnCfg.warnGuild == true and cachedGuildList[guild] then return true end

  return false
end

local function sendDiscord(data)
  if tostring(warnCfg.webhook or "") == "" then return end
  if not HTTP or not HTTP.postJSON then return end

  local payload = {
    username = "LNS Custom",
    embeds = {{
      title = "[LNS] Player Detection",
      color = 10038562,
      fields = {
        { name = "Local:", value = tostring(data.location or "-") },
        { name = "Amount Players on Screen:", value = tostring(data.amountScreen or 0) },
        { name = "Amount Players list:", value = tostring(data.amountList or 0) },
        { name = "Name:", value = tostring(data.name or "-") },
        { name = "Guild:", value = tostring(data.guild or "-") },
        { name = "Level:", value = tostring(data.level or "-") },
        { name = "Voc:", value = tostring(data.voc or "-") }
      },
      footer = {
        text = "LNS Custom"
      }
    }}
  }

  HTTP.postJSON(warnCfg.webhook, payload, function(_, err)
    if err then
      print("Discord Webhook Error: " .. tostring(err))
    end
  end)
end

macro(1000, function()
  if warnCfg.enabled ~= true then return end

  local delaySec = tonumber(warnCfg.delayWarn) or 5
  if now - lastWarnCheck < delaySec * 1000 then return end
  lastWarnCheck = now

  requestLookPlayers(false)

  local players = getWarnPlayersOnScreen()
  local amountScreen = #players
  local matched = {}

  for _, creature in ipairs(players) do
    local name = creature:getName()
    local info = name and playerInfos[name:lower()]

    if info and isTarget(info) then
      matched[name:lower()] = info
    end
  end

  local amountList = 0
  for _ in pairs(matched) do
    amountList = amountList + 1
  end

  if amountList <= 0 then return end

  for _, info in pairs(matched) do
    if warnCfg.discordWarn == true then
      sendDiscord({
        location = warnCfg.location,
        amountScreen = amountScreen,
        amountList = amountList,
        name = info.name,
        guild = info.guild ~= "" and info.guild or "-",
        level = info.level,
        voc = info.voc ~= "" and info.voc or "-"
      })
    end

    if warnCfg.sayGuild == true then
      local ch = getChannelId and getChannelId("guild")
      if ch then
        sayChannel(ch, "[LNS] Player Detection: " .. info.name .. " | Guild: " .. (info.guild ~= "" and info.guild or "-") .. " | Level: " .. info.level .. " | Voc: " .. (info.voc ~= "" and info.voc or "-"))
      end
    end
  end
end)

macro(30000, function()
  local fresh = {}
  for k, info in pairs(playerInfos) do
    if info.updated and now - info.updated < 60000 then
      fresh[k] = info
    end
  end
  playerInfos = fresh
end)

UI.Separator()

local function saveDummyChar()
  saveToolsGlobal()
end

local panelName = "Dummy Train"

toolsStorage[panelName] = toolsStorage[panelName] or {
  id = 28557,
  id2 = 28559,
  enabled = false,
  training = false,
  lastStart = 0,
  lastTry = 0,
  lastUsePos = nil
}

local cfg = toolsStorage[panelName]

cfg.training = false
cfg.lastStart = 0
cfg.lastTry = 0
cfg.lastUsePos = nil

local ui = setupUI([[
Panel
  height: 80

  Label
    id: itemLabel
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 5
    margin-left: 2
    text: Exercise
    text-auto-resize: true
    font: verdana-11px-rounded
    color: lightGray

  Label
    id: targetLabel
    anchors.top: parent.top
    anchors.right: parent.right
    margin-top: 5
    margin-right: 12
    text: Dummy
    font: verdana-11px-rounded
    color: lightGray

  BotItem
    id: item
    anchors.top: itemLabel.bottom
    anchors.left: itemLabel.left
    margin-top: 3
    margin-left: 9

  BotItem
    id: Target
    anchors.top: targetLabel.bottom
    anchors.right: targetLabel.right
    margin-top: 3
    margin-right: 6

  BotSwitch
    id: title
    anchors.top: item.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 18
    text-align: center
    !text: tr('Dummy Train')
]], parent)

ui:setId(panelName)

ui.title:setOn(cfg.enabled)

ui.title.onClick = function(widget)
  cfg.enabled = not cfg.enabled
  widget:setOn(cfg.enabled)

  if not cfg.enabled then
    cfg.training = false
    cfg.lastStart = 0
    cfg.lastTry = 0
  end

  saveDummyChar()
end

ui.item:setItemId(cfg.id)

ui.item.onItemChange = function(widget)
  cfg.id = widget:getItemId()
  saveDummyChar()
end

ui.Target:setItemId(cfg.id2)

ui.Target.onItemChange = function(widget)
  cfg.id2 = widget:getItemId()
  saveDummyChar()
end

function setDummyOff()
  cfg.enabled = false
  cfg.training = false
  cfg.lastStart = 0
  cfg.lastTry = 0

  ui.title:setOn(false)

  saveDummyChar()
end

function setDummyOn()
  cfg.enabled = true

  ui.title:setOn(true)

  saveDummyChar()
end

local function safeLower(s)
  return tostring(s or ""):lower()
end

local function isDummyTile(tile)
  if not tile then return false end

  local top = tile:getTopUseThing()
  if not top then return false end

  return top:getId() == cfg.id2
end

local function getClosestDummy()
  local playerPos = pos()
  if not playerPos then return nil end

  local bestTile = nil
  local bestDist = 999

  for _, tile in ipairs(g_map.getTiles(posz())) do
    if isDummyTile(tile) then
      local tPos = tile:getPosition()

      if tPos and tPos.z == playerPos.z then
        local dist = getDistanceBetween(playerPos, tPos)

        if dist <= 7 and dist < bestDist then
          bestDist = dist
          bestTile = tile
        end
      end
    end
  end

  return bestTile
end

local function tryStartTraining()
  local tile = getClosestDummy()
  if not tile then return false end

  local top = tile:getTopUseThing()
  if not top then return false end

  cfg.lastTry = now
  cfg.lastUsePos = tile:getPosition()

  useWith(cfg.id, top)

  return true
end

onTextMessage(function(mode, text)
  if not cfg.enabled then return end

  local msg = safeLower(text)

  if msg:find("you started your training", 1, true) then
    cfg.training = true
    cfg.lastStart = now
    return
  end

  if msg:find("your training has stopped", 1, true)
  or msg:find("your training has been canceled", 1, true)
  or msg:find("training has ended", 1, true)
  or msg:find("you are not training", 1, true)
  or msg:find("there is no dummy", 1, true)
  or msg:find("not possible", 1, true)
  or msg:find("you are too far away", 1, true) then
    cfg.training = false
    cfg.lastStart = 0
    cfg.lastTry = now
    return
  end
end)

cfg.training = false

macro(500, function()
  if not cfg.enabled then return end

  local tile = getClosestDummy()

  if not tile then
    cfg.training = false
    return
  end

  -- se ja iniciou o treino, NAO USA MAIS O ITEM NO DUMMY
  -- isso evita cancelar/reativar em loop
  if cfg.training then
    return
  end

  -- tenta iniciar somente quando realmente nao esta treinando
  if now - (cfg.lastTry or 0) > 3000 then
    tryStartTraining()
  end
end)


-----------------------------------
---------- HUD
-----------------------------------
local switchHud = "hudButton"
local panelName = "hudInterface"

toolsStorage[switchHud] = toolsStorage[switchHud] or {
  enabled = false
}

toolsStorage[panelName] = toolsStorage[panelName] or {
  switches = {},
  targetInfoPos = nil
}

toolsStorage[panelName].switches = toolsStorage[panelName].switches or {}

local function saveHudChar()
  saveToolsGlobal()
end

local hudCfg = toolsStorage[panelName]

toolsStorage[switchHud].enabled = true

--==================================================
-- HUD INTERFACE
--==================================================

hudInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 260 230
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60
  text: HUD Settings

  TextList
    id: panelMain
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 25
    margin-top: 0
    margin-right: 7
    margin-left: -3
    height: 235
    vertical-scrollbar: spellListScrollBar
    layout: verticalBox

    BotSwitch
      id: barLifeMana
      margin-top: 10
      margin-right: 5
      width: 25
      text: Life/Mana Bar Edited
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: targetInfo
      margin-top: 10
      margin-right: 5
      width: 25
      text: Target Info
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: comboManager
      margin-top: 10
      margin-right: 5
      width: 25
      text: Manager Attackbot
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80
      
  VerticalScrollBar
    id: spellListScrollBar
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    pixels-scroll: true
    image-color: #363636
    margin-top: 0
    margin-bottom: 0
    step: 10

  Button
    id: closePanel
    anchors.left: panelMain.left
    anchors.right: spellListScrollBar.right
    anchors.top: panelMain.bottom
    margin-left: 0
    margin-top: 5
    text: Close
    color: gray
]], g_ui.getRootWidget())

hudInterface:hide()

local function getHudWidget(id)
  if not hudInterface then return nil end
  return hudInterface:recursiveGetChildById(id)
end

local function bindHudSwitch(id)
  local widget = getHudWidget(id)
  if not widget then
    warn("[HUD] Widget nao encontrado: " .. tostring(id))
    return
  end

  if hudCfg.switches[id] == nil then
    hudCfg.switches[id] = false
    saveHudChar()
  end

  widget:setOn(hudCfg.switches[id] == true)

  widget.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    hudCfg.switches[id] = state
    saveHudChar()
  end
end

bindHudSwitch("barLifeMana")
bindHudSwitch("targetInfo")
bindHudSwitch("comboManager")

hudInterface.closePanel.onClick = function()
  hudInterface:hide()
end



--==================================================
-- HELPERS HUD
--==================================================

local function hudMasterOn()
  return true
end

local function hudSwitchOn(id)
  return toolsStorage[panelName]
    and toolsStorage[panelName].switches
    and toolsStorage[panelName].switches[id] == true
end

--==================================================
-- LIFE / MANA BAR
--==================================================

local function hpColor(p)
  return "red"
end

local function mpColor(p)
  if p <= 35 then return "#000099" end
  if p <= 75 then return "#3333CC" end
  return "#4D4DFF"
end

local HP_UI = [[
ProgressBar
  id: barHp
  anchors.centerIn: parent
  margin-top: -255
  margin-left: -20
  height: 11
  width: 320
  border: 1 black
  opacity: 0.60
  text-align: center
  background-color: red
]]

local MP_UI = [[
ProgressBar
  id: barMp
  anchors.centerIn: parent
  margin-top: -243
  margin-left: -20
  height: 11
  width: 240
  border: 1 black
  opacity: 0.60
  text-align: center
  background-color: blue
]]

local bars = {
  hp = nil,
  mp = nil
}

local function ensureBars()
  if bars.hp and not bars.hp:isDestroyed() and bars.mp and not bars.mp:isDestroyed() then
    return
  end

  bars.hp = setupUI(HP_UI, g_ui.getRootWidget())
  bars.mp = setupUI(MP_UI, g_ui.getRootWidget())

  bars.hp:hide()
  bars.mp:hide()
end

local function setBarsVisible(v)
  ensureBars()

  if v then
    bars.hp:show()
    bars.mp:show()
  else
    bars.hp:hide()
    bars.mp:hide()
  end
end

local function updateBars()
  if not bars.hp or not bars.mp then return end

  local hp = hppercent()
  local mp = manapercent()

  bars.hp:setPercent(hp)
  bars.hp:setText(string.format("HP: %d%%", hp))
  bars.hp:setBackgroundColor(hpColor(hp))

  bars.mp:setPercent(mp)
  bars.mp:setText(string.format("MP: %d%%", mp))
  bars.mp:setBackgroundColor(mpColor(mp))
end

macro(100, function()
  if not hudMasterOn() or not hudSwitchOn("barLifeMana") then
    setBarsVisible(false)
    return
  end

  setBarsVisible(true)
  updateBars()
end)

--==================================================
-- TARGET INFO
--==================================================

local targetLifeColors = {
  { percent = 35, color = "red" },
  { percent = 75, color = "yellow" },
  { percent = 100, color = "green" }
}

toolsStorage = toolsStorage or {}
toolsStorage[panelName] = toolsStorage[panelName] or {}
toolsStorage[panelName].targetInfoPos = toolsStorage[panelName].targetInfoPos or { x = 0, y = 0 }

local function getTargetColor(percent)
  percent = tonumber(percent) or 0

  for i = 1, #targetLifeColors do
    if percent <= targetLifeColors[i].percent then
      return targetLifeColors[i].color
    end
  end

  return "green"
end

local targetUI = setupUI([[
UIWindow
  id: targetInfoHUD
  anchors.centerIn: parent
  height: 62
  width: 260
  opacity: 1.00
  padding: 4
  background-color: alpha

  UICreature
    id: targetSprite
    width: 70
    height: 80
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: -18
    margin-top: -4

  Label
    id: targetName
    anchors.left: targetSprite.right
    anchors.right: parent.right
    anchors.top: parent.top
    margin-left: 5
    margin-top: 3
    font: verdana-11px-rounded
    color: white
    text: TARGET

  Label
    id: targetDistance
    anchors.left: targetName.left
    anchors.right: targetName.right
    anchors.top: targetName.bottom
    margin-top: 2
    font: verdana-11px-rounded
    color: white
    text: Distance:

  ProgressBar
    id: targetHpBar
    anchors.left: targetName.left
    anchors.right: parent.right
    anchors.top: targetDistance.bottom
    margin-top: 4
    height: 13
    border: 1 black
    opacity: 0.85
    text-align: center
    background-color: red
]], g_ui.getRootWidget())

targetUI:hide()

local function isMobile()
  return modules._G.g_app.isMobile()
end

local function isMoveKeyPressed()
  if modules._G.g_app.isMobile() then
    return true
  end

  return g_keyboard and g_keyboard.isCtrlPressed and g_keyboard.isCtrlPressed()
end

local function applyTargetPos()
  local p = toolsStorage[panelName].targetInfoPos

  targetUI:breakAnchors()

  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    targetUI:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    targetUI:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    return
  end

  targetUI:setPosition({ x = p.x, y = p.y })
end

local function saveTargetPos()
  local p = targetUI:getPosition()
  if not p then return end

  toolsStorage[panelName].targetInfoPos = {
    x = p.x,
    y = p.y
  }

  if type(saveHudChar) == "function" then
    saveHudChar()
  end
end

local function disableDrag()
  targetUI.onDragEnter = nil
  targetUI.onDragMove = nil
  targetUI:setFocusable(false)
  targetUI:setPhantom(true)
  targetUI:setDraggable(false)
  targetUI:setOpacity(1.00)
end

local function enableDrag()
  targetUI:setFocusable(true)
  targetUI:setPhantom(false)
  targetUI:setDraggable(true)
  targetUI:setOpacity(1.00)

  targetUI.onDragEnter = function(widget, mousePos)
    widget:breakAnchors()

    widget.movingReference = {
      x = mousePos.x - widget:getX(),
      y = mousePos.y - widget:getY()
    }

    return true
  end

  targetUI.onDragMove = function(widget, mousePos)
    local parent = widget:getParent()
    if not parent or not parent.getRect then return true end

    local r = parent:getRect()
    local ref = widget.movingReference or { x = 0, y = 0 }

    local x = mousePos.x - ref.x
    local y = mousePos.y - ref.y

    x = math.min(math.max(r.x, x), r.x + r.width - widget:getWidth())
    y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

    widget:move(x, y)

    toolsStorage[panelName].targetInfoPos = {
      x = x,
      y = y
    }

    saveTargetPos()
    return true
  end
end

local function sqmDistance(a, b)
  if not a or not b then return 0 end

  local dx = math.abs((a.x or 0) - (b.x or 0))
  local dy = math.abs((a.y or 0) - (b.y or 0))

  return math.max(dx, dy)
end

applyTargetPos()

local lastPressed = nil
local lastSavePos = 0

if modules._G.g_app.isMobile() then
  enableDrag()
  lastPressed = true
else
  disableDrag()
  lastPressed = false
end

macro(100, function()
  if not hudMasterOn() or not hudSwitchOn("targetInfo") then
    if targetUI:isVisible() then targetUI:hide() end
    return
  end

  if not g_game.isAttacking() then
    if targetUI:isVisible() then targetUI:hide() end
    return
  end

  if not targetUI:isVisible() then
    targetUI:show()
    applyTargetPos()

    if isMobile() then
      enableDrag()
      lastPressed = true
    end
  end

  local pressed = isMoveKeyPressed()

  if pressed ~= lastPressed then
    if pressed then
      enableDrag()
    else
      disableDrag()
      saveTargetPos()
    end

    lastPressed = pressed
  end

  if pressed and now - lastSavePos > 500 then
    saveTargetPos()
    lastSavePos = now
  end

  local target = g_game.getAttackingCreature and g_game.getAttackingCreature() or nil
  if not target then
    targetUI:hide()
    return
  end

  if target.getOutfit then
    targetUI.targetSprite:setOutfit(target:getOutfit())
  end

  local name = target.getName and target:getName() or "-"
  local hp = target.getHealthPercent and target:getHealthPercent() or 0
  hp = tonumber(hp) or 0

  local myPos = pos and pos() or nil
  local targetPos = target.getPosition and target:getPosition() or nil
  local dist = sqmDistance(myPos, targetPos)

  targetUI.targetName:setText(name)
  targetUI.targetDistance:setText("Distance: " .. dist)

  targetUI.targetHpBar:setPercent(hp)
  targetUI.targetHpBar:setText(hp .. "%")
  targetUI.targetHpBar:setBackgroundColor(getTargetColor(hp))
end)

--==================================================
-- MANAGER ATTACKBOT - LISTA SPELL/RUNE + CD
--==================================================
toolsStorage = toolsStorage or {}
panelName = panelName or "default"
toolsStorage[panelName] = toolsStorage[panelName] or {}

toolsStorage[panelName].managerAttackbotPos = toolsStorage[panelName].managerAttackbotPos or { x = 0, y = 0 }
toolsStorage[panelName].managerAttackbotMinimized = toolsStorage[panelName].managerAttackbotMinimized or false
toolsStorage[panelName].managerAttackbotSize =
  type(toolsStorage[panelName].managerAttackbotSize) == "table"
  and toolsStorage[panelName].managerAttackbotSize
  or { width = 270, height = 160 }

toolsStorage[panelName].managerAttackbotSize.width =
  tonumber(toolsStorage[panelName].managerAttackbotSize.width or toolsStorage[panelName].managerAttackbotSize.w) or 270

toolsStorage[panelName].managerAttackbotSize.height =
  tonumber(toolsStorage[panelName].managerAttackbotSize.height or toolsStorage[panelName].managerAttackbotSize.h) or 160

local managerAttackUI = setupUI([[
MiniWindow
  id: managerAttackbotHUD
  size: 270 160
  opacity: 1.00
  text: Manager AttackBot
  icon: /images/topbuttons/combatcontrols
  icon-size: 18 18

  TextList
    id: list
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-left: 7
    margin-top: 22
    margin-right: 15
    margin-bottom: 5
    vertical-scrollbar: scroll
    layout: verticalBox

  VerticalScrollBar
    id: scroll
    anchors.top: list.top
    anchors.bottom: list.bottom
    anchors.right: parent.right
    width: 12
    margin-right: 6
    pixels-scroll: true
    step: 24
]], g_ui.getRootWidget())

managerAttackUI:hide()

local managerAttackRow = [[
Panel
  height: 25
  margin-top: 1
  background-color: alpha
  focusable: true
  $hover:
    background-color: #242424

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    size: 21 21
    text: ""
    $on:
      image-color: green
    $!on:
      image-color: #202020

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: enabled.verticalCenter
    margin-left: 5
    size: 20 20
    visible: false

  Label
    id: name
    anchors.left: icon.right
    anchors.right: status.left
    anchors.verticalCenter: enabled.verticalCenter
    margin-left: 8
    margin-right: 5
    font: verdana-11px-rounded
    color: white
    text: -
    phantom: false

  Label
    id: status
    anchors.right: parent.right
    anchors.verticalCenter: enabled.verticalCenter
    margin-right: -2
    width: 42
    font: verdana-11px-rounded
    text-align: center
    color: green
    text: ON
]]

local function managerAtkSave()
  storage = storage or {}
  storage.LNSAttackBotGlobal = type(storage.LNSAttackBotGlobal) == "table" and storage.LNSAttackBotGlobal or {}
end

local function managerAtkStorage()
  storage = storage or {}
  storage.LNSAttackBotGlobal = type(storage.LNSAttackBotGlobal) == "table" and storage.LNSAttackBotGlobal or {}

  storage.LNSAttackBotGlobal.attackBotProfiles =
    type(storage.LNSAttackBotGlobal.attackBotProfiles) == "table" and storage.LNSAttackBotGlobal.attackBotProfiles or {
      activeProfile = 1,
      profiles = {}
    }

  return storage.LNSAttackBotGlobal
end

local function managerAtkProfileIndex()
  local st = managerAtkStorage()
  return math.max(1, math.min(5, tonumber(st.attackBotProfiles.activeProfile) or 1))
end

local function managerAtkProfile()
  local st = managerAtkStorage()
  local idx = managerAtkProfileIndex()

  st.attackBotProfiles.profiles[idx] =
    type(st.attackBotProfiles.profiles[idx]) == "table" and st.attackBotProfiles.profiles[idx] or {
      main = {},
      attacks = {}
    }

  local p = st.attackBotProfiles.profiles[idx]
  p.main = type(p.main) == "table" and p.main or {}
  p.attacks = type(p.attacks) == "table" and p.attacks or {}

  return p
end

local function managerAtkClear()
  local children = managerAttackUI.list:getChildren()
  for i = #children, 1, -1 do
    children[i]:destroy()
  end
end

local function managerAtkGetScrollValue()
  local scroll = managerAttackUI.scroll
  if not scroll or not scroll.getValue then return 0 end

  local ok, value = pcall(function()
    return scroll:getValue()
  end)

  return ok and tonumber(value) or 0
end

local function managerAtkRestoreScroll(value)
  value = tonumber(value) or 0

  schedule(10, function()
    local scroll = managerAttackUI and managerAttackUI.scroll
    if not scroll or not scroll.setValue then return end

    pcall(function()
      scroll:setValue(value)
    end)
  end)
end

local function setRowItem(widget, itemId)
  itemId = tonumber(itemId) or 0
  if not widget then return end

  if itemId <= 0 then
    widget:setVisible(false)
    return
  end

  widget:setVisible(true)

  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem and Item and Item.create then
    widget:setItem(Item.create(itemId, 1))
  end
end

local function managerAtkName(data)
  if not data then return "-" end

  if data.type == "spell" then
    return tostring(data.spell or "-")
  end

  if data.type == "rune" then
    return "Rune: [" .. tostring(data.id or 0) .. "]"
  end

  return "-"
end

local function managerAtkCooldownText(data)
  local cd = tonumber(data.nextCast) or 0

  if cd > now then
    return tostring(math.ceil((cd - now) / 1000)) .. "s"
  end

  return nil
end

local function managerAtkUpdateRow(row, data)
  local enabled = data and data.enabled == true
  local cdText = managerAtkCooldownText(data)

  row.enabled:setOn(enabled)

  if cdText then
    row.status:setText(cdText)
    row.status:setColor("yellow")
  elseif enabled then
    row.status:setText("ON")
    row.status:setColor("green")
  else
    row.status:setText("OFF")
    row.status:setColor("red")
  end
end

local function managerAtkToggle(index, row)
  local p = managerAtkProfile()
  local atk = p.attacks and p.attacks[index]
  if not atk then return end

  atk.enabled = not (atk.enabled == true)

  managerAtkUpdateRow(row, atk)
  managerAtkSave()

  if type(rebuildAttackList) == "function" then
    rebuildAttackList()
  end
end

local managerRows = {}
local lastManagerAttackCount = 0
local lastManagerAttackProfile = 0
local lastManagerAttackSignature = ""

local function managerAtkBuildSignature(profile)
  local parts = {}

  for index, attack in ipairs((profile and profile.attacks) or {}) do
    parts[#parts + 1] = table.concat({
      tostring(index),
      tostring(attack.type or ""),
      tostring(attack.spell or ""),
      tostring(attack.id or ""),
      tostring(attack.distance or ""),
      tostring(attack.mobs or ""),
      attack.safe == true and "1" or "0"
    }, "|")
  end

  return table.concat(parts, "\30")
end

local function managerAtkNeedsRefresh()
  local profile = managerAtkProfile()
  local count = #(profile.attacks or {})
  local profileIndex = managerAtkProfileIndex()
  local signature = managerAtkBuildSignature(profile)

  return count ~= lastManagerAttackCount
      or profileIndex ~= lastManagerAttackProfile
      or signature ~= lastManagerAttackSignature
end

local function managerAtkRefresh()
  local savedScrollValue = managerAtkGetScrollValue()

  managerAtkClear()
  managerRows = {}

  local profile = managerAtkProfile()

  for index, attack in ipairs(profile.attacks or {}) do
    local row = setupUI(managerAttackRow, managerAttackUI.list)

    row.name:setText(managerAtkName(attack))

    if attack.type == "rune" then
      setRowItem(row.icon, attack.id)
      row.name:setMarginLeft(5)
    else
      setRowItem(row.icon, 0)
      row.icon:setVisible(false)
      row.name:setMarginLeft(-15)
    end

    managerAtkUpdateRow(row, attack)

    local tip =
      "Distance: " .. tostring(attack.distance or 1) ..
      "\nMobs: " .. tostring(attack.mobs or 1) ..
      "\nSafe: " .. ((attack.safe and "Yes") or "No")

    row:setTooltip(tip)
    row.enabled:setTooltip(tip)
    row.icon:setTooltip(tip)
    row.name:setTooltip(tip)
    row.status:setTooltip(tip)

    local function clickLine()
      managerAtkToggle(index, row)
    end

    row.onClick = clickLine
    row.enabled.onClick = clickLine
    row.icon.onClick = clickLine
    row.name.onClick = clickLine
    row.status.onClick = clickLine

    table.insert(managerRows, {
      row = row,
      index = index
    })
  end

  lastManagerAttackCount = #(profile.attacks or {})
  lastManagerAttackProfile = managerAtkProfileIndex()
  lastManagerAttackSignature = managerAtkBuildSignature(profile)

  managerAtkRestoreScroll(savedScrollValue)
end

local function managerAtkUpdateCooldowns()
  local p = managerAtkProfile()

  for _, data in ipairs(managerRows) do
    local atk = p.attacks and p.attacks[data.index]
    if data.row and atk then
      managerAtkUpdateRow(data.row, atk)
    end
  end
end

local function managerAtkApplyPos()
  local p = toolsStorage[panelName].managerAttackbotPos

  managerAttackUI:breakAnchors()

  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    managerAttackUI:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    managerAttackUI:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    managerAttackUI:setMarginTop(80)
    return
  end

  managerAttackUI:setPosition({ x = p.x, y = p.y })
end

local function managerAtkSavePos()
  local p = managerAttackUI:getPosition()
  if not p then return end

  toolsStorage[panelName].managerAttackbotPos = {
    x = p.x,
    y = p.y
  }

  if type(saveHudChar) == "function" then
    saveHudChar()
  end
end

managerAttackUI.onDragEnter = function(widget, mousePos)
  widget:breakAnchors()
  widget.movingReference = {
    x = mousePos.x - widget:getX(),
    y = mousePos.y - widget:getY()
  }

  return true
end

managerAttackUI.onDragMove = function(widget, mousePos)
  local parent = widget:getParent()
  if not parent or not parent.getRect then return true end

  local r = parent:getRect()
  local ref = widget.movingReference or { x = 0, y = 0 }

  local x = mousePos.x - ref.x
  local y = mousePos.y - ref.y

  x = math.min(math.max(r.x, x), r.x + r.width - widget:getWidth())
  y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

  widget:move(x, y)
  return true
end

managerAttackUI.onDragLeave = function()
  managerAtkSavePos()
  return true
end

local managerMinimizedHeight = 25
local managerMinimumWidth = 180
local managerMinimumHeight = 80

local savedManagerSize = toolsStorage[panelName].managerAttackbotSize
local managerNormalWidth = math.max(managerMinimumWidth, tonumber(savedManagerSize.width) or 270)
local managerNormalHeight = math.max(managerMinimumHeight, tonumber(savedManagerSize.height) or 160)
local managerLastWidth = managerNormalWidth
local managerLastHeight = managerNormalHeight
local managerSizeSaveDeadline = 0

local function managerAtkClock()
  if g_clock and g_clock.millis then
    return g_clock.millis()
  end

  return tonumber(now) or 0
end

local function managerAtkApplySize()
  managerAttackUI:setWidth(managerNormalWidth)
  managerAttackUI:setHeight(managerNormalHeight)
end

local function managerAtkStoreCurrentSize(forceSave, ignoreMinimizedState)
  if toolsStorage[panelName].managerAttackbotMinimized == true and ignoreMinimizedState ~= true then
    return
  end

  local width = math.max(managerMinimumWidth, tonumber(managerAttackUI:getWidth()) or managerNormalWidth)
  local height = math.max(managerMinimumHeight, tonumber(managerAttackUI:getHeight()) or managerNormalHeight)

  if width ~= managerLastWidth or height ~= managerLastHeight then
    managerLastWidth = width
    managerLastHeight = height
    managerNormalWidth = width
    managerNormalHeight = height

    toolsStorage[panelName].managerAttackbotSize = {
      width = width,
      height = height
    }

    managerSizeSaveDeadline = managerAtkClock() + 600
  end

  if forceSave == true or (managerSizeSaveDeadline > 0 and managerAtkClock() >= managerSizeSaveDeadline) then
    managerSizeSaveDeadline = 0

    if type(saveHudChar) == "function" then
      saveHudChar()
    end
  end
end

managerAtkApplySize()
managerAtkApplyPos()
managerAtkRefresh()

local function managerAtkSetMinimized(state)
  state = state == true

  toolsStorage[panelName].managerAttackbotMinimized = state

  if state then
    if managerAttackUI:getHeight() > managerMinimizedHeight then
      managerAtkStoreCurrentSize(true, true)
    end

    if managerAttackUI.list then managerAttackUI.list:hide() end
    if managerAttackUI.scroll then managerAttackUI.scroll:hide() end
    if managerAttackUI.title then managerAttackUI.title:hide() end

    managerAttackUI:setHeight(managerMinimizedHeight)
  else
    managerAttackUI:setWidth(managerNormalWidth)
    managerAttackUI:setHeight(managerNormalHeight)

    if managerAttackUI.list then managerAttackUI.list:show() end
    if managerAttackUI.scroll then managerAttackUI.scroll:show() end
    if managerAttackUI.title then managerAttackUI.title:hide() end

    managerAtkRefresh()
  end

  if type(saveHudChar) == "function" then
    saveHudChar()
  end
end

schedule(100, function()
  managerAtkSetMinimized(toolsStorage[panelName].managerAttackbotMinimized == true)
end)

local miniScroll = managerAttackUI:getChildById("miniwindowScrollBar")
if miniScroll then miniScroll:hide() end

if managerAttackUI.closeButton then
  managerAttackUI.closeButton:hide()
end

if managerAttackUI.lockButton then
  managerAttackUI.lockButton:hide()
end

if managerAttackUI.minimizeButton then
  managerAttackUI.minimizeButton:setMarginRight(-13)
  managerAttackUI.minimizeButton.onClick = function()
    managerAtkSetMinimized(not (toolsStorage[panelName].managerAttackbotMinimized == true))
  end
end

macro(300, function()
  managerAtkStoreCurrentSize(false)

  if not hudSwitchOn("comboManager") then
    if managerAttackUI:isVisible() then
      managerAttackUI:hide()
    end
    return
  end

  if not managerAttackUI:isVisible() then
    managerAttackUI:show()
    managerAtkApplyPos()
    managerAtkSetMinimized(toolsStorage[panelName].managerAttackbotMinimized == true)
  end

  if not toolsStorage[panelName].managerAttackbotMinimized then
    if managerAtkNeedsRefresh() then
      managerAtkRefresh()
    end

    managerAtkUpdateCooldowns()
  end
end)

macro(1000, function()
  if not managerAttackUI:isVisible() then return end
  if toolsStorage[panelName].managerAttackbotMinimized then return end

  if managerAtkNeedsRefresh() then
    managerAtkRefresh()
  end

  managerAtkUpdateCooldowns()
end)
end)

lnsRunBlock("FUNCTION CAVEBOT", function()
setDefaultTab("Cave")

storage = storage or {}
storage.LNSCaveFunctionsGlobal = storage.LNSCaveFunctionsGlobal or {}

local caveFunctionsStorage = storage.LNSCaveFunctionsGlobal

local CAVE_FUNCTIONS_STORAGE = "lnsCaveFunctions"

caveFunctionsStorage[CAVE_FUNCTIONS_STORAGE] = caveFunctionsStorage[CAVE_FUNCTIONS_STORAGE] or {
  qtdeMortes = 1,
  pauseCaveDeath = false,
  exitGameDeath = false,

  qtdeLure = 1,
  qtdeReturnlure = 1,
  startLure = false,

  pauseTargetPlayer = false
}

local caveSetCfg = caveFunctionsStorage[CAVE_FUNCTIONS_STORAGE]

local function saveCaveFunctions()
  storage.LNSCaveFunctionsGlobal = caveFunctionsStorage
end

addButton("", "LNS Cavebot Settings", function()
  lnsCaveSet:show()
  lnsCaveSet:raise()
  lnsCaveSet:focus()
end)

sep = UI.Separator()
sep:setImageSource("")

lnsCaveSet = setupUI([[
MainWindow
  size: 330 350
  text: Panel Cave Functions
  
  FlatPanel
    id: flatp2
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -5
    margin-top: 2
    margin-bottom: 20

    ScrollablePanel
      id: listaMain
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-bottom: 5
      margin-top: 5
      margin-left: 4
      margin-right: 16
      image-source: /images/ui/panel_flat
      image-border: 1
      vertical-scrollbar: mainListScrollBar
      opacity: 1.00

      Label
        id: explicDeathLogout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        margin-left: 5
        margin-top: 2
        text-align: center
        color: orange
        text: "Deaths Control"

      HorizontalSeparator
        id: hsep
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-right: 3
        margin-top: 2

      Label
        id: labelqtdeMortes
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 5
        text-align: center
        text: Amount Deaths: 1

      HorizontalScrollBar
        id: qtdeMortes
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        minimum: 1
        maximum: 10

      BotSwitch
        id: PauseCaveDeath
        anchors.top: prev.bottom
        anchors.left: prev.left
        text: Pause Cavebot
        margin-top: 5
        width: 140

      BotSwitch
        id: ExitGameDeath
        anchors.top: prev.top
        anchors.right: qtdeMortes.right
        text: Exit Game
        width: 140
        margin-top: 0

      HorizontalSeparator
        id: hsep2
        anchors.top: prev.bottom
        anchors.left: hsep.left
        anchors.right: hsep.right
        margin-top: 10

      Label
        id: labelcontroleLure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        text-align: center
        text: "Lure Control"
        color: orange

      HorizontalSeparator
        id: hsep3
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2

      Label
        id: labelqtdelure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 5
        text-align: center
        text: Pause lure with: 1 creatures 

      HorizontalScrollBar
        id: qtdeLure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        minimum: 1
        maximum: 10

      Label
        id: labelreturnlure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 5
        text-align: center
        text: Return lure with: 1 creatures 

      HorizontalScrollBar
        id: qtdeReturnlure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        minimum: 1
        maximum: 10

      BotSwitch
        id: startLure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        text: Start Lure
        width: 140
        margin-top: 5

      HorizontalSeparator
        id: hsepp
        anchors.top: prev.bottom
        anchors.left: hsep.left
        anchors.right: hsep.right
        margin-top: 10

      Label
        id: labelRagnar
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        text-align: center
        text: "Pause Target"
        color: orange

      HorizontalSeparator
        id: hsepp2
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2

      BotSwitch
        id: pauseTargetPlayer
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        text: Pause Target with Player on Screen
        width: 140
        margin-top: 5

    VerticalScrollBar
      id: mainListScrollBar
      anchors.top: listaMain.top
      anchors.bottom: listaMain.bottom
      anchors.left: listaMain.right
      step: 10
      pixels-scroll: true
      visible: true
      opacity: 1.00
      margin-left: 0

  Button
    id: closePanel
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    size: 35 20
    margin-top: 5
    text: Close
]], g_ui.getRootWidget())

lnsCaveSet:hide()

local mainPanel = lnsCaveSet.flatp2.listaMain

lnsCaveSet.closePanel.onClick = function()
  lnsCaveSet:hide()
end

local function bindSwitch(widget, key)
  if not widget then return end

  caveSetCfg[key] = caveSetCfg[key] == true
  widget:setOn(caveSetCfg[key])

  widget.onClick = function(w)
    caveSetCfg[key] = not caveSetCfg[key]
    w:setOn(caveSetCfg[key])
    saveCaveFunctions()
  end
end

local function bindScroll(widget, label, key, defaultValue, labelPrefix, labelSuffix)
  if not widget then return end

  caveSetCfg[key] = tonumber(caveSetCfg[key]) or defaultValue or 1
  widget:setValue(caveSetCfg[key])

  local function updateLabel(value)
    if label then
      label:setText((labelPrefix or "") .. tostring(value) .. (labelSuffix or ""))
    end
  end

  updateLabel(caveSetCfg[key])

  widget.onValueChange = function(_, value)
    value = tonumber(value) or defaultValue or 1
    caveSetCfg[key] = value
    updateLabel(value)
    saveCaveFunctions()
  end
end

bindScroll(mainPanel.qtdeMortes, mainPanel.labelqtdeMortes, "qtdeMortes", 1, "Amount Deaths: ", "")
bindScroll(mainPanel.qtdeLure, mainPanel.labelqtdelure, "qtdeLure", 1, "Pause lure with: ", " creatures")
bindScroll(mainPanel.qtdeReturnlure, mainPanel.labelreturnlure, "qtdeReturnlure", 1, "Return lure with: ", " creatures")

mainPanel.PauseCaveDeath:setOn(caveSetCfg.pauseCaveDeath == true)
mainPanel.ExitGameDeath:setOn(caveSetCfg.exitGameDeath == true)

mainPanel.PauseCaveDeath.onClick = function(widget)
  local state = not widget:isOn()

  caveSetCfg.pauseCaveDeath = state
  caveSetCfg.exitGameDeath = false

  widget:setOn(state)
  mainPanel.ExitGameDeath:setOn(false)

  saveCaveFunctions()
end

mainPanel.ExitGameDeath.onClick = function(widget)
  local state = not widget:isOn()

  caveSetCfg.exitGameDeath = state
  caveSetCfg.pauseCaveDeath = false

  widget:setOn(state)
  mainPanel.PauseCaveDeath:setOn(false)

  saveCaveFunctions()
end

bindSwitch(mainPanel.startLure, "startLure")
bindSwitch(mainPanel.pauseTargetPlayer, "pauseTargetPlayer")

caveFunctionsStorage.deathControl = caveFunctionsStorage.deathControl or {
  deaths = 0
}

local deathState = {
  wasAlive = true
}

local function saveDeath()
  storage.LNSCaveFunctionsGlobal = caveFunctionsStorage
end

macro(500, function()
  if not caveSetCfg then return end

  local isDead = player:getHealth() == 0

  -- DETECTA MORTE
  if isDead and deathState.wasAlive then
    deathState.wasAlive = false

    caveFunctionsStorage.deathControl.deaths = (caveFunctionsStorage.deathControl.deaths or 0) + 1
    saveDeath()

    modules.game_textmessage.displayGameMessage("[Death Control] Morte: " .. caveFunctionsStorage.deathControl.deaths)

    local limit = tonumber(caveSetCfg.qtdeMortes) or 1

    if caveFunctionsStorage.deathControl.deaths >= limit then

      if caveSetCfg.pauseCaveDeath then
        CaveBot.setOff()
        TargetBot.setOff()
        modules.game_textmessage.displayGameMessage("[Death Control] Cavebot pausado.")
      
      elseif caveSetCfg.exitGameDeath then
        modules.game_textmessage.displayGameMessage("[Death Control] Saindo do jogo.")
        schedule(200, function()
          modules.game_interface.forceExit()
        end)
      end

      caveFunctionsStorage.deathControl.deaths = 0
      saveDeath()
    end

  elseif not isDead then
    deathState.wasAlive = true
  end
end)

local lurePausedByScript = false

local function countScreenMonsters()
  local count = 0

  for _, spec in ipairs(getSpectators(false)) do
    if spec:isMonster() then
      count = count + 1
    end
  end

  return count
end

macro(500, function()
  if not caveSetCfg then return end
  if caveSetCfg.startLure ~= true then
    lurePausedByScript = false
    return
  end

  local mobs = countScreenMonsters()
  local pauseAt = tonumber(caveSetCfg.qtdeLure) or 6
  local returnAt = tonumber(caveSetCfg.qtdeReturnlure) or 2

  if not lurePausedByScript and mobs >= pauseAt then
    lurePausedByScript = true
    CaveBot.setOff()
    TargetBot.setOn()
    modules.game_textmessage.displayGameMessage("[Lure Control] CaveBot pausado. Mobs na tela: " .. mobs)
    return
  end

  if lurePausedByScript and mobs <= returnAt then
    lurePausedByScript = false
    CaveBot.setOn()
    TargetBot.setOff()
    modules.game_textmessage.displayGameMessage("[Lure Control] CaveBot retomado. Mobs na tela: " .. mobs)
  end
end)

local targetPausedByPlayer = false

local function hasPlayerNear()
  local ppos = pos()
  if not ppos then return false end

  for _, spec in ipairs(getSpectators(false)) do
    if spec:isPlayer() and spec ~= player then
      local spos = spec:getPosition()
      if spos and spos.z == ppos.z and getDistanceBetween(ppos, spos) <= 6 then
        return true
      end
    end
  end

  return false
end

macro(300, function()
  if not caveSetCfg then return end
  if caveSetCfg.pauseTargetPlayer ~= true then
    targetPausedByPlayer = false
    return
  end

  if hasPlayerNear() then
    if not targetPausedByPlayer then
      targetPausedByPlayer = true
      TargetBot.setOff()
      modules.game_textmessage.displayGameMessage("[Pause Target] Player perto. TargetBot pausado.")
    end
    return
  end

  if targetPausedByPlayer then
    targetPausedByPlayer = false
    TargetBot.setOn()
    modules.game_textmessage.displayGameMessage("[Pause Target] Sem player perto. TargetBot retomado.")
  end
end)

end)

lnsRunBlock("WAR", function()
setDefaultTab("War")

UI.Separator():setMarginTop(0)

storage = storage or {}
storage.LNSWarGlobal = storage.LNSWarGlobal or {}

local warStorage = storage.LNSWarGlobal

local function saveWarGlobal()
  storage.LNSWarGlobal = warStorage
end

local function saveComboLeaderChar()
  saveWarGlobal()
end

local function trimText(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local switchComboLeader = "comboLeaderButton"
warStorage[switchComboLeader] = warStorage[switchComboLeader] or { enabled = false }

warStorage.comboLeaderPanel = warStorage.comboLeaderPanel or {
  lider1 = "",
  lider2 = "",
  lider3 = "",
  lider4 = "",
  liderCommand = false,
  selectChat = "Default"
}

local comboLeaderCfg = warStorage.comboLeaderPanel

comboLeaderButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Multi Leader
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
comboLeaderButton:setId(switchComboLeader)
comboLeaderButton.title:setOn(warStorage[switchComboLeader].enabled)

comboLeaderButton.title.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  warStorage[switchComboLeader].enabled = state
  saveComboLeaderChar()
end

comboLeader = setupUI([=[
MainWindow
  id: mainPanel
  size: 250 320
  text: Panel Multi Leader
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin: -6
    margin-top: 0
    margin-bottom: 20

    Label
      id: info
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 5
      margin-right: 0
      text-wrap: true
      text-auto-resize: true
      text: "[BR]: Insira o nome dos lideres em ordem de prioridade para seguir o target.\n\n[EN]: Enter the names of the leaders in order of priority to follow the tgt."

    HorizontalSeparator
      id: hsep
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 4
      margin-right: 4

    TextEdit
      id: lider1
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      placeholder: Insert Leader Name 1

    TextEdit
      id: lider2
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      placeholder: Insert Leader Name 2
    
    TextEdit
      id: lider3
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      placeholder: Insert Leader Name 3

    TextEdit
      id: lider4
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      placeholder: Insert Leader Name 4

    HorizontalSeparator
      id: hsep
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 4
      margin-right: 4

    BotSwitch
      id: liderCommand
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.bottom: parent.bottom
      margin-bottom: 6
      margin-top: 4
      width: 70
      text-wrap: true
      text-auto-resize: true
      text: Leader Command
      tooltip: Use this to send the attack command in the chat defined to the side (for knights or monks only).
      $on:
        image-color: green
        color: white

      $!on:
        image-color: red
        color: white

    Label
      id: channel
      anchors.top: prev.top
      anchors.left: prev.right
      margin-left: 5
      margin-top: -1
      text: Channel to send attack:

    ComboBox
      id: selectChat
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: parent.right
      margin-top: 1
      margin-right: 4
      height: 20
      @onSetup: |
        self:addOption("Default")
        self:addOption("Party Channel")
      
  Button
    id: closePanel
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    size: 35 20
    margin-top: 6
    text: Close
]=], g_ui.getRootWidget())
comboLeader:hide()

local function W(parent, id)
  if not parent then return nil end
  return (parent.getChildById and parent:getChildById(id)) or
         (parent.recursiveGetChildById and parent:recursiveGetChildById(id))
end

local leader1 = W(comboLeader, "lider1")
local leader2 = W(comboLeader, "lider2")
local leader3 = W(comboLeader, "lider3")
local leader4 = W(comboLeader, "lider4")
local liderCommand = W(comboLeader, "liderCommand")
local selectChat = W(comboLeader, "selectChat")
local closePanel = W(comboLeader, "closePanel")

local loadingComboLeaderFields = false

local function loadComboLeaderFields()
  loadingComboLeaderFields = true

  if leader1 then leader1:setText(comboLeaderCfg.lider1 or "") end
  if leader2 then leader2:setText(comboLeaderCfg.lider2 or "") end
  if leader3 then leader3:setText(comboLeaderCfg.lider3 or "") end
  if leader4 then leader4:setText(comboLeaderCfg.lider4 or "") end

  if liderCommand and liderCommand.setOn then
    liderCommand:setOn(comboLeaderCfg.liderCommand == true)
  end

  if selectChat and selectChat.setOption then
    selectChat:setOption(comboLeaderCfg.selectChat or "Default")
  end

  loadingComboLeaderFields = false
end

local function saveComboLeaderFields()
  if loadingComboLeaderFields then return end

  comboLeaderCfg.lider1 = trimText(leader1 and leader1:getText() or "")
  comboLeaderCfg.lider2 = trimText(leader2 and leader2:getText() or "")
  comboLeaderCfg.lider3 = trimText(leader3 and leader3:getText() or "")
  comboLeaderCfg.lider4 = trimText(leader4 and leader4:getText() or "")
  comboLeaderCfg.liderCommand = liderCommand and liderCommand:isOn() or false
  comboLeaderCfg.selectChat = selectChat and selectChat:getCurrentOption().text or "Default"

  saveComboLeaderChar()
end

comboLeaderButton.settings.onClick = function()
  loadComboLeaderFields()
  if not comboLeader:isVisible() then
    comboLeader:show()
    comboLeader:raise()
    comboLeader:focus()
  end
end

if closePanel then
  closePanel.onClick = function()
    saveComboLeaderFields()
    comboLeader:hide()
  end
end

if leader1 then
  leader1.onTextChange = function()
    saveComboLeaderFields()
  end
end

if leader2 then
  leader2.onTextChange = function()
    saveComboLeaderFields()
  end
end

if leader3 then
  leader3.onTextChange = function()
    saveComboLeaderFields()
  end
end

if leader4 then
  leader4.onTextChange = function()
    saveComboLeaderFields()
  end
end

if selectChat then
  selectChat.onOptionChange = function(widget, optionText)
    if loadingComboLeaderFields then return end
    comboLeaderCfg.selectChat = optionText
    saveComboLeaderChar()
  end
end

if liderCommand then
  liderCommand:setOn(comboLeaderCfg.liderCommand == true)

  liderCommand.onClick = function(widget)
    if loadingComboLeaderFields then return end
    comboLeaderCfg.liderCommand = not comboLeaderCfg.liderCommand
    widget:setOn(comboLeaderCfg.liderCommand)
    saveComboLeaderChar()
  end
end

loadComboLeaderFields()

local function lowerTrim(s)
  return trimText(s):lower()
end

local function getMultiLeaderPriority()
  return {
    lowerTrim(comboLeaderCfg.lider1),
    lowerTrim(comboLeaderCfg.lider2),
    lowerTrim(comboLeaderCfg.lider3),
    lowerTrim(comboLeaderCfg.lider4)
  }
end

local function getLeaderOnScreenByPriority()
  local leaders = getMultiLeaderPriority()
  local specs = getSpectators(false) or {}

  for i = 1, #leaders do
    local leaderName = leaders[i]
    if leaderName ~= "" then
      for _, creature in ipairs(specs) do
        if creature and creature:isPlayer() and lowerTrim(creature:getName()) == leaderName then
          return leaderName, creature
        end
      end
    end
  end

  return "", nil
end

local function getAttackLeaderName()
  local leaderName = getLeaderOnScreenByPriority()
  return leaderName or ""
end

onMissle(function(missle)
  if not warStorage[switchComboLeader] or not warStorage[switchComboLeader].enabled then return end

  local leaderName, leaderCreature = getLeaderOnScreenByPriority()
  if leaderName == "" or not leaderCreature then return end

  local src = missle:getSource()
  if not src or src.z ~= posz() then return end

  local from = g_map.getTile(src)
  local to = g_map.getTile(missle:getDestination())
  if not from or not to then return end

  local fromCreatures = from:getCreatures()
  local toCreatures = to:getCreatures()
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end

  local attacker = fromCreatures[1]
  local target = toCreatures[1]

  if not attacker or not target then return end
  if lowerTrim(attacker:getName()) ~= leaderName then return end
  if lowerTrim(target:getName()) == leaderName then return end

  local currentTarget = g_game.getAttackingCreature()
  if not currentTarget or currentTarget ~= target then
    g_game.attack(target)
  end
end)

local function decodeTargetId(text)
  local digits = (text or ""):gsub("%D", "")
  if digits == "" then return nil end
  return tonumber(digits)
end

local function sendAttackCommand(target)
  if not target then return end

  local msg = "ATACAR: " .. encodeTargetId(target:getId())

  if comboLeaderCfg.selectChat == "Party Channel" then
    sayChannel(1, msg)
  else
    say(msg)
  end
end

onTalk(function(name, level, mode, text, channelId, pos)
  if not warStorage[switchComboLeader] or not warStorage[switchComboLeader].enabled then return end
  if not comboLeaderCfg.liderCommand then return end

  local leaderName = getAttackLeaderName()
  if leaderName == "" then return end
  if lowerTrim(name) ~= leaderName then return end

  if comboLeaderCfg.selectChat == "Party Channel" and channelId ~= 1 then
    return
  end

  if not text or not text:find("ATACAR:", 1, true) then return end

  local id = decodeTargetId(text)
  if not id then return end

  local target = getCreatureById(id)
  if not target then return end
  if target:getPosition().z ~= posz() then return end
  if g_game.getAttackingCreature() == target then return end

  g_game.attack(target)
end)

---------------------------------
------ MWSYSTEM
---------------------------------

local MW_STORAGE = "holdMwWgPanel"

warStorage[MW_STORAGE] = warStorage[MW_STORAGE] or {
  enabled = false,

  mwRune = 3180,
  mwWall1 = 2129,
  mwWall2 = 16518,

  wgRune = 3156,
  wgWall1 = 2130,

  holdMw = false,
  holdWg = false,
  mwFront = false,
  mwBack = false,
  mwTrap = false,
  pause = true,

  -- usado pelo icone unico Hold MW/WG
  iconHoldMwWg = false,

  keyHoldMw = "",
  keyHoldWg = "",
  keyMwFront = "",
  keyMwBack = "",
  keyMwTrap = "",

  tempo = 1200
}

local mwCfg = warStorage[MW_STORAGE]

if mwCfg.iconHoldMwWg == nil then
  mwCfg.iconHoldMwWg = false
end

local function saveMwStorage()
  saveWarGlobal()
end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    return tonumber(widget:getItemId()) or 0
  end
  if widget.getItem then
    local item = widget:getItem()
    if item and item.getId then
      return tonumber(item:getId()) or 0
    end
  end
  return 0
end

local function setBotItemId(widget, id)
  id = tonumber(id) or 0
  if not widget then return end
  if widget.setItemId then
    widget:setItemId(id)
  elseif widget.setItem then
    widget:setItem(id)
  end
end

mwButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Hold MW/WG
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

mwInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 400 298
  text: Hold MW / WG
  margin-top: -50

  Panel
    anchors.fill: parent
    margin: 5
    margin-left: -3

  FlatPanel
    id: panelMw
    anchors.top: parent.top
    anchors.left: parent.left
    width: 185
    height: 110

    Label
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 5
      text: Magic Wall
      color: #e6d2a6
      text-auto-resize: true
      font: verdana-11px-rounded

    Label
      id: runa1
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 12
      margin-left: 8
      text: Rune:

    BotItem
      id: mwRune
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-right: 8

    Label
      anchors.top: runa1.bottom
      anchors.left: runa1.left
      margin-top: 34
      text: Walls:

    BotItem
      id: mwWall1
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-right: 8

    BotItem
      id: mwWall2
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: mwWall1.left
      margin-right: 4

  FlatPanel
    id: panelWG
    anchors.top: panelMw.bottom
    anchors.left: panelMw.left
    margin-top: 10
    width: 185
    height: 120

    Label
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 5
      text: Wild Growth
      color: #e6d2a6
      text-auto-resize: true
      font: verdana-11px-rounded

    Label
      id: rune2
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 15
      margin-left: 8
      text: Rune:

    BotItem
      id: wgRune
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-right: 8

    Label
      anchors.top: rune2.bottom
      anchors.left: rune2.left
      margin-top: 38
      text: Walls:

    BotItem
      id: wgWall1
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-right: 8

    BotItem
      id: wgWall2
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: wgWall1.left
      margin-right: 4

  FlatPanel
    id: previewPanel
    anchors.top: panelMw.top
    anchors.left: panelMw.right
    anchors.bottom: panelWG.bottom
    margin-left: 10
    width: 180

    BotSwitch
      id: holdMw
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 8
      margin-left: 5
      size: 30 20
      text: OFF
      $on:
        text: ON

    Label
      id: labelHoldMw
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Hold MW:

    TextEdit
      id: keyHoldMw
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 15
      margin-right: 5
      placeholder: Key

    BotSwitch
      id: holdWg
      anchors.top: holdMw.bottom
      anchors.left: holdMw.left
      margin-top: 12
      size: 30 20
      text: OFF
      $on:
        text: ON

    Label
      id: labelHoldWg
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Hold WG:

    TextEdit
      id: keyHoldWg
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 15
      margin-right: 5
      placeholder: Key

    BotSwitch
      id: mwFront
      anchors.top: holdWg.bottom
      anchors.left: holdWg.left
      margin-top: 12
      size: 30 20
      text: OFF
      $on:
        text: ON

    Label
      id: labelMwFront
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Mw Front:

    TextEdit
      id: keyMwFront
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: keyHoldWg.left
      anchors.right: keyHoldWg.right
      placeholder: Key

    BotSwitch
      id: mwBack
      anchors.top: mwFront.bottom
      anchors.left: mwFront.left
      margin-top: 12
      size: 30 20
      text: OFF
      $on:
        text: ON

    Label
      id: labelMwBack
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Mw Back:

    TextEdit
      id: keyMwBack
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: keyHoldWg.left
      anchors.right: keyHoldWg.right
      placeholder: Key

    BotSwitch
      id: mwTrap
      anchors.top: mwBack.bottom
      anchors.left: mwBack.left
      margin-top: 12
      size: 30 20
      text: OFF
      $on:
        text: ON

    Label
      id: labelMwTrap
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Mw Trap:

    TextEdit
      id: keyMwTrap
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: keyHoldWg.left
      anchors.right: keyHoldWg.right
      placeholder: Key

    HorizontalSeparator
      id: sep1
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-left: 5
      margin-right: 5
      margin-top: 9

    Label
      id: remainingTime
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text-align: center
      text: Remaining Time: 0

    HorizontalScrollBar
      id: tempo
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      minimum: 0
      maximum: 3000
      step: 100

    BotSwitch
      id: pause
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Pause to use MW

  Button
    id: closePanel
    anchors.left: panelMw.left
    anchors.right: previewPanel.right
    anchors.top: previewPanel.bottom
    size: 35 20
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())

mwInterface:hide()

local function bindSwitch(widget, key)
  if not widget then return end
  mwCfg[key] = mwCfg[key] == true
  widget:setOn(mwCfg[key])

  widget.onClick = function(w)
    mwCfg[key] = not mwCfg[key]
    w:setOn(mwCfg[key])
    saveMwStorage()
  end
end

local function bindText(widget, key)
  if not widget then return end
  widget:setText(tostring(mwCfg[key] or ""))

  widget.onTextChange = function(_, text)
    mwCfg[key] = tostring(text or "")
    saveMwStorage()
  end
end

local function bindBotItem(widget, key, defaultId)
  if not widget then return end

  mwCfg[key] = tonumber(mwCfg[key]) or tonumber(defaultId) or 0
  setBotItemId(widget, mwCfg[key])

  widget.onItemChange = function(w)
    mwCfg[key] = getBotItemId(w)
    saveMwStorage()
  end
end

local function updateTempoLabel(value)
  value = tonumber(value) or 0
  mwInterface.previewPanel.remainingTime:setText("Remaining Time: " .. value .. " ms")
end

mwButton.title:setOn(mwCfg.enabled == true)
mwButton.title.onClick = function(widget)
  mwCfg.enabled = not widget:isOn()
  widget:setOn(mwCfg.enabled)
  saveMwStorage()
end

mwButton.settings.onClick = function()
  if mwInterface:isVisible() then
    mwInterface:hide()
  else
    mwInterface:show()
    mwInterface:raise()
    mwInterface:focus()
  end
end

mwInterface.closePanel.onClick = function()
  mwInterface:hide()
end

bindBotItem(mwInterface.panelMw.mwRune, "mwRune", 3180)
bindBotItem(mwInterface.panelMw.mwWall1, "mwWall1", 2129)
bindBotItem(mwInterface.panelMw.mwWall2, "mwWall2", 2128)

bindBotItem(mwInterface.panelWG.wgRune, "wgRune", 3156)
bindBotItem(mwInterface.panelWG.wgWall1, "wgWall1", 2130)
bindBotItem(mwInterface.panelWG.wgWall2, "wgWall2", 0)

bindSwitch(mwInterface.previewPanel.holdMw, "holdMw")
bindSwitch(mwInterface.previewPanel.holdWg, "holdWg")
bindSwitch(mwInterface.previewPanel.mwFront, "mwFront")
bindSwitch(mwInterface.previewPanel.mwBack, "mwBack")
bindSwitch(mwInterface.previewPanel.mwTrap, "mwTrap")
bindSwitch(mwInterface.previewPanel.pause, "pause")

bindText(mwInterface.previewPanel.keyHoldMw, "keyHoldMw")
bindText(mwInterface.previewPanel.keyHoldWg, "keyHoldWg")
bindText(mwInterface.previewPanel.keyMwFront, "keyMwFront")
bindText(mwInterface.previewPanel.keyMwBack, "keyMwBack")
bindText(mwInterface.previewPanel.keyMwTrap, "keyMwTrap")

mwCfg.tempo = tonumber(mwCfg.tempo) or 0
mwInterface.previewPanel.tempo:setValue(mwCfg.tempo)
updateTempoLabel(mwCfg.tempo)

mwInterface.previewPanel.tempo.onValueChange = function(_, value)
  mwCfg.tempo = tonumber(value) or 0
  updateTempoLabel(mwCfg.tempo)
  saveMwStorage()
end

-- =========================================================
-- LNS HOLD MW/WG SYSTEM
-- Painel/Storage usado: mwCfg
-- =========================================================

pauseForMw = pauseForMw or 0

local MW_CAST_COOLDOWN = 200
local MW_KEY_COOLDOWN = 200
local MW_FAIL_COOLDOWN = 100
local HOLD_RECAST_DELAY = 300
local HOLD_ALL_CD = 250
local TRAP_CD = 250
local OWN_WALL_CAST_WINDOW = 3000
local CURSOR_REOPEN_DELAY = 50

local mwLastCast = 0
local mwLastKey = { front = 0, back = 0 }
local mwTileCooldown = {}

local holdPressAt = 0
local holdCandidates = {}
local holdReadyAt = {}
local holdLastCast = 0

local ownWallCasts = {}
local cursorCast = nil
local cursorActiveKind = nil
local cancelCursorCast

local trapCheckPos = nil
local trapMwPos = nil
local lastTrapCast = 0

local mwWgTimers = {}
local pauseTriggeredByTile = {}

local function keyPos(p)
  return p.x .. "," .. p.y .. "," .. p.z
end

local function samePos(a, b)
  return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function wallTextFromRuneId(id)
  id = tonumber(id)

  if id == tonumber(mwCfg.mwRune) then
    return "MW Here"
  end

  if id == tonumber(mwCfg.wgRune) then
    return "WG Here"
  end

  return nil
end

local function wallTextFromWallId(id)
  id = tonumber(id)

  if id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or id == 16518 or id == 2128 then
    return "MW Here"
  end

  if id == tonumber(mwCfg.wgWall1) or id == tonumber(mwCfg.wgWall2) then
    return "WG Here"
  end

  return nil
end

local function cleanOwnWallCasts()
  for k, data in pairs(ownWallCasts) do
    if not data or (data.expires or 0) < now then
      ownWallCasts[k] = nil
    end
  end
end

local function registerOwnWallCast(pos, runeId)
  if not pos then return end

  local text = wallTextFromRuneId(runeId)
  if not text then return end

  cleanOwnWallCasts()

  ownWallCasts[keyPos(pos)] = {
    text = text,
    expires = now + OWN_WALL_CAST_WINDOW
  }
end

local function takeOwnWallCast(pos, wallId)
  if not pos then return nil end

  local k = keyPos(pos)
  local data = ownWallCasts[k]
  if not data then return nil end

  if (data.expires or 0) < now then
    ownWallCasts[k] = nil
    return nil
  end

  local wallText = wallTextFromWallId(wallId)
  if not wallText or wallText ~= data.text then
    return nil
  end

  ownWallCasts[k] = nil
  return wallText
end

local function isSystemOn()
  return mwCfg and mwCfg.enabled == true
end

local function isWallId(id)
  id = tonumber(id)
  return id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or
         id == tonumber(mwCfg.wgWall1) or id == tonumber(mwCfg.wgWall2) or
         id == 16518 or id == 2128
end

local function hasWall(tile)
  if not tile then return false end
  for _, item in ipairs(tile:getItems() or {}) do
    if item.getId and isWallId(item:getId()) then
      return true
    end
  end
  return false
end

local function inRange(pos)
  local ppos = player:getPosition()
  return ppos and pos and ppos.z == pos.z and math.abs(ppos.x - pos.x) < 8 and math.abs(ppos.y - pos.y) < 6
end

local tryUseRuneOnThing

local function canUseOnTile(pos)
  if not pos or pos.z ~= posz() then return nil end
  if isInPz() then return nil end
  if not inRange(pos) then return nil end

  local tile = g_map.getTile(pos)
  if not tile then return nil end
  if not tile:canShoot() then return nil end
  if tile.isWalkable and not tile:isWalkable() then return nil end
  if hasWall(tile) then return nil end

  local top = tile:getTopUseThing()
  if not top then return nil end

  return tile, top
end

local function useMwAt(pos)
  local tile, top = canUseOnTile(pos)
  if not tile or not top then return false end

  if now - mwLastCast < MW_CAST_COOLDOWN then return false end

  local k = keyPos(tile:getPosition())
  if (mwTileCooldown[k] or 0) > now then return false end

  mwLastCast = now

  local runeId = tonumber(mwCfg.mwRune) or 3180

  if tryUseRuneOnThing(runeId, top) then
    registerOwnWallCast(tile:getPosition(), runeId)
    mwTileCooldown[k] = now + MW_CAST_COOLDOWN
    return true
  end

  mwTileCooldown[k] = now + MW_FAIL_COOLDOWN
  return false
end

-- =========================================================
-- MW FRONT / BACK
-- =========================================================

local function getTargetPosByDir(target, front)
  local tpos = target:getPosition()
  local dir = target:getDirection()
  if not tpos or dir == nil then return nil end

  local dx, dy = 0, 0
  if dir == 0 then dy = -1
  elseif dir == 1 then dx = 1
  elseif dir == 2 then dy = 1
  elseif dir == 3 then dx = -1 end

  if not front then
    dx, dy = -dx, -dy
  end

  return {x = tpos.x + dx, y = tpos.y + dy, z = tpos.z}, dir
end

local function getSpread(base, dir)
  local list = {base}

  if dir == 0 or dir == 2 then
    table.insert(list, {x = base.x - 1, y = base.y, z = base.z})
    table.insert(list, {x = base.x + 1, y = base.y, z = base.z})
  else
    table.insert(list, {x = base.x, y = base.y - 1, z = base.z})
    table.insert(list, {x = base.x, y = base.y + 1, z = base.z})
  end

  return list
end

local function castMwFrontBack(front)
  local target = g_game.getAttackingCreature()
  if not target then return end

  local tpos = target:getPosition()
  if not tpos or tpos.z ~= posz() then return end

  local base, dir = getTargetPosByDir(target, front)
  if not base then return end

  for _, p in ipairs(getSpread(base, dir)) do
    if useMwAt(p) then return true end
  end
end

local function executeMwFrontBack(front)
  if not isSystemOn() then return false end

  local mode = front and "front" or "back"
  if now - (mwLastKey[mode] or 0) < MW_KEY_COOLDOWN then return false end

  mwLastKey[mode] = now
  return castMwFrontBack(front) == true
end

-- API para outros scripts/ícones chamarem
LNS_MWSystem = LNS_MWSystem or {}
LNS_MWSystem.mwFront = function()
  return executeMwFrontBack(true)
end
LNS_MWSystem.mwBack = function()
  return executeMwFrontBack(false)
end
LNS_MWSystem.castFront = LNS_MWSystem.mwFront
LNS_MWSystem.castBack = LNS_MWSystem.mwBack


onKeyPress(function(keys)
  local key = tostring(keys or ""):lower()
  if key == "" then return end

  local frontKey = tostring(mwCfg.keyMwFront or ""):lower()
  local backKey = tostring(mwCfg.keyMwBack or ""):lower()

  local isFront = mwCfg.mwFront == true and frontKey ~= "" and key == frontKey
  local isBack = mwCfg.mwBack == true and backKey ~= "" and key == backKey

  if not isFront and not isBack then return end

  executeMwFrontBack(isFront)
end)

-- =========================================================
-- HOLD MW / WG
-- =========================================================

local function holdEnabled()
  return isSystemOn() and (mwCfg.holdMw == true or mwCfg.holdWg == true)
end

local function getRuneByText(text)
  if text == "MW Here" and mwCfg.holdMw == true then
    return tonumber(mwCfg.mwRune) or 3180
  end

  if text == "WG Here" and mwCfg.holdWg == true then
    return tonumber(mwCfg.wgRune) or 3156
  end

  return nil
end

local function addHoldCandidate(pos)
  if not pos then return end
  for _, p in ipairs(holdCandidates) do
    if samePos(p, pos) then return end
  end
  table.insert(holdCandidates, pos)
end

local function removeHoldCandidate(pos)
  for i = #holdCandidates, 1, -1 do
    if samePos(holdCandidates[i], pos) then
      table.remove(holdCandidates, i)
      return
    end
  end
end

local function clearHoldMarks()
  holdCandidates = {}
  holdReadyAt = {}

  for _, tile in ipairs(g_map.getTiles(posz())) do
    local text = tile:getText() or ""
    if text == "MW Here" or text == "WG Here" then
      tile:setText("")
    end
  end
end

local function setMwUiSwitch(widget, state)
  if widget and widget.setOn then
    widget:setOn(state == true)
  end
end

local function refreshMwHoldButtons()
  if mwButton and mwButton.title then
    setMwUiSwitch(mwButton.title, mwCfg.enabled == true)
  end

  if mwInterface and mwInterface.previewPanel then
    setMwUiSwitch(mwInterface.previewPanel.holdMw, mwCfg.holdMw == true)
    setMwUiSwitch(mwInterface.previewPanel.holdWg, mwCfg.holdWg == true)
  end
end

local function setHoldMwWgIcon(state)
  state = state == true
  mwCfg.iconHoldMwWg = state

  if state then
    mwCfg.enabled = true
    mwCfg.holdMw = true
    mwCfg.holdWg = true
  else
    mwCfg.holdMw = false
    mwCfg.holdWg = false
    clearHoldMarks()
    if type(cancelCursorCast) == "function" then
      cancelCursorCast()
    end
  end

  refreshMwHoldButtons()
  saveMwStorage()
  return mwCfg.iconHoldMwWg == true
end

local function isHoldMwWgIconOn()
  return mwCfg.iconHoldMwWg == true
end

local function wallTextById(id)
  return wallTextFromWallId(id)
end

local function mwLater(ms, fn)
  if type(schedule) == "function" then return schedule(ms, fn) end
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then return g_dispatcher:scheduleEvent(fn, ms) end
  return fn()
end

local function showMwMessage(text)
  if modules and modules.game_textmessage and type(modules.game_textmessage.displayGameMessage) == "function" then
    modules.game_textmessage.displayGameMessage(text)
  elseif type(warn) == "function" then
    warn(text)
  end
end

tryUseRuneOnThing = function(runeId, thing)
  runeId = tonumber(runeId)
  if not runeId or not thing then return false end

  -- Caminho principal: usa o useWith padrao do vBot/OTC pelo ID da runa.
  -- Esse e o jeito mais compativel para BP aberta/fechada em clients que ja resolvem itemId internamente.
  if type(useWith) == "function" then
    local ok, ret = pcall(function()
      return useWith(runeId, thing)
    end)

    -- Alguns OTCs retornam nil/false mesmo enviando a acao para o servidor.
    -- Entao aqui so tratamos erro real de pcall como falha.
    if ok then return true end
  end

  -- Fallback por ID do client, quando existir.
  if g_game and type(g_game.useInventoryItemWith) == "function" then
    local ok = pcall(function()
      g_game.useInventoryItemWith(runeId, thing)
    end)
    if ok then return true end
  end

  return false
end

local scriptCursorVisualOn = false

local function setScriptCursorVisual(state)
  state = state == true

  if state and scriptCursorVisualOn then return end
  if not state and not scriptCursorVisualOn then return end

  if state then
    scriptCursorVisualOn = true

    -- Apenas visual. Nao usa Item.create/startUseWith falso, porque isso pode debuggar o client.
    if g_mouse and type(g_mouse.pushCursor) == "function" then
      pcall(function() g_mouse.pushCursor("target") end)
      return
    end

    if g_window and type(g_window.setMouseCursor) == "function" then
      pcall(function() g_window.setMouseCursor("/cursors/crosshair") end)
      return
    end

    return
  end

  scriptCursorVisualOn = false

  if g_mouse and type(g_mouse.popCursor) == "function" then
    pcall(function() g_mouse.popCursor() end)
    return
  end

  if g_window and type(g_window.restoreMouseCursor) == "function" then
    pcall(function() g_window.restoreMouseCursor() end)
    return
  end
end

local handleCursorMapTile = nil
local lastCursorMapClick = { at = 0, key = "" }
local cursorMouseDown = false
local cursorMouseDownAt = 0
local cursorMouseDownPos = nil

local function isLeftCursorButton(button)
  if button == nil then return false end

  if MouseLeftButton ~= nil and button == MouseLeftButton then
    return true
  end

  if button == 1 or button == 0 then
    return true
  end

  local s = tostring(button):lower()
  return s == "left" or s == "mouseleftbutton" or s == "mouseleft" or s == "1" or s == "0"
end

local function cursorMouseMovedTooMuch(a, b)
  if not a or not b then return false end
  local dx = math.abs((a.x or 0) - (b.x or 0))
  local dy = math.abs((a.y or 0) - (b.y or 0))
  return dx > 14 or dy > 14
end

local function callOldMapMouse(widget, mousePos, button, oldFn)
  if type(oldFn) == "function" then
    local ok, ret = pcall(oldFn, widget, mousePos, button)
    if ok then return ret end
  end
  return false
end

local function restoreOldCursorMapHook()
  cursorMouseDown = false
  cursorMouseDownAt = 0
  cursorMouseDownPos = nil

  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel then return end

  if panel.lnsMwCursorOldMousePress then
    panel.onMousePress = panel.lnsMwCursorOldMousePress
    panel.lnsMwCursorOldMousePress = nil
  end

  if panel.lnsMwCursorOldMouseRelease then
    panel.onMouseRelease = panel.lnsMwCursorOldMouseRelease
    panel.lnsMwCursorOldMouseRelease = nil
  end

  panel.lnsMwCursorHooked = nil
end

local function installCursorMapHook()
  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel then return false end
  if panel.lnsMwCursorHooked then return true end

  panel.lnsMwCursorOldMousePress = panel.onMousePress
  panel.lnsMwCursorOldMouseRelease = panel.onMouseRelease
  panel.lnsMwCursorHooked = true

  panel.onMousePress = function(widget, mousePos, button)
    if cursorCast and cursorActiveKind and isLeftCursorButton(button) then
      cursorMouseDown = true
      cursorMouseDownAt = now
      cursorMouseDownPos = mousePos and { x = mousePos.x, y = mousePos.y } or nil
      return true
    end

    return callOldMapMouse(widget, mousePos, button, widget.lnsMwCursorOldMousePress)
  end

  panel.onMouseRelease = function(widget, mousePos, button)
    if cursorCast and cursorActiveKind and isLeftCursorButton(button) then
      local validClick = cursorMouseDown == true
        and now - (cursorMouseDownAt or 0) <= 1500
        and not cursorMouseMovedTooMuch(cursorMouseDownPos, mousePos)

      cursorMouseDown = false
      cursorMouseDownAt = 0
      cursorMouseDownPos = nil

      if validClick and handleCursorMapTile and handleCursorMapTile(mousePos, button) then
        return true
      end

      return true
    end

    return callOldMapMouse(widget, mousePos, button, widget.lnsMwCursorOldMouseRelease)
  end

  return true
end

restoreOldCursorMapHook()

local function stopNativeCrosshair()
  restoreOldCursorMapHook()
  setScriptCursorVisual(false)

  if modules and modules.game_interface and type(modules.game_interface.stopUseWith) == "function" then
    pcall(function() modules.game_interface.stopUseWith() end)
    return
  end

  if g_game and type(g_game.cancelUse) == "function" then
    pcall(function() g_game.cancelUse() end)
  end
end

cancelCursorCast = function()
  cursorCast = nil
  cursorActiveKind = nil
  stopNativeCrosshair()
end

local function startNativeCrosshair(runeId)
  runeId = tonumber(runeId)
  if not runeId then return false end

  local openedNative = false

  -- Se a runa estiver visivel, abre o cursor nativo real e NAO instala hook no mapa.
  -- Isso evita marcar tile por movimento/hover e deixa o client cuidar do clique normal.
  if type(findItem) == "function" and modules and modules.game_interface and type(modules.game_interface.startUseWith) == "function" then
    local item = nil
    local okFind, found = pcall(function() return findItem(runeId) end)
    if okFind then item = found end

    if item then
      local okStart = pcall(function() modules.game_interface.startUseWith(item) end)
      openedNative = okStart == true
    end
  end

  if openedNative then
    restoreOldCursorMapHook()
    setScriptCursorVisual(false)
    return true
  end

  -- Se a runa nao estiver visivel, ai sim entra o cursor seguro da script.
  -- Ele so executa no CLIQUE esquerdo real, tratado no onMouseRelease.
  if installCursorMapHook() then
    setScriptCursorVisual(true)
    return true
  end

  return false
end

local function getCursorRuneId(kind)
  if kind == "mw" then
    return tonumber(mwCfg.mwRune) or 3180
  end

  if kind == "wg" then
    return tonumber(mwCfg.wgRune) or 3156
  end

  return nil
end

local function isCursorKindActive(kind)
  return cursorActiveKind == kind
end

local function reopenActiveCursor(kind)
  kind = kind or cursorActiveKind
  if not kind or cursorActiveKind ~= kind then return end
  if mwCfg.iconHoldMwWg ~= true then return end

  local runeId = getCursorRuneId(kind)
  if not runeId then return end

  cursorCast = {
    kind = kind,
    runeId = runeId
  }

  startNativeCrosshair(runeId)
end

local function activateCursorCast(kind)
  if not isSystemOn() then
    mwCfg.enabled = true
    refreshMwHoldButtons()
    saveMwStorage()
  end

  if mwCfg.iconHoldMwWg ~= true then
    showMwMessage("Ligue o icone Hold MW/WG antes de usar o cursor.")
    return false
  end

  local runeId = getCursorRuneId(kind)
  if not runeId then return false end

  -- clique no mesmo cursor = desliga. Clique no outro = troca MW <-> WG.
  if cursorActiveKind == kind then
    cancelCursorCast()
    return false
  end

  cursorActiveKind = kind
  cursorCast = {
    kind = kind,
    runeId = runeId
  }

  if not startNativeCrosshair(runeId) then
    cancelCursorCast()
    return false
  end

  return true
end

local function getUseWithTargetPos(pos, target)
  if target and target.getPosition then
    local ok, tpos = pcall(function() return target:getPosition() end)
    if ok and tpos then
      return { x = tpos.x, y = tpos.y, z = tpos.z }
    end
  end

  if type(pos) == "table" and pos.x and pos.y and pos.z then
    return { x = pos.x, y = pos.y, z = pos.z }
  end

  return nil
end

local function markCursorHoldTile(pos, runeId)
  if not pos then return end

  local text = wallTextFromRuneId(runeId)
  if not text then return end

  registerOwnWallCast(pos, runeId)

  local tile = g_map.getTile(pos)
  if tile then
    tile:setText(text)
  end

  addHoldCandidate(pos)
  holdReadyAt[keyPos(pos)] = now + 1200
end

handleCursorMapTile = function(mousePos, button)
  if not cursorCast or not cursorActiveKind then return false end
  if not isLeftCursorButton(button) then return false end
  if mwCfg.iconHoldMwWg ~= true then return false end

  local tile = getTileUnderCursor()
  if not tile then return true end

  local pos = tile:getPosition()
  if not pos then return true end

  local clickKey = keyPos(pos)
  if lastCursorMapClick.key == clickKey and now - (lastCursorMapClick.at or 0) < 120 then
    return true
  end

  lastCursorMapClick.key = clickKey
  lastCursorMapClick.at = now

  local runeId = tonumber(cursorCast.runeId)
  if not runeId then return true end

  local _, top = canUseOnTile(pos)
  if not top then return true end

  markCursorHoldTile(pos, runeId)
  tryUseRuneOnThing(runeId, top)

  -- Como o cursor fica ligado, reforca o crosshair visual apos cada clique.
  local activeKind = cursorActiveKind
  mwLater(CURSOR_REOPEN_DELAY, function()
    reopenActiveCursor(activeKind)
  end)

  return true
end

onUseWith(function(pos, itemId, target, subType)
  if not cursorCast or not cursorActiveKind then return end

  itemId = tonumber(itemId)
  if not itemId or itemId ~= tonumber(cursorCast.runeId) then return end

  local activeKind = cursorActiveKind
  local tpos = getUseWithTargetPos(pos, target)
  if tpos then
    markCursorHoldTile(tpos, itemId)
  end

  -- Se o client disparar onUseWith pelo cursor nativo, ele ja tentou o uso normal.
  -- Nao fazemos outro use aqui para evitar double-use/debug. O hook proprio do mapa ja resolve o modo sem runa visivel.

  -- Mantem o cursor ligado: depois de cada clique no mapa, abre o cursor de novo.
  mwLater(CURSOR_REOPEN_DELAY, function()
    reopenActiveCursor(activeKind)
  end)
end)

LNS_MWSystem.isHoldMwWg = function()
  return isHoldMwWgIconOn()
end

LNS_MWSystem.setHoldMwWg = function(state)
  return setHoldMwWgIcon(state == true)
end

LNS_MWSystem.toggleHoldMwWg = function()
  return setHoldMwWgIcon(not isHoldMwWgIconOn())
end

LNS_MWSystem.cursorMw = function()
  return activateCursorCast("mw")
end

LNS_MWSystem.cursorWg = function()
  return activateCursorCast("wg")
end

LNS_MWSystem.stopCursor = function()
  cancelCursorCast()
  return true
end

LNS_MWSystem.isCursorMw = function()
  return isCursorKindActive("mw")
end

LNS_MWSystem.isCursorWg = function()
  return isCursorKindActive("wg")
end

LNS_MWSystem.isCursorActive = function()
  return cursorActiveKind ~= nil
end

LNS_MWSystem.startCursorMw = LNS_MWSystem.cursorMw
LNS_MWSystem.startCursorWg = LNS_MWSystem.cursorWg


local holdMacro = macro(20, function()
  if not holdEnabled() then return end
  if #holdCandidates == 0 then return end
  if now - holdLastCast < HOLD_ALL_CD then return end

  for i = #holdCandidates, 1, -1 do
    local pos = holdCandidates[i]
    local k = keyPos(pos)

    if (holdReadyAt[k] or 0) > now then
      goto continue
    end

    local tile = g_map.getTile(pos)
    if not tile then
      table.remove(holdCandidates, i)
      goto continue
    end

    local text = tile:getText() or ""
    local rune = getRuneByText(text)

    if not rune then
      table.remove(holdCandidates, i)
      goto continue
    end

    local _, top = canUseOnTile(pos)
    if not top then goto continue end

    holdLastCast = now
    if tryUseRuneOnThing(rune, top) then
      registerOwnWallCast(pos, rune)
      holdReadyAt[k] = now + HOLD_ALL_CD
      return
    end

    holdReadyAt[k] = now + MW_FAIL_COOLDOWN

    ::continue::
  end
end)

onKeyDown(function(keys)
  if not holdEnabled() or holdMacro.isOff() then return end

  local key = tostring(keys or ""):lower()
  local mwKey = tostring(mwCfg.keyHoldMw or ""):lower()
  local wgKey = tostring(mwCfg.keyHoldWg or ""):lower()

  local isMw = mwCfg.holdMw == true and mwKey ~= "" and key == mwKey
  local isWg = mwCfg.holdWg == true and wgKey ~= "" and key == wgKey

  if not isMw and not isWg then return end

  holdPressAt = now

  local tile = getTileUnderCursor()
  if not tile then return end

  local pos = tile:getPosition()
  local text = tile:getText() or ""

  if text == "MW Here" or text == "WG Here" then
    tile:setText("")
    removeHoldCandidate(pos)
    holdReadyAt[keyPos(pos)] = nil
  else
    tile:setText(isMw and "MW Here" or "WG Here")
    addHoldCandidate(pos)
    holdReadyAt[keyPos(pos)] = now
  end
end)

onKeyPress(function(keys)
  if not holdEnabled() or holdMacro.isOff() then return end

  local key = tostring(keys or ""):lower()
  local mwKey = tostring(mwCfg.keyHoldMw or ""):lower()
  local wgKey = tostring(mwCfg.keyHoldWg or ""):lower()

  if key ~= mwKey and key ~= wgKey then return end

  if now - holdPressAt > 1000 then
    clearHoldMarks()
  end
end)

macro(500, function()
  if mwCfg.iconHoldMwWg ~= true then return end

  local changed = false

  if mwCfg.enabled ~= true then
    mwCfg.enabled = true
    changed = true
  end

  if mwCfg.holdMw ~= true then
    mwCfg.holdMw = true
    changed = true
  end

  if mwCfg.holdWg ~= true then
    mwCfg.holdWg = true
    changed = true
  end

  if changed then
    refreshMwHoldButtons()
    saveMwStorage()
  end
end)

-- =========================================================
-- MW TRAP
-- =========================================================

local function isFriendSafe(name)
  if not name then return false end

  if type(isFriend) == "function" and isFriend(name) then
    return true
  end

  if warStorage.playerList and warStorage.playerList.friendList then
    for _, v in ipairs(warStorage.playerList.friendList) do
      if tostring(v):lower() == tostring(name):lower() then
        return true
      end
    end
  end

  local c = getCreatureByName(name)
  if c and c:isPlayer() and c:isPartyMember() then
    return true
  end

  return false
end

local function isEnemyPlayer(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then
    return false
  end
  return not isFriendSafe(creature:getName())
end

onKeyDown(function(keys)
  if not isSystemOn() then return end
  if mwCfg.mwTrap ~= true then return end

  local key = tostring(keys or ""):lower()
  local trapKey = tostring(mwCfg.keyMwTrap or ""):lower()

  if key == "" or key ~= trapKey then return end

  local tile = getTileUnderCursor()
  if not tile then return end

  local pos = tile:getPosition()
  local text = tile:getText() or ""

  if text == "Check" or text == "MW Trap" then
    tile:setText("")
    if samePos(pos, trapCheckPos) then trapCheckPos = nil end
    if samePos(pos, trapMwPos) then trapMwPos = nil end
    return
  end

  if not trapCheckPos then
    trapCheckPos = pos
    tile:setText("Check")
    return
  end

  if not trapMwPos then
    trapMwPos = pos
    tile:setText("MW Trap")
    return
  end

  local oldCheckTile = g_map.getTile(trapCheckPos)
  local oldTrapTile = g_map.getTile(trapMwPos)

  if oldCheckTile and oldCheckTile:getText() == "Check" then oldCheckTile:setText("") end
  if oldTrapTile and oldTrapTile:getText() == "MW Trap" then oldTrapTile:setText("") end

  trapCheckPos = pos
  trapMwPos = nil
  tile:setText("Check")
end)

macro(50, function()
  if not isSystemOn() then return end
  if mwCfg.mwTrap ~= true then return end
  if not trapCheckPos or not trapMwPos then return end
  if now - lastTrapCast < TRAP_CD then return end

  for _, spec in ipairs(getSpectators()) do
    if isEnemyPlayer(spec) and samePos(spec:getPosition(), trapCheckPos) then
      local tile = g_map.getTile(trapMwPos)
      if not tile or hasWall(tile) then return end

      local top = tile:getTopUseThing()
      if not top then return end

      local runeId = tonumber(mwCfg.mwRune) or 3180

      if tryUseRuneOnThing(runeId, top) then
        registerOwnWallCast(trapMwPos, runeId)
        lastTrapCast = now
        return
      end
    end
  end
end)

-- =========================================================
-- TIMER PAUSE PARA POT/RUNE
-- NÃO INTERFERE NO HOLD MW/WG
-- Use nas outras macros:
-- if pauseForMw and pauseForMw > now then return end
-- =========================================================

local function getWallDuration(id)
  id = tonumber(id)

  if id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or id == 16518 or id == 2128 then
    return 20000
  end

  if id == tonumber(mwCfg.wgWall1) or id == tonumber(mwCfg.wgWall2) then
    return 45000
  end

  return 0
end

onAddThing(function(tile, thing)
  if not isSystemOn() then return end
  if not thing or not thing.isItem or not thing:isItem() then return end

  local id = thing:getId()
  local duration = getWallDuration(id)
  if duration <= 0 then return end

  local pos = tile:getPosition()
  local key = keyPos(pos)
  mwWgTimers[key] = now + duration
  pauseTriggeredByTile[key] = nil

  if mwCfg.iconHoldMwWg == true then
    local markText = takeOwnWallCast(pos, id)
    if markText then
      tile:setText(markText)
      addHoldCandidate(pos)
      holdReadyAt[key] = now + duration + HOLD_RECAST_DELAY
    end
  end
end)

onRemoveThing(function(tile, thing)
  if not thing or not thing.isItem or not thing:isItem() then return end
  if not isWallId(thing:getId()) then return end

  local pos = tile:getPosition()
  local key = keyPos(pos)

  mwWgTimers[key] = nil
  pauseTriggeredByTile[key] = nil

  local text = tile:getText() or ""
  if text == "MW Here" or text == "WG Here" then
    addHoldCandidate(pos)
    holdReadyAt[key] = now + HOLD_RECAST_DELAY
  end
end)

macro(50, function()
  if not isSystemOn() then return end
  if mwCfg.pause ~= true then return end

  local pauseTime = tonumber(mwCfg.tempo or 0) or 0
  if pauseTime <= 0 then return end

  for key, expireAt in pairs(mwWgTimers) do
    local remaining = expireAt - now

    if remaining <= 0 then
      mwWgTimers[key] = nil
      pauseTriggeredByTile[key] = nil
    elseif remaining <= pauseTime and not pauseTriggeredByTile[key] then
      pauseTriggeredByTile[key] = true
      pauseForMw = math.max(pauseForMw or 0, now + pauseTime + 500)
    end
  end
end)

onKeyPress(function(keys)
  local key = tostring(keys or ""):lower()
  if key ~= "escape" and key ~= "esc" then return end

  cancelCursorCast()
  clearHoldMarks()

  if trapCheckPos then
    local tile = g_map.getTile(trapCheckPos)
    if tile and tile:getText() == "Check" then
      tile:setText("")
    end
  end

  if trapMwPos then
    local tile = g_map.getTile(trapMwPos)
    if tile and tile:getText() == "MW Trap" then
      tile:setText("")
    end
  end

  trapCheckPos = nil
  trapMwPos = nil
end)
-- ============================================================
--  PUSHMAX
-- ============================================================

local function savePushMaxChar()
  saveWarGlobal()
end

warStorage.pvpSystem = warStorage.pvpSystem or {}

warStorage.pvpSystem.pushSystem = warStorage.pvpSystem.pushSystem or {
    enabled = false,
    mode = "marcacao",  -- "marcacao" ou "numpad"
    
    -- Delays
    pushDelay = 1060,
    cancelDelayOnRetreat = false,
    
    -- Runa para items bloqueadores
    runeId = 3188,
    useRune = false,
    blockingItems = {3147, 2595, 2118, 2119, 2120, 2129},
    
    -- Destroy Field (limpar fields no caminho)
    destroyField = {
        enabled = false,
        runeId = 3148,
        fieldItems = {2118, 2122, 105, 2119}
    },
    
    -- Modo Marcacao
    marcacao = {
        hotkey = "F1",
        autoPush = false,
        showMarkers = true
    },
    
    -- Modo Numpad
    numpad = {
        maxDistance = 7,
        autoRetreat = true,
        keys = {
            ["1"] = "Numpad1",
            ["2"] = "Numpad2",
            ["3"] = "Numpad3",
            ["4"] = "Numpad4",
            ["6"] = "Numpad6",
            ["7"] = "Numpad7",
            ["8"] = "Numpad8",
            ["9"] = "Numpad9"
        }
    }
}

local config = warStorage.pvpSystem.pushSystem

local function saveConfig()
    savePushMaxChar()
end

-- Garantir que destroyField existe (compatibilidade com storages antigos)
if not config.destroyField then
    config.destroyField = {
        enabled = false,
        runeId = 3148,
        fieldItems = {2118, 2122, 105, 2119}
    }
    saveConfig()
end

-- Garantir que fieldItems existe
config.destroyField.fieldItems = config.destroyField.fieldItems or {2118, 2122, 105, 2119}

-- Garantir que numpad existe
config.numpad = config.numpad or {}

-- Garantir que numpad.keys existe (compatibilidade)
if not config.numpad.keys then
    config.numpad.keys = {
        ["1"] = "Numpad1",
        ["2"] = "Numpad2",
        ["3"] = "Numpad3",
        ["4"] = "Numpad4",
        ["6"] = "Numpad6",
        ["7"] = "Numpad7",
        ["8"] = "Numpad8",
        ["9"] = "Numpad9"
    }
    saveConfig()
end

-- ============================================================
--  HELPERS
-- ============================================================

local Helpers = {}

function Helpers.showMessage(msg)
    modules.game_textmessage.displayGameMessage(msg)
end

function Helpers.getDistance(pos1, pos2)
    if not pos1 or not pos2 then return 999 end
    return math.max(math.abs(pos1.x - pos2.x), math.abs(pos1.y - pos2.y))
end

function Helpers.isValidTile(tile)
    if not tile then return false end
    local pos = tile:getPosition()
    if not pos or pos.z ~= posz() then return false end
    if not tile:isWalkable() then return false end
    if tile:hasCreature() then return false end
    return true
end

-- ============================================================
--  UI DEFINITIONS
-- ============================================================

g_ui.loadUIFromString([[
ScrollDetector < UIWidget
  focusable: false
  phantom: true

PVPPushScrollBar < Panel
  height: 35
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  HorizontalScrollBar
    id: scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 10
    maximum: 3000
    step: 10

PVPPushItem < Panel
  height: 40
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter

  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right

PVPPushTextEdit < Panel
  height: 50
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  TextEdit
    id: textEdit
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    text-align: center

PVPPushCheckBox < BotSwitch
  height: 20
  margin-top: 7

PVPModeButton < Button
  height: 35
  margin-top: 7
  font: verdana-11px-rounded

PVPTabPanel < Panel
  margin: 3

  VerticalScrollBar
    id: panelScroll
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    step: 28
    pixels-scroll: true
    image-color: #87CEEB

  ScrollablePanel
    id: panelContent
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-left: 6
    margin-right: 10
    padding: 5
    padding-left: 8
    padding-top: 8
    padding-bottom: 8
    vertical-scrollbar: panelScroll
    layout:
      type: verticalBox
      spacing: 5

PVPKeysWindow < MainWindow
  size: 245 230
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

  FlatPanel
    id: content
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -6
    margin-top: 1
    margin-bottom: 0

    Label
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      id: configureKeys
      margin-top: 5
      margin-left: 8
      margin-right: 8
      text-align: center
      text: Settings to Push:

    TextEdit
      id: NW
      anchors.top: prev.bottom
      anchors.left: prev.left
      margin-top: 10
      placeholder: NW
      width: 65

    TextEdit
      id: N
      anchors.top: prev.top
      anchors.left: prev.right
      margin-top: 0
      margin-left: 10
      placeholder: N
      width: 65
      
    TextEdit
      id: NE
      anchors.top: prev.top
      anchors.left: prev.right
      margin-top: 0
      margin-left: 10
      placeholder: NE
      width: 65

    TextEdit
      id: W
      anchors.top: NW.bottom
      anchors.left: NW.left
      margin-top: 28
      placeholder: W
      width: 65

    TextEdit
      id: E
      anchors.top: NE.bottom
      anchors.left: NE.left
      margin-top: 28
      placeholder: E
      width: 65

    TextEdit
      id: SW
      anchors.top: W.bottom
      anchors.left: NW.left
      margin-top: 28
      placeholder: SW
      width: 65

    TextEdit
      id: S
      anchors.top: W.bottom
      anchors.left: N.left
      margin-top: 28
      placeholder: S
      width: 65
      
    TextEdit
      id: SE
      anchors.top: W.bottom
      anchors.left: NE.left
      margin-top: 28
      placeholder: SE
      width: 65

    Button
      id: saveBtn
      anchors.top: prev.bottom
      anchors.left: SW.left
      size: 105 20
      margin-top: 10
      text: Save

    Button
      id: resetBtn
      anchors.top: prev.top
      anchors.left: prev.right
      margin-top: 0
      margin-left: 3
      size: 105 20
      text: Reset

PVPMainWindow < MainWindow
  size: 315 340
  border: 1 black
  anchors.centerIn: parent
  margin-top: -50
  text: Panel PushMax

  FlatPanel
    id: content
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    margin: -5
    margin-top: 2
    height: 140
    layout: verticalBox

  Label
    id: tipoPush
    anchors.top: prev.top
    anchors.left: content.left
    margin-top: 7
    margin-left: 5
    text: Push Type:

  Button
    id: buttonNumpad
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-left: 5
    size: 70 21
    text: NUMPAD/WASD

  Button
    id: setupTeclas
    anchors.left: prev.right
    anchors.top: prev.top
    margin-top: 0
    margin-left: 2
    text: Cfg
    size: 30 21

  Button
    id: buttonMarcacao
    anchors.left: setupTeclas.right
    anchors.top: buttonNumpad.top
    size: 70 21
    margin-left: 10
    margin-top: 0
    text: Marcacao

  BotTextEdit
    id: pushKeyEdit
    anchors.left: buttonMarcacao.right
    anchors.top: buttonMarcacao.top
    anchors.right: content.right
    margin-right: 5
    margin-left: 2
    height: 20
    margin-top: 1
    placeholder: Atalho

  HorizontalSeparator
    id: hsep
    anchors.top: prev.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-left: 5
    margin-right: 5
    margin-top: 5

  Label
    id: labelDistance
    anchors.top: prev.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-top: 5

  HorizontalScrollBar
    id: distancePush
    anchors.top: labelDistance.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-right: 5
    margin-left: 5
    margin-top: 3
    minimum: 1
    maximum: 9
    step: 1

  Label
    id: distanceText
    anchors.centerIn: labelDistance
    text: ""

  Label
    id: labelDelay
    anchors.top: distancePush.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-top: 8

  HorizontalScrollBar
    id: delayPush
    anchors.top: labelDelay.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-right: 5
    margin-top: 3
    margin-left: 5
    minimum: 10
    maximum: 2000
    step: 10

  Label
    id: delayText
    anchors.centerIn: labelDelay
    text: ""

  CheckBox
    id: autoAfastar
    anchors.top: delayPush.bottom
    anchors.left: labelDelay.left
    margin-top: 15
    margin-left: 5
    text: Auto Move Away
    text-auto-resize: true

  FlatPanel
    id: panelRunas
    anchors.top: content.bottom
    anchors.right: content.right
    anchors.left: content.left
    margin-top: 10
    height: 130
    layout: verticalBox

  CheckBox
    id: firefield
    anchors.top: panelRunas.top
    anchors.left: autoAfastar.left
    margin-top: 14
    text: Fire Field Rune:
    text-auto-resize: true
    
  BotItem
    id: fireFieldId
    anchors.top: firefield.top
    anchors.left: firefield.right
    margin-top: -7
    margin-left: 140
    image-source: /images/ui/item

  CheckBox
    id: destroyField
    anchors.top: firefield.bottom
    anchors.left: autoAfastar.left
    margin-top: 25
    text: Destroy Field Rune:
    text-auto-resize: true
    
  BotItem
    id: destroyFieldId
    anchors.top: destroyField.top
    anchors.left: fireFieldId.left
    margin-top: -8
    image-source: /images/ui/item

  Panel
    id: destroyFieldList
    anchors.top: destroyFieldId.bottom
    anchors.left: destroyField.left
    anchors.right: panelRunas.right
    anchors.bottom: panelRunas.bottom
    margin-right: 5
    margin-top: 3
    margin-bottom: 5

  Button
    id: closePanel
    anchors.left: content.left
    anchors.right: content.right
    anchors.top: panelRunas.bottom
    size: 35 20
    margin-top: 5
    text: Close
]])

-- ============================================================
--  PAINEL PRINCIPAL
-- ============================================================

mainUI = setupUI([[
Panel
  height: 19

  BotSwitch
    id: switch
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: PushMax
    height: 18
    color: white

  Button
    id: setup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])

pvpWindow = UI.createWindow('PVPMainWindow', rootWidget)
pvpWindow:hide()
pvpWindow.closePanel.onClick = function()
    pvpWindow:hide()
end

pushPanel = UI.createWidget('PVPTabPanel', pvpWindow.content)
pushPanel:setId('pushPanel')

local mainPanel = pvpWindow.content
btnNumpad = pvpWindow.buttonNumpad
btnMarcacao = pvpWindow.buttonMarcacao
hkMarcacao = pvpWindow.buttonMarcacao
pvpWindow.pushKeyEdit.onTextChange = function(w, text)
    config.marcacao.hotkey = text
    saveConfig()
end
pvpWindow.pushKeyEdit:setText(config.marcacao.hotkey)

mainUI.switch:setOn(config.enabled)
mainUI.switch.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
    saveConfig()
end

mainUI.setup.onClick = function()
    pvpWindow:show()
    pvpWindow:raise()
    pvpWindow:focus()
end

local function updateModeButtons()
    if config.mode == "marcacao" then
        btnMarcacao:setColor("white")
        btnMarcacao:setText("Marcacao")
        btnMarcacao:setImageColor("green")
        btnNumpad:setColor("#FFFFFF")
        btnNumpad:setText("Tecla")
        btnNumpad:setImageColor("red")
    else
        btnMarcacao:setColor("#FFFFFF")
        btnMarcacao:setText("Marcacao")
        btnMarcacao:setImageColor("red")
        btnNumpad:setColor("white")
        btnNumpad:setText("Tecla")
        btnNumpad:setImageColor("green")
    end
end

btnMarcacao.onClick = function()
    if config.mode == "marcacao" then
        config.marcacao.autoPush = not config.marcacao.autoPush
        btnMarcacao:setOn(config.marcacao.autoPush)
    else
        config.mode = "marcacao"
    end

    updateModeButtons()
    saveConfig()
end

btnNumpad.onClick = function()
    config.mode = "numpad"
    updateModeButtons()
    saveConfig()
end

updateModeButtons()

local function getKeyName(keyCode, keyboardModifiers)
    local keyNames = {
        [48] = "0", [49] = "1", [50] = "2", [51] = "3", [52] = "4",
        [53] = "5", [54] = "6", [55] = "7", [56] = "8", [57] = "9",
        [65] = "A", [66] = "B", [67] = "C", [68] = "D", [69] = "E",
        [70] = "F", [71] = "G", [72] = "H", [73] = "I", [74] = "J",
        [75] = "K", [76] = "L", [77] = "M", [78] = "N", [79] = "O",
        [80] = "P", [81] = "Q", [82] = "R", [83] = "S", [84] = "T",
        [85] = "U", [86] = "V", [87] = "W", [88] = "X", [89] = "Y",
        [90] = "Z",
        [32] = "Space",
        [16777219] = "Backspace",
        [16777220] = "Enter",
        [16777217] = "Tab",
        [16777216] = "Escape",
        [96] = "Numpad0", [97] = "Numpad1", [98] = "Numpad2",
        [99] = "Numpad3", [100] = "Numpad4", [101] = "Numpad5",
        [102] = "Numpad6", [103] = "Numpad7", [104] = "Numpad8",
        [105] = "Numpad9",
        [16777234] = "Left", [16777235] = "Up", [16777236] = "Right", [16777237] = "Down",
        [16777264] = "F1", [16777265] = "F2", [16777266] = "F3", [16777267] = "F4",
        [16777268] = "F5", [16777269] = "F6", [16777270] = "F7", [16777271] = "F8",
        [16777272] = "F9", [16777273] = "F10", [16777274] = "F11", [16777275] = "F12",
        [16777238] = "Insert", [16777239] = "Delete", [16777232] = "Home", 
        [16777233] = "End", [16777238] = "PageUp", [16777239] = "PageDown"
    }
    
    local keyName = keyNames[keyCode] or "Key" .. keyCode
    
    if keyboardModifiers == KeyboardCtrlModifier then
        keyName = "Ctrl+" .. keyName
    elseif keyboardModifiers == KeyboardShiftModifier then
        keyName = "Shift+" .. keyName
    elseif keyboardModifiers == KeyboardAltModifier then
        keyName = "Alt+" .. keyName
    end
    
    return keyName
end

local function openKeysSetupWindow()
  local keysWindow = UI.createWindow('PVPKeysWindow', rootWidget)
  keysWindow:show()
  keysWindow:raise()
  keysWindow:focus()

  config = config or {}
  config.numpad = config.numpad or {}
  if not config.numpad.keys then
    config.numpad.keys = {
      ["1"] = "Numpad1",
      ["2"] = "Numpad2",
      ["3"] = "Numpad3",
      ["4"] = "Numpad4",
      ["6"] = "Numpad6",
      ["7"] = "Numpad7",
      ["8"] = "Numpad8",
      ["9"] = "Numpad9"
    }
  end

  local function safeKeyName(keyCode, keyboardModifiers)
    if type(getKeyName) == "function" then
      return getKeyName(keyCode, keyboardModifiers)
    end
    return tostring(keyCode or "")
  end

  local function setFieldText(field, text)
    if not field then return end
    field:setText(text or "")
  end

  local content = keysWindow:getChildById('content')
  if not content then
    keysWindow:destroy()
    return
  end

  local keyFields = {
    ["7"] = content:getChildById("NW"),
    ["8"] = content:getChildById("N"),
    ["9"] = content:getChildById("NE"),
    ["4"] = content:getChildById("W"),
    ["6"] = content:getChildById("E"),
    ["1"] = content:getChildById("SW"),
    ["2"] = content:getChildById("S"),
    ["3"] = content:getChildById("SE"),
  }
  local labels = {
    ["7"] = "^< Noroeste (7):",
    ["8"] = "^ Norte (8):",
    ["9"] = "^> Nordeste (9):",
    ["4"] = "< Oeste (4):",
    ["6"] = "> Leste (6):",
    ["1"] = "v< Sudoeste (1):",
    ["2"] = "v Sul (2):",
    ["3"] = "v> Sudeste (3):"
  }

  for pos, field in pairs(keyFields) do
    local fallback = "Numpad" .. pos
    setFieldText(field, config.numpad.keys[pos] or fallback)
  end

  for pos, field in pairs(keyFields) do
    if field then
      field.onKeyPress = function(widget, keyCode, keyboardModifiers)
          local keyName = safeKeyName(keyCode, keyboardModifiers)
          widget:setText(keyName)
          config.numpad.keys[pos] = keyName
          saveConfig()
          return true
      end
    end
  end

  local saveBtn = content:getChildById("saveBtn")
  local resetBtn = content:getChildById("resetBtn")

  if saveBtn then
    saveBtn.onClick = function()
      if Helpers and type(Helpers.showMessage) == "function" then
      end
      keysWindow:hide()
      keysWindow:destroy()
    end
  end

  if resetBtn then
    resetBtn.onClick = function()
      config.numpad.keys = {
        ["1"] = "1",
        ["2"] = "2",
        ["3"] = "3",
        ["4"] = "4",
        ["6"] = "6",
        ["7"] = "7",
        ["8"] = "8",
        ["9"] = "9"
      }

      for pos, field in pairs(keyFields) do
        if field then
          field:setText(config.numpad.keys[pos])
        end
      end

      saveConfig()
    end
  end

  if keysWindow.closeButton then
    keysWindow.closeButton.onClick = function()
      keysWindow:hide()
    end
  end
end

pvpWindow.setupTeclas.onClick = function()
    openKeysSetupWindow()
end

config = config or {}
config.numpad = config.numpad or {}
if not config.numpad.maxDistance then config.numpad.maxDistance = 1 end
if not config.pushDelay then config.pushDelay = 200 end

local distanceScroll = pvpWindow:recursiveGetChildById('distancePush')
local distanceText   = pvpWindow:recursiveGetChildById('distanceText')

local delayScroll = pvpWindow:recursiveGetChildById('delayPush')
local delayText   = pvpWindow:recursiveGetChildById('delayText')

if distanceScroll and distanceText then
  distanceScroll:setRange(1, 9) 
  distanceScroll:setStep(1)

  -- clamp simples pra não estourar
  local v = tonumber(config.numpad.maxDistance) or 1
  if v < 1 then v = 1 end
  if v > 9 then v = 9 end
  config.numpad.maxDistance = v

  distanceScroll:setValue(v)
  distanceText:setText("Max Distance Push: " .. v)

  distanceScroll.onValueChange = function(scroll, value)
    config.numpad.maxDistance = value
    distanceText:setText("Max Distance Push: " .. value)
    saveConfig()
  end
end

if delayScroll and delayText then
  delayScroll:setRange(10, 2000)
  delayScroll:setStep(10)

  local d = tonumber(config.pushDelay) or 200
  if d < 10 then d = 10 end
  if d > 2000 then d = 2000 end
  d = math.floor(d / 10) * 10
  config.pushDelay = d

  delayScroll:setValue(d)
  delayText:setText("Delay Push: " .. d .. "ms")

  delayScroll.onValueChange = function(scroll, value)
    config.pushDelay = value
    delayText:setText("Delay Push: " .. value .. "ms")
    saveConfig()
  end
end

config = config or {}
config.numpad = config.numpad or {}
pvpWindow.autoAfastar:setChecked(config.numpad.autoRetreat == true)
pvpWindow.autoAfastar.onCheckChange = function(_, checked)
  config.numpad.autoRetreat = checked == true
  saveConfig()
end

local runaSeparator = UI.createWidget('HorizontalSeparator', mainPanel)
runaSeparator:setMarginTop(300)

config.fireField = config.fireField or { enabled = false, runeId = 3188 }
config.fireField.key = nil

local uiFireCheck = pvpWindow:recursiveGetChildById('firefield')
local uiFireItem  = pvpWindow:recursiveGetChildById('fireFieldId')

if uiFireCheck then
  uiFireCheck:setChecked(config.fireField.enabled == true)
  uiFireCheck.onCheckChange = function(_, checked)
    config.fireField.enabled = checked == true
    saveConfig()
  end
end

if uiFireItem then
  if uiFireItem.setItemId then
    uiFireItem:setItemId(tonumber(config.fireField.runeId) or 0)
  end
  uiFireItem.onItemChange = function(widget)
    if widget and widget.getItemId then
      config.fireField.runeId = widget:getItemId()
      saveConfig()
    end
  end
end

local function trim(s)
  s = tostring(s or "")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local lastFireAt = 0
local function nowMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return math.floor(os.clock() * 1000)
end

config = config or {}
config.destroyField = config.destroyField or { enabled = false, runeId = 0, fieldItems = {} }

local destroyFieldLookup = {}

local function rebuildDestroyFieldLookup()
    destroyFieldLookup = {}

    for _, fieldId in ipairs(config.destroyField.fieldItems or {}) do
        local id = fieldId

        if type(fieldId) == "table" then
            id = fieldId.id or fieldId.itemId
        end

        id = tonumber(id)

        if id then
            destroyFieldLookup[id] = true
        end
    end
end

rebuildDestroyFieldLookup()

local useDestroyFieldCheck = pvpWindow:recursiveGetChildById('destroyField')
local destroyFieldItem = pvpWindow:recursiveGetChildById('destroyFieldId')

if useDestroyFieldCheck then
  useDestroyFieldCheck:setChecked(config.destroyField.enabled == true)

  useDestroyFieldCheck.onCheckChange = function(_, checked)
    config.destroyField.enabled = checked == true
    saveConfig()
  end
end

if destroyFieldItem then
  if destroyFieldItem.setItemId then
    destroyFieldItem:setItemId(tonumber(config.destroyField.runeId) or 0)
  end

  destroyFieldItem.onItemChange = function(widget)
    if widget and widget.getItemId then
      config.destroyField.runeId = widget:getItemId()
      saveConfig()
    end
  end
end

local fieldItemsLabel = UI.createWidget('UIWidget', mainPanel)
fieldItemsLabel:setHeight(20)
fieldItemsLabel:setMarginTop(10)
fieldItemsLabel:setText("Fields/Walls para Destruir:")
fieldItemsLabel:setTextAlign(AlignCenter)
fieldItemsLabel:setColor("#FFAA00")

config = config or {}
config.destroyField = config.destroyField or { enabled = false, runeId = 0, fieldItems = {} }

local hostPanel = pvpWindow:recursiveGetChildById('destroyFieldList')
if not hostPanel then
  print("[DESTROY CONFIG] ERRO: nao achei Panel destroyFieldList no OTUI")
  return
end

if hostPanel._dfContainer and hostPanel._dfContainer.destroy then
  pcall(function() hostPanel._dfContainer:destroy() end)
  hostPanel._dfContainer = nil
end

local fieldItemsContainer = UI.ContainerEx(function(_, items)
  local itemIds = normalizeContainerItems(items)

  config.destroyField.fieldItems = itemIds
  saveConfig()

end, true, hostPanel)

fieldItemsContainer:setParent(hostPanel)
fieldItemsContainer:fill('parent')

fieldItemsContainer:setItems(config.destroyField.fieldItems or {})

if fieldItemsContainer.setTooltip then
  fieldItemsContainer:setTooltip("Clique para adicionar IDs de fields/walls que devem ser destruidos (fire, poison, energy, magic wall). O destroy field sera usado automaticamente quando detectar.")
end

hostPanel._dfContainer = fieldItemsContainer

local blockingInfo = UI.createWidget('UIWidget', mainPanel)
blockingInfo:setHeight(50)
blockingInfo:setMarginTop(5)
blockingInfo:setTextWrap(true)
blockingInfo:setTextAlign(AlignCenter)
blockingInfo:setColor("#AAAAAA")
blockingInfo:setText("Clique no box acima para adicionar IDs.\nExemplos: 3147 (parcel), 2595 (box),\n2118 (fire field), 2119 (energy field)")

local infoLabel = UI.createWidget('UIWidget', mainPanel)
infoLabel:setHeight(100)
infoLabel:setMarginTop(15)
infoLabel:setTextWrap(true)
infoLabel:setTextAlign(AlignCenter)
infoLabel:setColor("#FFFF00")

btnMarcacao.onClick = function()
    config.mode = "marcacao"
    updateModeButtons()
    saveConfig()
end

btnNumpad.onClick = function()
    config.mode = "numpad"
    updateModeButtons()
    saveConfig()
end

do

PushState = {
    retreatLockUntil = 0,
    markedTarget = nil,
    markedTargetPos = nil,
    markedDest = nil,
    markStep = 0, 
    isProgressive = false,
    manualPush = false,
    
    currentTarget = nil,
    lastLookName = nil,
    
    lastPush = 0,
    
    justRetreated = false,
    retreatTime = 0,
    lastPlayerMove = 0,
    
    blockedPlayerPos = nil,
    blockedUntil = 0,
    
    lastDebugMsg = 0
}

local function clearMarkers()
    for _, tile in pairs(g_map.getTiles(posz())) do
        local text = tile:getText()
        if text == "Target" or text == "Dest" then
            tile:setText('')
        end
    end
    if PushState.markedTarget then
        PushState.markedTarget:setMarked(nil)
    end
end

local lastTargetPos = nil
local lastDestCheck = 0

local function updateMarkers()
    local currentTime = now
    
    if PushState.markedTarget then
        local targetPos = PushState.markedTarget:getPosition()
        if targetPos and targetPos.z == posz() then

            local posChanged = not lastTargetPos or 
                             lastTargetPos.x ~= targetPos.x or 
                             lastTargetPos.y ~= targetPos.y
            
            if posChanged then
                if lastTargetPos then
                    local oldTile = g_map.getTile(lastTargetPos)
                    if oldTile and oldTile:getText() == "Target" then
                        oldTile:setText('')
                    end
                end
                
                local targetTile = g_map.getTile(targetPos)
                if targetTile then
                    targetTile:setText('Target')
                end
                
                lastTargetPos = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
            end
            
            if currentTime - lastDestCheck > 1000 then
                PushState.markedTarget:setMarked('red')
            end
        end
    end

    if PushState.markedDest and PushState.markedDest.z == posz() then
        if currentTime - lastDestCheck > 1000 then
            local destTile = g_map.getTile(PushState.markedDest)
            if destTile then
                local currentText = destTile:getText()
                if currentText ~= "Dest" then
                    destTile:setText('Dest')
                end
            end
            lastDestCheck = currentTime
        end
    end
end

local function clearDestMarker()
    for _, tile in pairs(g_map.getTiles(posz())) do
        if tile and tile:getText() == "Dest" then
            pcall(function() tile:setText('') end)
        end
    end
end

local function resetPush()
    clearMarkers()
    PushState.iconPushTask = nil
    PushState.markedTarget = nil
    PushState.markedTargetPos = nil
    PushState.markedDest = nil
    PushState.markStep = 0 
    PushState.isProgressive = false
    PushState.manualPush = false
    PushState.justRetreated = false
    lastTargetPos = nil
  
    for _, tile in pairs(g_map.getTiles(posz())) do
        local text = tile:getText()
        if text and text ~= "" then
            tile:setText("")
        end
    end
end

local function hasObstacle(checkPos)
    if not checkPos then return true end
    
    local tile = g_map.getTile(checkPos)
    if not tile then return true end
    if not tile:isWalkable() then return true end
    
    local playerPos = pos()
    
    if playerPos.x == checkPos.x and playerPos.y == checkPos.y and playerPos.z == checkPos.z then
        return true
    end
    
    if PushState.blockedPlayerPos and now < PushState.blockedUntil then
        if PushState.blockedPlayerPos.x == checkPos.x and 
           PushState.blockedPlayerPos.y == checkPos.y and 
           PushState.blockedPlayerPos.z == checkPos.z then
            return true
        end
    end

    local creatures = tile:getCreatures()
    if #creatures > 0 then
        if #creatures == 1 and PushState.markedTarget then
            if creatures[1]:getId() == PushState.markedTarget:getId() then
                return false
            end
        end
        return true
    end
    
    return false
end

local function getNextStep(currentPos, targetPos)
    if not currentPos or not targetPos then return nil end

    local allDirections = {
        {x = currentPos.x + 1, y = currentPos.y,     z = currentPos.z, name = "L"},  -- Leste
        {x = currentPos.x - 1, y = currentPos.y,     z = currentPos.z, name = "O"},  -- Oeste
        {x = currentPos.x,     y = currentPos.y + 1, z = currentPos.z, name = "S"},  -- Sul
        {x = currentPos.x,     y = currentPos.y - 1, z = currentPos.z, name = "N"},  -- Norte
        {x = currentPos.x + 1, y = currentPos.y + 1, z = currentPos.z, name = "SE"}, -- Sudeste
        {x = currentPos.x - 1, y = currentPos.y + 1, z = currentPos.z, name = "SO"}, -- Sudoeste
        {x = currentPos.x + 1, y = currentPos.y - 1, z = currentPos.z, name = "NE"}, -- Nordeste
        {x = currentPos.x - 1, y = currentPos.y - 1, z = currentPos.z, name = "NO"}  -- Noroeste
    }

    local freeDirections = {}
    for _, dir in ipairs(allDirections) do
        local isBlocked = hasObstacle(dir)
        
        if not isBlocked then
            dir.distToTarget = Helpers.getDistance(dir, targetPos)
            table.insert(freeDirections, dir)
        end
    end
    
    if #freeDirections == 0 then
        return nil
    end

    local bestDir = freeDirections[1]
    for _, dir in ipairs(freeDirections) do
        if dir.distToTarget < bestDir.distToTarget then
            bestDir = dir
        end
    end
    
    return bestDir
end

local function hasFieldInTile(checkPos)
    if not checkPos then return false end

    local tile = g_map.getTile(checkPos)
    if not tile then return false end

    local items = tile:getItems()
    if not items then return false end

    for _, item in ipairs(items) do
        if item and item.getId then
            local id = item:getId()
            if destroyFieldLookup[id] then
                return true
            end
        end
    end

    return false
end

local function useDestroyFieldFast(destPos)
    if not config.destroyField.enabled then return false end

    local runeId = tonumber(config.destroyField.runeId) or 0
    if runeId <= 0 then return false end
    if not hasFieldInTile(destPos) then return false end

    local tile = g_map.getTile(destPos)
    if not tile then return false end

    local ground = tile:getGround()
    if not ground then return false end

    pausandoCombo = now + 2000
    g_game.useInventoryItemWith(runeId, ground)
    return true
end

local function executePush(creature, destPos)
    if not config.enabled then return false end
    if not creature or not destPos then return false end
    
    local currentTime = now
    local pushDelay = tonumber(config.pushDelay) or 0
    if pushDelay > 0 and currentTime - PushState.lastPush < pushDelay then
        return false
    end
    
    local creaturePos = creature:getPosition()
    if not creaturePos then return false end

    local dist = Helpers.getDistance(creaturePos, destPos)
    if dist ~= 1 then
        return false
    end

    local destTile = g_map.getTile(destPos)
    if not destTile then return false end

    -- Icon/API support: se o destino tiver field/wall configurado, tenta quebrar antes.
    -- O push em si fica para uma nova tentativa, porque o tile pode continuar bloqueado
    -- até o servidor atualizar o mapa.
    if not destTile:isWalkable() or destTile:hasCreature() then
        useDestroyFieldFast(destPos)
        return false
    end

    useDestroyFieldFast(destPos)

    if config.fireField and config.fireField.enabled == true then
        local runeId = tonumber(config.fireField.runeId) or 0

        if runeId > 0 then
            local targetTile = g_map.getTile(creaturePos)
            if targetTile then
                local topThing = targetTile:getTopUseThing()

                if topThing and (topThing:isPickupable() or not topThing:isNotMoveable()) then
                    pausandoCombo = now + 2000
                    useWith(runeId, creature)
                end
            end
        end
    end

    g_game.move(creature, destPos)

    PushState.lastPush = currentTime
    return true
end

local function autoRetreat(targetPos, pushDirection)
    if not config.numpad.autoRetreat then return false end
    if not targetPos or not pushDirection then return false end
    
    local currentTime = now

    if PushState.justRetreated and (currentTime - PushState.retreatTime) < 200 then
        return false
    end

    if (currentTime - PushState.lastPlayerMove) < 200 then
        return false
    end
    
    local playerPos = pos()
    local distance = Helpers.getDistance(playerPos, targetPos)

    if distance <= 1 then
        local relativeX = playerPos.x - targetPos.x
        local relativeY = playerPos.y - targetPos.y

        local retreatPos = {
            x = playerPos.x,
            y = playerPos.y,
            z = playerPos.z
        }

        if relativeX == 0 then
            if relativeY < 0 then
                retreatPos.y = playerPos.y - 1
            else
                retreatPos.y = playerPos.y + 1 
            end

        elseif relativeY == 0 then
            if relativeX < 0 then
                retreatPos.x = playerPos.x - 1 
            else
                retreatPos.x = playerPos.x + 1
            end
        else
            if relativeX < 0 then
                retreatPos.x = playerPos.x - 1
            else
                retreatPos.x = playerPos.x + 1
            end
        end
        
        local retreatTile = g_map.getTile(retreatPos)
        if retreatTile and retreatTile:isWalkable() and not retreatTile:hasCreature() then
            local playerCurrentPos = pos()
            PushState.blockedPlayerPos = {
                x = playerCurrentPos.x,
                y = playerCurrentPos.y,
                z = playerCurrentPos.z
            }
            PushState.blockedUntil = now + 200 
            
            autoWalk(retreatPos, true, true)
            
            PushState.justRetreated = true
            PushState.retreatTime = now
            
            return true
        else
            local alternativeRetreat = {
                {x = playerPos.x - 1, y = playerPos.y},
                {x = playerPos.x + 1, y = playerPos.y},
                {x = playerPos.x, y = playerPos.y - 1},
                {x = playerPos.x, y = playerPos.y + 1}
            }
            
            for _, altPos in ipairs(alternativeRetreat) do
                altPos.z = playerPos.z
                local altTile = g_map.getTile(altPos)
                if altTile and altTile:isWalkable() and not altTile:hasCreature() then
                    local newDist = Helpers.getDistance(altPos, targetPos)
                    if newDist > distance then
                        local playerCurrentPos = pos()
                        PushState.blockedPlayerPos = {
                            x = playerCurrentPos.x,
                            y = playerCurrentPos.y,
                            z = playerCurrentPos.z
                        }
                        PushState.blockedUntil = now + 50
                        
                        autoWalk(altPos, true, true)
                        
                        PushState.justRetreated = true
                        PushState.retreatTime = now
                        
                        return true
                    end
                end
            end
        end
    end
    
    return false
end


-- ============================================================
--  API PUBLICA PARA ICONES PUSHMAX
--  Use: LNS_PushMaxIconPush(dx, dy)
--  dx/dy seguem o padrao do numpad:
--  NW(-1,-1), N(0,-1), NE(1,-1), W(-1,0), E(1,0), SW(-1,1), S(0,1), SE(1,1)
-- ============================================================

local function samePosition(a, b)
    return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function pushMaxLater(ms, fn)
    if type(schedule) == "function" then return schedule(ms, fn) end
    if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
    if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
        return g_dispatcher:scheduleEvent(fn, ms)
    end
    return fn()
end

local function useFireFieldOnCreature(creature)
    if not config.fireField or config.fireField.enabled ~= true then return false end

    local runeId = tonumber(config.fireField.runeId) or 0
    if runeId <= 0 or not creature then return false end

    local currentTime = now
    if currentTime and lastFireAt and (currentTime - lastFireAt) < 350 then
        return false
    end

    local cpos = creature:getPosition()
    if not cpos then return false end

    local tile = g_map.getTile(cpos)
    local used = false

    -- Primeiro tenta diretamente na criatura, que funciona em boa parte dos OTC/vBot.
    if type(useWith) == "function" then
        local ok = pcall(function() 
          pausandoCombo = now + 2000
          useWith(runeId, creature) 
        end)
        if ok then used = true end
    end

    -- Fallback: usa no top use thing/ground do SQM do alvo.
    if not used then
        local thing = nil
        if tile then
            if tile.getTopUseThing then
                local ok, res = pcall(function() return tile:getTopUseThing() end)
                if ok then thing = res end
            end
            if not thing and tile.getGround then
                local ok, res = pcall(function() return tile:getGround() end)
                if ok then thing = res end
            end
        end

        if thing and g_game and g_game.useInventoryItemWith then
            local ok = pcall(function() pausandoCombo = now + 2000
              g_game.useInventoryItemWith(runeId, thing) end)
            if ok then used = true end
        end
    end

    if used then
        lastFireAt = currentTime or nowMs()
    end

    return used
end

local function getPushMaxIconTarget()
    local function validCreature(creature)
        if not creature then return nil end
        local cpos = creature:getPosition()
        if not cpos or cpos.z ~= posz() then return nil end
        return creature
    end

    local creature =
        validCreature(PushState.currentTarget) or
        validCreature(PushState.markedTarget) or
        validCreature(g_game.getAttackingCreature and g_game.getAttackingCreature()) or
        validCreature(g_game.getFollowingCreature and g_game.getFollowingCreature())

    if creature then
        PushState.currentTarget = creature
        return creature
    end

    return nil
end

local function stopIconPush()
    PushState.iconPushTask = nil
end

local function startIconPushTask(creature, dx, dy)
    if not creature then return false end

    local targetPos = creature:getPosition()
    if not targetPos or targetPos.z ~= posz() then return false end

    local maxDistance = tonumber(config.numpad and config.numpad.maxDistance) or 7
    if Helpers.getDistance(pos(), targetPos) > maxDistance then
        return false
    end

    local destPos = {
        x = targetPos.x + dx,
        y = targetPos.y + dy,
        z = targetPos.z
    }

    -- Uma seta = uma ordem ate o alvo chegar neste SQM final.
    -- Isso imita o modo marcacao: clica uma vez e a macro continua tentando.
    PushState.iconPushTask = {
        creature = creature,
        dx = dx,
        dy = dy,
        destPos = destPos,
        startedAt = now,
        lastDestroyAt = 0,
        lastFireAt = 0,
        lastMoveTryAt = 0,
        fireDone = false,
        attempts = 0
    }

    return true
end

local function listHasId(list, id)
    id = tonumber(id)
    if not id then return false end

    for _, entry in ipairs(list or {}) do
        local entryId = entry
        if type(entry) == "table" then
            entryId = entry.id or entry.itemId
        end

        if tonumber(entryId) == id then
            return true
        end
    end

    return false
end

local function hasBlockingItemUnderCreature(creature)
    if not creature then return false end

    local cpos = creature:getPosition()
    if not cpos then return false end

    local tile = g_map.getTile(cpos)
    if not tile then return false end

    local function isBlockingId(id)
        id = tonumber(id)
        if not id then return false end

        if listHasId(config.blockingItems, id) then
            return true
        end

        if config.destroyField and listHasId(config.destroyField.fieldItems, id) then
            return true
        end

        return false
    end

    -- Melhor caso: varre todos os things do SQM.
    if tile.getThings then
        local ok, things = pcall(function()
            return tile:getThings()
        end)

        if ok and type(things) == "table" then
            for _, thing in ipairs(things) do
                if thing and thing.getId then
                    local okId, id = pcall(function()
                        return thing:getId()
                    end)

                    if okId and isBlockingId(id) then
                        return true, id
                    end
                end
            end
        end
    end

    -- Fallbacks para OTC/vBot que não retornam getThings direito.
    local getters = {
        "getTopMoveThing",
        "getTopUseThing",
        "getTopThing"
    }

    for _, fn in ipairs(getters) do
        if tile[fn] then
            local ok, thing = pcall(function()
                return tile[fn](tile)
            end)

            if ok and thing and thing.getId then
                local okId, id = pcall(function()
                    return thing:getId()
                end)

                if okId and isBlockingId(id) then
                    return true, id
                end
            end
        end
    end

    return false
end

local function processIconPushTask()
    local task = PushState.iconPushTask
    if not task then return end

    if not config.enabled then
        stopIconPush()
        return
    end

    local currentTime = now
    if currentTime - (task.startedAt or currentTime) > 5000 then
        stopIconPush()
        return
    end

    local creature = task.creature
    if not creature then
        stopIconPush()
        return
    end

    local targetPos = creature:getPosition()
    if not targetPos or targetPos.z ~= posz() then
        stopIconPush()
        return
    end

    local destPos = task.destPos
    if not destPos then
        stopIconPush()
        return
    end

    -- Chegou no SQM pedido pela seta.
    if samePosition(targetPos, destPos) then
        stopIconPush()
        return
    end

    -- Se o target saiu de perto do SQM final, encerra para nao puxar coisa errada.
    if Helpers.getDistance(targetPos, destPos) ~= 1 then
        stopIconPush()
        return
    end

    local maxDistance = tonumber(config.numpad and config.numpad.maxDistance) or 7
    if Helpers.getDistance(pos(), targetPos) > maxDistance then
        return
    end

    local destTile = g_map.getTile(destPos)
    if not destTile then return end

    local pushDir = {
        x = destPos.x - targetPos.x,
        y = destPos.y - targetPos.y
    }

    if config.numpad and config.numpad.autoRetreat and Helpers.getDistance(pos(), targetPos) <= 1 then
        if autoRetreat(targetPos, pushDir) then
            return
        end
    end

    -- 1) Se tem field/wall configurado no destino, fica usando Destroy Field ate limpar.
    -- Nao para aqui: a task continua viva e volta no proximo tick para tacar fire/puxar.
    if hasFieldInTile(destPos) then
        if currentTime - (task.lastDestroyAt or 0) >= 450 then
            useDestroyFieldFast(destPos)
            task.lastDestroyAt = currentTime
        end
        return
    end

    -- 2) Se ainda esta bloqueado, tenta Destroy Field mesmo assim quando estiver habilitado.
    -- Isso cobre MW/field que deixam o tile non-walkable antes do mapa atualizar.
    if (not destTile:isWalkable() or destTile:hasCreature()) then
        if currentTime - (task.lastDestroyAt or 0) >= 450 then
            useDestroyFieldFast(destPos)
            task.lastDestroyAt = currentTime
        end
        return
    end

    -- 3) Destino liberado: joga Fire Field no pe do target uma vez antes do drag.
    local minTryDelay = math.max(60, tonumber(config.pushDelay) or 0)
    if currentTime - (task.lastMoveTryAt or 0) < minTryDelay then
        return
    end

    task.lastMoveTryAt = currentTime
    task.attempts = (task.attempts or 0) + 1

    local beforePos = creature:getPosition()
    local ok = executePush(creature, destPos)

    -- 4) Se o push nao andar e tiver item configurado embaixo do alvo,
    -- ai sim joga Fire Field UMA vez.
    pushMaxLater(120, function()
        if not PushState.iconPushTask or PushState.iconPushTask ~= task then return end
        if not creature then return end
        if task.fireDone then return end
        if not config.fireField or config.fireField.enabled ~= true then return end

        local afterPos = creature:getPosition()
        if not afterPos or not beforePos then return end

        local stillSameSqm =
            afterPos.x == beforePos.x and
            afterPos.y == beforePos.y and
            afterPos.z == beforePos.z

        if not stillSameSqm then
            return
        end

        local hasBlocker = hasBlockingItemUnderCreature(creature)
        if not hasBlocker then
            return
        end

        if useFireFieldOnCreature(creature) then
            task.fireDone = true
            task.lastFireAt = now
        else
            task.fireDone = true
        end
    end)

    -- Caso o executePush tenha voltado falso por algum estado temporario,
    -- deixa a task rodando para repetir sem precisar clicar de novo.
    if ok then
        PushState.justRetreated = false
        PushState.blockedPlayerPos = nil
        PushState.blockedUntil = 0
        PushState.retreatLockUntil = 0
    end
end

macro(50, function()
    processIconPushTask()
end)

local function iconPushDirection(dx, dy)
    if not config.enabled then return false end

    dx, dy = tonumber(dx) or 0, tonumber(dy) or 0
    if dx == 0 and dy == 0 then return false end
    if dx < -1 or dx > 1 or dy < -1 or dy > 1 then return false end

    local creature = getPushMaxIconTarget()
    if not creature then
        Helpers.showMessage("Selecione/ataque/siga o player que deseja empurrar")
        return false
    end

    return startIconPushTask(creature, dx, dy)
end

LNS_PushMaxIconPush = iconPushDirection
LNSPushMaxIconTarget = getPushMaxIconTarget


local function doMark()
  if PushState.markStep == 2 and PushState.markedDest then
    if not PushState.markedTarget and PushState.markedTargetPos then
      local targetTile = g_map.getTile(PushState.markedTargetPos)
      if targetTile then
        local creatures = targetTile:getCreatures()
        if #creatures > 0 then
          PushState.markedTarget = creatures[1]
          PushState.markedTarget:setMarked('red')
        end
      end
    end
    return
  end

  local tile = getTileUnderCursor()
  if not tile then return end

  if PushState.markStep == 0 then
    local creatures = tile:getCreatures()

    if #creatures > 0 then
      PushState.markedTarget = creatures[1]
      PushState.markedTarget:setMarked('red')
      PushState.markedTargetPos = nil
    else
      PushState.markedTarget = nil
      PushState.markedTargetPos = tile:getPosition()
    end

    tile:setText('Target')
    PushState.markStep = 1

  elseif PushState.markStep == 1 then
    if Helpers.isValidTile(tile) then
      local destPos = tile:getPosition()

      pcall(function() tile:setText('Dest') end)
      PushState.markedDest = destPos
      PushState.markStep = 2

      PushState.isProgressive = true

    else
      resetPush()
    end
  end
end


onKeyDown(function(keys)
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end

    local normalizedKeys = string.lower(keys or "")
    local hotkey = string.lower(config.marcacao.hotkey or "")

    if normalizedKeys == hotkey then
        doMark()
    end
    
end)

macro(200, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if PushState.markStep < 1 then return end

    if not PushState.markedTarget and PushState.markedTargetPos then
        local targetTile = g_map.getTile(PushState.markedTargetPos)
        if targetTile then
            local creatures = targetTile:getCreatures()
            if #creatures > 0 then
                if not PushState.markedTarget then
                    PushState.markedTarget = creatures[1]
                    PushState.markedTarget:setMarked('red')

                    if PushState.markedDest then
                        PushState.isProgressive = true
                    else
                    end
                end
            end
        end
    end
end)

macro(200, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if PushState.markStep > 0 then
        updateMarkers()
    end
end)

macro(50, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if not PushState.isProgressive then return end
    if not PushState.markedTarget or not PushState.markedDest then return end

    local targetPos = PushState.markedTarget:getPosition()
    if not targetPos or targetPos.z ~= posz() then
        if PushState.markedDest then
            PushState.markedTarget = nil
            PushState.markStep = 1
            PushState.isProgressive = false
        else
            resetPush()
        end
        return
    end
    
    if targetPos.x == PushState.markedDest.x and 
       targetPos.y == PushState.markedDest.y and 
       targetPos.z == PushState.markedDest.z then
        if PushState.isProgressive then

            clearDestMarker()
            PushState.markedDest = nil
            PushState.isProgressive = false
            PushState.markStep = 1

            if not PushState.markedTarget and PushState.markedTargetPos then
            end
        end

        clearDestMarker()
        PushState.markedDest = nil
        PushState.markStep = 1 
        
        return 
    end

    local currentTime = now
    if currentTime - PushState.lastPush < config.pushDelay then
        return
    end

    local nextStep = getNextStep(targetPos, PushState.markedDest)
    
    if not nextStep then
        if (now - (PushState.lastDebugMsg or 0)) > 20 then
            PushState.lastDebugMsg = now
        end
        return
    end

    local distToNext = Helpers.getDistance(targetPos, nextStep)
    if distToNext ~= 1 then
        return
    end

    local destTile = g_map.getTile(nextStep)
    if Helpers.isValidTile(destTile) then
        local playerPos = pos()
        local playerToTargetDist = Helpers.getDistance(playerPos, targetPos)

        if playerToTargetDist <= 1 and config.numpad.autoRetreat then
            local pushDir = {
                x = nextStep.x - targetPos.x,
                y = nextStep.y - targetPos.y
            }

            if autoRetreat(targetPos, pushDir) then
                return
            end
        end
        
        local pushResult = executePush(PushState.markedTarget, nextStep)
        if pushResult then
            -- Push executado com sucesso!
            PushState.justRetreated = false
            -- Limpar bloqueio da posicao antiga do jogador
            PushState.blockedPlayerPos = nil
            PushState.blockedUntil = 0
            PushState.retreatLockUntil = 0
        end
    end
end)

onKeyDown(function(keys)
    if not config.enabled then return end
    if keys == "Escape" then
        -- Sempre limpar TUDO com ESC, mesmo sem marcações
        resetPush()
        PushState.iconPushTask = nil
        PushState.currentTarget = nil
    end
end)

onTextMessage(function(mode, text)
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    local name = text:match("You see ([^%(]+)")
    if name then
        name = name:gsub("^%s*(.-)%s*$", "%1")  -- trim
        PushState.lastLookName = name

        for _, creature in ipairs(getSpectators()) do
            if creature:getName() == name and creature:getPosition().z == posz() then
                PushState.currentTarget = creature
                return
            end
        end
    end
end)

macro(100, function()
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    local attacking = g_game.getAttackingCreature()
    local following = g_game.getFollowingCreature()
    
    if attacking then
        PushState.currentTarget = attacking
    elseif following then
        PushState.currentTarget = following
    end
end)

onKeyDown(function(keys)
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    local directionVectors = {
        ["1"] = {x = -1, y =  1},  -- Sudoeste
        ["2"] = {x =  0, y =  1},  -- Sul
        ["3"] = {x =  1, y =  1},  -- Sudeste
        ["4"] = {x = -1, y =  0},  -- Oeste
        ["6"] = {x =  1, y =  0},  -- Leste
        ["7"] = {x = -1, y = -1},  -- Noroeste
        ["8"] = {x =  0, y = -1},  -- Norte
        ["9"] = {x =  1, y = -1}   -- Nordeste
    }

    local dir = nil
    local dirPos = nil

    local normalizedKeys = string.lower(keys or "")
    
    if config.numpad.keys then
        for pos, keyName in pairs(config.numpad.keys) do
            local normalizedKeyName = string.lower(keyName or "")
            if normalizedKeys == normalizedKeyName then
                dir = directionVectors[pos]
                dirPos = pos
                break
            end
        end
    end
    
    if not dir then return end
    
    if not PushState.currentTarget then
        Helpers.showMessage("Selecione o Player que deseja empurrar")
        return
    end
    
    local targetPos = PushState.currentTarget:getPosition()
    if not targetPos or targetPos.z ~= posz() then
        PushState.currentTarget = nil
        return
    end

    local distance = Helpers.getDistance(pos(), targetPos)
    
    if distance > config.numpad.maxDistance then
        return
    end

    local destPos = {
        x = targetPos.x + dir.x,
        y = targetPos.y + dir.y,
        z = targetPos.z
    }

    local destTile = g_map.getTile(destPos)
    if not Helpers.isValidTile(destTile) then
        Helpers.showMessage("Impossivel arastar para este SQM")
        return
    end

    if autoRetreat(targetPos, dir) then
      executePush(PushState.currentTarget, destPos)
    else
      executePush(PushState.currentTarget, destPos)
    end
end)

onPlayerPositionChange(function(newPos, oldPos)
    if not config.enabled then return end
    
    if oldPos and newPos then
        local moved = (oldPos.x ~= newPos.x or oldPos.y ~= newPos.y)
        
        if moved then
            PushState.lastPlayerMove = now
            
            if config.cancelDelayOnRetreat then
                -- Resetar delay para permitir push imediato
                PushState.lastPush = 0

                if config.mode == "numpad" and PushState.currentTarget then
                elseif config.mode == "marcacao" and PushState.isProgressive then
                end
            end
        end
    end
end)

end

-------------------------
--- DROP FLOWERS - SEM LOCAL NO MAIN
-------------------------
switchDropFlor = "dropFlorButton"

warStorage[switchDropFlor] = warStorage[switchDropFlor] or { enabled = false }

function saveDropFlorChar()
  saveWarGlobal()
end

dropFlorButton = setupUI([[
Panel
  height: 19
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Drop Flowers
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

dropFlorButton:setId(switchDropFlor)
dropFlorButton.title:setOn(warStorage[switchDropFlor].enabled)

dropFlorButton.title.onClick = function(widget)
  newState = not widget:isOn()
  widget:setOn(newState)
  warStorage[switchDropFlor].enabled = newState
  saveDropFlorChar()
end

dropFlorInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 250 270
  anchors.centerIn: parent
  margin-top: -60
  text: Panel DropFlowers
  opacity: 1.00

  FlatPanel
    id: cardFlower
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 110
    opacity: 0.95
    margin: -5
    margin-top: 2

  Label
    id: labelcontainer
    anchors.top: prev.top
    anchors.left: prev.left
    margin-top: 16
    margin-left: 7
    text: ID Flowers:

  BotItem
    id: idFlower
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-left: 5

  BotItem
    id: idFlower2
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 3

  BotItem
    id: idFlower3
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 3

  BotItem
    id: idFlower4
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 3

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: 11
    text: Key Drop Back:
    width: 110

  TextEdit
    id: keyDropBACK
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardFlower.right
    margin-top: 0
    margin-right: 10
    placeholder: Key Here

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: 11
    text: Shortcut Marking:
    width: 110

  TextEdit
    id: keyMarking
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardFlower.right
    margin-top: 0
    margin-right: 10
    placeholder: Key Here

  FlatPanel
    id: cardCollect
    anchors.top: cardFlower.bottom
    anchors.left: cardFlower.left
    anchors.right: cardFlower.right
    height: 85
    opacity: 1.00
    margin-top: 10

  Label
    id: labelCollect
    anchors.top: prev.top
    anchors.left: prev.left
    margin-top: 16
    margin-left: 10
    text: ID Container Collect:

  BotItem
    id: idContainerCollect
    anchors.right: cardCollect.right
    anchors.verticalCenter: prev.verticalCenter
    image-source: /images/ui/item-blessed
    margin-top: 2
    margin-right: 10

  Label
    anchors.top: prev.bottom
    anchors.left: labelCollect.left
    margin-top: 11
    text: Key to Collect:
    width: 110

  TextEdit
    id: keyCollectFlower
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardCollect.right
    margin-top: 0
    margin-right: 10
    placeholder: Key Here

  Button
    id: closePanel
    anchors.left: cardCollect.left
    anchors.right: cardCollect.right
    anchors.top: cardCollect.bottom
    margin-top: 5
    text: Close
]], g_ui.getRootWidget())

dropFlorInterface:hide()

dropFlorInterface.closePanel.onClick = function()
  dropFlorInterface:hide()
end

DropFlorMobileOk = false
DropFlorIsMobile = false
if g_app and type(g_app.isMobile) == "function" then
  DropFlorMobileOk, DropFlorIsMobile = pcall(function() return g_app:isMobile() end)
  if not DropFlorMobileOk then
    DropFlorMobileOk, DropFlorIsMobile = pcall(function() return g_app.isMobile() end)
  end
end
if DropFlorIsMobile == true then
  if comboLeader then comboLeader:setSize("250 340") end
  if mwInterface then mwInterface:setSize("400 320") end
  if pvpWindow then pvpWindow:setSize("315 360") end
  if dropFlorInterface then dropFlorInterface:setSize("250 250") end
end

dropFlorButton.settings.onClick = function()
  dropFlorInterface:setVisible(not dropFlorInterface:isVisible())
  if dropFlorInterface:isVisible() then
    dropFlorInterface:raise()
    dropFlorInterface:focus()
  end
end

-- =========================================
-- CHAR STORAGE + BINDS
-- =========================================
panelStoreName = "panelDropFlorStorage"

warStorage[panelStoreName] = warStorage[panelStoreName] or {
  flowerId = 2981,
  flowerId2 = 0,
  flowerId3 = 0,
  flowerId4 = 0,
  containerCollectId = 2854,
  keyDropBACK = "",
  keyMarking = "",
  keyCollectFlower = "F2"
}

cfg = warStorage[panelStoreName]

function saveCfg()
  saveDropFlorChar()
end

function sched(ms, fn)
  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  if g_dispatcher and type(g_dispatcher.addEvent) == "function" then
    return g_dispatcher:addEvent(fn)
  end
  return nil
end

function safeSetItem(widget, id)
  if not widget then return end
  id = tonumber(id) or 0
  if id > 0 and widget.setItemId then widget:setItemId(id) end
  if id > 0 and (not widget.setItemId) and widget.setItem then widget:setItem(id) end
end

function safeGetItem(widget)
  if not widget then return 0 end
  if widget.getItemId then return tonumber(widget:getItemId()) or 0 end
  if widget.getItem then
    it = widget:getItem()
    if it and it.getId then return tonumber(it:getId()) or 0 end
  end
  return 0
end

function bindBotItem(widget, store, key, defaultId)
  if not widget then return end
  v = tonumber(store[key]) or 0
  if (v <= 0) and (tonumber(defaultId) or 0) > 0 then
    v = tonumber(defaultId)
    store[key] = v
    saveCfg()
  end
  safeSetItem(widget, v)
  widget.onItemChange = function(w)
    store[key] = safeGetItem(w)
    saveCfg()
  end
end

function bindTextEdit(widget, store, key, defaultText)
  if not widget then return end
  v = store[key]
  if v == nil then
    v = tostring(defaultText or "")
    store[key] = v
    saveCfg()
  end
  store[key] = tostring(v or "")
  if widget.setText then widget:setText(store[key]) end
  widget.onTextChange = function(_, text)
    store[key] = tostring(text or "")
    saveCfg()
  end
end

bindBotItem(dropFlorInterface.idFlower,  cfg, "flowerId",  2981)
bindBotItem(dropFlorInterface.idFlower2, cfg, "flowerId2", 0)
bindBotItem(dropFlorInterface.idFlower3, cfg, "flowerId3", 0)
bindBotItem(dropFlorInterface.idFlower4, cfg, "flowerId4", 0)
bindBotItem(dropFlorInterface.idContainerCollect, cfg, "containerCollectId", 2854)

bindTextEdit(dropFlorInterface.keyDropBACK, cfg, "keyDropBACK", "")
bindTextEdit(dropFlorInterface.keyMarking, cfg, "keyMarking", "")
bindTextEdit(dropFlorInterface.keyCollectFlower, cfg, "keyCollectFlower", "F2")

-- =========================================
-- HELPERS
-- =========================================
function tableContains(t, value)
  for i = 1, #t do
    if t[i] == value then return true end
  end
  return false
end

function normalizeFlowerIds()
  ids = {}
  added = {}

  list = {
    tonumber(cfg.flowerId or 0) or 0,
    tonumber(cfg.flowerId2 or 0) or 0,
    tonumber(cfg.flowerId3 or 0) or 0,
    tonumber(cfg.flowerId4 or 0) or 0
  }

  for i = 1, #list do
    id = list[i]
    if id > 0 and not added[id] then
      added[id] = true
      table.insert(ids, id)
    end
  end

  return ids
end

function findItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  for _, c in pairs(g_game.getContainers() or {}) do
    for _, it in ipairs(c:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

function findAnyFlowerItem()
  flowerIds = normalizeFlowerIds()
  for i = 1, #flowerIds do
    it = findItemById(flowerIds[i])
    if it then
      return it, flowerIds[i]
    end
  end
  return nil, 0
end

function collectFlowers()
  if not pos() then return end

  flowerIds = normalizeFlowerIds()
  if #flowerIds == 0 then return end

  containerId = tonumber(cfg.containerCollectId or 0) or 0
  if containerId <= 0 then return end

  dest = nil
  for _, c in pairs(g_game.getContainers() or {}) do
    bpItem = c:getContainerItem()
    if bpItem and bpItem.getId and tonumber(bpItem:getId()) == containerId then
      dest = c
      break
    end
  end
  if not dest then return end

  slotPos = dest:getSlotPosition(0)
  if not slotPos then return end

  for dx = -1, 1 do
    for dy = -1, 1 do
      tile = g_map.getTile({x = posx() + dx, y = posy() + dy, z = posz()})
      if tile then
        for _, it in ipairs(tile:getItems() or {}) do
          if it and it.isItem and it:isItem() and it.getId then
            itemId = tonumber(it:getId()) or 0
            if tableContains(flowerIds, itemId) then
              g_game.move(it, slotPos, it:getCount())
            end
          end
        end
      end
    end
  end
end

-- =========================================
-- HOTKEYS
-- =========================================
function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

function normKey(s)
  return trim(s):lower()
end

-- =========================================
-- SHORTCUT MARKING FAST
-- Marca sqm pelo mouse, sem setTimer/contagem feia.
-- Usa setMarked se existir; se nao existir, fica com texto fixo.
-- =========================================
MARK_FLOWER_TEXT = "Flower"
MARK_DROP_COOLDOWN = 2
MARK_VISUAL_INTERVAL = 50

__markedFlowerTiles = {}
__markedFlowerCooldown = {}
__markBlink = false
__nextMarkVisual = 0

function markTimeMs()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

function markPosKey(p)
  if not p then return "" end
  return tostring(p.x) .. "," .. tostring(p.y) .. "," .. tostring(p.z)
end

function copyMarkPos(p)
  return {x = p.x, y = p.y, z = p.z}
end

function clearTileMarkVisual(tile)
  if not tile then return end

  if tile.setText and tile.getText then
    ok, txt = pcall(function() return tile:getText() end)
    if ok and txt == MARK_FLOWER_TEXT then
      pcall(function() tile:setText("") end)
    end
  elseif tile.setText then
    pcall(function() tile:setText("") end)
  end

  -- Alguns OTCv8 aceitam setMarked em tile; se nao aceitar, o pcall ignora.
  if tile.setMarked then
    pcall(function() tile:setMarked(nil) end)
  end
end

function setMarkedTileVisual(tile)
  if not tile then return end

  -- Mantem a frase marcada no SQM, sem timer/contador.
  if tile.setText then
    pcall(function() tile:setText(MARK_FLOWER_TEXT) end)
  end

  -- Pisca o SQM sem usar setTimer. setTimer mostra contagem, por isso foi removido.
  if tile.setMarked then
    color = __markBlink and "#00FFFF" or "#FFFF00"
    pcall(function() tile:setMarked(color) end)
  end
end

function clearOneMarkedFlower(key)
  p = __markedFlowerTiles[key]
  if p then
    clearTileMarkVisual(g_map.getTile(p))
  end

  __markedFlowerTiles[key] = nil
  __markedFlowerCooldown[key] = nil
end

function clearAllMarkedFlowers()
  for key in pairs(__markedFlowerTiles) do
    clearOneMarkedFlower(key)
  end
end

function toggleMarkedFlowerTile(tile)
  if not tile then return nil end

  p = tile:getPosition()
  if not p or p.z ~= posz() then return nil end

  key = markPosKey(p)

  if __markedFlowerTiles[key] then
    clearOneMarkedFlower(key)
    return nil
  end

  __markedFlowerTiles[key] = copyMarkPos(p)
  __markedFlowerCooldown[key] = 0
  setMarkedTileVisual(tile)
  return key
end

function isMwOrWgId(id)
  id = tonumber(id) or 0

  -- IDs padrao mais comuns de MW/WG.
  if id == 2129 or id == 16518 or id == 2130 then
    return true
  end

  -- Se o painel MW/WG estiver no mesmo warStorage, respeita os IDs configurados nele tambem.
  mwStore = warStorage and warStorage.holdMwWgPanel
  if type(mwStore) == "table" then
    if id == tonumber(mwStore.mwWall1 or 0) then return true end
    if id == tonumber(mwStore.mwWall2 or 0) then return true end
    if id == tonumber(mwStore.wgWall1 or 0) then return true end
    if id == tonumber(mwStore.wgWall2 or 0) then return true end
  end

  return false
end

function tileHasPlayer(tile)
  if not tile then return false end

  for _, creature in ipairs(tile:getCreatures() or {}) do
    if creature and creature.isPlayer and creature:isPlayer() then
      return true
    end
  end

  return false
end

function tileHasMwOrWg(tile)
  if not tile then return false end

  for _, it in ipairs(tile:getItems() or {}) do
    if it and it.getId and isMwOrWgId(it:getId()) then
      return true
    end
  end

  return false
end

function tileHasFlower(tile)
  if not tile then return false end

  flowerIds = normalizeFlowerIds()
  if #flowerIds == 0 then return false end

  for _, it in ipairs(tile:getItems() or {}) do
    if it and it.getId and tableContains(flowerIds, tonumber(it:getId()) or 0) then
      return true
    end
  end

  return false
end

function canDropFlowerOnMarkedTile(tile)
  if not tile then return false end

  p = tile:getPosition()
  if not p or p.z ~= posz() then return false end

  if tileHasPlayer(tile) then return false end
  if tileHasMwOrWg(tile) then return false end
  if tileHasFlower(tile) then return false end

  return true
end

function dropFlowerOnMarkedTile(key, tile, force)
  if not key or not tile then return false end
  if not canDropFlowerOnMarkedTile(tile) then return false end

  t = markTimeMs()
  if not force and (__markedFlowerCooldown[key] or 0) > t then return false end
  __markedFlowerCooldown[key] = t + MARK_DROP_COOLDOWN

  flower = findAnyFlowerItem()
  if not flower then return false end

  g_game.move(flower, tile:getPosition(), 1)
  return true
end

macro(10, function()
  if not warStorage[switchDropFlor] or warStorage[switchDropFlor].enabled ~= true then return end
  if not pos() then return end

  t = markTimeMs()
  updateVisual = false

  if t >= __nextMarkVisual then
    __nextMarkVisual = t + MARK_VISUAL_INTERVAL
    __markBlink = not __markBlink
    updateVisual = true
  end

  for key, markedPos in pairs(__markedFlowerTiles) do
    if markedPos and markedPos.z == posz() then
      tile = g_map.getTile(markedPos)
      if tile then
        if updateVisual then
          setMarkedTileVisual(tile)
        end
        dropFlowerOnMarkedTile(key, tile, false)
      end
    end
  end
end)

onKeyPress(function(keys)
  if not warStorage[switchDropFlor] or warStorage[switchDropFlor].enabled ~= true then return end

  k = normKey(keys)
  if k == "" then return end

  if k == "escape" or k == "esc" then
    clearAllMarkedFlowers()
    return true
  end

  kMarking = normKey(cfg.keyMarking)
  if kMarking ~= "" and k == kMarking then
    tile = getTileUnderCursor()
    if tile then
      key = toggleMarkedFlowerTile(tile)
      if key then
        -- tenta jogar no mesmo instante em que marcou, sem esperar o macro.
        dropFlowerOnMarkedTile(key, tile, true)
      end
    end
    return true
  end

  kCollect = normKey(cfg.keyCollectFlower)
  if kCollect ~= "" and k == kCollect then
    collectFlowers()
    return true
  end
end)

__dropBackRunning = false
__dropBackTickUntil = 0

function nowMs()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

function getMyDir()
  if g_game and g_game.getLocalPlayer then
    p = g_game.getLocalPlayer()
    if p and p.getDirection then
      d = p:getDirection()
      if d ~= nil then return tonumber(d) end
    end
  end
  if player and player.getDirection then
    d = player:getDirection()
    if d ~= nil then return tonumber(d) end
  end
  return nil
end

function getBackOffsets(dir)
  if dir == 0 then
    return { {0, 1}, {-1, 1}, {1, 1} }
  elseif dir == 2 then
    return { {0, -1}, {1, -1}, {-1, -1} }
  elseif dir == 1 then
    return { {-1, 0}, {-1, -1}, {-1, 1} }
  elseif dir == 3 then
    return { {1, 0}, {1, 1}, {1, -1} }
  end
  return { {0, 1}, {-1, 1}, {1, 1} }
end

function canPlaceFlowerOnTile(tile, flowerIds, myPos)
  if not tile then return false end
  tilePos = tile:getPosition()
  if not tilePos then return false end

  isSelf = (tilePos.x == myPos.x and tilePos.y == myPos.y and tilePos.z == myPos.z)
  topThing = tile:getTopThing()

  return isSelf or (not topThing or (topThing:isItem() and not tableContains(flowerIds, topThing:getId())))
end

function startDropBack()
  if __dropBackRunning then return end

  myPos = pos()
  if not myPos then return end

  flowerIds = normalizeFlowerIds()
  if #flowerIds == 0 then return end

  dir = getMyDir()
  if dir == nil then return end

  order = getBackOffsets(dir)
  tiles = {}

  for i = 1, #order do
    off = order[i]
    t = g_map.getTile({ x = myPos.x + off[1], y = myPos.y + off[2], z = myPos.z })
    if t then
      table.insert(tiles, t)
    end
  end

  if #tiles == 0 then return end

  __dropBackRunning = true
  idx = 1

  function step()
    if not warStorage[switchDropFlor] or warStorage[switchDropFlor].enabled ~= true then
      __dropBackRunning = false
      return
    end

    t = nowMs()
    if __dropBackTickUntil > t then
      sched(20, step)
      return
    end
    __dropBackTickUntil = t + 50

    if idx > #tiles then
      __dropBackRunning = false
      return
    end

    tile = tiles[idx]
    idx = idx + 1

    if tile and canPlaceFlowerOnTile(tile, flowerIds, myPos) then
      it = findAnyFlowerItem()
      if it then
        g_game.move(it, tile:getPosition(), 1)
      end
    end

    sched(110, step)
  end

  step()
end

macro(30, function()
  if not pos() then return end
  if not warStorage[switchDropFlor] or warStorage[switchDropFlor].enabled ~= true then return end
  if __dropBackRunning then return end

  if cfg.keyDropBACK ~= "" and modules.corelib.g_keyboard.isKeyPressed(cfg.keyDropBACK) then
    startDropBack()
  end
end)

UI.Separator()

--========================================================
-- ANTI PUSH / PICK UP / PUSH ALL
-- CHAR STORAGE
--========================================================

local function saveThisWarStorage()
  saveWarGlobal()
end
local function savepickUp()
  saveWarGlobal()
end


local function normalizeContainerItems(items)
  local r = {}
  if type(items) ~= "table" then return r end

  for _, v in pairs(items) do
    local id = nil

    if type(v) == "table" then
      id = tonumber(v.id)
      if not id and v.getId then
        local ok, got = pcall(function() return v:getId() end)
        if ok then id = tonumber(got) end
      end
    else
      id = tonumber(v)
    end

    if id and id > 0 then
      table.insert(r, id)
    end
  end

  return r
end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = tonumber(entry) or tonumber(entry and entry.id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end
  return r
end

local function getDropIdsFromContainer(list)
  local t = {}
  for _, entry in pairs(list or {}) do
    local id = nil
    if type(entry) == "table" then
      id = tonumber(entry.id)
    else
      id = tonumber(entry)
    end
    if id and id > 0 then
      table.insert(t, id)
    end
  end
  return t
end

--========================================================
-- ANTI PUSH
--========================================================
local switchAntiPush = "AntiPushButton"

warStorage[switchAntiPush] = warStorage[switchAntiPush] or {
  enabled = false,
  items = {3031, 3035}
}

local antiCfg = warStorage[switchAntiPush]

if type(antiCfg.items) ~= "table" or #antiCfg.items == 0 then
  antiCfg.items = {3031, 3035}
  saveThisWarStorage()
end

AntiPushButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 45
    height: 18
    text-align: center
    text: Anti-Push
    color: white

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Show
    opacity: 1.00
    color: white
]])

AntiPushButton:setId(switchAntiPush)
AntiPushButton.title:setOn(antiCfg.enabled)

AntiPushButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  antiCfg.enabled = newState
  saveThisWarStorage()
end

antiPushInterface = setupUI([[
Panel
  height: 100
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Items to Drop
    color: gray

  BotContainer
    id: antiPushItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 73
]])

antiPushInterface:hide()

UI.ContainerEx(function(widget, items)
  antiCfg.items = normalizeContainerItems(items)
  if #antiCfg.items == 0 then
    antiCfg.items = {3031, 3035}
  end
  saveThisWarStorage()
end, true, nil, antiPushInterface.antiPushItems)

antiPushInterface.antiPushItems:setItems(antiCfg.items)

AntiPushButton.edit.onClick = function()
  if antiPushInterface:isVisible() then
    antiPushInterface:hide()
    AntiPushButton.edit:setText("Show")
  else
    antiPushInterface:show()
    AntiPushButton.edit:setText("Hide")
  end
end

local currencyBreak = {
  [3031] = 3035, -- se faltar gold, usa platinum
  [3035] = 3043  -- se faltar platinum, usa crystal
}

local lastCurrencyUse = 0
local currencyDelay = 800

local function tryBreakCurrency(itemId)
  if now - lastCurrencyUse < currencyDelay then return false end

  local currencyId = currencyBreak[itemId]
  if not currencyId then return false end

  local currency = findItem(currencyId)
  if not currency then return false end

  lastCurrencyUse = now
  g_game.use(currency)
  return true
end

local function AntiPush()
  if antiCfg.enabled ~= true then return end

  local dropItems = getDropIdsFromContainer(antiCfg.items)
  if #dropItems == 0 then return end

  local tile = g_map.getTile(pos())
  if not tile then return end

  local thing = tile:getTopThing()
  local topId = thing and thing.getId and thing:getId() or 0

  for _, itemId in pairs(dropItems) do
    if itemId ~= topId then
      local dropItem = findItem(itemId)

      if dropItem then
        local count = dropItem:getCount() or 1

        if count <= 2 then
          tryBreakCurrency(itemId)
        end

        g_game.move(dropItem, pos(), count == 1 and 1 or 2)
        return
      else
        if tryBreakCurrency(itemId) then
          return
        end
      end
    end
  end
end

macro(250, function()
  if antiCfg.enabled ~= true then return end
  AntiPush()
end)

--========================================================
-- PICK UP
--========================================================
local switchPickUp = "PickUpButton"

warStorage[switchPickUp] = warStorage[switchPickUp] or {
  enabled = false,
  items = {3031, 3035},
  containerId = 2854,
  containerCount = 1
}

local pickCfg = warStorage[switchPickUp]

if type(pickCfg.items) ~= "table" or #pickCfg.items == 0 then
  pickCfg.items = {3031, 3035}
end

pickCfg.containerId = tonumber(pickCfg.containerId or 0) or 0
if pickCfg.containerId <= 0 then
  pickCfg.containerId = 2854
end

pickCfg.containerCount = tonumber(pickCfg.containerCount or 0) or 0
if pickCfg.containerCount <= 0 then
  pickCfg.containerCount = 1
end

local config = {
  enabled = pickCfg.enabled,
  pickUpItems = pickCfg.items,
  containerPickUpItems = {}
}

local function syncConfig()
  config.enabled = (pickCfg.enabled == true)
  config.pickUpItems = pickCfg.items or {}

  local cid = tonumber(pickCfg.containerId or 0) or 0
  if cid > 0 then
    config.containerPickUpItems = { { id = cid } }
  else
    config.containerPickUpItems = {}
  end
end

syncConfig()

PickUpButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 45
    text-align: center
    height: 18
    text: Pick Up
    color: white

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    height: 18
    margin-left: 2
    text: Show
    opacity: 1.00
    color: white
]])

PickUpButton:setId(switchPickUp)
PickUpButton.title:setOn(pickCfg.enabled)

PickUpButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  pickCfg.enabled = newState
  syncConfig()
  savepickUp()
end

pickUpInterface = setupUI([[
Panel
  height: 130

  Label
    id: labelcontainer
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 10
    margin-left: 5
    text: ID Container:
    color: gray

  BotItem
    id: idContainerPick
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    image-source: /images/ui/item-blessed
    margin-top: 5

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: -1
    text: Items to Collect:
    color: gray

  BotContainer
    id: pickUpItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 73
]])

pickUpInterface:hide()

do
  local wid = pickUpInterface.idContainerPick
  local id = tonumber(pickCfg.containerId or 0) or 0

  if type(wid.setItemId) == "function" then
    wid:setItemId(id)
  elseif type(wid.setItem) == "function" then
    wid:setItem(id)
  end

  if type(wid.setItemCount) == "function" then
    wid:setItemCount(tonumber(pickCfg.containerCount or 1) or 1)
  end

  wid.onItemChange = function(widget)
    local item = widget:getItem()
    if item then
      pickCfg.containerId = item:getId()
      pickCfg.containerCount = item:getCount() or 1
    else
      pickCfg.containerId = 2854
      pickCfg.containerCount = 1
    end
    syncConfig()
    savepickUp()
  end
end

UI.ContainerEx(function(widget, items)
  pickCfg.items = normalizeContainerItems(items)
  if #pickCfg.items == 0 then
    pickCfg.items = {3031, 3035}
  end
  syncConfig()
  savepickUp()
end, true, nil, pickUpInterface.pickUpItems)

pickUpInterface.pickUpItems:setItems(pickCfg.items)

PickUpButton.edit.onClick = function()
  if pickUpInterface:isVisible() then
    pickUpInterface:hide()
    PickUpButton.edit:setText("Show")
  else
    pickUpInterface:show()
    PickUpButton.edit:setText("Hide")
  end
end

local CheckPOS = 1

local pickUpMacro = macro(200, function()
  if not config.enabled then return end

  local pickUpIds = properTable(config.pickUpItems)
  local containerIds = properTable(config.containerPickUpItems)

  if #pickUpIds == 0 or #containerIds == 0 then return end

  for x = -CheckPOS, CheckPOS do
    for y = -CheckPOS, CheckPOS do
      local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
      if tile then
        for _, item in pairs(tile:getThings()) do
          if table.find(pickUpIds, item:getId()) then
            for _, container in pairs(getContainers()) do
              local cItem = container:getContainerItem()
              if cItem and table.find(containerIds, cItem:getId()) then
                g_game.move(item, container:getSlotPosition(container:getItemsCount()), item:getCount())
                return
              end
            end
          end
        end
      end
    end
  end
end)

--========================================================
-- PUSH ALL
--========================================================
local switchPushAll = "pushAllButton"

warStorage[switchPushAll] = warStorage[switchPushAll] or {
  enabled = false
}

local pushAllCfg = warStorage[switchPushAll]

pushAllButton = setupUI([[
Panel
  height: 19
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Pull Nearby Items
    height: 18
    color: white
]])

pushAllButton:setId(switchPushAll)
pushAllButton.title:setOn(pushAllCfg.enabled)

pushAllButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  pushAllCfg.enabled = newState
  saveThisWarStorage()
end

macro(100, function()
  if not pushAllCfg.enabled then return end

  for _, tile in pairs(g_map.getTiles(posz())) do
    local tilePos = tile:getPosition()
    if distanceFromPlayer(tilePos) == 1 then
      local top = tile:getTopUseThing()
      if top and not top:isNotMoveable() then
        if distanceFromPlayer(tilePos) > 1 then return end
        g_game.move(top, pos(), top:getCount())
        return
      end
    end
  end
end)

--========================================================
-- FULL TANK
--========================================================
UI.Separator()

local function saveFullTank()
  saveWarGlobal()
end

local STORAGE_KEY = "lnsFullTank"

warStorage[STORAGE_KEY] = warStorage[STORAGE_KEY] or {
  enabled = false,
  ringId = 3048,   -- might ring
  amuletId = 3081, -- ssa
  hotkey = "F12"
}

local cfg = warStorage[STORAGE_KEY]

lnsFullTankActive = cfg.enabled == true

function isLnsFullTankActive()
  return lnsFullTankActive == true
end

local FULL_SLOT_NECK = SlotNeck or 2
local FULL_SLOT_FINGER = SlotFinger or 9
local FULL_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local FULL_ACTION_DELAY = FULL_IS_OLD_CLIENT and 250 or 0

local ui = setupUI([[
Panel
  height: 60

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 18
    text-align: center
    text: FULL TANK
    visible: false
    color: white
    font: verdana-11px-rounded

  BotItem
    id: ringItem
    anchors.top: title.top
    anchors.horizontalCenter: parent.horizontalCenter
    margin-right: 18
    margin-top: 0
    tooltip: ID RING

  BotItem
    id: amuletItem
    anchors.top: title.top
    anchors.left: ringItem.right
    margin-left: 8
    margin-top: 0
    tooltip: ID AMULET

  BotSwitch
    id: enable
    anchors.top: ringItem.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 19
    margin-top: 6
    margin-right: 40
    color: white
    text: Full Equip

  BotTextEdit
    id: hotkey
    anchors.top: ringItem.bottom
    anchors.left: prev.right
    anchors.right: parent.right
    height: 19
    margin-top: 6
    margin-left: 3
    text: F12
]], parent)

local function getBotItemId(widget)
  if not widget then return 0 end

  if widget.getItemId then
    local id = tonumber(widget:getItemId()) or 0
    if id > 0 then return id end
  end

  if widget.getItem then
    local item = widget:getItem()
    if type(item) == "number" then return item end
    if item and item.getId then return tonumber(item:getId()) or 0 end
  end

  return 0
end

local function setBotItemId(widget, itemId)
  itemId = tonumber(itemId) or 0
  if not widget then return end

  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem then
    widget:setItem(itemId)
  end
end

local function fullGetContainers()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end

  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end

  return {}
end

local function fullFindItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local item = findItem(id)
    if item then return item end
  end

  for _, container in ipairs(fullGetContainers()) do
    for _, item in ipairs(container:getItems() or {}) do
      if item and item.getId and tonumber(item:getId()) == id then
        return item
      end
    end
  end

  return nil
end

local function fullGetSlotId(slot)
  local item = getSlot(slot)
  if item and item.getId then
    return tonumber(item:getId()) or 0
  end
  return 0
end

local function fullEquipToSlot(itemId, slot)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return false end

  if not FULL_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(itemId)
    end)

    if ok then return true end

    ok = pcall(function()
      g_game.equipItemId(itemId)
    end)

    return ok
  end

  local item = fullFindItemById(itemId)
  if not item then return false end

  local ok = pcall(function()
    g_game.move(item, {x = 65535, y = slot, z = 0}, 1)
  end)

  return ok
end

function setFullTankEnabled(state)
  cfg.enabled = state == true
  lnsFullTankActive = cfg.enabled == true

  ui.enable:setOn(cfg.enabled)
  ui.enable:setText("Full Equip")

  saveFullTank()
end

setBotItemId(ui.ringItem, cfg.ringId or 3048)
setBotItemId(ui.amuletItem, cfg.amuletId or 3081)
ui.enable:setOn(cfg.enabled == true)
ui.enable:setText(cfg.enabled and "Full Equip" or "Full Equip")
ui.hotkey:setText(cfg.hotkey or "F12")

ui.enable.onClick = function(widget)
  setFullTankEnabled(not widget:isOn())
end

ui.ringItem.onItemChange = function(widget)
  cfg.ringId = getBotItemId(widget)
  saveFullTank()
end

ui.amuletItem.onItemChange = function(widget)
  cfg.amuletId = getBotItemId(widget)
  saveFullTank()
end

ui.hotkey.onTextChange = function(widget, text)
  cfg.hotkey = tostring(text or ""):upper():gsub("%s+", "")
  widget:setText(cfg.hotkey)
  saveFullTank()
end

local function isHotkeyPressed()
  local key = tostring(cfg.hotkey or ""):upper():gsub("%s+", "")
  if key == "" then return false end

  if not g_keyboard or not g_keyboard.isKeyPressed then
    return false
  end

  return g_keyboard.isKeyPressed(key) or g_keyboard.isKeyPressed(key:lower())
end

local lastHotkey = 0

macro(20, function()
  if isHotkeyPressed() and now - lastHotkey > 350 then
    lastHotkey = now
    setFullTankEnabled(not cfg.enabled)
  end
end)

local nextEquipAction = 0
pauseSwapRing = pauseSwapRing or 0
local nextEquipAction = 0

macro(20, function()
  if cfg.enabled ~= true then return end
  if now < nextEquipAction then return end

  local ringId = tonumber(cfg.ringId) or 0
  local amuletId = tonumber(cfg.amuletId) or 0

  if not FULL_IS_OLD_CLIENT then
    if ringId > 0 and fullGetSlotId(FULL_SLOT_FINGER) ~= ringId then
      pcall(function()
        g_game.equipItemId(ringId, FULL_SLOT_FINGER)
      end)
    end

    if amuletId > 0 and fullGetSlotId(FULL_SLOT_NECK) ~= amuletId then
      pcall(function()
        g_game.equipItemId(amuletId, FULL_SLOT_NECK)
      end)
    end

    return
  end

  -- old client: precisa mover um por vez para evitar bug/exhaust
  if ringId > 0 and fullGetSlotId(FULL_SLOT_FINGER) ~= ringId then
    if fullEquipToSlot(ringId, FULL_SLOT_FINGER) then
      nextEquipAction = now + FULL_ACTION_DELAY
      return
    end
  end

  if amuletId > 0 and fullGetSlotId(FULL_SLOT_NECK) ~= amuletId then
    if fullEquipToSlot(amuletId, FULL_SLOT_NECK) then
      nextEquipAction = now + FULL_ACTION_DELAY
      return
    end
  end
end)

--========================================================
-- DOUBLE UE
--========================================================
UI.Separator()

do

lnsDoubleUE = lnsDoubleUE or {}
lnsDoubleUE.panelName = "doubleUEInterface"

warStorage[lnsDoubleUE.panelName] = warStorage[lnsDoubleUE.panelName] or {
  switches = {},
  checks = {},
  texts = {},
  items = {}
}

warStorage[lnsDoubleUE.panelName].switches = warStorage[lnsDoubleUE.panelName].switches or {}
warStorage[lnsDoubleUE.panelName].checks   = warStorage[lnsDoubleUE.panelName].checks or {}
warStorage[lnsDoubleUE.panelName].texts    = warStorage[lnsDoubleUE.panelName].texts or {}
warStorage[lnsDoubleUE.panelName].items    = warStorage[lnsDoubleUE.panelName].items or {}

if warStorage[lnsDoubleUE.panelName].items.potionItem == nil and warStorage[lnsDoubleUE.panelName].items.ringItem ~= nil then
  warStorage[lnsDoubleUE.panelName].items.potionItem = warStorage[lnsDoubleUE.panelName].items.ringItem
  warStorage[lnsDoubleUE.panelName].items.ringItem = nil
end

if warStorage[lnsDoubleUE.panelName].texts.spellEdit == nil or warStorage[lnsDoubleUE.panelName].texts.spellEdit == "" then
  warStorage[lnsDoubleUE.panelName].texts.spellEdit = "Exevo Gran Mas Flam"
end

if warStorage[lnsDoubleUE.panelName].texts.hotkeyEdit == nil or warStorage[lnsDoubleUE.panelName].texts.hotkeyEdit == "" then
  warStorage[lnsDoubleUE.panelName].texts.hotkeyEdit = "F5"
end

if warStorage[lnsDoubleUE.panelName].checks.ativarAvatar == nil then
  warStorage[lnsDoubleUE.panelName].checks.ativarAvatar = true
end

lnsDoubleUE.save = function()
  saveWarGlobal()
end

doubleUE = setupUI([[
Panel
  height: 19

  BotSwitch
    id: ativarDoubleUE
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 45
    height: 18
    text-align: center
    text: Active Double UE
    color: white

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Show
    opacity: 1.00
    color: white
]], parent)

doubleUEInterface = setupUI([[
Panel
  height: 120

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 15
    text-auto-resize: true
    text: Pot Cooldown:
    color: white
    font: verdana-11px-rounded

  BotItem
    id: potionItem
    anchors.verticalCenter: prev.verticalCenter
    anchors.right: parent.right

  Label
    id: spellLabel
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 3
    text: Spell:
    text-auto-resize: true
    color: white
    font: verdana-11px-rounded

  BotTextEdit
    id: spellEdit
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 2

  Label
    id: hotkeyLabel
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
    text: Atalho:
    text-auto-resize: true
    color: white
    font: verdana-11px-rounded

  BotTextEdit
    id: hotkeyEdit
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    width: 80

  CheckBox
    id: ativarAvatar
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
    size: 100 20
    text: Auto Avatar
    text-align: verticalCenter
]], parent)

doubleUEInterface:hide()

doubleUE.edit.onClick = function()
  if doubleUEInterface:isVisible() then
    doubleUEInterface:hide()
    doubleUE.edit:setText("Show")
  else
    doubleUEInterface:show()
    doubleUE.edit:setText("Hide")
  end
end

lnsDoubleUE.getWidget = function(id)
  local widget = nil

  if doubleUE then
    if doubleUE.recursiveGetChildById then
      widget = doubleUE:recursiveGetChildById(id)
    else
      widget = doubleUE[id]
    end
  end

  if widget then return widget end
  if not doubleUEInterface then return nil end

  if doubleUEInterface.recursiveGetChildById then
    return doubleUEInterface:recursiveGetChildById(id)
  end

  return doubleUEInterface[id]
end

lnsDoubleUE.bindSwitch = function(id)
  lnsDoubleUE.widget = lnsDoubleUE.getWidget(id)
  if not lnsDoubleUE.widget then
    warn("[Double UE] bindSwitch nao encontrou widget: " .. tostring(id))
    return
  end

  if warStorage[lnsDoubleUE.panelName].switches[id] ~= nil then
    lnsDoubleUE.widget:setOn(warStorage[lnsDoubleUE.panelName].switches[id] == true)
  else
    warStorage[lnsDoubleUE.panelName].switches[id] = lnsDoubleUE.widget:isOn() == true
    lnsDoubleUE.save()
  end

  lnsDoubleUE.widget.onClick = function(widget)
    lnsDoubleUE.state = not widget:isOn()
    widget:setOn(lnsDoubleUE.state)
    warStorage[lnsDoubleUE.panelName].switches[id] = lnsDoubleUE.state
    lnsDoubleUE.save()
  end
end

lnsDoubleUE.bindCheck = function(id)
  lnsDoubleUE.widget = lnsDoubleUE.getWidget(id)
  if not lnsDoubleUE.widget then
    warn("[Double UE] bindCheck nao encontrou widget: " .. tostring(id))
    return
  end

  if warStorage[lnsDoubleUE.panelName].checks[id] ~= nil then
    lnsDoubleUE.widget:setChecked(warStorage[lnsDoubleUE.panelName].checks[id] == true)
  else
    warStorage[lnsDoubleUE.panelName].checks[id] = lnsDoubleUE.widget:isChecked() == true
    lnsDoubleUE.save()
  end

  lnsDoubleUE.widget.onCheckChange = function(widget, checked)
    warStorage[lnsDoubleUE.panelName].checks[id] = checked == true
    lnsDoubleUE.save()
  end
end

lnsDoubleUE.bindText = function(id)
  lnsDoubleUE.widget = lnsDoubleUE.getWidget(id)
  if not lnsDoubleUE.widget then
    warn("[Double UE] bindText nao encontrou widget: " .. tostring(id))
    return
  end

  if warStorage[lnsDoubleUE.panelName].texts[id] ~= nil then
    lnsDoubleUE.widget:setText(tostring(warStorage[lnsDoubleUE.panelName].texts[id]))
  else
    warStorage[lnsDoubleUE.panelName].texts[id] = lnsDoubleUE.widget:getText() or ""
    lnsDoubleUE.save()
  end

  lnsDoubleUE.widget.onTextChange = function(widget, text)
    warStorage[lnsDoubleUE.panelName].texts[id] = tostring(text or widget:getText() or "")
    lnsDoubleUE.save()
  end
end

lnsDoubleUE.readBotItemId = function(widget)
  if not widget then return 0 end

  if widget.getItemId then
    lnsDoubleUE.tmpItemId = tonumber(widget:getItemId()) or 0
    if lnsDoubleUE.tmpItemId > 0 then
      return lnsDoubleUE.tmpItemId
    end
  end

  if widget.getItem and widget:getItem() then
    lnsDoubleUE.tmpItemObj = widget:getItem()

    if lnsDoubleUE.tmpItemObj and lnsDoubleUE.tmpItemObj.getId then
      lnsDoubleUE.tmpItemId = tonumber(lnsDoubleUE.tmpItemObj:getId()) or 0
      if lnsDoubleUE.tmpItemId > 0 then
        return lnsDoubleUE.tmpItemId
      end
    end
  end

  return 0
end

lnsDoubleUE.bindItem = function(id)
  lnsDoubleUE.widget = lnsDoubleUE.getWidget(id)
  if not lnsDoubleUE.widget then
    warn("[Double UE] bindItem nao encontrou widget: " .. tostring(id))
    return
  end

  lnsDoubleUE.savedItem = tonumber(warStorage[lnsDoubleUE.panelName].items[id]) or 0

  if lnsDoubleUE.savedItem > 0 then
    lnsDoubleUE.widget:setItemId(lnsDoubleUE.savedItem)
  else
    lnsDoubleUE.itemId = lnsDoubleUE.readBotItemId(lnsDoubleUE.widget)

    if lnsDoubleUE.itemId > 0 then
      warStorage[lnsDoubleUE.panelName].items[id] = lnsDoubleUE.itemId
      lnsDoubleUE.save()
    end
  end

  lnsDoubleUE.widget.onItemChange = function(widget)
    lnsDoubleUE.itemId = lnsDoubleUE.readBotItemId(widget)

    if lnsDoubleUE.itemId > 0 then
      warStorage[lnsDoubleUE.panelName].items[id] = lnsDoubleUE.itemId
      lnsDoubleUE.save()
    end
  end

  lnsDoubleUE.widget.onItemIdChange = function(widget, itemId)
    lnsDoubleUE.itemId = tonumber(itemId) or 0

    if lnsDoubleUE.itemId <= 0 then
      lnsDoubleUE.itemId = lnsDoubleUE.readBotItemId(widget)
    end

    if lnsDoubleUE.itemId > 0 then
      warStorage[lnsDoubleUE.panelName].items[id] = lnsDoubleUE.itemId
      lnsDoubleUE.save()
    end
  end

  macro(100, function()
    lnsDoubleUE.itemWidget = lnsDoubleUE.getWidget(id)
    if not lnsDoubleUE.itemWidget then return end

    lnsDoubleUE.itemId = lnsDoubleUE.readBotItemId(lnsDoubleUE.itemWidget)
    if lnsDoubleUE.itemId <= 0 then return end

    if tonumber(warStorage[lnsDoubleUE.panelName].items[id]) == lnsDoubleUE.itemId then return end

    warStorage[lnsDoubleUE.panelName].items[id] = lnsDoubleUE.itemId
    lnsDoubleUE.save()
  end)
end

lnsDoubleUE.bindItem("potionItem")
lnsDoubleUE.bindText("spellEdit")
lnsDoubleUE.bindText("hotkeyEdit")
lnsDoubleUE.bindSwitch("ativarDoubleUE")
lnsDoubleUE.bindCheck("ativarAvatar")

lnsDoubleUE.trim = function(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

lnsDoubleUE.enabled = function()
  return warStorage[lnsDoubleUE.panelName]
    and warStorage[lnsDoubleUE.panelName].switches
    and warStorage[lnsDoubleUE.panelName].switches.ativarDoubleUE == true
end

lnsDoubleUE.avatarEnabled = function()
  return warStorage[lnsDoubleUE.panelName]
    and warStorage[lnsDoubleUE.panelName].checks
    and warStorage[lnsDoubleUE.panelName].checks.ativarAvatar == true
end

lnsDoubleUE.getSpell = function()
  return lnsDoubleUE.trim(warStorage[lnsDoubleUE.panelName].texts.spellEdit or "")
end

lnsDoubleUE.getHotkey = function()
  return lnsDoubleUE.trim(warStorage[lnsDoubleUE.panelName].texts.hotkeyEdit or "")
end

lnsDoubleUE.getPotion = function()
  lnsDoubleUE.potionWidget = lnsDoubleUE.getWidget("potionItem")

  if lnsDoubleUE.potionWidget then
    lnsDoubleUE.potionId = lnsDoubleUE.readBotItemId(lnsDoubleUE.potionWidget)

    if lnsDoubleUE.potionId > 0 then
      warStorage[lnsDoubleUE.panelName].items.potionItem = lnsDoubleUE.potionId
      return lnsDoubleUE.potionId
    end
  end

  return tonumber(warStorage[lnsDoubleUE.panelName].items.potionItem) or 0
end

lnsDoubleUE.vocationsMap = {
  [1] = "Knight",
  [2] = "Paladin",
  [3] = "Sorcerer",
  [4] = "Druid",
  [5] = "Monk",
  [6] = "Elite Knight",
  [7] = "Royal Paladin",
  [8] = "Master Sorcerer",
  [9] = "Elder Druid",
  [10] = "Exalted Monk"
}

lnsDoubleUE.avatarSpellByVoc = {
  knight = "uteta res eq",
  paladin = "uteta res sac",
  sorcerer = "uteta res ven",
  druid = "uteta res dru",
  monk = "uteta res tio"
}

lnsDoubleUE.getVocationType = function(playerObj)
  if not playerObj then return "knight" end

  lnsDoubleUE.vocId = playerObj:getVocation()
  lnsDoubleUE.vocName = lnsDoubleUE.vocationsMap[lnsDoubleUE.vocId] or "Unknown"

  if lnsDoubleUE.vocName == "Knight" or lnsDoubleUE.vocName == "Elite Knight" then
    return "knight"
  end

  if lnsDoubleUE.vocName == "Paladin" or lnsDoubleUE.vocName == "Royal Paladin" then
    return "paladin"
  end

  if lnsDoubleUE.vocName == "Sorcerer" or lnsDoubleUE.vocName == "Master Sorcerer" then
    return "sorcerer"
  end

  if lnsDoubleUE.vocName == "Druid" or lnsDoubleUE.vocName == "Elder Druid" then
    return "druid"
  end

  if lnsDoubleUE.vocName == "Monk" or lnsDoubleUE.vocName == "Exalted Monk" then
    return "monk"
  end

  return "knight"
end

lnsDoubleUE.getAvatarSpell = function()
  lnsDoubleUE.playerObj = g_game.getLocalPlayer()
  if not lnsDoubleUE.playerObj then return "" end

  lnsDoubleUE.vocType = lnsDoubleUE.getVocationType(lnsDoubleUE.playerObj)
  return lnsDoubleUE.avatarSpellByVoc[lnsDoubleUE.vocType] or lnsDoubleUE.avatarSpellByVoc.knight or ""
end

lnsDoubleUE.lastCast = 0
lnsDoubleUE.keyDown = false

lnsDoubleUE.usePotion = function(itemId)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return false end

  lnsDoubleUE.localPlayer = g_game.getLocalPlayer()
  if not lnsDoubleUE.localPlayer then return false end

  use(itemId)
  return true
end

lnsDoubleUE.execute = function()
  if not lnsDoubleUE.enabled() then return end
  if lnsDoubleUE.lastCast > now then return end

  lnsDoubleUE.spell = lnsDoubleUE.getSpell()
  lnsDoubleUE.potionId = lnsDoubleUE.getPotion()

  if lnsDoubleUE.spell == "" then return end
  if lnsDoubleUE.potionId <= 0 then
    warn("[Double UE] Potion ID invalido no BotItem.")
    return
  end

  lnsDoubleUE.lastCast = now + 200

  if lnsDoubleUE.avatarEnabled() then
    lnsDoubleUE.avatarSpell = lnsDoubleUE.getAvatarSpell()
    if lnsDoubleUE.avatarSpell ~= "" then
      say(lnsDoubleUE.avatarSpell)
    end
  end

  say(lnsDoubleUE.spell)
  lnsDoubleUE.usePotion(lnsDoubleUE.potionId)
  say(lnsDoubleUE.spell)
end

lnsDoubleUE.iconExecute = function()
  if not lnsDoubleUE or not lnsDoubleUE.panelName then return end
  if not warStorage or not warStorage[lnsDoubleUE.panelName] then return end
  if not warStorage[lnsDoubleUE.panelName].switches then return end

  local oldState = warStorage[lnsDoubleUE.panelName].switches.ativarDoubleUE

  -- libera a execução só nesse clique
  warStorage[lnsDoubleUE.panelName].switches.ativarDoubleUE = true

  if lnsDoubleUE.execute then
    lnsDoubleUE.execute()
  end

  -- volta para o estado original, então não deixa a script ligada
  warStorage[lnsDoubleUE.panelName].switches.ativarDoubleUE = oldState == true
end

macro(20, function()
  if not lnsDoubleUE.enabled() then
    lnsDoubleUE.keyDown = false
    return
  end

  lnsDoubleUE.key = lnsDoubleUE.getHotkey()

  if lnsDoubleUE.key == "" then
    lnsDoubleUE.keyDown = false
    return
  end

  if not g_keyboard or not g_keyboard.isKeyPressed then return end

  lnsDoubleUE.pressed = g_keyboard.isKeyPressed(lnsDoubleUE.key)

  if not lnsDoubleUE.pressed then
    lnsDoubleUE.keyDown = false
    return
  end

  if lnsDoubleUE.keyDown then return end

  lnsDoubleUE.keyDown = true
  lnsDoubleUE.execute()
end)

end

--========================================================
-- FOODS HP/MP
--========================================================

do

local foodStorageName = "foodRecovery"

warStorage[foodStorageName] = warStorage[foodStorageName] or {
  hp = {
    enabled = false,
    item = 28485,
    percent = 15
  },

  mana = {
    enabled = false,
    item = 28484,
    percent = 15
  }
}

local foodCfg = warStorage[foodStorageName]

foodCfg.hp = foodCfg.hp or {}
foodCfg.hp.enabled = foodCfg.hp.enabled == true
foodCfg.hp.item = tonumber(foodCfg.hp.item) or 28485
foodCfg.hp.percent = tonumber(foodCfg.hp.percent) or 15

foodCfg.mana = foodCfg.mana or {}
foodCfg.mana.enabled = foodCfg.mana.enabled == true
foodCfg.mana.item = tonumber(foodCfg.mana.item) or 28484
foodCfg.mana.percent = tonumber(foodCfg.mana.percent) or 15

local function saveFoodStorage()
  if type(saveThisWarStorage) == "function" then
    saveThisWarStorage()
  elseif type(saveWarGlobal) == "function" then
    saveWarGlobal()
  end
end

local function getFoodItemId(widget)
  if not widget then return 0 end

  if widget.getItemId then
    local itemId = tonumber(widget:getItemId()) or 0

    if itemId > 0 then
      return itemId
    end
  end

  if widget.getItem then
    local item = widget:getItem()

    if item and item.getId then
      return tonumber(item:getId()) or 0
    end
  end

  return 0
end

foodhpPanel = setupUI([[
Panel
  height: 35
  margin-top: 5

  BotItem
    id: item
    anchors.top: parent.top
    anchors.left: parent.left
    margin-left: 2
    margin-top: 2
    image-color: pink
    border: 1 pink

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: item.right
    anchors.right: parent.right
    anchors.bottom: item.verticalCenter
    text-align: center
    text: Food HP
    margin-left: 5
    width: 123

  HorizontalScrollBar
    id: HPPercent
    anchors.top: parent.top
    anchors.left: item.right
    anchors.right: parent.right
    margin-left: 6
    margin-top: 23
    width: 120
    minimum: 1
    maximum: 100
    step: 1

  BotLabel
    id: help
    anchors.top: HPPercent.top
    anchors.bottom: HPPercent.bottom
    anchors.left: HPPercent.left
    anchors.right: HPPercent.right
    text-align: center
    color: white
    phantom: true

]], parent)

foodmpPanel = setupUI([[
Panel
  height: 35
  margin-top: 5

  BotItem
    id: item
    anchors.top: parent.top
    anchors.left: parent.left
    margin-left: 2
    margin-top: 2
    image-color: blue
    border: 1 blue

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: item.right
    anchors.right: parent.right
    anchors.bottom: item.verticalCenter
    text-align: center
    text: Food Mana
    margin-left: 5
    width: 123

  HorizontalScrollBar
    id: manaPercent
    anchors.top: parent.top
    anchors.left: item.right
    anchors.right: parent.right
    margin-left: 6
    margin-top: 23
    width: 120
    minimum: 1
    maximum: 100
    step: 1

  BotLabel
    id: help
    anchors.top: manaPercent.top
    anchors.bottom: manaPercent.bottom
    anchors.left: manaPercent.left
    anchors.right: manaPercent.right
    text-align: center
    color: white
    phantom: true

]], parent)

local function bindFoodPanel(panel, config, scrollbarId, text)
  local scrollbar = panel:recursiveGetChildById(scrollbarId)

  local function updateLabel()
    panel.help:setText(text .. ": " .. config.percent .. "%")
  end

  panel.item:setItemId(config.item)
  panel.title:setOn(config.enabled)
  scrollbar:setValue(config.percent)
  updateLabel()

  panel.title.onClick = function(widget)
    config.enabled = not widget:isOn()
    widget:setOn(config.enabled)
    saveFoodStorage()
  end

  scrollbar.onValueChange = function(widget, value)
    config.percent = tonumber(value) or 15
    updateLabel()
    saveFoodStorage()
  end

  local function saveItem(widget, itemId)
    itemId = tonumber(itemId) or getFoodItemId(widget)

    if itemId <= 0 or itemId == config.item then
      return
    end

    config.item = itemId
    saveFoodStorage()
  end

  panel.item.onItemChange = function(widget)
    saveItem(widget)
  end

  panel.item.onItemIdChange = function(widget, itemId)
    saveItem(widget, itemId)
  end
end

bindFoodPanel(foodhpPanel, foodCfg.hp, "HPPercent", "HP")
bindFoodPanel(foodmpPanel, foodCfg.mana, "manaPercent", "Mana")

-- COOLDOWN DAS FOODS
local FOOD_COOLDOWN = 10 * 60 -- 10 minutos em segundos

foodCfg.hp.nextUse = tonumber(foodCfg.hp.nextUse) or 0
foodCfg.mana.nextUse = tonumber(foodCfg.mana.nextUse) or 0

foodRecoveryState = foodRecoveryState or {
  nextAction = 0
}

foodRecoveryState.nextAction =
  tonumber(foodRecoveryState.nextAction) or 0

local function setFoodCooldown(foodType)
  local config = foodCfg[foodType]
  if not config then return end

  config.nextUse = os.time() + FOOD_COOLDOWN
  saveFoodStorage()
end

-- Atualiza a função corretamente ao recarregar a script
foodRecoveryHandleMessage = function(mode, text)
  text = tostring(text or "")

  if text:find("You were healed completely.", 1, true) then
    setFoodCooldown("hp")
    return
  end

  if text:find("Your mana was refilled completely.", 1, true) then
    setFoodCooldown("mana")
  end
end

-- Registra o listener apenas uma vez
if not foodRecoveryMessageListener then
  foodRecoveryMessageListener = onTextMessage(function(mode, text)
    if type(foodRecoveryHandleMessage) == "function" then
      foodRecoveryHandleMessage(mode, text)
    end
  end)
end

local function tryUseFood(foodType, currentPercent)
  local config = foodCfg[foodType]

  if not config or config.enabled ~= true then
    return false
  end

  local configuredPercent = tonumber(config.percent) or 15

  if currentPercent > configuredPercent then
    return false
  end

  -- Verifica o cooldown de 10 minutos
  if os.time() < (tonumber(config.nextUse) or 0) then
    return false
  end

  local itemId = tonumber(config.item) or 0
  if itemId <= 0 then
    return false
  end

  local foodItem = findItem(itemId)
  if not foodItem then
    return false
  end

  g_game.use(foodItem)
  return true
end

macro(100, function()
  if not g_game.isOnline() then return end
  if now < foodRecoveryState.nextAction then return end

  -- Food de HP tem prioridade
  if tryUseFood("hp", hppercent()) then
    foodRecoveryState.nextAction = now + 500
    return
  end

  if tryUseFood("mana", manapercent()) then
    foodRecoveryState.nextAction = now + 500
  end
end)

end
--========================================================
-- EXIVAS
--========================================================
UI.Separator()


local function saveExivaChar()
  saveWarGlobal()
end

local exivaTargetSwitch = "exivaTargetSwitch"
local xExivaSwitch      = "xExivaSwitch"
local exivaArrowSwitch  = "exivaArrowSwitch"

warStorage[exivaTargetSwitch] = warStorage[exivaTargetSwitch] or { enabled = false }
warStorage[xExivaSwitch]      = warStorage[xExivaSwitch] or { enabled = false }
warStorage[exivaArrowSwitch]  = warStorage[exivaArrowSwitch] or { enabled = true }

warStorage.Sense       = warStorage.Sense or false
warStorage.SenseTarget = warStorage.SenseTarget or false

exivaInterface = setupUI([[
Panel
  height: 53

  BotSwitch
    id: exivaTarget
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Exiva Target
    height: 18
    color: white

  BotSwitch
    id: xExiva
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: xExiva
    height: 18
    color: white

  BotSwitch
    id: exivaArrow
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Show Animation Exiva
    height: 18
    color: white
]])
exivaInterface:show()

-- =========================
-- HELPERS
-- =========================
local Directions = {
  ["east"]       = {x = 1,  y = 0},
  ["west"]       = {x = -1, y = 0},
  ["north"]      = {x = 0,  y = -1},
  ["south"]      = {x = 0,  y = 1},
  ["north-east"] = {x = 1,  y = -1},
  ["north-west"] = {x = -1, y = -1},
  ["south-east"] = {x = 1,  y = 1},
  ["south-west"] = {x = -1, y = 1},
}

local EXIVA_DIR_REGEX = "(south-east|north-east|south-west|north-west|north|south|west|east)"
local EXIVA_NAME_DIR_REGEX = "(.+) is to the (south-east|north-east|south-west|north-west|north|south|west|east)"

local CurrentDirection = nil
local VirtualTargetPos = nil
local LastExivaMode = nil
local LastAnimName = nil
local LastSenseAt = 0
local LastAnimAt = 0

local SHOOT_DELAY = 160
local EXIVA_DELAY = 2300
local PROJECT_DISTANCE = 30
local MISSILE_ID = 9

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function getPlayerByNameSafe(name)
  name = trim(name):lower()
  if name == "" then return nil end

  local specs = getSpectators(pos(), false)
  if not specs then return nil end

  for _, spec in ipairs(specs) do
    if spec and spec:isPlayer() and spec:getName() and spec:getName():lower() == name then
      return spec
    end
  end

  return nil
end

local function getProjectedPos(direction, dist)
  local dir = Directions[direction]
  if not dir then return nil end
  dist = dist or PROJECT_DISTANCE

  return {
    x = posx() + (dir.x * dist),
    y = posy() + (dir.y * dist),
    z = posz()
  }
end

local function refreshVirtualTarget()
  if not CurrentDirection then
    VirtualTargetPos = nil
    return
  end
  VirtualTargetPos = getProjectedPos(CurrentDirection, PROJECT_DISTANCE)
end

local function shootEffect(targetPos)
  if not targetPos then return end

  local effect = Missile.create()
  if not effect then return end

  effect:setId(MISSILE_ID)
  effect:setPath(pos(), targetPos)
  g_map.addThing(effect, pos())
end

function clearAnimation()
  CurrentDirection = nil
  VirtualTargetPos = nil
  LastAnimName = nil
  LastExivaMode = nil
end

function setAnimationTarget(name, mode)
  LastAnimName = trim(name or "")
  LastExivaMode = mode
end

-- =========================
-- UI BINDS
-- =========================
exivaInterface.exivaTarget:setOn(warStorage[exivaTargetSwitch].enabled)
exivaInterface.exivaTarget.onClick = function(widget)
  warStorage[exivaTargetSwitch].enabled = not warStorage[exivaTargetSwitch].enabled
  widget:setOn(warStorage[exivaTargetSwitch].enabled)
  saveExivaChar()
end

exivaInterface.xExiva:setOn(warStorage[xExivaSwitch].enabled)
exivaInterface.xExiva.onClick = function(widget)
  warStorage[xExivaSwitch].enabled = not warStorage[xExivaSwitch].enabled
  widget:setOn(warStorage[xExivaSwitch].enabled)
  saveExivaChar()
end

exivaInterface.exivaArrow:setOn(warStorage[exivaArrowSwitch].enabled)
exivaInterface.exivaArrow.onClick = function(widget)
  warStorage[exivaArrowSwitch].enabled = not warStorage[exivaArrowSwitch].enabled
  widget:setOn(warStorage[exivaArrowSwitch].enabled)

  if not warStorage[exivaArrowSwitch].enabled then
    clearAnimation()
  end

  saveExivaChar()
end

-- =========================
-- EXIVA TARGET
-- =========================
macro(200, function()
  if not warStorage[exivaTargetSwitch].enabled then return end

  local target = g_game.getAttackingCreature()
  if target and target:isPlayer() then
    warStorage.SenseTarget = target:getName()
    saveExivaChar()
  end

  if not warStorage.SenseTarget or warStorage.SenseTarget == "" then return end

  local creature = getPlayerByNameSafe(warStorage.SenseTarget)
  if not (creature and creature:getPosition().z == player:getPosition().z and getDistanceBetween(pos(), creature:getPosition()) <= 6) then
    LastExivaMode = "target"
    say('exiva "' .. warStorage.SenseTarget)
    LastSenseAt = nowMs()
    delay(2300)
  end
end)

-- =========================
-- xEXIVA
-- =========================
macro(200, function()
  if not warStorage[xExivaSwitch].enabled then return end
  if not warStorage.Sense or warStorage.Sense == "" then return end

  local creature = getPlayerByNameSafe(warStorage.Sense)
  if not (creature and creature:getPosition().z == player:getPosition().z and getDistanceBetween(pos(), creature:getPosition()) <= 6) then
    LastExivaMode = "manual"
    say('exiva "' .. warStorage.Sense)
    LastSenseAt = nowMs()
    delay(2300)
  end
end)

-- =========================
-- xNOME
-- =========================
onTalk(function(name, level, mode, text, channelId, talkPos)
  if name ~= player:getName() then return end
  if type(text) ~= "string" or text:len() < 1 then return end

  if text:sub(1, 1):lower() == "x" then
    local checkMsg = trim(text:sub(2))

    if checkMsg == "0" then
      warStorage.Sense = false
    elseif checkMsg ~= "" then
      warStorage.Sense = checkMsg
    end

    saveExivaChar()
  end
end)

-- =========================
-- RESULTADO DO EXIVA
-- =========================
onTextMessage(function(mode, text)
  text = tostring(text or "")

  local byName = regexMatch(text, EXIVA_NAME_DIR_REGEX)
  if byName and #byName > 0 then
    for _, v in pairs(byName) do
      local sensedName = trim(v[2] or "")
      local dir = trim(v[3] or "")

      if sensedName ~= "" then
        if LastExivaMode == "target" and warStorage[exivaTargetSwitch].enabled then
          setAnimationTarget(sensedName, "target")
        elseif LastExivaMode == "manual" and warStorage[xExivaSwitch].enabled then
          setAnimationTarget(sensedName, "manual")
        else
          setAnimationTarget(sensedName, LastExivaMode)
        end
      end

      if dir ~= "" then
        CurrentDirection = dir
        refreshVirtualTarget()
      end
    end
    return
  end

  local onlyDir = regexMatch(text, EXIVA_DIR_REGEX)
  if onlyDir and #onlyDir > 0 then
    for _, v in pairs(onlyDir) do
      local dir = trim(v[2] or "")
      if dir ~= "" then
        CurrentDirection = dir
        refreshVirtualTarget()

        if LastExivaMode == "target" and warStorage[exivaTargetSwitch].enabled then
          setAnimationTarget(warStorage.SenseTarget, "target")
        elseif LastExivaMode == "manual" and warStorage[xExivaSwitch].enabled then
          setAnimationTarget(warStorage.Sense, "manual")
        end
      end
    end
  end
end)

-- =========================
-- ANIMAÇÃO CONTÍNUA
-- =========================
macro(100, function()
  if not warStorage[exivaArrowSwitch].enabled then return end
  if not LastAnimName or LastAnimName == "" then return end
  if not CurrentDirection then return end

  if LastExivaMode == "target" and not warStorage[exivaTargetSwitch].enabled then return end
  if LastExivaMode == "manual" and not warStorage[xExivaSwitch].enabled then return end

  local targetPos = nil

  -- prioridade: alvo real visível
  local realTarget = getPlayerByNameSafe(LastAnimName)
  if realTarget and realTarget:getPosition() then
    targetPos = realTarget:getPosition()
  end

  -- fallback: posição virtual da direção do último exiva
  if not targetPos then
    if not VirtualTargetPos and CurrentDirection then
      refreshVirtualTarget()
    end
    targetPos = VirtualTargetPos
  end

  if not targetPos then return end
  if nowMs() - LastAnimAt < SHOOT_DELAY then return end

  LastAnimAt = nowMs()
  shootEffect(targetPos)
end)

-- =========================
-- RESET
-- =========================
if g_keyboard and g_keyboard.bindKeyDown then
  g_keyboard.bindKeyDown("Escape", function()
    warStorage.SenseTarget = false
    saveExivaChar()
    clearAnimation()
  end)
end
  
end)

lnsRunBlock("ICONES", function()
setDefaultTab("Main")

--==================================================
-- STORAGE FIXO DOS ICONES
--==================================================

storage = storage or {}
storage.LNSIconsGlobal = storage.LNSIconsGlobal or storage.lnsIconsPanel or {}
local iconsStorage = storage.LNSIconsGlobal
iconsStorage.cond_utana = nil

local function lnsIconStore(name)
  storage[name] = storage[name] or {}
  return storage[name]
end

local function lnsIconEnsureSwitch(root, key)
  root[key] = root[key] or { enabled = false }
  return root[key]
end

local function lnsIconSyncBridge()
  storage.LNSIconsBridgeGlobal = storage.LNSIconsBridgeGlobal or {}
  local bridge = storage.LNSIconsBridgeGlobal

  local attack = lnsIconStore("LNSAttackBotGlobal")
  lnsIconEnsureSwitch(attack, "comboButton")
  bridge.comboButton = attack.comboButton
  bridge.attackBotProfiles = attack.attackBotProfiles or {}
  attack.attackBotProfiles = bridge.attackBotProfiles
  bridge.playerList = attack.playerList or {}
  attack.playerList = bridge.playerList

  local healing = lnsIconStore("LNSHealingGlobal")
  lnsIconEnsureSwitch(healing, "healingButton")
  bridge.healingButton = healing.healingButton

  local conditions = lnsIconStore("LNSConditionsGlobal")
  lnsIconEnsureSwitch(conditions, "conditionsButton")
  bridge.conditionsButton = conditions.conditionsButton
  bridge.conditionsInterface = conditions.conditionsInterface or {}
  conditions.conditionsInterface = bridge.conditionsInterface

  local healFriend = lnsIconStore("LNSHealFriendGlobal")
  lnsIconEnsureSwitch(healFriend, "sioButton")
  bridge.sioButton = healFriend.sioButton

  local follow = lnsIconStore("LNSControlFollowGlobal")
  lnsIconEnsureSwitch(follow, "followButton")
  bridge.followButton = follow.followButton
  bridge.lnsFollow = follow.lnsFollow or {}
  follow.lnsFollow = bridge.lnsFollow
  bridge.follow2Panel = follow.follow2Panel or {}
  follow.follow2Panel = bridge.follow2Panel

  local eq = lnsIconStore("LNSEqManagerGlobal")
  lnsIconEnsureSwitch(eq, "eqManagerButton")
  bridge.eqManagerButton = eq.eqManagerButton

  local swap = lnsIconStore("LNSSmartSwapGlobal")
  lnsIconEnsureSwitch(swap, "swapButton")
  bridge.swapButton = swap.swapButton

  local prey = lnsIconStore("LNSAutoPreyGlobal")
  lnsIconEnsureSwitch(prey, "preyButton")
  bridge.preyButton = prey.preyButton

  local tools = lnsIconStore("LNSToolsGlobal")
  bridge.moneySystem = tools.moneySystem or {}
  tools.moneySystem = bridge.moneySystem
  bridge.utilityPanel = tools.utilityPanel or {}
  tools.utilityPanel = bridge.utilityPanel
  bridge.autoParty = tools.autoParty or {}
  tools.autoParty = bridge.autoParty
  bridge.autopartyui = tools.autoParty
  bridge.eatFoodSystem = tools.eatFoodSystem or {}
  tools.eatFoodSystem = bridge.eatFoodSystem
  bridge.eatFood = tools.eatFoodSystem
  bridge.staminaUse = tools.staminaUse or {}
  tools.staminaUse = bridge.staminaUse
  bridge.warnDiscord = tools.warnDiscord or {}
  tools.warnDiscord = bridge.warnDiscord

  local war = lnsIconStore("LNSWarGlobal")
  lnsIconEnsureSwitch(war, "comboLeaderButton")
  bridge.comboLeaderButton = war.comboLeaderButton
  bridge.comboLeaderPanel = war.comboLeaderPanel or {}
  war.comboLeaderPanel = bridge.comboLeaderPanel
  bridge.holdMwWgPanel = war.holdMwWgPanel or {}
  war.holdMwWgPanel = bridge.holdMwWgPanel
  bridge.pvpSystem = war.pvpSystem or {}
  war.pvpSystem = bridge.pvpSystem
  lnsIconEnsureSwitch(war, "dropFlorButton")
  bridge.dropFlorButton = war.dropFlorButton
  lnsIconEnsureSwitch(war, "AntiPushButton")
  bridge.AntiPushButton = war.AntiPushButton
  lnsIconEnsureSwitch(war, "PickUpButton")
  bridge.PickUpButton = war.PickUpButton
  lnsIconEnsureSwitch(war, "pushAllButton")
  bridge.pushAllButton = war.pushAllButton
  bridge.lnsFullTank = war.lnsFullTank or { enabled = false }
  war.lnsFullTank = bridge.lnsFullTank
  lnsIconEnsureSwitch(war, "exivaTargetSwitch")
  bridge.exivaTargetSwitch = war.exivaTargetSwitch
  lnsIconEnsureSwitch(war, "xExivaSwitch")
  bridge.xExivaSwitch = war.xExivaSwitch

  local scroll = lnsIconStore("LNSImbueScrollGlobal")
  bridge.scrollImbue = scroll

  local imb = lnsIconStore("LNSImbuementsGlobal")
  bridge.autoImbuement = imb.autoImbuement or {}
  imb.autoImbuement = bridge.autoImbuement

  return bridge
end

local lnsIconsBridgeStorage = lnsIconSyncBridge()

--==================================================
-- HELPERS BASE
--==================================================

local function later(ms, fn)
  if type(schedule) == "function" then return schedule(ms, fn) end
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then return g_dispatcher:scheduleEvent(fn, ms) end
  return fn()
end

local function lnsIsMobile()
  if g_app and type(g_app.isMobile) == "function" then
    local ok, res = pcall(function() return g_app.isMobile() end)
    return ok and res == true
  end
  return false
end

local function clamp(v, a, b)
  v = tonumber(v) or 0
  if v < a then return a end
  if v > b then return b end
  return v
end

local function pctTo01(v)
  return clamp(v, 0, 100) / 100
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function getConfigNameSafe()
  local botPanel = modules.game_bot and modules.game_bot.contentsPanel
  local config = botPanel and botPanel.config and botPanel.config:getCurrentOption()
  return (config and config.text) or "default"
end

local MyConfigName = getConfigNameSafe()

local function saveIcons()
  storage.LNSIconsGlobal = iconsStorage
end

local function getItemId(widget)
  if widget and widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and tonumber(id) then return tonumber(id) end
  end

  if widget and widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and tonumber(id) then return tonumber(id) end
    end
  end

  return 0
end

local function setBotItemId(widget, itemId)
  if not widget then return end
  itemId = tonumber(itemId) or 0

  if widget.setItemId then
    widget:setItemId(itemId)
    return
  end

  if widget.setItem and Item and Item.create then
    if itemId > 0 then
      widget:setItem(Item.create(itemId, 1))
    else
      pcall(function() widget:setItem(nil) end)
    end
  end
end

local function applyIconItem(icon, itemId)
  if not icon or not icon.item then return end
  itemId = tonumber(itemId) or 0

  if icon.creature and icon.creature.setVisible then
    icon.creature:setVisible(false)
  end

  if icon.item.setVisible then
    icon.item:setVisible(true)
  end

  if icon.item.setItemId then
    icon.item:setItemId(itemId)
    return
  end

  if icon.item.setItem and Item and Item.create then
    if itemId > 0 then
      icon.item:setItem(Item.create(itemId, 1))
    else
      pcall(function() icon.item:setItem(nil) end)
    end
  end
end

local function applyRelativePos(widget, st)
  if not widget or not st then return end

  local parent = widget:getParent()
  if not parent then return end

  local r = parent:getRect()
  local w = r.width - widget:getWidth()
  local h = r.height - widget:getHeight()

  local x = pctTo01(st.x or 0)
  local y = pctTo01(st.y or 0)

  widget:setMarginLeft(w * (-0.5 + x))
  widget:setMarginTop(math.max(h * (-0.5) - parent:getMarginTop(), h * (-0.5 + y)))
end

--==================================================
-- PAINEL
--==================================================

iconesInterface = setupUI([=[
iconesRow < Panel
  height: 43
  margin-top: 2
  margin-left: 3
  margin-right: 3
  border: 1 #696969

  BotItem
    id: itemIcone
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5

  Button
    id: listaIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 20
    text: L
    tooltip: Lista de items

  TextEdit
    id: textIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 90

  Label
    id: lblX
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 10
    width: 14
    color: #d7c08a
    text: X:

  BotTextEdit
    id: editX
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    width: 38
    height: 22
    text-align: center
    color: white
    text: 0

  Label
    id: lblY
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 3
    width: 14
    color: #d7c08a
    text: Y:

  BotTextEdit
    id: editY
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    width: 38
    height: 22
    text-align: center
    color: white
    text: 0

  BotSwitch
    id: ativarIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    margin-top: -1
    height: 22
    width: 38
    image-source: ""
    font: verdana-11px-rounded
    $on:
      text: HIDE
      color: red
    $!on:
      text: SHOW
      color: green

MainWindow
  id: mainPanel
  size: 367 400
  text: Panel Icones
  margin-top: -50

  Label
    text: Search Icones:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    margin-left: -5
    text-auto-resize: true

  TextEdit
    id: pesquisaIcons
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: parent.right
    margin-right: -5
    margin-top: 2
    placeholder: Search icon name
    phantom: true

  FlatPanel
    id: flatp
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: closePanel.top
    margin-bottom: 5
    margin-top: 8

    TextList
      id: lista
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin: 3
      margin-right: 16
      vertical-scrollbar: scrollLista

    VerticalScrollBar
      id: scrollLista
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      width: 13
      margin-top: 3
      margin-bottom: 3
      margin-right: 3
      step: 43
      pixels-scroll: true
      visible: true

  Button
    id: closePanel
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 20
    margin-left: -5
    margin-right: -5
    margin-bottom: -2
    text: Close

]=], g_ui.getRootWidget())

iconesInterface:hide()

if modules._G.g_app.isMobile() then
  equipInterface:setSize("367 420")
end

local buticon = addButton("", "Icones", function()
  iconesInterface:show()
  iconesInterface:raise()
  iconesInterface:focus()
end)
buticon:setMarginTop(0)

iconesInterface.closePanel.onClick = function()
  iconesInterface:hide()
end

--==================================================
-- LISTA DE ITEMS COM PESQUISA POR NOME / ID
--==================================================

local idPicker = {
  win = nil,
  itemList = nil,
  pageLabel = nil,
  btnBack = nil,
  btnNext = nil,
  btnClose = nil,
  searchEdit = nil,
  target = nil,
  lootList = {},
  filteredList = {},
  itemIndex = 1,
  pageSize = 104,
  query = ""
}

local function safeRead(path)
  if not g_resources or type(g_resources.readFileContents) ~= "function" then return nil end
  local ok, content = pcall(function() return g_resources.readFileContents(path) end)
  if not ok or not content or content == "" then return nil end
  return content
end

local function loadLootItems()
  local content =
    safeRead("/bot/" .. MyConfigName .. "/loot_items.lua") or
    safeRead("/bot/" .. MyConfigName .. "/loot_items") or
    safeRead("loot_items.lua")

  if not content then
    warn("[LNS Icones] Nao achei loot_items.lua em /bot/" .. MyConfigName .. "/")
    return {}
  end

  local list, seen = {}, {}
  for name, idStr in content:gmatch('%["(.-)"%]%s*=%s*(%d+)') do
    local id = tonumber(idStr)
    if id and not seen[id] then
      seen[id] = true
      table.insert(list, { name = tostring(name), id = id })
    end
  end

  table.sort(list, function(a, b) return normalizeText(a.name) < normalizeText(b.name) end)
  return list
end

local function pickerW(win, id)
  if win and win.recursiveGetChildById then return win:recursiveGetChildById(id) end
  if win and win.getChildById then return win:getChildById(id) end
  return nil
end

local function refreshPickerFilter()
  local q = normalizeText(idPicker.query)
  idPicker.filteredList = {}

  for _, it in ipairs(idPicker.lootList or {}) do
    local n = normalizeText(it.name)
    local sid = tostring(it.id or "")
    if q == "" or n:find(q, 1, true) or sid:find(q, 1, true) then
      table.insert(idPicker.filteredList, it)
    end
  end

  idPicker.itemIndex = 1
end

local function renderItemPicker()
  if not idPicker.itemList then return end
  idPicker.itemList:destroyChildren()

  local list = idPicker.filteredList or {}
  local total = #list

  if total == 0 then
    if idPicker.pageLabel then idPicker.pageLabel:setText("0/0") end
    return
  end

  if idPicker.itemIndex < 1 then idPicker.itemIndex = 1 end
  if idPicker.itemIndex > total then idPicker.itemIndex = total end

  local toIndex = idPicker.itemIndex + idPicker.pageSize - 1
  if toIndex > total then toIndex = total end

  for i = idPicker.itemIndex, toIndex do
    local entry = list[i]
    if entry then
      local w = UI.createWidget("LnsIconItemPickerEntry", idPicker.itemList)
      w.item:setSize({ width = 50, height = 50 })
      w.item:setItemId(entry.id)
      w.item:setTooltip(tostring(entry.name or "") .. " (" .. tostring(entry.id) .. ")")

      w.onDoubleClick = function()
        local t = idPicker.target
        if not t or not t.key then return end

        iconsStorage[t.key].itemId = tonumber(entry.id) or 0

        if t.row and t.row.itemIcone then
          setBotItemId(t.row.itemIcone, iconsStorage[t.key].itemId)
        end

        saveIcons()
        updateIcon(t.key)

        if idPicker.win then idPicker.win:hide() end
      end
    end
  end

  if idPicker.pageLabel then
    idPicker.pageLabel:setText(idPicker.itemIndex .. " - " .. toIndex .. " / " .. total)
  end
end

local function buildItemPickerUI()
  if idPicker.win then return end

  g_ui.loadUIFromString([[
LnsIconItemPickerWindow < MainWindow
  size: 685 520
  anchors.centerIn: parent
  margin-top: -60
  text: Panel Select Icone x Item
  @onEscape: self:hide()

  TextEdit
    id: searchItem
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    margin-left: 0
    margin-right: 0
    height: 22
    placeholder: Search item by name or ID
    phantom: true

  Panel
    id: itemList
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    anchors.bottom: separator.top
    margin-left: -5
    margin-top: 5
    layout:
      type: grid
      cell-size: 50 50
      flow: true

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 45

  Button
    id: backButton
    !text: tr('Previous')
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-left: 0
    margin-top: 4
    width: 200

  Label
    id: page
    text: 0/0
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.left: prev.right
    anchors.top: prev.top
    width: 220
    margin-top: 2
    font: terminus-14px-bold
    text-align: center

  Button
    id: nextButton
    !text: tr('Next')
    margin-right: 0
    anchors.left: page.right
    anchors.top: backButton.top
    margin-top: 0
    width: 200

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    text: Close

LnsIconItemPickerEntry < UIWidget
  size: 40 40
  margin-left: 6
  margin-top: 0

  Item
    id: item
    size: 20 20
    phantom: false
    anchors.top: parent.top
    anchors.left: parent.left
    padding: 5
    border: 1 alpha
    $hover:
      border: 1 white
  ]])

  idPicker.win = UI.createWindow("LnsIconItemPickerWindow", g_ui.getRootWidget())
  idPicker.win:hide()

  idPicker.itemList = pickerW(idPicker.win, "itemList")
  idPicker.pageLabel = pickerW(idPicker.win, "page")
  idPicker.btnBack = pickerW(idPicker.win, "backButton")
  idPicker.btnNext = pickerW(idPicker.win, "nextButton")
  idPicker.btnClose = pickerW(idPicker.win, "closePanel")
  idPicker.searchEdit = pickerW(idPicker.win, "searchItem")

  if idPicker.btnClose then
    idPicker.btnClose.onClick = function()
      idPicker.win:hide()
    end
  end

  if idPicker.searchEdit then
    idPicker.searchEdit.onTextChange = function(_, text)
      idPicker.query = tostring(text or "")
      refreshPickerFilter()
      renderItemPicker()
    end
  end

  if idPicker.btnBack then
    idPicker.btnBack.onClick = function()
      idPicker.itemIndex = idPicker.itemIndex - idPicker.pageSize
      if idPicker.itemIndex < 1 then idPicker.itemIndex = 1 end
      renderItemPicker()
    end
  end

  if idPicker.btnNext then
    idPicker.btnNext.onClick = function()
      local total = #(idPicker.filteredList or {})
      idPicker.itemIndex = idPicker.itemIndex + idPicker.pageSize
      if idPicker.itemIndex > total then idPicker.itemIndex = total end
      renderItemPicker()
    end
  end
end

local function openItemPicker(key, row)
  buildItemPickerUI()
  idPicker.target = { key = key, row = row }
  idPicker.lootList = loadLootItems()
  idPicker.query = ""

  if idPicker.searchEdit then
    idPicker.searchEdit:setText("")
  end

  refreshPickerFilter()

  if idPicker.win then
    idPicker.win:show()
    idPicker.win:raise()
    idPicker.win:focus()
  end

  renderItemPicker()
end

--==================================================
-- CORE ICONES
--==================================================

local LNS_ICON = {
  icons = {},
  rows = {}
}

function updateIcon(key)
  local pack = LNS_ICON.icons[key]
  if not pack or not pack.icon then return end

  local st = iconsStorage[key]
  local def = pack.def
  local icon = pack.icon
  if not st then return end

  applyIconItem(icon, st.itemId)

  if icon.text then
    icon.text:setText(st.text or def.text or key)
    icon.text:setFont(def.font or "verdana-9px")
    icon.text:setColor("white")
  end

  icon.onMousePress = function(widget, mousePos, button)
    return true
  end

  icon.onMouseRelease = function(widget, mousePos, button)
    return true
  end

  if icon.status then
    icon.status:show()
    local ok, state = false, false
    if def.getState then
      ok, state = pcall(def.getState)
    end
    icon.status:setOn(ok and state == true)
  end

  if lnsIsMobile() then
    icon:setSize('50 50')
  else
    icon:setSize('65 50')
  end
  
  icon:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
  icon:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)

  applyRelativePos(icon, st)

  if st.show == true then
    icon:show()
    icon:raise()
  else
    icon:hide()
  end
end

local function createIcon(key)
  local pack = LNS_ICON.icons[key]
  if not pack then return end

  if pack.icon then
    updateIcon(key)
    return
  end

  local panel = modules.game_interface.gameMapPanel
  if not panel then
    warn("LNS ICON: gameMapPanel nao encontrado.")
    return
  end

  local icon = g_ui.createWidget("BotIcon", panel)
  icon.botWidget = true
  icon.botIcon = true

  icon.onDragEnter = function(widget, mousePos)
    if not modules.corelib.g_keyboard.isCtrlPressed() then return false end

    widget:breakAnchors()
    widget.movingReference = {
      x = mousePos.x - widget:getX(),
      y = mousePos.y - widget:getY()
    }

    return true
  end

  icon.onDragMove = function(widget, mousePos)
    local parent = widget:getParent()
    if not parent or not widget.movingReference then return false end

    local pr = parent:getRect()
    local x = mousePos.x - widget.movingReference.x
    local y = mousePos.y - widget.movingReference.y

    x = clamp(x, pr.x, pr.x + pr.width - widget:getWidth())
    y = clamp(y, pr.y - parent:getMarginTop(), pr.y + pr.height - widget:getHeight())

    widget:move(x, y)
    return true
  end

  icon.onDragLeave = function(widget)
    local st = iconsStorage[key]
    local row = LNS_ICON.rows[key]
    local parent = widget:getParent()
    if not st or not parent then return true end

    local pr = parent:getRect()
    local x = widget:getX() - pr.x
    local y = widget:getY() - pr.y
    local width = pr.width - widget:getWidth()
    local height = pr.height - widget:getHeight()

    st.x = math.floor(clamp((x / math.max(1, width)) * 100, 0, 100) + 0.5)
    st.y = math.floor(clamp((y / math.max(1, height)) * 100, 0, 100) + 0.5)

    widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    applyRelativePos(widget, st)

    if row then
      row.editX._lnsBlock = true
      row.editY._lnsBlock = true
      row.editX:setText(tostring(st.x))
      row.editY:setText(tostring(st.y))
      row.editX._lnsBlock = false
      row.editY._lnsBlock = false
    end

    saveIcons()
    return true
  end

  icon.onClick = function()
    if pack.def and pack.def.onClick then
      pcall(pack.def.onClick)
    end
    updateIcon(key)
  end

  icon.onGeometryChange = function(widget)
    if widget:isDragging() then return end
    local st = iconsStorage[key]
    if st then applyRelativePos(widget, st) end
  end

  pack.icon = icon
  updateIcon(key)
end

local function bindRow(key, row)
  local pack = LNS_ICON.icons[key]
  local def = pack.def
  local st = iconsStorage[key]

  setBotItemId(row.itemIcone, tonumber(st.itemId) or def.itemId or 3555)
  row.textIcone:setText(st.text or def.text or key)
  row.editX:setText(tostring(st.x or 0))
  row.editY:setText(tostring(st.y or 0))
  row.ativarIcone:setOn(st.show == true)

  row.listaIcone.onClick = function()
    openItemPicker(key, row)
  end

  row.itemIcone.onItemChange = function(widget)
    local id = getItemId(widget)
    if id <= 0 then return end

    st.itemId = id
    saveIcons()
    updateIcon(key)
  end

  row.itemIcone.onItemIdChange = row.itemIcone.onItemChange

  row.textIcone.onTextChange = function(_, text)
    st.text = tostring(text or "")
    saveIcons()
    updateIcon(key)
  end

  row.editX.onTextChange = function(w, text)
    if w._lnsBlock then return end
    local n = tonumber(text)
    if not n then return end
    st.x = clamp(n, 0, 100)
    saveIcons()
    updateIcon(key)
  end

  row.editY.onTextChange = function(w, text)
    if w._lnsBlock then return end
    local n = tonumber(text)
    if not n then return end
    st.y = clamp(n, 0, 100)
    saveIcons()
    updateIcon(key)
  end

  row.ativarIcone.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    st.show = state == true
    saveIcons()
    createIcon(key)
    updateIcon(key)
  end
end

local function registerIcon(def)
  local key = def.key
  if not key then return end

  iconsStorage[key] = iconsStorage[key] or {
    show = def.show == true,
    itemId = def.itemId or 3555,
    text = def.text or key,
    x = def.x or 0,
    y = def.y or 0
  }

  local st = iconsStorage[key]
  st.x = clamp(st.x or 0, 0, 100)
  st.y = clamp(st.y or 0, 0, 100)
  st.itemId = tonumber(st.itemId) or def.itemId or 3555
  st.text = st.text or def.text or key
  st.show = st.show == true

  LNS_ICON.icons[key] = {
    def = def,
    icon = nil
  }

  local row = g_ui.createWidget("iconesRow", iconesInterface.flatp.lista)
  row:setId("row_" .. key)

  LNS_ICON.rows[key] = row

  bindRow(key, row)
  createIcon(key)
  saveIcons()
end

local function updateAllIcons()
  for key in pairs(LNS_ICON.icons) do
    updateIcon(key)
  end
end

--==================================================
-- AUTO ICONS MODEL
--==================================================

local boundStates = {}

local function callSave(saveFn)
  if type(saveFn) == "function" then
    pcall(saveFn)
  elseif type(saveIcons) == "function" and type(lnsIconsBridgeStorage) == "table" then
    pcall(function() saveIcons(lnsIconsBridgeStorage) end)
  end
  saveIcons()
end

local function isToggleWidget(toggle)
  local t = type(toggle)
  return t == "table" or t == "userdata"
end

local function getToggle(def)
  if type(def.getButton) ~= "function" then return nil end
  local ok, res = pcall(def.getButton)
  if ok and isToggleWidget(res) then return res end
  return nil
end

local function readToggle(toggle)
  if not isToggleWidget(toggle) then return nil end

  if toggle.isOn then
    local ok, res = pcall(function() return toggle:isOn() end)
    if ok then return res == true end
  end

  if toggle.isChecked then
    local ok, res = pcall(function() return toggle:isChecked() end)
    if ok then return res == true end
  end

  return nil
end

local function setToggle(toggle, state)
  if not isToggleWidget(toggle) then return end
  state = state == true

  if toggle.setOn then
    pcall(function() toggle:setOn(state) end)
    return
  end

  if toggle.setChecked then
    pcall(function() toggle:setChecked(state) end)
    return
  end
end

local function safeStoreTable(store)
  lnsIconsBridgeStorage = lnsIconSyncBridge()
  if type(store) == "table" then return store end
  if type(lnsIconsBridgeStorage) == "table" then return lnsIconsBridgeStorage end
  return storage
end

local function readStorage(def)
  local store = safeStoreTable(type(def.store) == "function" and def.store() or nil)
  local key = def.storageKey or def.switch or def.button or def.key

  if type(store[key]) == "table" then
    if store[key].enabled ~= nil then return store[key].enabled == true end
    if store[key].active ~= nil then return store[key].active == true end
    if store[key].isOn ~= nil then return store[key].isOn == true end
    if store[key].value ~= nil then return store[key].value == true end
    return false
  end

  return store[key] == true
end

local function writeStorage(def, state)
  local store = safeStoreTable(type(def.store) == "function" and def.store() or nil)
  local key = def.storageKey or def.switch or def.button or def.key
  state = state == true

  if type(store[key]) == "table" then
    if store[key].enabled ~= nil then
      store[key].enabled = state
    elseif store[key].active ~= nil then
      store[key].active = state
    elseif store[key].isOn ~= nil then
      store[key].isOn = state
    elseif store[key].value ~= nil then
      store[key].value = state
    else
      store[key].enabled = state
    end
  else
    store[key] = state
  end
end

local function readState(def)
  if type(def.read) == "function" then
    local ok, res = pcall(def.read)
    if ok and res ~= nil then return res == true end
  end

  local toggle = getToggle(def)
  local tState = readToggle(toggle)
  if tState ~= nil then return tState end

  return readStorage(def)
end

local function applyVisual(def, state, toggle)
  boundStates[def.key] = state == true
  setToggle(toggle, state)

  local pack = LNS_ICON.icons[def.key]
  local icon = pack and pack.icon

  if icon and icon.status then
    icon.status:show()
    icon.status:setOn(state == true)
  end

  callSave(def.save)
end

local function setState(def, state, toggle)
  state = state == true

  if type(def.write) == "function" then
    pcall(def.write, state)
  else
    writeStorage(def, state)
  end

  applyVisual(def, state, toggle)
end

local function clickRealButton(def, toggle)
  if not isToggleWidget(toggle) then
    setState(def, not readState(def), nil)
    return
  end

  if type(toggle.onClick) == "function" then
    pcall(toggle.onClick, toggle)
  else
    local current = readToggle(toggle)
    setToggle(toggle, not (current == true))
  end

  local state = readToggle(toggle)
  if state == nil then
    state = readState(def)
  end

  if type(def.write) == "function" then
    pcall(def.write, state == true)
  else
    writeStorage(def, state == true)
  end

  applyVisual(def, state == true, toggle)
end

local function makeAutoIcon(def)
  return {
    key = def.key,
    itemId = def.itemId or 3555,
    text = def.text or def.key,
    font = def.font or "verdana-9px",
    x = def.x or 0,
    y = def.y or 0,
    show = def.show == true,

    getState = function()
      return readState(def)
    end,

    onClick = function()
      clickRealButton(def, getToggle(def))
    end,

    _autoBind = def
  }
end

local function bindAutoIcon(def)
  local tries = 0
  local maxTries = 200
  local lock = false

  local function tryBind()
    tries = tries + 1

    local pack = LNS_ICON.icons[def.key]
    local icon = pack and pack.icon
    local toggle = getToggle(def)

    if not icon then
      if tries < maxTries then later(100, tryBind) end
      return
    end

    applyVisual(def, readState(def), toggle)

    if isToggleWidget(toggle) then
      local oldClick = toggle.onClick

      toggle.onClick = function(widget, ...)
        if lock then return end
        lock = true

        if type(oldClick) == "function" then
          pcall(oldClick, widget, ...)
        else
          local current = readToggle(widget)
          setToggle(widget, not (current == true))
        end

        local state = readToggle(widget)
        if state == nil then state = readState(def) end

        applyVisual(def, state == true, widget)

        lock = false
      end
    end

    icon.onClick = function()
      if lock then return end

      clickRealButton(def, getToggle(def))
      updateIcon(def.key)
    end
  end

  tryBind()
end

--==================================================
-- HELPERS CONDITIONS
--==================================================

local function getConditionsSwitch(id)
  if not conditionsInterface then return nil end
  if conditionsInterface.recursiveGetChildById then
    return conditionsInterface:recursiveGetChildById(id)
  end
  return nil
end

local function readConditionSwitch(id)
  if type(lnsIconsBridgeStorage) ~= "table" then return false end
  lnsIconsBridgeStorage.conditionsInterface = lnsIconsBridgeStorage.conditionsInterface or {}
  lnsIconsBridgeStorage.conditionsInterface.switches = lnsIconsBridgeStorage.conditionsInterface.switches or {}
  return lnsIconsBridgeStorage.conditionsInterface.switches[id] == true
end

local function writeConditionSwitch(id, state)
  if type(lnsIconsBridgeStorage) ~= "table" then return end
  lnsIconsBridgeStorage.conditionsInterface = lnsIconsBridgeStorage.conditionsInterface or {}
  lnsIconsBridgeStorage.conditionsInterface.switches = lnsIconsBridgeStorage.conditionsInterface.switches or {}
  lnsIconsBridgeStorage.conditionsInterface.switches[id] = state == true
end

local function saveConditionsIcon()
  if type(saveConditionsChar) == "function" then
    saveConditionsChar()
  elseif type(saveIcons) == "function" and type(lnsIconsBridgeStorage) == "table" then
    saveIcons(lnsIconsBridgeStorage)
  end
end

--==================================================
-- AUTO_ICONS
--==================================================

local function getFoodRecoveryConfig(foodType)
  warStorage = warStorage or {}
  warStorage.foodRecovery = warStorage.foodRecovery or {}

  local defaultItem = foodType == "hp" and 28485 or 28484

  warStorage.foodRecovery[foodType] = warStorage.foodRecovery[foodType] or {
    enabled = false,
    item = defaultItem,
    percent = 15
  }

  local config = warStorage.foodRecovery[foodType]
  config.enabled = config.enabled == true
  config.item = tonumber(config.item) or defaultItem
  config.percent = tonumber(config.percent) or 15

  return config
end

local function saveFoodRecoveryIcon()
  if type(saveThisWarStorage) == "function" then
    saveThisWarStorage()
  elseif type(saveWarGlobal) == "function" then
    saveWarGlobal()
  end
end

local AUTO_ICONS = {
  {
    key = "attackbot",
    storageKey = "comboButton",
    itemId = 3555,
    text = "ATK",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return comboButton and comboButton.title end,
    save = function() if type(saveAttackBotChar) == "function" then saveAttackBotChar() end end
  },

  {
    key = "attackbot_antired_full",
    itemId = 37339,
    text = "ANTI-RED FULL",
    show = false,

    read = function()
      local function isOn(widget)
        if not widget then return false end

        if widget.isOn then
          local ok, res = pcall(function() return widget:isOn() end)
          if ok then return res == true end
        end

        if widget.isChecked then
          local ok, res = pcall(function() return widget:isChecked() end)
          if ok then return res == true end
        end

        return false
      end

      local exitFragsWidget =
        (comboInterface and comboInterface.deslogarFrags) or
        (panelSpellsUnsafe and panelSpellsUnsafe.deslogarFrags)

      return isOn(comboInterface and comboInterface.manterDist)
        and isOn(comboInterface and comboInterface.checkPlayers)
        and isOn(comboInterface and comboInterface.checkFloors)
        and isOn(comboInterface and comboInterface.checkStairs)
        and isOn(exitFragsWidget)
    end,

    write = function(state)
      state = state == true

      local function isOn(widget)
        if not widget then return false end

        if widget.isOn then
          local ok, res = pcall(function() return widget:isOn() end)
          if ok then return res == true end
        end

        if widget.isChecked then
          local ok, res = pcall(function() return widget:isChecked() end)
          if ok then return res == true end
        end

        return false
      end

      local function setWanted(widget, wanted)
        if not widget then return false end
        if isOn(widget) == wanted then return true end

        if type(widget.onClick) == "function" then
          pcall(widget.onClick, widget)
          return true
        end

        if widget.setOn then
          pcall(function() widget:setOn(wanted) end)
          return true
        end

        if widget.setChecked then
          pcall(function() widget:setChecked(wanted) end)
          return true
        end

        return false
      end

      local exitFragsWidget =
        (comboInterface and comboInterface.deslogarFrags) or
        (panelSpellsUnsafe and panelSpellsUnsafe.deslogarFrags)

      local ok = true
      ok = setWanted(comboInterface and comboInterface.manterDist, state) and ok
      ok = setWanted(comboInterface and comboInterface.checkPlayers, state) and ok
      ok = setWanted(comboInterface and comboInterface.checkFloors, state) and ok
      ok = setWanted(comboInterface and comboInterface.checkStairs, state) and ok
      ok = setWanted(exitFragsWidget, state) and ok

      if not ok then
        warn("[Icon ANTI-RED FULL] Carregue o AttackBot antes dos icones ou abra o painel do AttackBot uma vez.")
      end

      if type(saveAttackBotChar) == "function" then
        saveAttackBotChar()
      elseif type(saveIcons) == "function" and type(lnsIconsBridgeStorage) == "table" then
        saveIcons(lnsIconsBridgeStorage)
      end
    end,

    save = function()
      if type(saveAttackBotChar) == "function" then
        saveAttackBotChar()
      elseif type(saveIcons) == "function" and type(lnsIconsBridgeStorage) == "table" then
        saveIcons(lnsIconsBridgeStorage)
      end
    end
  },

  {
    key = "healing",
    storageKey = "healingButton",
    itemId = 7643,
    text = "HEALING",
    store = function()
      if type(lnsIconsBridgeStorage) == "table" and lnsIconsBridgeStorage.healingButton ~= nil then return lnsIconsBridgeStorage end
      return storage
    end,
    getButton = function() return healingButton and healingButton.title end,
    save = function() if type(saveHealingChar) == "function" then saveHealingChar() end end
  },

  {
    key = "conditions",
    storageKey = "conditionsButton",
    itemId = 4115,
    text = "CONDITIONS",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return conditionsButton and conditionsButton.title end,
    save = function() if type(saveConditionsChar) == "function" then saveConditionsChar() end end
  },

  {
    key = "cond_haste",
    itemId = 3079,
    text = "HASTE",
    show = false,
    read = function() return readConditionSwitch("ativadorHaste") end,
    write = function(state) writeConditionSwitch("ativadorHaste", state) end,
    getButton = function() return getConditionsSwitch("ativadorHaste") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_buff",
    itemId = 3411,
    text = "BUFF",
    show = false,
    read = function() return readConditionSwitch("ativadorBuff") end,
    write = function(state) writeConditionSwitch("ativadorBuff", state) end,
    getButton = function() return getConditionsSwitch("ativadorBuff") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_antilyze",
    itemId = 3160,
    text = "ANTI LYZE",
    show = false,
    read = function() return readConditionSwitch("ativadorAntiLyze") end,
    write = function(state) writeConditionSwitch("ativadorAntiLyze", state) end,
    getButton = function() return getConditionsSwitch("ativadorAntiLyze") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_utura",
    itemId = 3160,
    text = "UTURA",
    show = false,
    read = function() return readConditionSwitch("ativadorUtura") end,
    write = function(state) writeConditionSwitch("ativadorUtura", state) end,
    getButton = function() return getConditionsSwitch("ativadorUtura") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_utamo",
    itemId = 3051,
    text = "UTAMO",
    show = false,
    read = function() return readConditionSwitch("ativadorUtamo") end,
    write = function(state) writeConditionSwitch("ativadorUtamo", state) end,
    getButton = function() return getConditionsSwitch("ativadorUtamo") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_cure_status",
    itemId = 3153,
    text = "CURE",
    show = false,
    read = function() return readConditionSwitch("ativadorCureStatus") end,
    write = function(state) writeConditionSwitch("ativadorCureStatus", state) end,
    getButton = function() return getConditionsSwitch("ativadorCureStatus") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_spell_swap",
    itemId = 3160,
    text = "SPELL SWAP",
    show = false,
    read = function() return readConditionSwitch("ativadorSpellSwap") end,
    write = function(state) writeConditionSwitch("ativadorSpellSwap", state) end,
    getButton = function() return getConditionsSwitch("ativadorSpellSwap") end,
    save = saveConditionsIcon
  },

  {
    key = "healingfriend",
    storageKey = "sioButton",
    itemId = 3160,
    text = "HEALFRIEND",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return sioButton and sioButton.title end,
    save = function() if type(saveHealFriendChar) == "function" then saveHealFriendChar() end end
  },

  {
    key = "follow",
    storageKey = "followButton",
    itemId = 10798,
    text = "FOLLOW",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return followButton and followButton.title end,
    save = function() if type(saveFollow2) == "function" then saveFollow2() end end
  },

  {
    key = "eqmanager",
    storageKey = "eqManagerButton",
    itemId = 28719,
    text = "EQ MANAGER",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return eqManagerButton and eqManagerButton.title end,
    save = function() if type(saveEqManagerChar) == "function" then saveEqManagerChar() end end
  },

  {
    key = "swap",
    storageKey = "swapButton",
    itemId = 3081,
    text = "SWAP",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return swapButton and swapButton.title end,
    save = function() if type(saveSmartSwapChar) == "function" then saveSmartSwapChar() end end
  },

    {
    key = "swap_ring_1",
    itemId = 3007,
    text = "SWAP RING",
    read = function()
      return type(lnsGetSmartSwapPreset) == "function" and lnsGetSmartSwapPreset("ring", 1) or false
    end,
    write = function(state)
      if type(lnsSetSmartSwapPreset) == "function" then
        lnsSetSmartSwapPreset("ring", state and 1 or 0)
      end
    end
  },

  {
    key = "swap_ring_2",
    itemId = 3007,
    text = "TRIPLE RING",
    read = function()
      return type(lnsGetSmartSwapPreset) == "function" and lnsGetSmartSwapPreset("ring", 2) or false
    end,
    write = function(state)
      if type(lnsSetSmartSwapPreset) == "function" then
        lnsSetSmartSwapPreset("ring", state and 2 or 0)
      end
    end
  },

  {
    key = "swap_ring_3",
    itemId = 3007,
    text = "FULL RINGS",
    read = function()
      return type(lnsGetSmartSwapPreset) == "function" and lnsGetSmartSwapPreset("ring", 3) or false
    end,
    write = function(state)
      if type(lnsSetSmartSwapPreset) == "function" then
        lnsSetSmartSwapPreset("ring", state and 3 or 0)
      end
    end
  },

  {
    key = "swap_amulet_1",
    itemId = 3081,
    text = "SWAP AMULET",
    read = function()
      return type(lnsGetSmartSwapPreset) == "function" and lnsGetSmartSwapPreset("amulet", 1) or false
    end,
    write = function(state)
      if type(lnsSetSmartSwapPreset) == "function" then
        lnsSetSmartSwapPreset("amulet", state and 1 or 0)
      end
    end
  },

  {
    key = "swap_amulet_2",
    itemId = 3081,
    text = "TRIPLE AMULET",
    read = function()
      return type(lnsGetSmartSwapPreset) == "function" and lnsGetSmartSwapPreset("amulet", 2) or false
    end,
    write = function(state)
      if type(lnsSetSmartSwapPreset) == "function" then
        lnsSetSmartSwapPreset("amulet", state and 2 or 0)
      end
    end
  },

  {
    key = "swap_amulet_3",
    itemId = 3081,
    text = "FULL AMULETS",
    read = function()
      return type(lnsGetSmartSwapPreset) == "function" and lnsGetSmartSwapPreset("amulet", 3) or false
    end,
    write = function(state)
      if type(lnsSetSmartSwapPreset) == "function" then
        lnsSetSmartSwapPreset("amulet", state and 3 or 0)
      end
    end
  },
  
  {
    key = "prey",
    storageKey = "preyButton",
    itemId = 9056,
    text = "AUTO PREY",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return preyButton and preyButton.title end,
    save = function() if type(savePreyChar) == "function" then savePreyChar() end end
  },

  {
    key = "money",
    storageKey = "exchangeButton",
    itemId = 3043,
    text = "EXCHANGE",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return exchangeButton and exchangeButton.exchangeMoney end,
    save = function() if type(saveMoneyTrade) == "function" then saveMoneyTrade() end end
  },

  {
    key = "trade",
    itemId = 3232,
    text = "TRADE",
    read = function() return lnsIconsBridgeStorage.moneySystem and lnsIconsBridgeStorage.moneySystem.sendTrade == true end,
    write = function(state)
      lnsIconsBridgeStorage.moneySystem = lnsIconsBridgeStorage.moneySystem or {}
      lnsIconsBridgeStorage.moneySystem.sendTrade = state
    end,
    getButton = function() return sendTrade and sendTrade.title end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "dropper",
    itemId = 2526,
    text = "DROPPER",
    read = function() return lnsIconsBridgeStorage.moneySystem and lnsIconsBridgeStorage.moneySystem.dropperEnabled == true end,
    write = function(state)
      lnsIconsBridgeStorage.moneySystem = lnsIconsBridgeStorage.moneySystem or {}
      lnsIconsBridgeStorage.moneySystem.dropperEnabled = state
    end,
    getButton = function() return dropper and dropper.title end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "autoPT",
    storageKey = "autopartyui",
    itemId = 3435,
    text = "PARTY",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return autopartyui and autopartyui.status end,
    save = function() if type(saveAutoParty) == "function" then saveAutoParty() end end
  },

  {
    key = "food",
    storageKey = "eatFood",
    itemId = 6279,
    text = "FOOD",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return eatFood and eatFood.eatFood end,
    save = function() if type(saveEatFood) == "function" then saveEatFood() end end
  },


  {
    key = "food_hp",
    itemId = 28485,
    text = "FOOD HP",
    show = false,

    read = function()
      return getFoodRecoveryConfig("hp").enabled == true
    end,

    write = function(state)
      getFoodRecoveryConfig("hp").enabled = state == true
    end,

    getButton = function()
      return foodhpPanel and foodhpPanel.title
    end,

    save = saveFoodRecoveryIcon
  },

  {
    key = "food_mp",
    itemId = 28484,
    text = "FOOD MP",
    show = false,

    read = function()
      return getFoodRecoveryConfig("mana").enabled == true
    end,

    write = function(state)
      getFoodRecoveryConfig("mana").enabled = state == true
    end,

    getButton = function()
      return foodmpPanel and foodmpPanel.title
    end,

    save = saveFoodRecoveryIcon
  },

  {
    key = "stamina",
    itemId = 11372,
    text = "STAMINA",
    read = function() return lnsIconsBridgeStorage.staminaUse and lnsIconsBridgeStorage.staminaUse.enabled == true end,
    write = function(state)
      lnsIconsBridgeStorage.staminaUse = lnsIconsBridgeStorage.staminaUse or {}
      lnsIconsBridgeStorage.staminaUse.enabled = state
    end,
    getButton = function() return stamina and stamina.staminacheck end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "comboLeader",
    storageKey = "comboLeaderButton",
    itemId = 3546,
    text = "ATK-LEADER",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return comboLeaderButton and comboLeaderButton.title end,
    save = function() if type(saveComboLeaderChar) == "function" then saveComboLeaderChar() end end
  },

  {
    key = "mwsystem",
    itemId = 10181,
    text = "MW SYSTEM",
    read = function() return lnsIconsBridgeStorage.holdMwWgPanel and lnsIconsBridgeStorage.holdMwWgPanel.enabled == true end,
    write = function(state)
      lnsIconsBridgeStorage.holdMwWgPanel = lnsIconsBridgeStorage.holdMwWgPanel or {}
      lnsIconsBridgeStorage.holdMwWgPanel.enabled = state
    end,
    getButton = function() return mwButton and mwButton.title end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "mwsystem_hold_mw_wg",
    itemId = 3180,
    text = "HOLD MW/WG",
    show = false,

    read = function()
      if LNS_MWSystem and type(LNS_MWSystem.isHoldMwWg) == "function" then
        return LNS_MWSystem.isHoldMwWg() == true
      end

      return type(lnsIconsBridgeStorage) == "table"
        and type(lnsIconsBridgeStorage.holdMwWgPanel) == "table"
        and lnsIconsBridgeStorage.holdMwWgPanel.iconHoldMwWg == true
    end,

    write = function(state)
      if LNS_MWSystem and type(LNS_MWSystem.setHoldMwWg) == "function" then
        LNS_MWSystem.setHoldMwWg(state == true)
      else
        warn("[Icon Hold MW/WG] LNS_MWSystem.setHoldMwWg nao encontrada. Carregue o MW System antes dos icones.")
      end
    end,

    save = function()
      if type(saveIcons) == "function" and type(lnsIconsBridgeStorage) == "table" then
        saveIcons(lnsIconsBridgeStorage)
      end
    end
  },

  {
    key = "mwsystem_front_click",
    itemId = 3180,
    text = "MW FRONT",
    show = false,

    -- ícone de ação: não é switch, só executa ao clicar
    read = function()
      return false
    end,

    write = function()
      if LNS_MWSystem and type(LNS_MWSystem.mwFront) == "function" then
        LNS_MWSystem.mwFront()
      else
        warn("[Icon MW Front] LNS_MWSystem.mwFront nao encontrada. Carregue o MW System antes dos icones.")
      end
    end
  },

  {
    key = "mwsystem_back_click",
    itemId = 3180,
    text = "MW BACK",
    show = false,

    -- ícone de ação: não é switch, só executa ao clicar
    read = function()
      return false
    end,

    write = function()
      if LNS_MWSystem and type(LNS_MWSystem.mwBack) == "function" then
        LNS_MWSystem.mwBack()
      else
        warn("[Icon MW Back] LNS_MWSystem.mwBack nao encontrada. Carregue o MW System antes dos icones.")
      end
    end
  },

  {
    key = "pushmax",
    itemId = 5090,
    text = "PUSHMAX",
    getButton = function() return mainUI and mainUI.switch end,
    save = function() if type(saveConfig) == "function" then saveConfig() end end
  },

  {
    key = "dropFlower",
    storageKey = "dropFlorButton",
    itemId = 2981,
    text = "DROP FLOWER",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return dropFlorButton and dropFlorButton.title end,
    save = function() if type(saveDropFlorChar) == "function" then saveDropFlorChar() end end
  },

  {
    key = "antipush",
    storageKey = "AntiPushButton",
    itemId = 3492,
    text = "ANTI PUSH",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return AntiPushButton and AntiPushButton.title end,
    save = function() if type(saveThisWarStorage) == "function" then saveThisWarStorage() end end
  },

  {
    key = "pickup",
    storageKey = "PickUpButton",
    itemId = 3217,
    text = "PICK ITEMS",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return PickUpButton and PickUpButton.title end,
    save = function() if type(savepickUp) == "function" then savepickUp() end end
  },

  {
    key = "pullall",
    storageKey = "pushAllButton",
    itemId = 34079,
    text = "PULL ITEMS",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return pushAllButton and pushAllButton.title end,
    save = function() if type(saveThisWarStorage) == "function" then saveThisWarStorage() end end
  },

  {
    key = "war_full_equip",
    itemId = 21435,
    text = "FULL EQ",

    read = function()
        return isLnsFullTankActive()
    end,

    write = function(state)
        setFullTankEnabled(state)
    end,

    save = function()
        saveFullTank()
    end
},

  {
    key = "war_double_ue_click",
    itemId = 21463,
    text = "DOUBLE UE",
    show = false,

    -- sempre falso porque esse icone nao é switch, é botao de ação
    read = function()
      return false
    end,

    -- ao clicar no icone, executa a Double UE direto
    write = function()
      if lnsDoubleUE and lnsDoubleUE.iconExecute then
        lnsDoubleUE.iconExecute()
      else
        warn("[Icon Double UE] lnsDoubleUE.iconExecute nao encontrada. Verifique se o bloco foi colado no war.lua.")
      end
    end
  },

  {
    key = "exivaTarget",
    storageKey = "exivaTargetSwitch",
    itemId = 29342,
    text = "EXIVA TARGET",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return exivaInterface and exivaInterface.exivaTarget end,
    save = function() if type(saveExivaChar) == "function" then saveExivaChar() end end
  },

  {
    key = "exivax",
    storageKey = "xExivaSwitch",
    itemId = 29343,
    text = "xEXIVA",
    store = function() return lnsIconsBridgeStorage end,
    getButton = function() return exivaInterface and exivaInterface.xExiva end,
    save = function() if type(saveExivaChar) == "function" then saveExivaChar() end end
  },

  {
    key = "targetbot",
    itemId = 3283,
    text = "TARGETBOT",
    show = false,
    read = function() return TargetBot and TargetBot.isOn and TargetBot.isOn() end,
    write = function(state)
      if not TargetBot then return end
      if state then
        if TargetBot.setOn then TargetBot.setOn() end
      else
        if TargetBot.setOff then TargetBot.setOff() end
      end
    end
  },

  {
    key = "cavebot",
    itemId = 9196,
    text = "CAVEBOT",
    show = false,
    read = function() return CaveBot and CaveBot.isOn and CaveBot.isOn() end,
    write = function(state)
      if not CaveBot then return end
      if state then
        if CaveBot.setOn then CaveBot.setOn() end
      else
        if CaveBot.setOff then CaveBot.setOff() end
      end
    end
  },

  {
    key = "chase_mode",
    itemId = 52662,
    text = "CHASE",
    show = false,

    read = function()
      return g_game.getChaseMode() == 1
    end,

    write = function(state)
      g_game.setChaseMode(state and 1 or 0)
    end
  },

  {
    key = "util_open_next_bp",
    storageKey = "proximaBp",
    itemId = 2854,
    text = "NEXT BP",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp and utilityInterface.flatp.proximaBp end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_loot_chest",
    storageKey = "LootChest",
    itemId = 19250,
    text = "LOOT CHEST",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp and utilityInterface.flatp.LootChest end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_hold_target",
    storageKey = "HoldTarget",
    itemId = 3409,
    text = "HOLD TARGET",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.HoldTarget end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_super_dash",
    storageKey = "SuperDash",
    itemId = 3079,
    text = "DASH",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.SuperDash end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_dancing",
    storageKey = "Dancing",
    itemId = 6576,
    text = "DANCING",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.Dancing end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_hold_position",
    storageKey = "HoldPosition",
    itemId = 2025,
    text = "HOLD POS",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.HoldPosition end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_sleep_mode",
    storageKey = "SleepMode",
    itemId = 694,
    text = "SLEEP",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.SleepMode end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_hide_sprites",
    storageKey = "EsconderSprites",
    itemId = 3248,
    text = "HIDE SPRITE",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.EsconderSprites end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_hide_texts",
    storageKey = "EsconderTextos",
    itemId = 3509,
    text = "HIDE TXT",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.EsconderTextos end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_auto_mount",
    storageKey = "AutoMount",
    itemId = 9196,
    text = "FULL MOUNT",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AutoMount end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_auto_ban",
    storageKey = "AutoBan",
    itemId = 3547,
    text = "BAN CAST",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AutoBan end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_auto_summon",
    storageKey = "SummonF",
    itemId = 38677,
    text = "SUMMON",
    store = function()
      lnsIconsBridgeStorage.utilityPanel = lnsIconsBridgeStorage.utilityPanel or {}
      return lnsIconsBridgeStorage.utilityPanel
    end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.SummonF
    end,
    save = function()
      if type(saveIcons) == "function" then
        saveIcons(lnsIconsBridgeStorage)
      end
    end
  },

  {
    key = "util_exeta_res",
    storageKey = "ExetaRes",
    itemId = 3077,
    text = "EXETA RES",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.ExetaRes end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_exeta_loot",
    storageKey = "ExetaLoot",
    itemId = 3031,
    text = "EXETA LOOT",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.ExetaLoot end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_amp_res",
    storageKey = "AmpRes",
    itemId = 3160,
    text = "AMP RES",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AmpRes end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_wall_hugger",
    storageKey = "WallHugger",
    itemId = 10455,
    text = "WALL HUGGER",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.WallHugger end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_auto_aol",
    storageKey = "autoAol",
    itemId = 3057,
    text = "AUTO AOL",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.autoAol end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_esconder_andares",
    storageKey = "esconderAndares",
    itemId = 20478,
    text = "HIDE FLOOR",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.esconderAndares
    end,
    save = function()
      if type(saveIcons) == "function" then
        saveIcons(lnsIconsBridgeStorage)
      end
    end
  },

  {
    key = "util_dash_mouse",
    storageKey = "dashMouse",
    itemId = 3079,
    text = "DASH MOUSE",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.dashMouse
    end,
    save = function()
      if type(saveIcons) == "function" then
        saveIcons(lnsIconsBridgeStorage)
      end
    end
  },

  {
    key = "util_utevo_lux",
    storageKey = "utevoLux",
    itemId = 3241,
    text = "UTEVO LUX",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.utevoLux end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_mana_train",
    storageKey = "manaTrain",
    itemId = 3160,
    text = "MANA TRAIN",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.manaTrain end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "util_mana_train_mage",
    storageKey = "manaTrainMage",
    itemId = 23373,
    text = "TRAIN MAGE",
    store = function() return lnsIconsBridgeStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.manaTrainMage end,
    save = function() if type(saveIcons) == "function" then saveIcons(lnsIconsBridgeStorage) end end
  },

  {
    key = "manual_imbue_all",
    itemId = 14513,
    text = "M.IMBUE",
    show = false,

    -- icone de ação, não fica ligado/desligado
    read = function()
      return false
    end,

    write = function()
      if type(startImbueAllFromList) == "function" then
        startImbueAllFromList(true)
      else
        warn("[Icon M.IMBUE] startImbueAllFromList nao encontrada. Carregue a script de Imbue antes dos icones.")
      end
    end
  },
  
  {
    key = "scroll_blank_imbue",
    itemId = 51442,
    text = "S.IMBUE",
    show = false,
    read = function()
      return type(isScrollImbueBlankActive) == "function" and isScrollImbueBlankActive() == true
    end,
    write = function(state)
      if state == true then
        if type(startScrollImbueBlank) == "function" then
          startScrollImbueBlank()
        else
          warn("[Icones] startScrollImbueBlank nao encontrada. Carregue o Imbue Scroll antes dos icones.")
        end
      else
        if type(stopScrollImbueBlank) == "function" then
          stopScrollImbueBlank()
        end
      end
    end,
    save = function()
      if type(saveIcons) == "function" and type(lnsIconsBridgeStorage) == "table" then
        saveIcons(lnsIconsBridgeStorage)
      end
    end
  },

  {
    key = "scroll_item_imbue",
    itemId = 51464,
    text = "I.SCROLL",
    show = false,
    read = function()
      if type(isScrollImbueItemsEnabled) == "function" then
        return isScrollImbueItemsEnabled() == true
      end
      return type(lnsIconsBridgeStorage) == "table"
        and type(lnsIconsBridgeStorage.scrollImbue) == "table"
        and lnsIconsBridgeStorage.scrollImbue.itemAutoEnabled == true
    end,
    write = function(state)
      if type(setScrollImbueItemsAuto) == "function" then
        setScrollImbueItemsAuto(state == true)
        return
      end

      if type(lnsIconsBridgeStorage) == "table" then
        lnsIconsBridgeStorage.scrollImbue = lnsIconsBridgeStorage.scrollImbue or {}
        lnsIconsBridgeStorage.scrollImbue.itemAutoEnabled = state == true
        if type(saveIcons) == "function" then
          saveIcons(lnsIconsBridgeStorage)
        end
      else
        warn("[Icones] setScrollImbueItemsAuto nao encontrada. Carregue o Imbue Scroll antes dos icones.")
      end
    end,
    save = function()
      if type(saveIcons) == "function" and type(lnsIconsBridgeStorage) == "table" then
        saveIcons(lnsIconsBridgeStorage)
      end
    end
  }

}

local ICON_DEFS = {}
for _, def in ipairs(AUTO_ICONS) do
  table.insert(ICON_DEFS, makeAutoIcon(def))
end

for _, def in ipairs(ICON_DEFS) do
  registerIcon(def)
end

for _, def in ipairs(AUTO_ICONS) do
  bindAutoIcon(def)
end


--==================================================
-- PUSHMAX: SETAS AO REDOR DO ICONE
--==================================================

local LNS_PUSHMAX_ARROWS = {
  widgets = {},
  size = lnsIsMobile() and 34 or 28,
  defs = {
    { id = "nw", text = "NW", dx = -1, dy = -1, ox = -54, oy = -45 },
    { id = "n",  text = "N", dx =  0, dy = -1, ox =   0, oy = -58 },
    { id = "ne", text = "NE", dx =  1, dy = -1, ox =  54, oy = -45 },
    { id = "w",  text = "W", dx = -1, dy =  0, ox = -70, oy =   0 },
    { id = "e",  text = "E", dx =  1, dy =  0, ox =  70, oy =   0 },
    { id = "sw", text = "SW", dx = -1, dy =  1, ox = -54, oy =  48 },
    { id = "s",  text = "S", dx =  0, dy =  1, ox =   0, oy =  62 },
    { id = "se", text = "SE", dx =  1, dy =  1, ox =  54, oy =  48 }
  }
}

local function pushMaxIconWidget()
  local pack = LNS_ICON.icons["pushmax"]
  return pack and pack.icon or nil
end

local function isWidgetVisible(widget)
  if not widget then return false end
  if widget.isVisible then
    local ok, res = pcall(function() return widget:isVisible() end)
    if ok then return res == true end
  end
  if widget.isHidden then
    local ok, res = pcall(function() return widget:isHidden() end)
    if ok then return res ~= true end
  end
  return true
end

local function isPushMaxEnabledForArrows()
  local st = iconsStorage["pushmax"]
  local icon = pushMaxIconWidget()

  if not st or st.show ~= true or not isWidgetVisible(icon) then
    return false
  end

  -- Se o script PushMax ja carregou, usa o botao real dele.
  local btn = mainUI and mainUI.switch
  if btn then
    if btn.isOn then
      local ok, res = pcall(function() return btn:isOn() end)
      if ok then return res == true end
    end

    if btn.isChecked then
      local ok, res = pcall(function() return btn:isChecked() end)
      if ok then return res == true end
    end
  end

  -- Fallback direto no lnsIconsBridgeStorage, caso o botao ainda nao tenha bindado.
  return type(lnsIconsBridgeStorage) == "table"
    and type(lnsIconsBridgeStorage.pvpSystem) == "table"
    and type(lnsIconsBridgeStorage.pvpSystem.pushSystem) == "table"
    and lnsIconsBridgeStorage.pvpSystem.pushSystem.enabled == true
end

local function hidePushMaxArrows()
  for _, w in pairs(LNS_PUSHMAX_ARROWS.widgets) do
    if w then pcall(function() w:hide() end) end
  end
end

if not LNS_PUSHMAX_ARROW_UI_LOADED then
  LNS_PUSHMAX_ARROW_UI_LOADED = true

  g_ui.loadUIFromString([[
LNSPushMaxArrow < UIWidget
  size: 34 34
  phantom: false
  focusable: false

  Item
    id: item
    anchors.centerIn: parent
    size: 32 32
    phantom: true

  Label
    id: dir
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: prev.bottom
    margin-bottom: 1
    margin-left: 5
    color: #ff7a00
    font: verdana-11px-rounded
    phantom: true
]])
end

local function setArrowItem(widget, itemId)
  if not widget then return end
  itemId = tonumber(itemId) or 3541

  if widget.setItemId then
    widget:setItemId(itemId)
    return
  end

  if widget.setItem and Item and Item.create then
    widget:setItem(Item.create(itemId, 1))
  end
end

local function ensurePushMaxArrow(def)
  local w = LNS_PUSHMAX_ARROWS.widgets[def.id]
  if w then return w end

  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel then return nil end

  w = g_ui.createWidget("LNSPushMaxArrow", panel)
  w.botWidget = true
  w.botIcon = true
  w:setId("lnsPushMaxArrow_" .. def.id)
  w:setTooltip("PushMax " .. def.text)
  w:setSize(LNS_PUSHMAX_ARROWS.size .. " " .. LNS_PUSHMAX_ARROWS.size)

  if w.item then
    setArrowItem(w.item, 3541)
  end

  if w.dir then
    w.dir:setText(def.text)
    w.dir:setTextAlign(AlignCenter)
    w.dir:setColor("#ff7a00")
    if w.dir.setFont then
      w.dir:setFont("verdana-11px-rounded")
    end
  end

  if w.setOpacity then
    w:setOpacity(0.95)
  end

  local function executeArrowPush()
    if type(LNS_PushMaxIconPush) == "function" then
        pcall(LNS_PushMaxIconPush, def.dx, def.dy)
    elseif modules and modules.game_textmessage then
        modules.game_textmessage.displayGameMessage("Carregue o PushMax antes dos icones.")
    end
  end

  w.onMousePress = function(widget, mousePos, button)
    executeArrowPush()
      return true
  end

  w.onMouseRelease = function(widget, mousePos, button)
      if button == MouseLeftButton or button == nil then
      end
      return true
  end

  w.onClick = function()
      return true
  end

  w.onDoubleClick = function()
      return true
  end

  LNS_PUSHMAX_ARROWS.widgets[def.id] = w
  return w
end

local function updatePushMaxArrows()
  local icon = pushMaxIconWidget()
  if not icon or not isPushMaxEnabledForArrows() then
    hidePushMaxArrows()
    return
  end

  local cx = icon:getX() + (icon:getWidth() / 2)
  local cy = icon:getY() + (icon:getHeight() / 2)

  for _, def in ipairs(LNS_PUSHMAX_ARROWS.defs) do
    local w = ensurePushMaxArrow(def)
    if w then
      local x = math.floor(cx + def.ox - (w:getWidth() / 2))
      local y = math.floor(cy + def.oy - (w:getHeight() / 2))

      w:breakAnchors()
      w:move(x, y)
      w:show()
      w:raise()
    end
  end

  -- Mantem o icone central acima/visivel junto com as setas.
  pcall(function() icon:raise() end)
end

macro(80, function()
  updatePushMaxArrows()
end)


--==================================================
-- MW/WG: CURSORES AO LADO DO ICONE HOLD MW/WG
--==================================================

local LNS_MW_CURSOR_ICONS = {
  widgets = {},
  width = lnsIsMobile() and 64 or 58,
  height = lnsIsMobile() and 46 or 42,
  defs = {
    -- ficam embaixo do HOLD MW/WG, nos dois quadrados marcados
    { id = "mw", text = "CURSOR MW", fn = "cursorMw", stateFn = "isCursorMw", itemId = 3180, storageRune = "mwRune", ox = -33, oy = 52 },
    { id = "wg", text = "CURSOR WG", fn = "cursorWg", stateFn = "isCursorWg", itemId = 3156, storageRune = "wgRune", ox =  33, oy = 52 }
  }
}

local function holdMwWgIconWidget()
  local pack = LNS_ICON.icons["mwsystem_hold_mw_wg"]
  return pack and pack.icon or nil
end

local function isHoldMwWgEnabledForCursorIcons()
  local st = iconsStorage["mwsystem_hold_mw_wg"]
  local icon = holdMwWgIconWidget()

  if not st or st.show ~= true or not isWidgetVisible(icon) then
    return false
  end

  if LNS_MWSystem and type(LNS_MWSystem.isHoldMwWg) == "function" then
    local ok, res = pcall(LNS_MWSystem.isHoldMwWg)
    if ok then return res == true end
  end

  return type(lnsIconsBridgeStorage) == "table"
    and type(lnsIconsBridgeStorage.holdMwWgPanel) == "table"
    and lnsIconsBridgeStorage.holdMwWgPanel.iconHoldMwWg == true
end

local function hideMwCursorIcons()
  for _, w in pairs(LNS_MW_CURSOR_ICONS.widgets) do
    if w then pcall(function() w:hide() end) end
  end

  if LNS_MWSystem and type(LNS_MWSystem.stopCursor) == "function" then
    pcall(LNS_MWSystem.stopCursor)
  end
end

if not LNS_MW_CURSOR_ICON_UI_LOADED then
  LNS_MW_CURSOR_ICON_UI_LOADED = true

  g_ui.loadUIFromString([[
LNSMWCursorIcon < UIWidget
  size: 58 42
  phantom: false
  focusable: false

  Item
    id: item
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: -1
    size: 28 28
    phantom: true

  Label
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 0
    color: white
    font: verdana-9px
    text-align: center
    phantom: true
]])
end

local function getMwCursorIconItemId(def)
  local cfg = type(lnsIconsBridgeStorage) == "table" and lnsIconsBridgeStorage.holdMwWgPanel or nil
  return tonumber(cfg and cfg[def.storageRune]) or tonumber(def.itemId) or 0
end

local function isMwCursorIconActive(def)
  if LNS_MWSystem and def and def.stateFn and type(LNS_MWSystem[def.stateFn]) == "function" then
    local ok, res = pcall(LNS_MWSystem[def.stateFn])
    return ok and res == true
  end
  return false
end

local function applyMwCursorIconVisual(w, def)
  if not w then return end

  local active = isMwCursorIconActive(def)

  if w.title then
    w.title:setColor(active and "#00ff00" or "white")
  end

  if w.setOpacity then
    w:setOpacity(active and 1.00 or 0.90)
  end

  if w.setTooltip then
    w:setTooltip(def.text .. (active and " ON" or " OFF"))
  end
end

local function ensureMwCursorIcon(def)
  local w = LNS_MW_CURSOR_ICONS.widgets[def.id]
  if w then return w end

  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel then return nil end

  w = g_ui.createWidget("LNSMWCursorIcon", panel)
  w.botWidget = true
  w.botIcon = true
  w:setId("lnsMwCursorIcon_" .. def.id)
  w:setTooltip(def.text)
  w:setSize(LNS_MW_CURSOR_ICONS.width .. " " .. LNS_MW_CURSOR_ICONS.height)

  if w.title then
    w.title:setText(def.text)
    w.title:setTextAlign(AlignCenter)
    w.title:setColor("white")
    if w.title.setFont then
      w.title:setFont("verdana-9px")
    end
  end

  if w.setOpacity then
    w:setOpacity(0.95)
  end

  local function executeCursor()
    if LNS_MWSystem and type(LNS_MWSystem[def.fn]) == "function" then
      pcall(LNS_MWSystem[def.fn])
      applyMwCursorIconVisual(w, def)
    elseif modules and modules.game_textmessage then
      modules.game_textmessage.displayGameMessage("Carregue o MW System antes dos icones.")
    end
  end

  w.onMousePress = function(widget, mousePos, button)
    executeCursor()
    return true
  end

  w.onMouseRelease = function(widget, mousePos, button)
    return true
  end

  w.onClick = function()
    return true
  end

  w.onDoubleClick = function()
    return true
  end

  LNS_MW_CURSOR_ICONS.widgets[def.id] = w
  return w
end

local function updateMwCursorIcons()
  local icon = holdMwWgIconWidget()
  if not icon or not isHoldMwWgEnabledForCursorIcons() then
    hideMwCursorIcons()
    return
  end

  local cx = icon:getX() + (icon:getWidth() / 2)
  local cy = icon:getY() + (icon:getHeight() / 2)

  for _, def in ipairs(LNS_MW_CURSOR_ICONS.defs) do
    local w = ensureMwCursorIcon(def)
    if w then
      if w.item then
        setArrowItem(w.item, getMwCursorIconItemId(def))
      end

      applyMwCursorIconVisual(w, def)

      local x = math.floor(cx + def.ox - (w:getWidth() / 2))
      local y = math.floor(cy + def.oy - (w:getHeight() / 2))

      w:breakAnchors()
      w:move(x, y)
      w:show()
      w:raise()
    end
  end

  pcall(function() icon:raise() end)
end

macro(120, function()
  updateMwCursorIcons()
end)


--==================================================
-- PESQUISA DE ICONES
--==================================================

iconesInterface.pesquisaIcons.onTextChange = function(_, text)
  local q = normalizeText(text)

  for _, def in ipairs(ICON_DEFS) do
    local row = LNS_ICON.rows[def.key]
    if row then
      local a = normalizeText(def.key)
      local b = normalizeText(def.text)

      if q == "" or a:find(q, 1, true) or b:find(q, 1, true) then
        row:show()
      else
        row:hide()
      end
    end
  end
end

macro(20, function()
  if not boundStates["chase_mode"] then return end

  if g_game.getChaseMode() ~= 1 then
    g_game.setChaseMode(1)
  end
end)

macro(2000, function()
  updateAllIcons()
end)

updateAllIcons()
saveIcons()
 
end)

lnsRunBlock("Task_Ragnar", function()

local TASKS = {
  goblins = { label="Goblins", required=100, iconId=61, creatures={ "Goblin", "Goblin Assassin", "Goblin Leader", "Goblin Scavenger" } },
  trolls = { label="Trolls", required=100, iconId=15, creatures={ "Troll", "Swamp Troll", "Frost Troll", "Island Troll" } },
  orcs = { label="Orcs", required=250, iconId=5, creatures={ "Orc", "Orc Spearman", "Orc Warrior", "Orc Shaman", "Orc Rider", "Orc Berserker", "Orc Leader", "Orc Warlord" } },
  rotworms = { label="Rotworms", required=200, iconId=26, creatures={ "Rotworm", "Carrion Worm" } },
  minotaurs = { label="Minotaurs", required=300, iconId=25, creatures={ "Minotaur", "Minotaur Archer", "Minotaur Guard", "Minotaur Mage" } },
  dwarfs = { label="Dwarfs", required=300, iconId=69, creatures={ "Dwarf", "Dwarf Soldier", "Dwarf Guard", "Dwarf Geomancer" } },
  dworcs = { label="Dworcs", required=300, iconId=216, creatures={ "Dworc Venomsniper", "Dworc Voodoomaster", "Dworc Fleshhunter" } },
  elves = { label="Elves", required=400, iconId=62, creatures={ "Elf", "Elf Scout", "Elf Arcanist", "Firestarter" } },
  dark_cathedral = { label="Dark Cathedral", required=500, iconId=372, creatures={ "Dark Apprentice", "Dark Magician", "Dark Monk", "Assassin", "Smuggler", "Bandit", "Wild Warrior", "Witch", "Ghost", "Hunter", "Stone Golem", "Demon Skeleton" } },
  tombs = { label="Tombs", required=800, iconId=85, creatures={ "Ghost", "Mummy", "Ghoul", "Demon Skeleton", "Skeleton", "Crypt Shambler" } },
  scarabs = { label="Scarabs", required=600, iconId=83, creatures={ "Scarab" } },
  cyclops = { label="Cyclops", required=500, iconId=22, creatures={ "Cyclops", "Cyclops Smith", "Cyclops Drone" } },
  mutateds = { label="Mutateds", required=600, iconId=521, creatures={ "Mutated Human", "Mutated Bat", "Mutated Rat", "Mutated Tiger" } },
  coryms = { label="Coryms", required=400, iconId=916, creatures={ "Corym Charlatan", "Corym Skirmisher", "Corym Vanguard" } },
  banuta_surface = { label="Banuta Surface", required=600, iconId=116, creatures={ "Kongra", "Sibang", "Merlkin" } },
  pirates = { label="Pirates", required=600, iconId=247, creatures={ "Pirate Marauder", "Pirate Cutthroat", "Pirate Corsair", "Pirate Buccaneer" } },
  barbarians = { label="Barbarians", required=600, iconId=323, creatures={ "Barbarian Bloodwalker", "Barbarian Brutetamer", "Barbarian Headsplitter", "Barbarian Skullhunter" } },
  djinns = { label="Djinns", required=600, iconId=104, creatures={ "Marid", "Efreet", "Green Djinn", "Blue Djinn" } },
  stonerefiners = { label="Stonerefiners", required=500, iconId=1525, creatures={ "Stonerefiner" } },
  dragons = { label="Dragons", required=500, iconId=34, creatures={ "Dragon", "Dragon Hatchling" } },
  quaras = { label="Quaras", required=500, iconId=241, creatures={ "Quara Mantassin", "Quara Mantassin Scout", "Quara Constrictor", "Quara Constrictor Scout", "Quara Pincher", "Quara Pincher Scout", "Quara Predator", "Quara Predator Scout", "Quara Hydromancer", "Quara Hydromancer Scout" } },
  drefia_crypts = { label="Drefia Crypts", required=600, iconId=975, creatures={ "Gravedigger", "Zombie", "Blood Hand", "Necromancer" } },
  ancient_scarabs = { label="Ancient Scarabs", required=500, iconId=79, creatures={ "Ancient Scarab" } },
  giant_spiders = { label="Giant Spiders", required=500, iconId=38, creatures={ "Giant Spider" } },
  laguna_islands = { label="Laguna Islands", required=500, iconId=259, creatures={ "Thornback Tortoise", "Tortoise", "Toad", "Blood Crab" } },
  oramond = { label="Oramond", required=1000, iconId=1052, creatures={ "Minotaur Hunter", "Mooh'Tah Warrior", "Minotaur Amazon", "Worm Priestess", "Execowtioner", "Moohtant" } },
  wyrms = { label="Wyrms", required=1000, iconId=461, creatures={ "Wyrm", "Elder Wyrm" } },
  book_world = { label="Book World", required=2000, iconId=2673, creatures={ "Bluebeak", "Bramble Wyrmling", "Crusader", "Hawk Hopper", "Headwalker", "Lion Hydra" } },
  cults = { label="Cults", required=1500, iconId=1512, creatures={ "Cult Believer", "Vicious Squire", "Cult Enforcer", "Renegade Knight", "Vile Grandmaster", "Cult Scholar", "Hero" } },
  barkless = { label="Barkless", required=1000, iconId=1486, creatures={ "Barkless Devotee", "Barkless Fanatic" } },
  feyrist_surface = { label="Feyrist Surface", required=1500, iconId=1434, creatures={ "Faun", "Dark Faun", "Nymph", "Pixie", "Pooka", "Twisted Pooka", "Swan Maiden" } },
  deeplings = { label="Deeplings", required=1000, iconId=772, creatures={ "Deepling Spellsinger", "Deepling Scout", "Deepling Warrior", "Deepling Guard" } },
  wereboars = { label="Wereboars", required=1500, iconId=1549, creatures={ "Werefox", "Werebadger", "Wereboar", "Werebear", "Werewolf" } },
  minotaur_cults = { label="Minotaur Cults", required=1800, iconId=1508, creatures={ "Minotaur Cult Follower", "Minotaur Cult Prophet", "Minotaur Cult Zealot" } },
  orc_cults = { label="Orc Cults", required=2000, iconId=2438, creatures={ "Orc Cult Fanatic", "Orc Cult Inquisitor", "Orc Cult Minion", "Orc Cult Priest", "Orc Cultist" } },
  feyrist_nightmares = { label="Feyrist Nightmares", required=2000, iconId=1442, creatures={ "Weakened Frazzlemaw", "Enfeebled Silencer" } },
  bandits = { label="Glooth Bandits", required=3000, iconId=1119, creatures={ "Glooth Bandit", "Glooth Brigand" } },
  exotics = { label="Exotics", required=3500, iconId=2024, creatures={ "Exotic Cave Spider", "Exotic Bat" } },
  pirats = { label="Pirats", required=2000, iconId=2038, creatures={ "Pirat Bombardier", "Pirat Cutthroat", "Pirat Mate", "Pirat Scoundrel" } },
  werehyaenas = { label="Werehyaenas", required=2000, iconId=1963, creatures={ "Werehyaena", "Werehyaena Shaman" } },
  dragon_lords = { label="Dragon Lords", required=2000, iconId=39, creatures={ "Dragon Lord", "Dragon Lord Hatchling" } },
  frost_dragons = { label="Frost Dragons", required=2000, iconId=317, creatures={ "Frost Dragon", "Frost Dragon Hatchling" } },
  banuta_deeper = { label="Banuta Deeper", required=2000, iconId=120, creatures={ "Medusa", "Serpent Spawn", "Hydra", "Eternal Guardian" } },
  nightmares = { label="Nightmares", required=2000, iconId=33, creatures={ "Nightmare", "Nightmare Scion" } },
  drakens = { label="Drakens", required=3000, iconId=673, creatures={ "Draken Abomination", "Draken Elite", "Draken Spellweaver", "Draken Warmaster", "Lizard Legionnaire", "Lizard Magistratus", "Lizard Noble", "Lizard Chosen", "Lizard Dragon Priest", "Lizard High Guard" } },
  the_hive = { label="The Hive", required=3000, iconId=785, creatures={ "Waspoid", "Crawler", "Spitter", "Kollos", "Spidris", "Spidris Elite", "Hive Overseer" } },
  carnivors = { label="Carnivors", required=4000, iconId=1723, creatures={ "Lumbering Carnivor", "Spiky Carnivor", "Menacing Carnivor" } },
  nightmare_isles = { label="Nightmare Isles", required=3000, iconId=1017, creatures={ "Choking Fear", "Retching Horror", "Silencer" } },
  warlock = { label="Warlocks", required=2000, iconId=10, creatures={ "Warlock" } },
  mota = { label="Mota", required=3000, iconId=291, creatures={ "Fury", "Floating Savant", "Demon", "Retching Horror", "Hellhound" } },
  grim_reapers = { label="Grim Reapers", required=3000, iconId=519, creatures={ "Hellspawn", "Grim Reaper" } },
  candia = { label="Candia", required=3500, iconId=2535, creatures={ "Candy Horror", "Nibblemaw", "Honey Elemental", "Angry Sugar Fairy", "Candy Floss Elemental", "Goggle Cake" } },
  lycanthropes = { label="Lycanthropes", required=4000, iconId=1965, creatures={ "Werelion", "Werelioness" } },
  the_void = { label="The Void", required=5000, iconId=1696, creatures={ "Breach Brood", "Dread Intruder", "Sparkion", "Reality Reaver" } },
  asuras = { label="Asuras", required=5000, iconId=1134, creatures={ "Dawnfire Asura", "Midnight Asura", "Frost Flower Asura" } },
  buried_cathedral = { label="Buried Cathedral", required=5000, iconId=1725, creatures={ "Gazer Spectre", "Burster Spectre", "Ripper Spectre", "Thanatursus", "Arachnophobica" } },
  rathleton_catacombs = { label="Rathleton Catacombs", required=6000, iconId=287, creatures={ "Destroyer", "Dark Torturer", "Demon", "Grim Reaper", "Hellhound", "Hellspawn", "Juggernaut" } },
  roshamuul = { label="Roshamuul", required=8000, iconId=2682, creatures={ "Guzzlemaw", "Frazzlemaw", "Silencer", "Choking Fear", "Retching Horror" } },
  warzone_1 = { label="Warzone 1", required=3000, iconId=891, creatures={ "Hideous Fungus", "Humongous Fungus" } },
  warzone_2 = { label="Warzone 2", required=5000, iconId=882, creatures={ "Weeper", "Magma Crawler", "Lost Berserker" } },
  warzone_3 = { label="Warzone 3", required=5000, iconId=889, creatures={ "Cliff Strider", "Ironblight", "Orewalker" } },
  weretigers = { label="Weretigers", required=6000, iconId=2386, creatures={ "Weretiger", "White Weretiger", "Cunning Werepanther" } },
  winter_elves = { label="Winter Elves", required=10000, iconId=1734, creatures={ "Soul-broken Harbinger", "Crazed Winter Vanguard", "Crazed Winter Rearguard", "Arachnophobica" } },
  summer_elves = { label="Summer Elves", required=8000, iconId=1733, creatures={ "Crazed Summer Rearguard", "Crazed Summer Vanguard", "Insane Siren", "Arachnophobica" } },
  deathlings = { label="Deathlings", required=4000, iconId=1667, creatures={ "Deathling Scout", "Deathling Spellsinger" } },
  great_pearl = { label="Great Pearl", required=8000, iconId=2259, creatures={ "Foam Stalker", "Two-headed Turtle" } },
  nagas = { label="Nagas", required=8000, iconId=2262, creatures={ "Makara", "Naga Archer", "Naga Warrior" } },
  carnisylvans = { label="Carnisylvans", required=8000, iconId=2109, creatures={ "Dark Carnisylvan", "Hulking Carnisylvan", "Poisonous Carnisylvan" } },
  warzone_4 = { label="Warzone 4", required=7000, iconId=1546, creatures={ "Chasm Spawn", "Drillworm", "Elder Wyrm", "Lava Lurker" } },
  warzone_5 = { label="Warzone 5", required=7000, iconId=1544, creatures={ "Cave Devourer", "High Voltage Elemental", "Tunnel Tyrant" } },
  warzone_6 = { label="Warzone 6", required=12000, iconId=1531, creatures={ "Deepworm", "Diremaw", "Humongous Fungus" } },
  seacrest = { label="Seacrest", required=5000, iconId=1096, creatures={ "Seacrest Serpent", "Sea Serpent", "Young Sea Serpent" } },
  kilmaresh_deeper = { label="Kilmaresh Deeper", required=8000, iconId=1798, creatures={ "Burning Gladiator", "Black Sphinx Acolyte", "Priestess Of The Wild Sun" } },
  kilmaresh_surface = { label="Kilmaresh Surface", required=15000, iconId=1808, creatures={ "Sphinx", "Manticore", "Lamassu", "Feral Sphinx", "Crypt Warden", "Young Goanna", "Adult Goanna" } },
  falcon_bastion = { label="Falcon Bastion", required=16000, iconId=1646, creatures={ "Falcon Knight", "Falcon Paladin" } },
  kilmaresh_mountains = { label="Kilmaresh Mountains", required=10000, iconId=1821, creatures={ "Ogre Rowdy", "Ogre Ruffian", "Ogre Sage" } },
  roshamuul_prison = { label="Roshamuul Prison", required=12000, iconId=1019, creatures={ "Demon Outcast", "Blightwalker", "Plaguesmith", "Dark Torturer", "Hellhound", "Juggernaut" } },
  cobra_bastion = { label="Cobra Bastion", required=20000, iconId=1775, creatures={ "Cobra Assassin", "Cobra Scout", "Cobra Vizier" } },
  bulltaur_lair = { label="Bulltaur Lair", required=15000, iconId=2448, creatures={ "Bulltaur Alchemist", "Bulltaur Brute", "Bulltaur Forgepriest" } },
  netherworld = { label="Netherworld", required=15000, iconId=1864, creatures={ "Flimsy Lost Soul", "Mean Lost Soul", "Freakish Lost Soul" } },
  deep_desert = { label="Deep Desert", required=13000, iconId=46, creatures={ "Black Knight", "Guardian of the Sands", "Undead Sun Soldier", "Undead Cobra Scout" } },
  nimmersatts = { label="Nimmersatt's", required=20000, iconId=2456, creatures={ "Dragolisk", "Mega Dragon", "Wardragon" } },
  bashmus = { label="Bashmus", required=20000, iconId=2100, creatures={ "Bashmu", "Juvenile Bashmu" } },
  girtablilu = { label="Girtablilu", required=15000, iconId=2099, creatures={ "Girtablilu Warrior", "Venerable Girtablilu" } },
  true_asuras = { label="True Asuras", required=12000, iconId=1620, creatures={ "True Dawnfire Asura", "True Frost Flower Asura", "True Midnight Asura", "Hellhound" } },
  ingol = { label="Ingol", required=25000, iconId=2339, creatures={ "Boar Man", "Carnivostrich", "Crape Man", "Harpy", "Liodile", "Rhindeer" } },
  ferumbras_seal = { label="Ferumbras Seal", required=15000, iconId=1197, creatures={ "Vexclaw", "Grimeleech", "Hellflayer" } },
  warzone_7 = { label="Warzone 7", required=20000, iconId=2094, creatures={ "Afflicted Strider", "Blemished Spawn", "Eyeless Devourer" } },
  warzone_8 = { label="Warzone 8", required=15000, iconId=2095, creatures={ "Lavafungus", "Lavaworm", "Streaked Devourer" } },
  warzone_9 = { label="Warzone 9", required=15000, iconId=2096, creatures={ "Cave Chimera", "Tremendous Tyrant", "Varnished Diremaw" } },
  podzilla = { label="Podzilla", required=25000, iconId=2539, creatures={ "Rootthing Amber Shaper", "Rootthing Nutshell", "Rootthing Bug Tracker" } },
  podzilla_deep = { label="Podzilla Deep", required=20000, iconId=2543, creatures={ "Quara Looter", "Quara Plunderer", "Quara Raider" } },
  inferniarchs_castle = { label="Inferniarchs Castle", required=15000, iconId=2603, creatures={ "Broodrider Inferniarch", "Gorger Inferniarch", "Sineater Inferniarch" } },
  earth_library = { label="Earth Library", required=12000, iconId=1652, creatures={ "Cursed Book", "Ink Blob", "Biting Book" } },
  ice_library = { label="Ice Library", required=20000, iconId=1664, creatures={ "Icecold Book", "Squid Warden", "Animated Feather" } },
  fire_library = { label="Fire Library", required=20000, iconId=1663, creatures={ "Burning Book", "Rage Squid", "Guardian Of Tales" } },
  energy_library = { label="Energy Library", required=20000, iconId=1665, creatures={ "Energetic Book", "Brain Squid", "Energuardian Of Tales" } },
  furious_crater = { label="Furious Crater", required=25000, iconId=1929, creatures={ "Vibrant Phantom", "Courage Leech", "Cloak Of Terror" } },
  dark_thais = { label="Dark Thais", required=25000, iconId=1927, creatures={ "Many Faces", "Druid’s Apparition", "Knight’s Apparition", "Paladin’s Apparition", "Sorcerer’s Apparition", "Monk’s Apparition", "Distorted Phantom" } },
  rotten_wasteland = { label="Rotten Wasteland", required=25000, iconId=0, creatures={ } },
  claustrophobic_inferno = { label="Claustrophobic Inferno", required=25000, iconId=1930, creatures={ "Brachiodemon", "Infernal Demon", "Infernal Phantom" } },
  inferniarchs_catacombs = { label="Inferniarchs Catacombs", required=25000, iconId=2601, creatures={ "Brinebrute Inferniarch", "Hellhunter Inferniarch", "Spellreaper Inferniarch" } },
  ebb_and_flow = { label="Ebb And Flow", required=25000, iconId=1926, creatures={ "Bony Sea Devil", "Turbulent Elemental", "Capricious Phantom" } },
  crystal_enigma = { label="Crystal Enigma", required=30000, iconId=2268, creatures={ "Emerald Tortoise", "Gore Horn", "Gorerilla", "Hulking Prehemoth", "Sabretooth" } },
  sparkling_pools = { label="Sparkling Pools", required=30000, iconId=2275, creatures={ "Headpecker", "Mantosaurus", "Mercurial Menace", "Noxious Ripptor", "Shrieking Cry-stal" } },
  graveyard = { label="Graveyard", required=30000, iconId=2264, creatures={ "Sulphider", "Sulphur Spouter", "Nighthunter", "Stalking Stalk", "Undertaker" } },
  putrefatory = { label="Putrefatory", required=40000, iconId=2394, creatures={ "Meandering Mushroom", "Oozing Carcass", "Rotten Man-maggot", "Sopping Carcass" } },
  gloom_pillars = { label="Gloom Pillars", required=40000, iconId=2379, creatures={ "Converter", "Darklight Construct", "Darklight Emitter", "Wandering Pillar" } },
  jaded_roots = { label="Jaded Roots", required=40000, iconId=2392, creatures={ "Bloated Man-maggot", "Mycobiontic Beetle", "Oozing Corpus", "Sopping Corpus" } },
  darklight_core = { label="Darklight Core", required=40000, iconId=2380, creatures={ "Darklight Matter", "Darklight Source", "Darklight Striker", "Walking Pillar" } },
}

local TASKS_BY_LEVEL = {
  [1]={
    "goblins","trolls","orcs","rotworms","minotaurs","dwarfs","dworcs",
    "elves","dark_cathedral","tombs","scarabs","cyclops","mutateds","coryms",
    "banuta_surface","pirates","barbarians","djinns","stonerefiners","dragons","quaras",
    "drefia_crypts","ancient_scarabs","giant_spiders","laguna_islands"
  },
  [2]={
    "oramond","wyrms","book_world","cults","barkless","feyrist_surface","deeplings",
    "wereboars","minotaur_cults","orc_cults","feyrist_nightmares","bandits","exotics","pirats",
    "werehyaenas","dragon_lords","frost_dragons","banuta_deeper","nightmares","drakens","the_hive",
    "carnivors","nightmare_isles","warlock"
  },
  [3]={
    "mota","grim_reapers","candia","lycanthropes","the_void","asuras","buried_cathedral",
    "rathleton_catacombs","roshamuul","warzone_1","warzone_2","warzone_3","weretigers","winter_elves",
    "summer_elves","deathlings","great_pearl","nagas","carnisylvans","warzone_4","warzone_5",
    "warzone_6","seacrest"
  },
  [4]={
    "kilmaresh_deeper","kilmaresh_surface","falcon_bastion","kilmaresh_mountains","roshamuul_prison","cobra_bastion","bulltaur_lair",
    "netherworld","deep_desert","nimmersatts","bashmus","girtablilu","true_asuras"
  },
  [5]={
    "ingol","ferumbras_seal","warzone_7","warzone_8","warzone_9","podzilla","podzilla_deep",
    "inferniarchs_castle"
  },
  [6]={
    "earth_library","ice_library","fire_library","energy_library","furious_crater","dark_thais","rotten_wasteland",
    "claustrophobic_inferno","inferniarchs_catacombs","ebb_and_flow"
  },
  [7]={
    "crystal_enigma","sparkling_pools","graveyard","putrefatory","gloom_pillars","jaded_roots","darklight_core"
  }
}

local nomes={"?","NIVEL 1","NIVEL 2","NIVEL 3","NIVEL 4","NIVEL 5","NIVEL 6","NIVEL 7"}

storage=storage or {}
storage.ragnarTasks=type(storage.ragnarTasks)=="table" and storage.ragnarTasks or {}
storage.ragnarButton=type(storage.ragnarButton)=="table" and storage.ragnarButton or {enabled=false}
storage._configs=storage._configs or {}
storage._configs.cavebot_configs=storage._configs.cavebot_configs or {}
storage._configs.targetbot_configs=storage._configs.targetbot_configs or {}
local cfg,rb=storage.ragnarTasks,storage.ragnarButton
cfg.completed=type(cfg.completed)=="table" and cfg.completed or {}
cfg.progress=type(cfg.progress)=="table" and cfg.progress or {}
cfg.level=math.max(1,math.min(7,tonumber(cfg.level) or 1))
cfg.current=TASKS[cfg.current] and cfg.current or nil
cfg.kills=math.max(0,tonumber(cfg.kills) or 0)
cfg.required=math.max(0,tonumber(cfg.required) or 0)
cfg.trackerPos=type(cfg.trackerPos)=="table" and cfg.trackerPos or {}
cfg.trackerMinimized=cfg.trackerMinimized==true
cfg.questTrackerProgress=type(cfg.questTrackerProgress)=="table" and cfg.questTrackerProgress or {}
rb.enabled=rb.enabled==true

for nivel,lista in ipairs(TASKS_BY_LEVEL) do
  for _,chave in ipairs(lista) do
    local t=TASKS[chave]
    if t then t.key,t.level=chave,nivel end
  end
end

-- Detecta o cliente mobile sem gerar erro caso algum objeto nao exista.
local function ragnarIsMobile()
  if not modules or not modules._G or not modules._G.g_app or
     type(modules._G.g_app.isMobile)~="function" then
    return false
  end

  local ok,mobile=pcall(function()
    return modules._G.g_app.isMobile()
  end)

  return ok and mobile==true
end

local RAGNAR_REQUIRED_EXTRA={djinns=80}
local RAGNAR_MOBILE_EXTRA=50

function ragnarRequired(key)
  local task=key and TASKS[key]
  if not task then return 0 end

  local required=tonumber(task.required) or 0
  required=required+(RAGNAR_REQUIRED_EXTRA[key] or 0)

  -- No mobile todas as tasks recebem mais 50 mortes de seguranca.
  if ragnarIsMobile() then
    required=required+RAGNAR_MOBILE_EXTRA
  end

  return math.max(0,required)
end

ragnarButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Task Ragnar
    tooltip: Ligue para iniciar o auto task (PARTIDA SEMPRE DO DP DE THAIS).
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

ragnarInterface=setupUI([=[
MainWindow
  id: mainPanel
  size: 430 300
  text: Task Ragnar
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    margin-left: -5
    margin-right: -5
    height: 40
    padding-top: 7
    padding-left: 6
    padding-bottom: 7
    layout:
      type: horizontalBox
      spacing: 5

  Button
    id: listaTask
    checkable: true
    anchors.top: flatp.bottom
    anchors.left: flatp.left
    size: 180 30
    margin-top: 15
    text-align: center
    text: LISTA DE TASK
    font: cipsoftFont

    UIItem
      id: uiItem
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 30 30
      padding: 3
      phantom: true

  TextList
    id: listTaskRagnar
    anchors.top: listaTask.bottom
    anchors.left: listaTask.left
    anchors.right: listaTask.right
    margin-right: 12
    margin-left: 1
    height: 150
    padding: 1
    vertical-scrollbar: listTaskRagnarScrollBar
    opacity: 0.95
    font: verdana-11px-rounded
    layout:
      type: verticalBox
      fit-children: false

  VerticalScrollBar
    id: listTaskRagnarScrollBar
    anchors.top: listTaskRagnar.top
    anchors.bottom: listTaskRagnar.bottom
    anchors.left: listTaskRagnar.right
    step: 10
    pixels-scroll: true
    visible: true
    opacity: 0.90

  UIButton
    id: transferToConcl
    anchors.verticalCenter: listTaskRagnar.verticalCenter
    anchors.left: listTaskRagnarScrollBar.right
    size: 25 25
    margin-left: 15
    margin-top: -40
    image-padding: 5
    image-source: /images/ui/arrow_vertical
    image-clip: 21 0 21 12
    rotation: 90
    tooltip: Marcar a Task como concluida.

  UIButton
    id: transferToList
    anchors.top: prev.bottom
    anchors.left: prev.left
    size: 25 25
    margin-left: 0
    margin-top: 30
    image-padding: 5
    image-source: /images/ui/arrow_vertical
    image-clip: 21 0 21 12
    rotation: 270
    tooltip: Marcar a Task como NAO concluida

  Button
    id: listaTaskConcl
    checkable: true
    anchors.top: flatp.bottom
    anchors.right: flatp.right
    size: 180 30
    margin-top: 15
    text-align: center
    text: "     TASKS CONCLUIDAS"
    font: cipsoftFont

    UIItem
      id: uiItem
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -8
      margin-left: -9
      size: 40 35
      padding: 3
      phantom: true

  TextList
    id: listTaskConcl
    anchors.top: listaTaskConcl.bottom
    anchors.left: listaTaskConcl.left
    anchors.right: listaTaskConcl.right
    margin-right: 12
    margin-left: 1
    height: 150
    padding: 1
    vertical-scrollbar: listTaskConclScrollBar
    opacity: 0.95
    font: verdana-11px-rounded
    layout:
      type: verticalBox
      fit-children: false

  VerticalScrollBar
    id: listTaskConclScrollBar
    anchors.top: listTaskConcl.top
    anchors.bottom: listTaskConcl.bottom
    anchors.left: listTaskConcl.right
    step: 10
    pixels-scroll: true
    visible: true
    opacity: 0.90

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: flatp.left
    anchors.right: flatp.right
    text: CLOSE
    font: cipsoftFont
    margin-top: 8
]=],g_ui.getRootWidget())

ragnarInterface.listaTask.uiItem:setItemId(9186)
ragnarInterface.listaTaskConcl.uiItem:setItemId(37423)

taskInterface=setupUI([=[
UIWindow
  id: ragnarTracker
  size: 250 90

  Panel
    anchors.fill: parent
    image-source: /images/ui/miniwindow
    image-border: 20

  Panel
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25

  Label
    id: title
    anchors.centerIn: topBar
    text: "    Task Ragnar"
    margin-left: -55
    color: gray
    margin-top: -4
    text-auto-resize: true

  Button
    id: minimize
    anchors.top: parent.top
    anchors.right: parent.right
    margin-top: 0
    margin-right: 3
    size: 20 18
    text: -
    font: verdana-11px-rounded
    color: gray

  Panel
    id: content
    anchors.top: topBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: 5
    margin-top: 1

    UICreature
      id: icon
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: 60
      margin-left: 2
      border: 1 #4F4F4F

    Panel
      id: info
      anchors.left: icon.right
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      margin-left: 7

      Label
        id: taskName
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        margin-top: 3
        height: 18
        text: AGUARDANDO
        text-align: center
        color: white
        font: cipsoftFont

      Label
        id: count
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: taskName.bottom
        margin-top: 0
        height: 18
        text: 0/0
        text-align: center
        font: cipsoftFont
        color: white

      ProgressBar
        id: progress
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: count.bottom
        margin-top: 4
        height: 18
        minimum: 0
        maximum: 100
        margin-right: 2
        value: 0
        text: 0%
        text-align: center
        font: verdana-11px-rounded
]=],g_ui.getRootWidget())
taskInterface:hide()

local function norm(s) return tostring(s or ""):lower():gsub("’","'"):gsub("_"," "):gsub("^%s+",""):gsub("%s+$",""):gsub("%s+"," ") end
local function smart(s)
  s=norm(s):gsub("^the%s+",""):gsub("[^%w%s]","")
  return s:sub(-1)=="s" and s:sub(1,-2) or s
end

local function parseHunt(text)
  local hunt=tostring(text or ""):match("[Yy]our hunt for%s+(.+)%s+has begun")
  if not hunt then return end
  hunt=smart(hunt)
  for key,t in pairs(TASKS) do if smart(key)==hunt or smart(t.label)==hunt then return key end end
end
local function trackerBar(kills,required,emptyText)
  kills,required=math.max(0,tonumber(kills) or 0),math.max(0,tonumber(required) or 0)
  local pct=required>0 and math.min(100,math.floor(kills*100/required)) or 0
  local info=taskInterface.content.info
  local bar=info.progress

  info.count:setText(required>0 and (kills.."/"..required) or (emptyText or "0/0"))
  bar:setText(pct.."%")

  if bar.setMinimum then pcall(function() bar:setMinimum(0) end) end
  if bar.setMaximum then pcall(function() bar:setMaximum(100) end) end
  if bar.setValue then
    local ok=pcall(function() bar:setValue(pct) end)
    if not ok then pcall(function() bar:setValue(pct,100) end) end
  end
  if bar.setPercent then pcall(function() bar:setPercent(pct) end) end
end
local function trackerIcon(t)
  local icon=taskInterface.content.icon
  if not t or (tonumber(t.iconId) or 0)<=0 then icon:hide(); return end
  icon:show()
  local outfit={type=tonumber(t.iconId) or 0,addons=0,mount=0,head=0,body=0,legs=0,feet=0}
  if player and player.getOutfit then
    local ok,o=pcall(function() return player:getOutfit() end)
    if ok and type(o)=="table" then o.type=tonumber(t.iconId) or 0; o.addons=0; o.mount=0; outfit=o end
  end
  if icon.setOutfit then pcall(function() icon:setOutfit(outfit) end) end
end
local function refreshTracker()
  if not rb.enabled then taskInterface:hide(); return end
  taskInterface:show(); taskInterface:raise()
  local t=cfg.current and TASKS[cfg.current]

  if not t then
    taskInterface.title:setText("Task Ragnar")
    taskInterface.content.info.taskName:setText("AGUARDANDO")
    taskInterface.content.icon:hide()
    trackerBar(0,0,"0/0")
    return
  end

  cfg.progress[cfg.current]=type(cfg.progress[cfg.current])=="table" and cfg.progress[cfg.current] or {kills=cfg.kills}

  -- Quando o Quest Tracker ja informou o andamento, ele vira a
  -- fonte da contagem exibida no painel Task Ragnar.
  -- No mobile ignora totalmente qualquer valor salvo pelo Quest Tracker
  -- e mantem somente a contagem local por loot/morte/dano.
  local questProgress=not ragnarIsMobile() and cfg.questTrackerProgress[cfg.current] or nil
  if type(questProgress)=="table" and (tonumber(questProgress.required) or 0)>0 then
    cfg.required=math.max(0,tonumber(questProgress.required) or 0)
    cfg.kills=math.min(cfg.required,math.max(0,tonumber(questProgress.kills) or 0))
  else
    cfg.required=ragnarRequired(cfg.current)
    cfg.kills=math.min(cfg.required,math.max(0,tonumber(cfg.progress[cfg.current].kills) or 0))
  end

  cfg.progress[cfg.current].kills=cfg.kills

  taskInterface.title:setText("Task Ragnar (Nivel "..t.level..")")
  taskInterface.content.info.taskName:setText(tostring(t.label):upper())
  trackerIcon(t)
  trackerBar(cfg.kills,cfg.required)
end
local function setTrackedTask(key)
  local t=TASKS[key]
  if not t then return end
  cfg.current,cfg.required=key,ragnarRequired(key)
  cfg.progress[key]=type(cfg.progress[key])=="table" and cfg.progress[key] or {kills=0}
  cfg.kills=math.min(cfg.required,math.max(0,tonumber(cfg.progress[key].kills) or 0))
  cfg.progress[key].kills=cfg.kills
  refreshTracker()
end
local function setTrackerMinimized(on)
  cfg.trackerMinimized=on==true
  if cfg.trackerMinimized then taskInterface.content:hide() else taskInterface.content:show() end
  taskInterface:setHeight(cfg.trackerMinimized and 32 or 90)
  taskInterface.minimize:setText(cfg.trackerMinimized and "+" or "-")
end
taskInterface.minimize.onClick=function() setTrackerMinimized(not cfg.trackerMinimized) end
taskInterface.onDragEnter=function(w,p) w:breakAnchors(); w.movingReference={x=p.x-w:getX(),y=p.y-w:getY()}; return true end
taskInterface.onDragMove=function(w,p)
  local r=w:getParent():getRect()
  local x=math.min(math.max(r.x,p.x-w.movingReference.x),r.x+r.width-w:getWidth())
  local y=math.min(math.max(r.y-w:getParent():getMarginTop(),p.y-w.movingReference.y),r.y+r.height-w:getHeight())
  w:move(x,y); cfg.trackerPos={x=x,y=y}; return true
end
if cfg.trackerPos.x and cfg.trackerPos.y then taskInterface:setPosition({x=cfg.trackerPos.x,y=cfg.trackerPos.y}) end
setTrackerMinimized(cfg.trackerMinimized)

local KS={seen={},counted={},death={},loot={},pending={},lastLoot={text="",source="",time=0},lastHit={text="",source="",time=0}}
local CANCEL_MSG,lastCancel="your task has been canceled",0
local pendingReportKey,pendingReportStarted=nil,0
local function taskCancelada(text) return norm(text):find(CANCEL_MSG,1,true)~=nil end
function ragnarClearTask()
  local key=cfg.current
  if key then
    cfg.progress[key]=nil
    cfg.questTrackerProgress[key]=nil
  end
  pendingReportKey,pendingReportStarted=nil,0
  cfg.current,cfg.kills,cfg.required=nil,0,0
  KS.seen,KS.counted,KS.death,KS.loot,KS.pending={},{},{},{},{}
  KS.lastLoot,KS.lastHit={text="",source="",time=0},{text="",source="",time=0}
  refreshTracker()
  return key
end
local function handleTaskCancel(text)
  if not taskCancelada(text) then return false end
  local t=tonumber(now) or os.time()*1000
  if t-lastCancel>500 then lastCancel=t; ragnarClearTask() end
  return true
end

local LOOT_PATTERNS={"[Ll]oot of an (.-):","[Ll]oot of a (.-):","[Ll]oot of the (.-):","[Ll]oot of (.-):"}
local HIT_PATTERNS={
  "^[Aa]n? (.-) [Ll]oses? %d+ [Hh]itpoints? due to your attack%.?$",
  "^[Tt]he (.-) [Ll]oses? %d+ [Hh]itpoints? due to your attack%.?$",
  "^(.-) [Ll]oses? %d+ [Hh]itpoints? due to your attack%.?$",
  "^[Yy]ou deal %d+ damage to an? (.-)%.?$",
  "^[Yy]ou deal %d+ damage to the (.-)%.?$",
  "^[Yy]ou deal %d+ damage to (.-)%.?$"
}
local function nowMs() return tonumber(now) or os.time()*1000 end
local function parseBy(text,patterns)
  text=tostring(text or "")
  for _,p in ipairs(patterns) do local mob=text:match(p); if mob then return mob end end
end
local function lootMob(text) return parseBy(text,LOOT_PATTERNS) end
local function hitMob(text) return parseBy(text,HIT_PATTERNS) end
local function taskMob(name,key)
  local t=TASKS[key or cfg.current]
  if not t then return false end
  name=norm(name)
  for _,mob in ipairs(t.creatures) do if name==norm(mob) then return true end end
  return false
end
local function tileStats(pos)
  local tile=pos and g_map.getTile(pos)
  local containers,items,top,topContainer=0,0,0,false
  if tile and tile.getItems then
    local list=tile:getItems() or {}; items=#list
    for _,item in ipairs(list) do
      if item.isContainer then local ok,v=pcall(function() return item:isContainer() end); if ok and v then containers=containers+1 end end
    end
    local thing=tile:getTopUseThing()
    if thing then
      if thing.getId then top=thing:getId() end
      if thing.isContainer then local ok,v=pcall(function() return thing:isContainer() end); topContainer=ok and v or false end
    end
  end
  return containers,items,top,topContainer
end
local function addKill()
  local t=cfg.current and TASKS[cfg.current]
  if not rb.enabled or not t then return end
  cfg.progress[cfg.current]=type(cfg.progress[cfg.current])=="table" and cfg.progress[cfg.current] or {kills=0}
  cfg.required=ragnarRequired(cfg.current)
  cfg.kills=math.min(cfg.required,(tonumber(cfg.progress[cfg.current].kills) or 0)+1)
  cfg.progress[cfg.current].kills=cfg.kills; refreshTracker()
end
local function queue(tab,name,value) name=norm(name); tab[name]=tab[name] or {}; table.insert(tab[name],value) end
local function consumeTime(tab,name,maxAge)
  local q,t=tab[norm(name)],nowMs()
  if not q then return false end
  while q[1] and t-q[1]>maxAge do table.remove(q,1) end
  if q[1] then table.remove(q,1); return true end
  tab[norm(name)]=nil; return false
end
local function track(c)
  if not rb.enabled or not cfg.current or not c or not taskMob(c:getName()) then return end
  if c.isMonster then local ok,v=pcall(function() return c:isMonster() end); if ok and not v then return end end
  local id,pos=c:getId(),c:getPosition()
  KS.seen[id]=KS.seen[id] or {id=id,name=c:getName(),task=cfg.current}
  local s=KS.seen[id]
  s.name,s.task,s.pos,s.time=c:getName(),cfg.current,pos,nowMs()
  s.hp=tonumber(c:getHealthPercent()) or s.hp or 100
  s.containers,s.items,s.top,s.topContainer=tileStats(pos)
  return s
end
local function countDeath(s)
  if not s or not s.hit or not rb.enabled or s.task~=cfg.current or not taskMob(s.name,s.task) then return end
  local t=nowMs()
  if KS.counted[s.id] and t-KS.counted[s.id]<5000 then return end
  KS.counted[s.id]=t
  if consumeTime(KS.loot,s.name,500) then return end
  addKill(); queue(KS.death,s.name,t)
end
local function pending(s)
  if not s then return end
  s.deadEvidence,s.deadAt=true,nowMs()
  if s.hit then return countDeath(s) end
  queue(KS.pending,s.name,s)
end
local function takePending(name,maxAge)
  local q,t=KS.pending[norm(name)],nowMs()
  if not q then return end
  while q[1] and t-(q[1].deadAt or 0)>maxAge do table.remove(q,1) end
  local s=table.remove(q,1)
  if #q==0 then KS.pending[norm(name)]=nil end
  return s
end
local function recentSeen(name)
  local best,a=0,g_game.getAttackingCreature()
  if a and norm(a:getName())==norm(name) then
    local s=KS.seen[a:getId()] or track(a)
    if s then return s end
  end
  local found
  for _,s in pairs(KS.seen) do
    if s.task==cfg.current and norm(s.name)==norm(name) and nowMs()-(s.time or 0)<2500 and (s.time or 0)>best then found,best=s,s.time end
  end
  return found
end
local function markHit(name)
  if not rb.enabled or not cfg.current or not taskMob(name) then return end
  local s=takePending(name,900) or recentSeen(name)
  if not s then return end
  s.hit,s.hitAt=true,nowMs()
  if s.deadEvidence or (tonumber(s.hp) or 100)<=0 then countDeath(s) end
end
local function handleHit(text,source)
  if not rb.enabled or not cfg.current then return end
  local mob=hitMob(text)
  if not mob or not taskMob(mob) then return end
  local sig,t=norm(text),nowMs()
  if sig==KS.lastHit.text and source~=KS.lastHit.source and t-KS.lastHit.time<250 then return end
  KS.lastHit={text=sig,source=source,time=t}; markHit(mob)
end
local function handleLoot(text,source)
  if not rb.enabled or not cfg.current then return end
  local mob=lootMob(text)
  if not mob or not taskMob(mob) then return end
  local sig,t=norm(text),nowMs()
  if sig==KS.lastLoot.text and source~=KS.lastLoot.source and t-KS.lastLoot.time<250 then return end
  KS.lastLoot={text=sig,source=source,time=t}
  if consumeTime(KS.death,mob,1500) then return end
  addKill(); queue(KS.loot,mob,t)
end
local function healthChange(c,hp)
  if not rb.enabled or not cfg.current or not c then return end
  local id=c:getId()
  local s=KS.seen[id]
  if not s then
    local a=g_game.getAttackingCreature()
    if not a or a:getId()~=id then return end
    s=track(c)
  end
  if not s or s.task~=cfg.current then return end
  hp=tonumber(hp) or tonumber(c:getHealthPercent()) or s.hp or 100
  s.hp,s.pos,s.time=hp,c:getPosition(),nowMs()
  if hp<=0 then pending(s) end
end

if type(onAttackingCreatureChange)=="function" then onAttackingCreatureChange(function(c) if c then track(c) end end) end
if type(onCreatureHealthPercentChange)=="function" then onCreatureHealthPercentChange(function(c,hp) healthChange(c,hp) end) end
if type(onCreaturePositionChange)=="function" then
  onCreaturePositionChange(function(c,newPos)
    local s=c and KS.seen[c:getId()]
    if s and newPos then
      s.pos,s.time=newPos,nowMs()
      s.containers,s.items,s.top,s.topContainer=tileStats(newPos)
    end
  end)
end
if type(onCreatureDisappear)=="function" then
  onCreatureDisappear(function(c)
    if not rb.enabled or not cfg.current or not c then return end
    local s=KS.seen[c:getId()]
    if not s or s.task~=cfg.current then return end
    local ok,hp=pcall(function() return c:getHealthPercent() end)
    hp=ok and tonumber(hp) or s.hp
    if hp and hp<=0 then pending(s); return end
    local bc,bi,bt,pos=s.containers or 0,s.items or 0,s.top or 0,s.pos
    schedule(100,function()
      if not rb.enabled or cfg.current~=s.task then return end
      local containers,items,top,topContainer=tileStats(pos)
      if containers>bc or (topContainer and top~=bt) or (s.hit and items>bi) then pending(s) end
    end)
  end)
end

macro(50,function()
  if not rb.enabled or not cfg.current then return end
  local c=g_game.getAttackingCreature()
  if c then
    local s=KS.seen[c:getId()] or track(c)
    if s then
      s.time,s.pos=nowMs(),c:getPosition()
      local hp=tonumber(c:getHealthPercent())
      if hp then s.hp=hp; if hp<=0 then pending(s) end end
      s.containers,s.items,s.top,s.topContainer=tileStats(s.pos)
    end
  end
end)
macro(1000,function()
  local t=nowMs()
  for id,s in pairs(KS.seen) do if t-(s.time or 0)>12000 then KS.seen[id]=nil end end
  for id,v in pairs(KS.counted) do if t-v>6000 then KS.counted[id]=nil end end
  for name,q in pairs(KS.pending) do
    while q[1] and t-(q[1].deadAt or 0)>1200 do table.remove(q,1) end
    if #q==0 then KS.pending[name]=nil end
  end
  if rb.enabled then if not taskInterface:isVisible() then refreshTracker() end elseif taskInterface:isVisible() then taskInterface:hide() end
end)

local function caveDoNivel(n) return "LNS_Task"..n end
local function caveRagnar(v) return type(v)=="string" and v:match("^LNS_Task[1-7]$")~=nil end
local function setRagnar(on)
  rb.enabled=on==true; ragnarButton.title:setOn(rb.enabled)
  local caveCfg,targetCfg=storage._configs.cavebot_configs,storage._configs.targetbot_configs
  if rb.enabled then
    local cave=caveDoNivel(cfg.level)
    if caveCfg.selected~=cave then CaveBot.setOff(); caveCfg.selected=cave end
    if targetCfg.selected~="Target_Tasks" then TargetBot.setOff(); targetCfg.selected="Target_Tasks" end
    CaveBot.setOn(); TargetBot.setOn(); refreshTracker()
  else
    taskInterface:hide()
    if caveRagnar(caveCfg.selected) then CaveBot.setOff(); TargetBot.setOff() end
  end
end

ragnarButton.title.onClick=function(w) setRagnar(not w:isOn()) end
ragnarButton.settings.onClick=function() ragnarInterface:show(); ragnarInterface:raise(); ragnarInterface:focus() end
ragnarInterface.closePanel.onClick=function() ragnarInterface:hide() end

local ROW_UI=[=[
Button
  height: 21
  margin-bottom: 1
  margin-right: 1
  font: cipsoftFont
  text-align: left
  text-offset: 4 0
]=]
local nivelButtons,nivelButton,taskButton,taskKey,taskConcluida={}

local function marcar(w,on)
  if w.setChecked then w:setChecked(on) end
  if w.setPressed then w:setPressed(on) end
  if w.setOn then w:setOn(on) end
  w:setOpacity(on and 1 or .74)
  w:setColor(on and "#d7c08a" or (w.taskConcluida and "#8fcf70" or "gray"))
end

local function limpar(w)
  local c=w:getChildren()
  for i=#c,1,-1 do c[i]:destroy() end
end

local function tooltip(t)
  local required=ragnarRequired(t.key)
  local specificExtra=RAGNAR_REQUIRED_EXTRA[t.key] or 0
  local mobileExtra=ragnarIsMobile() and RAGNAR_MOBILE_EXTRA or 0
  local totalExtra=specificExtra+mobileExtra

  return "Required: "..required..
         (totalExtra>0 and " ("..t.required.." + "..totalExtra.." safety)" or "")..
         "\nCreatures: "..(#t.creatures>0 and table.concat(t.creatures,", ") or "N/A")
end

local function selecionarTask(b,chave,concluida)
  if taskButton and taskButton~=b then marcar(taskButton,false) end
  taskButton,taskKey,taskConcluida=b,chave,concluida
  marcar(b,true)
end

local function addTask(lista,chave,concluida)
  local t=TASKS[chave]
  if not t then return end
  local b=setupUI(ROW_UI,lista)
  b.taskKey,b.taskData,b.taskConcluida=chave,t,concluida
  b:setText(t.label); b:setTooltip(tooltip(t)); marcar(b,false)
  b.onClick=function() selecionarTask(b,chave,concluida) end
end

local function atualizar()
  limpar(ragnarInterface.listTaskRagnar); limpar(ragnarInterface.listTaskConcl)
  taskButton,taskKey,taskConcluida=nil,nil,nil
  for _,chave in ipairs(TASKS_BY_LEVEL[cfg.level]) do
    local concluida=cfg.completed[chave]==true
    addTask(concluida and ragnarInterface.listTaskConcl or ragnarInterface.listTaskRagnar,chave,concluida)
  end
end

local function selecionarNivel(nivel)
  if nivelButton and nivelButton~=nivelButtons[nivel] then marcar(nivelButton,false) end
  if cfg.current and TASKS[cfg.current] and TASKS[cfg.current].level~=nivel then cfg.current,cfg.kills,cfg.required=nil,0,0 end
  cfg.level,nivelButton=nivel,nivelButtons[nivel]
  marcar(nivelButton,true); atualizar(); if rb.enabled then setRagnar(true) end
end

for i,nome in ipairs(nomes) do
  local b=g_ui.createWidget("Button",ragnarInterface.flatp)
  b:setText(nome); b:setWidth(i==1 and 18 or 49); b:setHeight(22); b:setFont("cipsoftFont")
  if i==1 then b:setTooltip("Selecione o Nivel da Task para prosseguir.")
  else
    local nivel=i-1
    nivelButtons[nivel]=b; marcar(b,false)
    b.onClick=function() selecionarNivel(nivel) end
  end
end

ragnarInterface.transferToConcl.onClick=function()
  if not taskKey or taskConcluida then return end
  cfg.completed[taskKey]=true; atualizar()
end

ragnarInterface.transferToList.onClick=function()
  if not taskKey or not taskConcluida then return end
  cfg.completed[taskKey]=nil; atualizar()
end

selecionarNivel(cfg.level)
setRagnar(rb.enabled)
ragnarInterface:hide()

function ragnarAvailableTasks()
  local out={}
  for _,key in ipairs(TASKS_BY_LEVEL[cfg.level] or {}) do
    if TASKS[key] and cfg.completed[key]~=true then out[#out+1]=key end
  end
  return out
end
function ragnarActiveTask()
  local key=cfg.current
  return key and TASKS[key] and TASKS[key].level==cfg.level and cfg.completed[key]~=true and key or nil
end
function ragnarHasTask() return ragnarActiveTask()~=nil end


-- =========================================================
-- HUNTING TASKS -> QUEST TRACKER AUTOMATICO
-- Usa TASKS[cfg.current].label e somente roda quando
-- o botao principal Task Ragnar estiver ligado.
-- Nao usa connect, disconnect ou g_clock.
-- =========================================================
local ragnarQuestTrackerState={
  key=nil,
  phase="idle",
  questId=nil,
  trackData=nil,
  lastAction=0,
  waitUntil=0,
  lastError=0
}

local function rqtNormalize(text)
  return tostring(text or "")
    :lower()
    :gsub("’","'")
    :gsub("%(completed%)","")
    :gsub("[^%w]+"," ")
    :gsub("^%s+","")
    :gsub("%s+$","")
    :gsub("%s+"," ")
end

local function rqtMissionName(text)
  text=tostring(text or ""):gsub("%s*%([Cc]ompleted%)%s*$","")
  return rqtNormalize(text:match(":%s*(.+)$") or text)
end

local function rqtChildren(widget)
  if not widget or not widget.getChildren then return {} end
  return widget:getChildren() or {}
end

local function rqtCurrentTask()
  if not rb.enabled then return nil,nil end

  local key=cfg.current
  local task=key and TASKS[key]

  if not task or task.level~=cfg.level or cfg.completed[key]==true then
    return nil,nil
  end

  return key,task
end

local function rqtTrackerText(widget)
  if not widget then return "" end

  if widget.description and widget.description.getText then
    return widget.description:getText() or ""
  end

  if widget.getText then
    return widget:getText() or ""
  end

  return ""
end

local function rqtParseProgress(description)
  local kills,required=tostring(description or ""):match(
    "([%d%.,]+)%s*/%s*([%d%.,]+)"
  )

  if not kills or not required then return nil,nil end

  local killsDigits=kills:gsub("[^%d]","")
  local requiredDigits=required:gsub("[^%d]","")

  kills=tonumber(killsDigits)
  required=tonumber(requiredDigits)

  if not kills or not required or required<=0 then return nil,nil end
  return math.max(0,kills),math.max(0,required)
end

local function rqtSyncTaskPanel(widget,key)
  local description=rqtTrackerText(widget)
  local kills,required=rqtParseProgress(description)
  if not kills or not required then return end

  local previous=cfg.questTrackerProgress[key]
  local changed=type(previous)~="table"
    or tonumber(previous.kills)~=kills
    or tonumber(previous.required)~=required

  cfg.questTrackerProgress[key]={
    kills=kills,
    required=required,
    description=description
  }

  cfg.progress[key]=type(cfg.progress[key])=="table" and cfg.progress[key] or {}
  cfg.progress[key].kills=kills
  cfg.kills=kills
  cfg.required=required

  if changed then refreshTracker() end
end

local function rqtTrackerMatches(description,task)
  local text=" "..rqtNormalize(description).." "
  local label=" "..rqtNormalize(task and task.label).." "

  if label=="  " or not text:find(label,1,true) then
    return false
  end

  -- Ajuda a diferenciar nomes parecidos, por exemplo:
  -- Cults / Minotaur Cults / Orc Cults.
  local _,required=tostring(description or ""):match(
    "([%d%.,]+)%s*/%s*([%d%.,]+)"
  )

  if required then
    local requiredDigits=required:gsub("[^%d]","")
    required=tonumber(requiredDigits)
    if required and tonumber(task.required) and required~=tonumber(task.required) then
      return false
    end
  end

  return true
end

local function rqtGetTrackerList(questModule)
  local window=questModule and questModule.trackerWindow
  local panel=window and window.contentsPanel
  return panel and panel.list or nil
end

local function rqtFindTaskInTracker(questModule,task)
  local trackerList=rqtGetTrackerList(questModule)
  if not trackerList then return nil end

  local trackData=ragnarQuestTrackerState.trackData
  if trackData and trackerList.getChildById then
    local widget=trackerList:getChildById(trackData)
    if widget and widget:isVisible() then return widget end
  end

  for _,widget in pairs(rqtChildren(trackerList)) do
    if widget:isVisible() and rqtTrackerMatches(rqtTrackerText(widget),task) then
      return widget
    end
  end

  return nil
end

local function rqtFindHuntingTasks(questModule)
  local questWindow=questModule.window
  local questList=questWindow.questlog.questList

  for _,widget in pairs(rqtChildren(questList)) do
    local name=widget.questName
    if not name and widget.getText then name=widget:getText() end

    if rqtNormalize(name)=="hunting tasks" then
      return widget
    end
  end

  return nil
end

local function rqtFindMission(questModule,task)
  local missionList=questModule.window.missionlog.missionList
  local wanted=rqtNormalize(task.label)

  for _,widget in pairs(rqtChildren(missionList)) do
    local name=widget.getText and widget:getText() or ""

    -- Compara exatamente apos remover o prefixo, por exemplo:
    -- "Adventurer: Feyrist Surface" -> "Feyrist Surface".
    if widget:isVisible() and rqtMissionName(name)==wanted then
      return widget
    end
  end

  return nil
end

local function rqtReset(key)
  local state=ragnarQuestTrackerState
  state.key=key
  state.phase=key and "requestQuestLog" or "idle"
  state.questId=nil
  state.trackData=nil
  state.lastAction=0
  state.waitUntil=0
end

local function rqtRun()
  -- O cliente mobile nao possui Quest Log/Quest Tracker.
  -- Nao solicita quest log, nao procura Hunting Tasks e nao abre janelas.
  -- A contagem continua normalmente pelo sistema local da script.
  if ragnarIsMobile() then
    local state=ragnarQuestTrackerState
    if state.key or state.phase~="idle" then rqtReset(nil) end
    return
  end

  if not g_game.isOnline() then return end

  local key,task=rqtCurrentTask()
  local state=ragnarQuestTrackerState

  if not key then
    if state.key or state.phase~="idle" then rqtReset(nil) end
    return
  end

  if state.key~=key then
    rqtReset(key)
    print("[Ragnar Tracker] Task ativa: "..tostring(task.label))
  end

  local questModule=modules and modules.game_questlog
  if not questModule or not questModule.window or not questModule.trackerWindow then
    return
  end

  local questWindow=questModule.window
  local trackerWindow=questModule.trackerWindow
  local currentTime=tonumber(now) or 0

  -- A task atual ja esta no tracker: sincroniza o painel Ragnar
  -- com a contagem oficial exibida pelo Quest Tracker.
  local trackedWidget=rqtFindTaskInTracker(questModule,task)
  if trackedWidget then
    rqtSyncTaskPanel(trackedWidget,key)

    if not trackerWindow:isVisible() then
      trackerWindow:show()
      trackerWindow:raise()
    end

    if questWindow:isVisible() then questWindow:hide() end

    if state.phase~="done" then
      print("[Ragnar Tracker] Mostrando no Quest Tracker: "..tostring(task.label))
    end

    state.phase="done"
    return
  end

  -- Foi removida do tracker ou a task ativa mudou.
  if state.phase=="done" then
    state.phase="requestQuestLog"
    state.lastAction=0
  end

  -- 1. Abre o Quest Log.
  if state.phase=="requestQuestLog" then
    if questWindow:isVisible() and questWindow.questlog:isVisible() then
      state.phase="findHuntingTasks"
      return
    end

    if currentTime-state.lastAction>=1000 then
      state.lastAction=currentTime
      g_game.requestQuestLog()
    end

    return
  end

  -- 2. Seleciona Hunting Tasks.
  if state.phase=="findHuntingTasks" then
    if not questWindow:isVisible() or not questWindow.questlog:isVisible() then
      state.phase="requestQuestLog"
      return
    end

    local huntingTasks=rqtFindHuntingTasks(questModule)

    if not huntingTasks then
      if currentTime-state.lastAction>=2000 then
        state.phase="requestQuestLog"
        state.lastAction=0
      end
      return
    end

    questWindow.questlog.questList:focusChild(huntingTasks)
    state.questId=huntingTasks.questId
    state.lastAction=currentTime
    state.phase="findMission"

    if type(questModule.showQuestLine)=="function" then
      questModule.showQuestLine()
    else
      state.phase="requestQuestLog"
    end

    return
  end

  -- 3. Procura a LABEL da task ativa dentro de Hunting Tasks.
  if state.phase=="findMission" then
    local missionLog=questWindow.missionlog

    if not questWindow:isVisible() or not missionLog:isVisible() then
      if currentTime-state.lastAction>=3000 then
        state.phase="requestQuestLog"
        state.lastAction=0
      end
      return
    end

    local mission=rqtFindMission(questModule,task)

    if not mission then
      if currentTime-state.lastAction>=3000 then
        warn("[Ragnar Tracker] Task nao encontrada em Hunting Tasks: "..tostring(task.label))
        state.phase="requestQuestLog"
        state.lastAction=currentTime
      end
      return
    end

    missionLog.missionList:focusChild(mission)
    state.trackData=mission.trackData or (mission.getId and mission:getId())
    state.phase="enableTracker"
    state.waitUntil=currentTime+300
    return
  end

  -- 4. Marca Show in quest tracker.
  if state.phase=="enableTracker" then
    if currentTime<state.waitUntil then return end

    local missionLog=questWindow.missionlog
    if not questWindow:isVisible() or not missionLog:isVisible() then
      state.phase="requestQuestLog"
      return
    end

    local missionList=missionLog.missionList
    local focused=missionList:getFocusedChild()

    if not focused or (state.trackData and focused.trackData~=state.trackData) then
      local missionWidget=nil
      if state.trackData and missionList.getChildById then
        missionWidget=missionList:getChildById(state.trackData)
      end

      if missionWidget then
        missionList:focusChild(missionWidget)
        state.waitUntil=currentTime+300
      else
        state.phase="findMission"
        state.lastAction=currentTime
      end
      return
    end

    local checkbox=missionLog.track
    if not checkbox or not checkbox:isEnabled() then return end

    local trackerList=rqtGetTrackerList(questModule)
    local trackerWidget=nil

    if trackerList and state.trackData and trackerList.getChildById then
      trackerWidget=trackerList:getChildById(state.trackData)
    end

    if not trackerWidget or not trackerWidget:isVisible() then
      checkbox:setChecked(false)
      questModule.onTrackOptionChange(checkbox)
    end

    questWindow:hide()
    trackerWindow:show()
    trackerWindow:raise()

    state.phase="verify"
    state.waitUntil=currentTime+500
    return
  end

  -- 5. Confirma que a LABEL atual esta aparecendo no tracker.
  if state.phase=="verify" then
    if currentTime<state.waitUntil then return end

    if rqtFindTaskInTracker(questModule,task) then
      state.phase="done"
      print("[Ragnar Tracker] Adicionada com sucesso: "..tostring(task.label))
      return
    end

    state.phase="requestQuestLog"
    state.lastAction=currentTime
  end
end

-- Macro sem nome: nao cria um segundo botao no painel.
-- Ela somente executa quando rb.enabled estiver ativo.
macro(200,function()
  local ok,err=pcall(rqtRun)
  if ok then return end

  local state=ragnarQuestTrackerState
  local currentTime=tonumber(now) or 0

  if currentTime-state.lastError>=3000 then
    state.lastError=currentTime
    warn("[Ragnar Tracker] Erro: "..tostring(err))
  end
end)
local function ragnarTaskComplete(key)
  local task=key and TASKS[key]
  if not task then return false,0,0 end
  local progress=cfg.progress[key]
  local kills=tonumber(progress and progress.kills) or tonumber(cfg.kills) or 0
  local required=ragnarRequired(key)
  return required>0 and kills>=required,kills,required
end
function ragnarGotoTask()
  local active=ragnarActiveTask()
  local label

  if active then
    local complete=ragnarTaskComplete(active)
    label=complete and "reportTask" or active
  else
    local available=ragnarAvailableTasks()
    label=#available>0 and "pegar_task" or "Trainer"
  end

  CaveBot.gotoLabel(label)
  return label
end

local npcBusy=false
local function npcSequence(words,done,i)
  i=i or 1
  if not words[i] then npcBusy=false; if done then done() end; return end
  NPC.say(words[i])
  schedule(1000,function() npcSequence(words,done,i+1) end)
end
local function startNpcSequence(words,done)
  if npcBusy then return false end
  npcBusy=true; npcSequence(words,done); return true
end
local REPORT_CONFIRMATIONS={
  "task is complete",
  "reward has been granted",
  "you have my thanks",
  "deeds strengthen these lands",
  "seek another hunt",
  "speak task when you are ready"
}
local REPORT_CONFIRM_TIMEOUT=20000

local function isRagnarReportConfirmation(text)
  local msg=norm(text)
  for _,fragment in ipairs(REPORT_CONFIRMATIONS) do
    if msg:find(fragment,1,true) then return true end
  end
  return false
end

local function handleRagnarReportConfirmation(name,text)
  if name and norm(name)~="ragnar" then return false end
  if not isRagnarReportConfirmation(text) then return false end

  local key=cfg.current
  if not key or not TASKS[key] then return false end

  -- A mensagem do NPC é a confirmação final da entrega.
  -- Não depende do timer, do pendingReportKey ou do contador local.
  pendingReportKey,pendingReportStarted=nil,0
  cfg.completed[key]=true
  ragnarClearTask()
  atualizar()
  print("Task Ragnar: task reportada e confirmada pelo NPC.")
  return true
end

function ragnarReportTask()
  local key=ragnarActiveTask()
  if not key or pendingReportKey then return false end

  local complete,kills,required=ragnarTaskComplete(key)
  if not complete then
    print("Task Ragnar: task incompleta ("..kills.."/"..required.."). Report cancelado.")
    return false,kills,required
  end

  pendingReportKey,pendingReportStarted=key,nowMs()
  if not startNpcSequence({"hi","task", "report","yes"}) then
    pendingReportKey,pendingReportStarted=nil,0
    return false
  end

  schedule(REPORT_CONFIRM_TIMEOUT,function()
    if pendingReportKey==key and nowMs()-pendingReportStarted>=REPORT_CONFIRM_TIMEOUT then
      pendingReportKey,pendingReportStarted=nil,0
      print("Task Ragnar: nenhuma confirmação de conclusão foi recebida; a task foi mantida ativa.")
    end
  end)

  return true
end

onTalk(function(name,level,mode,text,channelId)
  if name and norm(name)=="ragnar" then
    if handleTaskCancel(text) then return end
    if handleRagnarReportConfirmation(name,text) then return end
  end
  if not rb.enabled then return end
  if channelId==11 then handleLoot(text,"talk"); handleHit(text,"talk") end
  if name and norm(name)=="ragnar" then local key=parseHunt(text); if key then setTrackedTask(key) end end
end)
onTextMessage(function(mode,text)
  if handleTaskCancel(text) then return end
  if handleRagnarReportConfirmation(nil,text) then return end
  if not rb.enabled then return end
  local key=parseHunt(text); if key then setTrackedTask(key) end
  handleHit(text,"text"); handleLoot(text,"text")
end)
function ragnarRandomTask()
  if npcBusy or ragnarActiveTask() then return false end
  local list=ragnarAvailableTasks()
  if #list==0 then return nil end
  local key=list[math.random(#list)]
  if not startNpcSequence({"hi","task",TASKS[key].label,"yes"}) then return false end
  return key,TASKS[key]
end

local ragnarCaveAtual = nil

function ragnarSetCaveTask(taskKey)
  if not TASKS[taskKey] then
    print("Task Ragnar: cave inválida: "..tostring(taskKey))
    return false
  end

  ragnarCaveAtual = taskKey
  return true
end

function checkRagnarAndamento(labelTask, labelSaida)
  local taskAtiva = ragnarActiveTask()

  -- Só valida a cave quando ela tiver sido configurada
  if ragnarCaveAtual and taskAtiva ~= ragnarCaveAtual then
    print(
      "Task Ragnar: cave incorreta. Task ativa: "..
      tostring(taskAtiva).." | Cave atual: "..tostring(ragnarCaveAtual)
    )

    CaveBot.gotoLabel(labelSaida)
    return false, labelSaida, 0, 0, "cave_incorreta"
  end

  local concluida, kills, required = ragnarTaskComplete(taskAtiva)
  local label = concluida and labelSaida or labelTask

  CaveBot.gotoLabel(label)

  return concluida, label, kills, required
end

function checkSupplies(labelSemSupply,labelComSupply)
  if not Supplies or type(Supplies.hasEnough)~="function" then
    print("CaveBot[SupplyCheck]: Supplies.hasEnough não está disponível.")
    return false
  end

  local data=Supplies.hasEnough()

  if type(data)=="table" then
    print(
      "CaveBot[SupplyCheck]: Supply insuficiente. Item: "..
      tostring(data.id).." | Quantidade: "..tostring(data.amount)
    )

    if labelSemSupply then
      CaveBot.gotoLabel(labelSemSupply)
    end

    return false,data
  end

  if labelComSupply then
    CaveBot.gotoLabel(labelComSupply)
  end

  return true
end

end)
