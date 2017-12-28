dat = readLines("input")
pos = c(1,vapply(strsplit(dat[1],""), function(x) which(x == '|'),1))
direction = c(1,0)
current = '|'
tracking = ""
steps = 0
while (current != " ") {
    if (current == "+") {
        want = ""
        if (all(direction == c(1,0) || all(direction == c(-1,0)))) {
            want = "-"
        } else {
            want = "|"
        }
        test = c(direction[2],direction[1])
        testpos = pos + test
        if (substr(dat[testpos[1]],testpos[2],testpos[2]) == want) {
            direction = test
        } else {
            direction = -test
        }
    } else if (current != "|" && current != "-") {
        tracking = paste(tracking,current,sep="")
    }
    steps = steps + 1
    pos = pos + direction
    current = substr(dat[pos[1]],pos[2],pos[2])
}
print(steps)
print(tracking)
