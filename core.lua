Environment = {type = "Environment"}

--function(table): table
function Environment:new(env)
    local public = {}
        public.env = env

    setmetatable(public, self)
    self.__index = self; return public
end

--function(table, table): table
function Environment:newWith(env, without)
    local public = {}
        public.env = env

    
    for k, v in pairs(without) do 
        public.env[v] = nil
    end

    setmetatable(public, self)
    self.__index = self; return public
end
