local args = {...}
DLogged = args[1]
term.setBackgroundColor(colors.gray)
term.setTextColor(colors.lightGray)
term.clear()
term.setCursorPos(1,1)
print("Diamond")
print(" ")
print(" Welcome, "..DLogged.."!")
shell.setDir("")
shell.run("Diamond/System/Core/Home.app/main.lua")
