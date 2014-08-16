DSystemPath = fs.getDir(fs.getDir(fs.getDir(shell.getRunningProgram())))

term.setBackgroundColor(colors.lightBlue)
term.clear()

local loginPath = fs.combine(DSystemPath, "System/Core/Login.app/main.lua")
shell.setDir("/")
shell.run(loginPath)
