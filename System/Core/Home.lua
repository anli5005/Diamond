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
