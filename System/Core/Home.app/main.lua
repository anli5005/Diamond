shell.setDir("")
shell.openTab("Diamond/System/Core/Notifications.app/main.lua")

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
  term.setCursorPos(4,2)
  for appKey,theApp in ipairs(appList) do
    local h = fs.open(fs.combine(theApp, "settings"), "r")
    local text = h.readLine()
    local bg = h.readLine()
    local tColor = h.readLine()
    h.close()
    term.setBackgroundColor(bg)
    term.setTextColor(tColor)
    term.clearLine()
    print(" "..text)
  end
end

updateHomeScreen()
multishell.setTitle(multishell.getCurrent(), "Diamond")
local timer = os.startTimer(0.1)
while true do
  event, p1, p2, p3, p4, p5 = os.pullEvent()
  if (event == "timer") and (p1 == timer) then
    updateHomeTime()
    timer = os.startTimer(0.1)
  end
end
