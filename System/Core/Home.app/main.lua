shell.setDir("")
-- shell.openTab("Diamond/System/Core/Notifications.app/main.lua")
-- will use when ready

local theAppList = {}
local uses24hour = false

local function updateHomeTime()
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.lightGray)
  term.setCursorPos(2,2)
  term.clearLine()
  term.write(textutils.formatTime(os.time(), uses24hour))
  term.setTextColor(colors.gray)
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
    local text, bg, tColor
    if fs.exists(fs.combine(theApp, "settings")) then
      local h = fs.open(fs.combine(theApp, "settings"), "r")
      text = h.readLine()
      bg = tonumber(h.readLine())
      tColor = tonumber(h.readLine())
      h.close()
    else
      text = fs.getName(theApp)
      bg = colors.gray
      tColor = colors.lightGray
    end
    term.setBackgroundColor(bg)
    term.setTextColor(tColor)
    term.clearLine()
    print(" "..text)
  end
  theAppList = appList
  
  local w, h = term.getSize()
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.lightGray)
  term.setCursorPos(1,h-2)
  term.clearLine()
  print("")
  term.clearLine()
  print(" ^ ")
  term.clearLine()
  term.setTextColor(colors.gray)
  term.setCursorBlink(true)
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
  if (event == "term_resize") then
    updateHomeScreen()
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
        local h = fs.open(fs.combine(theAppList[appY], "settings"), "r")
        if h then
          multishell.setTitle(tab, h.readLine())
        else
          multishell.setTitle(tab, fs.getName(theAppList[appY]))
        end
        h.close()
      end
    elseif y > (h - 3) then
      -- Clicked menu
      -- Draw menu
      term.setCursorPos(1,h-6)
      term.setBackgroundColor(colors.lightGray)
      term.setTextColor(colors.gray)
      print("          ")
      print(" Shutdown ")
      print(" Restart  ")
      print("          ")
      while true do
        local e, btn, aX, aY, aZ = os.pullEvent()
        if e == "mouse_click" then
          if aX < 11 then
            if (aY > (h - 7)) and (aY < (h - 2)) then
              if aY == (h - 5) then
                os.shutdown()
              elseif aY == (h - 4) then
                os.reboot()
              end
            else
              break
            end
          else
            break
          end
        end
        if e == "timer" then
          if btn == timer then
            updateHomeTime()
            timer = os.startTimer(0.1)
          end
        end
      end
      updateHomeScreen()
    else
      if uses24hour then
        uses24hour = false
      else
        uses24hour = true
      end
      updateHomeTime()
    end
  end
end
