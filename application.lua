ApplicationParams = {type = "ApplicationParams"}

--function(num, str, table): table
function ApplicationParams:new(path, env)
    local public = {}
        public.path = path
        public.env = env

        --function(): ApplicationParams
        function public:copy()
            return ApplicationParams:new(self.path, self.env)
        end

    setmetatable(public, self)
    self.__index = self; return public
end

Application = {type = "Application"}

Application.status = {
    waitForLoad = 0,
    inProcess = 1,
    dead = 2,
}

Application.exitCodes = {
    notKilled = 0,
    killed = 1,
    done = 2,
}

--function(table): Application
function Application:new(params)

    local private= {}
        private.params = params
        private.coroutine = nil
        private.status = Application.status.waitForLoad
        private.exitCode = Application.exitCodes.notKilled

        --function(): nil
        function private:close()
            private.status = Application.status.dead
            private.coroutine = nil
            private.params = nil
        end

    local public = {}

        --function(): nil
        function public:load()
            assert(private.status == Application.status.waitForLoad)
            local file = loadfile(private.params.path, "t", private.params.env)
            private.coroutine = coroutine.create(file)
            private.status = Application.status.inProcess
        end

        --function(): bool
        function public:continue(...)
            eventData = {...}
            assert(private.status == Application.status.inProcess)
            local res = coroutine.resume(assert(private.coroutine), unpack(eventData))
            return res
        end

        function public:status()
            assert(private.status == Application.status.inProcess)
            return coroutine.status(assert(private.coroutine))
        end

        --function(): nil
        function public:kill()
            assert(private.status == Application.status.inProcess)
            private.exitCode = Application.exitCode.killed
            private:close()
        end

        --function(): nil
        function public:done()
            assert(private.status == Application.status.inProcess)
            private.exitCode = Application.exitCodes.done
            private:close()
        end

    setmetatable(public, self)
    self.__index = self; return public
end

app = Application:new(ApplicationParams:new("test.lua", _ENV))
app:load()
app:continue()