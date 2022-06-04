function split (inputstr, sep)
    if sep == nil then
       sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
       table.insert(t, str)
    end
    return t
 end

while true do
    write(">")
    local input = split(read(), " ")

    if input[1] == "list" then
        a = getApplicationList()

        for i = 1, #a do
            print(a[i]:getLoadInformation().id .." -- " ..a[i]:getLoadInformation().runId .." -- " ..a[i]:getParams().path  .." -- " ..a[i]:getParams().env.name .." -- " ..a[i]:getStatus())
        end
    elseif input[1] == "kill" then
        killApplication(tonumber(input[2]))
    elseif input[1] == "run" then
        addApplication(App.Application:new(App.ApplicationParams:new(input[2], Environment.u)))
    end
end