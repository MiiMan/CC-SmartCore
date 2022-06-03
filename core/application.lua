local App= {}

App.ApplicationParams = {type = "ApplicationParams"}

--function(num, str, table): ApplicationParams
function App.ApplicationParams:new(path, env)
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
        private.params = params
        private.coroutine = nil
        private.status = App.Application.status.waitForLoad
        private.exitCode = App.Application.exitCodes.notKilled

        --function(): nil
        function private:close()
            private.status = App.Application.status.dead
            private.coroutine = nil
            private.params = nil
        end

    local public = {}

        --function(): nil
        function public:load()
            assert(private.status == App.Application.status.waitForLoad)
            local file = loadfile(private.params.path, "t", private.params.env)
            private.coroutine = coroutine.create(file)
            private.status = App.Application.status.inProcess
        end

        --function(): bool
        function public:continue(...)
            eventData = {...}
            assert(private.status == App.Application.status.inProcess)
            local res = coroutine.resume(assert(private.coroutine), unpack(eventData))
            return res
        end

        function public:status()
            assert(private.status == App.Application.status.inProcess)
            return coroutine.status(assert(private.coroutine))
        end

        --function(): nil
        function public:kill()
            assert(private.status == App.Application.status.inProcess)
            private.exitCode = App.Application.exitCode.killed
            private:close()
        end

        --function(): nil
        function public:done()
            assert(private.status == App.Application.status.inProcess)
            private.exitCode = App.Application.exitCodes.done
            private:close()
        end

    setmetatable(public, self)
    self.__index = self; return public
end

return App