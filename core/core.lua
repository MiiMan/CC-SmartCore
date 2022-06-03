local inputs = {...}

local Port = require "port"
local TaskManager = require "task_manager"
local App = require "application"
local Environment = require "environment"

local task_manager = TaskManager:new()

local function _addApplication(cor)
    task_manager:addApplication(cor)
end

local function _killApplication(id)
    task_manager:killApplication(id)
end

Environment.u = Environment:newWith(_ENV, {task_manager=nil, Port = Port})
Environment.su = Environment:newWith(_ENV, {task_manager=nil,addApplication=_addApplication, killApplication=_killApplication, Environment = Environment, Port = Port})

task_manager:addApplication(App.Application:new(App.ApplicationParams:new(inputs[1], Environment.su)))
task_manager:run()
