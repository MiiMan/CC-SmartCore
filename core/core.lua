local inputs = {...}
assert(inputs[1])

local Port = require "port"
local TaskManager = require "task_manager"
local App = require "application"
local Environment = require "environment"

local task_manager = TaskManager:new()

local su = {}

su.Environment = Environment
su.App = App

--function(Application): nil
function su.addApplication(cor)
    task_manager:addApplication(cor)
end

--function(num): nil
function su.killApplication(id)
    task_manager:killApplication(id)
end

--function(): table
function su.getApplicationList()
    return task_manager:getApplicationList()
end

Environment.u = Environment:newWith("u", _ENV, {task_manager=nil, Port = Port})
Environment.su = Environment:newWith("su", Environment.u.env, su)

task_manager:addApplication(App.Application:new(App.ApplicationParams:new(inputs[1], Environment.su)))
task_manager:run()
