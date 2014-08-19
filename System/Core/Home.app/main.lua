shell.setDir("")
shell.openTab("Diamond/System/Core/Notifications.app/main.lua")

local theAppList = {}

local function updateHomeTime()
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.lightGray)
  term.setCursorPos(2,2)
  term.clearLine()
  term.write(textutils.formatTime(os.time(), false))
end

local function updateHomeScreen()
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.lightGray)
  term.clear()
  updateHomeTime()
  
  local rawAppList = fs.list("/Apps")
  local appList = {}
  for appKey,theFilePath in ipairs(rawAppList) do
    local realFilePath = fs.combine("/Apps", theFilePath)
    if fs.isDir(realFilePath) then
      if not(string.sub(theFilePath,1,1) == ".") then
        if fs.exists(fs.combine(realFilePath,"main.lua")) then
          appList[#appList+1] = realFilePath
        end
      end
    end
  end
  term.setCursorPos(1,4)
  for appKey,theApp in ipairs(appList) do
    local h = fs.open(fs.combine(theApp, "settings"), "r")
    local text = h.readLine()
    local bg = tonumber(h.readLine())
    local tColor = tonumber(h.readLine())
    h.close()
    term.setBackgroundColor(bg)
    term.setTextColor(tColor)
    term.clearLine()
    print(" "..text)
  end
  theAppList = appList
end

updateHomeScreen()
multishell.setTitle(multishell.getCurrent(), "Diamond")
local timer = os.startTimer(0.1)
while true do
  local event, p1, p2, p3, p4, p5 = os.pullEvent()
  if (event == "timer") and (p1 == timer) then
    updateHomeTime()
    timer = os.startTimer(0.1)
  end
  if (event == "mouse_click") then
    local b = p1
    local x = p2
    local y = p3
    local w,h = term.getSize()
    if (y > 3) and (y < (h - 2)) then
      -- Clicked inside apps
      local appY = y - 3
      if theAppList[appY] then
        shell.setDir("")
        local tab = shell.openTab(fs.combine(theAppList[appY], "main.lua"))
        shell.switchTab(tab)
        multishell.setTitle(tab, fs.getName(theAppList[appY]))
      end
    elseif y > (h - 3) then
      -- Clicked menu
    else
      -- Clicked clock
    end
  end
end
