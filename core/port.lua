local Port = {}
--function(num): nil
function Port:put(number, data)
    assert(type(number) == "number")
    os.queueEvent("PortRecieve", number, data)
    coroutine.yield()
end

return Port