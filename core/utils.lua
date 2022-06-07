--from Norman Ramsey https://stackoverflow.com/a/664611
--function(table): table
 function table.copy(t)
    local u = { }
    for k, v in pairs(t) do 
        u[k] = v
    end
    return setmetatable(u, getmetatable(t))
end

--from https://gist.github.com/tylerneylon/81333721109155b2d244
--function(table, table): table
function table.deepCopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[table.deepCopy(k, s)] = table.deepCopy(v, s) end
    return res
end