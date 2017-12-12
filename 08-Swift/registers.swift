var registers = [String : Int]()

var max_ever = 0;

func check_condition(reg: String, comparison: String, val: Int) -> Bool {
    let check = registers[reg] ?? 0
    switch comparison {
    case ">": return check > val
    case "<": return check < val
    case "==": return check == val
    case "!=": return check != val
    case ">=": return check >= val
    case "<=": return check <= val
    default: return false
    }
}

func do_action(reg: String, direction: String, val: Int) {
    if direction == "inc" {
        registers[reg] = (registers[reg] ?? 0) + val
    } else {
        registers[reg] = (registers[reg] ?? 0) - val
    }
    if (registers[reg] ?? 0) > max_ever {
        max_ever = registers[reg] ?? 0
    }
}

while let line = readLine() {
    let parts = line.split(separator:" ")
    if check_condition(reg: String(parts[4]),
                       comparison: String(parts[5]),
                       val: Int(String(parts[6]))! )
    {
        do_action(reg: String(parts[0]),
                  direction: String(parts[1]),
                  val: Int(String(parts[2]))! )
    } 
}

var max = 0;

for (reg, val) in registers {
    print("\(reg) := \(val)\n")
    if val > max {
        max = val
    }
}

print("The biggest register is \(max)\n")
print("The biggest register EVER in the calculation is \(max_ever)\n")
