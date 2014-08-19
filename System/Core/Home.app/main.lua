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
    if fs.isDir(theFilePath) then
      if not(string.sub(theFilePath,1,1) == ".") then
        if fs.exists(fs.combine(theFilePath,"main.lua")) then
          appList[#appList+1] = theFilePath
        end
      end
    end
  end
  term.setCursorPos(2,3)
  print(textutils.serialize(appList))
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
