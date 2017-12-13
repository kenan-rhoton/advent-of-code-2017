inputs = readlines()

function get_distance(directions)
    x, y, z = 0, 0, 0
    high = 0
    dist = 0
    for dir in split(directions, ",")
        if dir == "n"
            y+=1; z-=1
        elseif dir == "ne"
            x+=1; z-=1
        elseif dir == "se"
            x+=1; y-=1
        elseif dir == "s"
            z+=1; y-=1
        elseif dir == "sw"
            z+=1; x-=1
        elseif dir == "nw"
            y+=1; x-=1
        end
        dist = max(abs(x),abs(y),abs(z))
        if dist > high
            high = dist
        end
    end
    return dist, high
end

for i in inputs
    res, hi = get_distance(i)
    println("$res -> $hi")
end
