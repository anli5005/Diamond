DSystemPath = fs.getDir(fs.getDir(fs.getDir(shell.getRunningProgram())))

term.setBackgroundColor(colors.lightBlue)
term.clear()

os.loadAPI(fs.combine(DSystemPath, "System/APIs/S"))

local loginPath = fs.combine(DSystemPath, "System/Core/Login/main.lua")
shell.setDir("/")
shell.run(loginPath)
