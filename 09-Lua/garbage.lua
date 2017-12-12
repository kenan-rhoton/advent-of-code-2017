for line in io.lines() do
    value = 0
    sum = 0
    groups = 0
    ignorenext = false
    garbage = false
    garbageCount = 0
    for char in line:gmatch(".") do
        if ignorenext then
            ignorenext = false
        elseif garbage then
            if char == ">" then
                garbage = false
            elseif char == "!" then
                ignorenext = true
            else
                garbageCount = garbageCount + 1
            end
        else
            if char == "{" then
                value = value + 1
                sum = sum + value
                groups = groups + 1
            elseif char == "}" then
                value = value - 1
            elseif char == "<" then
                garbage = true
            end
        end
    end

    print("There are " .. groups .. " groups")
    print("They have a value of " .. sum)
    print("There was " .. garbageCount .. " garbage detected")
    print()
end
