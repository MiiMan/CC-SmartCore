Application = {}

--function(table): table
function Application:new(params)

    local private= {}
        private.params = params

    local public = {}

        --function(table): int
        function public:start(env)
            
        end

        --function(): int
        function public:continue()
            
        end

    setmetatable(public, self)
    self.__index = self; return public
end