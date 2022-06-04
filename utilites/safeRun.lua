local inputs = {...}

path = inputs[1]
table.remove(inputs, 1)

assert(loadfile(name, "t", Environment.u))(unpack(inputs))