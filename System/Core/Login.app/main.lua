term.setBackgroundColor(colors.lightGray)
term.clear()
term.setBackgroundColor(colors.gray)
local function clearLine(line)
  term.setCursorPos(1,line)
  term.clearLine()
end
clearLine(4)
clearLine(3)
clearLine(2)
clearLine(1)
term.setCursorPos(1,1)
term.setTextColor(colors.lightGray)
term.write("Diamond")
term.setCursorPos(2,3)
term.write("Welcome to Diamond")
term.setBackgroundColor(colors.lightGray)
term.setTextColor(colors.gray)

local function checkForUsers()
  if fs.exists("/Users") then
    local userList = {}
    local rawUserList = fs.list("/Users")
    for theUserKey,theUserName in ipairs(rawUserList) do
      if fs.isDir(fs.combine("/Users", theUserName)) then
        if not(string.sub(theUserName, 1, 1) == ".") then
          userList[#userList+1] = theUserName
        end
      end
    end
    return userList
  else
    return {}
  end
end
local selected
local theUsers = checkForUsers()
if #theUsers == 0 then
  term.setCursorPos(2,6)
  term.write("Welcome!")
  term.setCursorPos(2,7)
  print("Please type in a new username:")
  print(" (You can set a password in Settings later)")
  write(" ")
  local theNewName
  while true do
    local newName = read()
    if (newName == "") or (string.sub(newName, 1, 1) == ".") then
      local x,y = term.getCursorPos()
      term.setCursorPos(2,y-1)
      term.clearLine()
    else
      theNewName = newName
      break
    end
  end
  if fs.exists(fs.combine("/Users", theNewName)) then
    fs.delete(fs.combine("/Users", theNewName))
  end
  fs.makeDir(fs.combine("/Users", theNewName))
  selected = theNewName
else
  term.setCursorPos(1,6)
  for theUserKey,theUserName in ipairs(theUsers) do
    write(" ")
    print(theUserName)
  end
  print(" Hold CTRL+S to shutdown")
  print(" Hold CTRL+R to restart")
  while true do
    local e, btn, x, y = os.pullEvent("mouse_click")
    if theUsers[y-5] then
      selected = theUsers[y-5]
      break
    end
  end
end
local appPath = fs.getDir(shell.getRunningProgram())
shell.setDir("")
shell.run(fs.combine(appPath, "login.lua"), selected)
