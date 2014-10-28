local parent = term.current()
local w, h = parent.getSize()

local processes = {}
local currentP = nil
local runningP = nil
local windowOrder = {}

local function crash(result)
  -- I'm going to makes this useful later, but for now this calls printError
  printError(result)
end

local function focusWindow(n)
end

local function setWindowTitle(n, title)
  processes[n].title = title
end

local function resumeProcess(n, event, ...)
  local process = processes[n]
  local filter = process.filter
  if filter == nil or filter == event or event == "terminate" then
    local prevProcess = runningP
    runningP = n
    term.redirect(process.window)
    local ok, result = coroutine.resume(process.co, event, ...)
    process.window = term.current()
    if ok then
      process.filter = result
    else
      printError(result)
    end
    runningP = prevProcess
  end
end

local function launch(isWindow, env, filepath, ...)
  local args = {...}
  local n = #processes + 1
  local process = {}
  process.title = "App"
  process.borderWindow = window.create(parent, 1, 2, w, h-5, true)
  if isWindow then
    process.window = window.create(process.borderWindow, 2, 3, w-2, h-7, true)
    process.borderWindow.setBackgroundColor(colors.lightGray)
    process.borderWindow.clear()
    process.borderWindow.setCursorPos(1,1)
    process.borderWindow.write("App")
    process.borderWindow.redraw()
  else
    process.window = process.borderWindow
  end
  process.co = coroutine.create(function()
    os.run(env, filepath, unpack(args))
  end)
  process.isWindow = isWindow
  process.filter = nil
  processes[n] = process
  resumeProcess(n)
  return process
end
