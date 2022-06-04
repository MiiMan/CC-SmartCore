require "utils"

local TaskManager = {type = "TaskManager"}

--function(): TaskManager
function TaskManager:new()
    local private = {}
        private.applications = {}
        private.running = {}
        private.tempDone = {}


        --function(): nil
        function private:clearDoneTable()
            private.tempDone = {}
        end
        
        --function(num): nil
        function private:addToDoneTable(i)
            table.insert(private.tempDone, i)
        end

    local public = {}

        --function(Application): nil
        function public:addApplication(cor)
            cor = table.copy(cor)
            local continue, kill = cor:load({id = #private.applications+1, runId = #private.running+1})
            table.insert(private.applications, cor)
            table.insert(private.running, {app = private.applications[#private.applications], continue = continue, kill = kill})
        end

        --function(num): nil
        function public:killApplication(id)
            assert(#private.applications <= id and id >= 1)
            assert(private.applications[id]:getStatus() == App.Application.status.inProcess)

            local appInfo = private.running[private.applications[id]:getLoadInformation().runId]
            appInfo.kill(appInfo.app)
        end

        --function(): table
        function public:getApplicationList()
            return table.copy(private.applications)
        end
        
        --function(): nil
        function public:run()
            while #private.running > 0 do
                private:clearDoneTable()
                local eventData = {os.pullEventRaw()}

                for i = 1, #private.running do
                    if private.running[i].app:getStatus() == App.Application.status.inProcess then
                        private.running[i].continue(private.running[i].app, unpack(eventData))
                    else
                        private:addToDoneTable(i)
                    end
                end

                for i = #private.tempDone, 1, -1 do
                    table.remove(private.running, private.tempDone[i])
                end
            end
        end

    setmetatable(public, self)
    self.__index = self; return public
end

return TaskManager