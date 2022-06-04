local Environment = {type = "Environment"}

--function(table): table
function Environment:new(name, env)
    public = {}
        public.name = name
        public.env = env

    setmetatable(public, self)
    self.__index = self; return public
end

--function(str, table, table): table
function Environment:newWith(name, env, with)
    public = {}
        public.name = name
        public.env = env
    
    for k, v in pairs(with) do 
        public.env[k] = v
    end

    setmetatable(public, self)
    self.__index = self; return public
end

return Environment