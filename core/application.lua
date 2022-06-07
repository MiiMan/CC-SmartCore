require "utils"

local App= {}

App.ApplicationParams = {type = "ApplicationParams"}

--function(num, str, table): ApplicationParams
function App.ApplicationParams:new(path, env)
    local private = {}
        private.path = path

    local public = {}

        public.env = env

        function getPath()
            return path
        end

    setmetatable(public, self)
    self.__index = self; return public
end

App.Application = {type = "Application"}

App.Application.status = {
    waitForLoad = 0,
    inProcess = 1,
    dead = 2,
}

App.Application.exitCodes = {
    notKilled = 0,
    killed = 1,
    done = 2,
}

--function(table): Application
function App.Application:new(params)

    local private= {}
        private.loadInformation = {}
        private.params = params
        private.coroutine = nil
        private.status = App.Application.status.waitForLoad
        private.exitCode = App.Application.exitCodes.notKilled
        private.exitMessage = ""

        --function(str/nil): nil
        function private:close(m)
            private.status = App.Application.status.dead
            private.exitMessage = m or ""
            private.coroutine = nil
        end

        --function(): bool
        function private:continue(...)
            eventData = {...}

            assert(private.status == App.Application.status.inProcess)
            local res, ex = coroutine.resume(assert(private.coroutine), unpack(eventData))

            if res == false then
                private.exitCode = App.Application.exitCodes.done
                private:close(ex)
            end 
        end

        --function(str): nil
        function private:kill(m)
            assert(private.status == App.Application.status.inProcess)
            private.exitCode = App.Application.exitCodes.killed
            private:close(m)
        end

    local public = {}

         --function(): table
         function public:getParams()
            return table.deepCopy(private.params)
        end

        --function(): num
        function public:getLoadInformation()
            return private.loadInformation
        end

        --function(): num
        function public:getStatus()
            return private.status
        end

         --function(): num
         function public:getExitCode()
            return private.exitCode
        end

        --function(): num
        function public:getExitMessage()
            return private.exitMessage
        end

        --function(): nil
        function public:load(loadInformation)
            assert(private.status == App.Application.status.waitForLoad)

            private.loadInformation = loadInformation
            
            local file = loadfile(private.params.getPath(), "t", private.params.env.env)
            private.coroutine = coroutine.create(file)
            private.status = App.Application.status.inProcess
            
            return private.continue, private.kill
        end

    setmetatable(public, self)
    self.__index = self; return public
end

return App