require "utils"

local Environment = {type = "Environment"}

--function(table): table
function Environment:new(name, env)
    public = {}
        public.name = name
        public.env = table.deepCopy(env)

    setmetatable(public, self)
    self.__index = self; return public
end

--function(str, table, table): table
function Environment:newWith(name, env, with)
    public = {}
        public.name = name
        public.env = table.deepCopy(env)
    
    for k, v in pairs(table.deepCopy(with)) do 
        public.env[k] = v
    end

    setmetatable(public, self)
    self.__index = self; return public
end

--function(str, table, table): table
function Environment:copy(env)
    public = {}
        public.name = env.name .." inst."
        public.env = table.deepCopy(env.env)
    
    setmetatable(public, self)
    self.__index = self; return public
end

--function(str, table, table): table
function Environment:copyWith(env, with)
    public = {}
        public.name = env.name .." inst."
        public.env = table.deepCopy(env.env)
    
    for k, v in pairs(table.deepCopy(with)) do 
        public.env[k] = v
    end

    setmetatable(public, self)
    self.__index = self; return public
end


return Environment