const getStdin = require('get-stdin')

var registers = Array(26).fill(0)
var instructions = []
var next = 0
const a = "a".charCodeAt(0)
var playSound = null
var recovered = null

interface Command {
    instruction: string;
    src: string;
    dest: string;
}

function makeCommand(input: string) {
    var parts = input.split(" ")
    return {instruction: parts[0], src: parts[1], dest: parts[2]}
}

function rget(which: string) {
    var pos = which.charCodeAt(0) - a
    var res = null
    if (pos >= 0 && pos <= 26) {
        res = registers[pos]
    } else {
        res = parseInt(which)
    }
    console.log("fetching "+which+": "+res)
    return res
}

function rset(which: string, value: number) {
    console.log("setting "+which+" to "+value)
    registers[which.charCodeAt(0) - a] = value
}

function execute(com: Command) {
    console.log("executing: " + com.instruction + " " + com.src + " " + com.dest)
    switch(com.instruction) {
        case "snd":
            playSound = rget(com.src)
            break
        case "set":
            rset(com.src, rget(com.dest))
            break
        case "add":
            rset(com.src, rget(com.src) + rget(com.dest))
            break
        case "mul":
            rset(com.src, rget(com.src) * rget(com.dest))
            break
        case "mod":
            rset(com.src, rget(com.src) % rget(com.dest))
            break
        case "rcv":
            if (rget(com.src) != 0) {
                recovered = playSound
            }
            break
        case "jgz":
            if (rget(com.src) > 0) {
                next += parseInt(com.dest)-1
            }
            break
    }
}

getStdin().then(str => {
    instructions = str.split("\n").map(makeCommand)
    instructions.pop()

    while(recovered == null) {
        execute(instructions[next])
        next++
    }

    console.log(recovered)

})
