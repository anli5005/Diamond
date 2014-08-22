term.setCursorBlink(false)
term.setBackgroundColor(colors.gray)
term.setTextColor(colors.lightGray)
while true do
  local args = {...}
  local willBreak = false
  if fs.exists("Users/"..args[1].."/Diamond/Security") then
    local h = fs.open("Users/"..args[1].."/Diamond/Security", "r")
    local p = h.readAll()
    h.close()
    if not(p == "") then
      local try = ""
      while true do
        term.clear()
        term.setCursorPos(1,1)
        print("Diamond")
        print(" ")
        if try == "" then
          print(" Enter password for "..args[1])
        elseif not(try == p) then
          print(" Wrong password")
        end
        write(" ")
        try = read("*")
        if try == p then
          break
        end
        if try == "" then
          willBreak = true
          break
        end
      end
    end
  end
  if willBreak then
    break
  end
  multishell.DLogged = args[1]
  term.clear()
  term.setCursorPos(1,1)
  print("Diamond")
  print(" ")
  print(" Welcome, "..multishell.DLogged.."!")
  shell.setDir("")
  shell.run("Diamond/System/Core/Home.app/main.lua")
  break
end
