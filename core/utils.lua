--from Norman Ramsey https://stackoverflow.com/a/664611
 --function(table): table
 function table.copy(t)
    local u = { }
    for k, v in pairs(t) do 
        u[k] = v
    end
    return setmetatable(u, getmetatable(t))
end