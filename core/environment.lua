local Environment = {}

--function(table, table): table
function Environment:newWith(env, with)
    
    for k, v in pairs(with) do 
        env[k] = v
    end

    return env
end

return Environment