class Program
    
    @name : String
    @connections : Array(String)

    def initialize(name : String)
        @name = name
        @connections = [] of String
    end

    def connect(friend : String)
        @connections << friend
    end

    def friends
        @connections
    end
end

programs = {} of String => Program

while input = gets
    g = input.to_s.split(" <-> ")
    p = Program.new(g[0])
    if programs.has_key?(g[0])
        p = programs[g[0]]
    end
    g[1].split(", ").each do |friend|
        p.connect(friend)
        if programs.has_key?(friend)
            programs[friend].connect(g[0])
        else
            f = Program.new(friend)
            f.connect(g[0])
            programs[friend] = f
        end
    end
    programs[g[0]] = p
end

def group_of(start : String, progs : Hash(String, Program))
    check = [] of String
    check << start
    i = 0
    while i < check.size
        p = progs[check[i]]
        p.friends.each do |friend|
            if !check.includes?(friend)
                check << friend
            end
        end
        i+=1
    end
    return check
end

puts group_of("0", programs).size

groups = [] of Array(String)

programs.each do |program, value|
    done = false
    groups.each do |group|
        if group.includes? program
            done = true
            break
        end
    end
    if !done
        g = group_of(program, programs)
        groups << g
    end
end

puts groups.size
