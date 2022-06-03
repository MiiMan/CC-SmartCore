require "application"

TaskManager = {type = "TaskManager"}

--function(): TaskManager
function TaskManager:new()
    local private = {}
        private.applications = {}
    local public = {}

        --function(Application): nil
        function public:addApplication(cor)
            cor:load()
            table.insert(private.coroutines, cor)
        end
        
        --function(): nil
        function public:run()
            local tempDone = {}
            while #private.applications > 0 do
                tempDone = {}
                local eventData = {os.pullEventRaw()}

                for i = 1, #private.applications do
                    private.applications[i]:continue(unpack(eventData)) 
                    
                    if private.applications[i]:status() == "dead" then
                        table.insert(tempDone, i)
                    end
                end

                for i = 1, #tempDone do
                    private.applications[tempDone[i]]:done()
                    table.remove(private.applications, tempDone[i])
                end
            end
        end

    setmetatable(public, self)
    self.__index = self; return public
end


t = TaskManager:new()
t:addCoroutine(Application:new(ApplicationParams:new("test.lua", _ENV)))
t:run()