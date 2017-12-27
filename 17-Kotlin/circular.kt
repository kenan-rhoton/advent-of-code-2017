fun main(args: Array<String>) {
    var buffer: ArrayList<Int> = ArrayList(2018)
    val step = args[0].toInt()
    var position = 0
    buffer.add(0)
    for (i in 1..2017) {
        position = ((position + step) % buffer.size) + 1
        buffer.add(position,i)
    }
    println(buffer[position+1])
}
