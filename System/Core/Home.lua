local parent = term.current()
local w, h = parent.getSize()

local programs = {}
local currentP = nil
local runningP = nil

local Process = S.NewClass(S.Object)
