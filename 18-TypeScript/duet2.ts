const getStdin = require('get-stdin')
const a = "a".charCodeAt(0)

interface Command {
    instruction: string;
    src: string;
    dest: string;
}

function makeCommand(input: string) {
    var parts = input.split(" ")
    return {instruction: parts[0], src: parts[1], dest: parts[2]}
}

class Program {

    instructions: Command[]
    registers: number[]
    next: number
    sending: number[]
    receiving: string
    send_counter: number
    terminated: boolean

    constructor(instr: Command[]) {
        this.instructions = instr
        this.registers = Array(26).fill(0)
        this.next = 0
        this.sending = []
        this.receiving = "p"
        this.send_counter = 0
        this.terminated = false
    }

    rget(which: string) {
        var pos = which.charCodeAt(0) - a
        var res = null
        if (pos >= 0 && pos <= 26) {
            res = this.registers[pos]
        } else {
            res = parseInt(which)
        }
        return res
    }

    rset(which: string, value: number) {
        this.registers[which.charCodeAt(0) - a] = value
    }

    execute(com: Command) {
        switch(com.instruction) {
            case "snd":
                this.send_counter++
                this.sending.push(this.rget(com.src))
                break
            case "set":
                this.rset(com.src, this.rget(com.dest))
                break
            case "add":
                this.rset(com.src, this.rget(com.src) + this.rget(com.dest))
                break
            case "mul":
                this.rset(com.src, this.rget(com.src) * this.rget(com.dest))
                break
            case "mod":
                this.rset(com.src, this.rget(com.src) % this.rget(com.dest))
                break
            case "rcv":
                this.receiving = com.src
                break
            case "jgz":
                if (this.rget(com.src) > 0) {
                    this.next += this.rget(com.dest)-1
                }
                break
        }
    }

    start() {
        while (this.receiving == null && this.terminated == false) {
            this.execute(this.instructions[this.next])
            this.next++
            if (this.next < 0 || this.next >= this.instructions.length) {
                this.terminated = true
            }
        }
    }
    receive(value: number) {
        this.rset(this.receiving, value)
        this.receiving = null
    }
}

getStdin().then(str => {
    var instructions = str.split("\n").map(makeCommand)
    instructions.pop()

    let program0 = new Program(instructions)
    let program1 = new Program(instructions)
    program0.sending.push(1)
    program1.sending.push(0)

    while(true) {
        var first = program1.sending.shift()
        if (first != undefined && !program0.terminated) {
            program0.receive(first)
            program0.start()
        }
        var second = program0.sending.shift()
        if (second != undefined && !program1.terminated) {
            program1.receive(second)
            program1.start()
        }
        if ((first == undefined || program0.terminated) && 
            (second == undefined || program1.terminated)) {
            break
        }
    }

    console.log(program1.send_counter)

})
