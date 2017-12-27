fun main(args: Array<String>) {
    val step = args[0].toInt()
    var position = 0
    var res = 0
    for (i in 1..50000000) {
        position = ((position + step) % i) + 1
        if (position == 1) {
            res = i
        }
    }
    println(res)
}
