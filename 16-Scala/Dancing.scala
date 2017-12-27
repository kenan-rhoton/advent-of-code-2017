object Dancing extends App {
  def spin(prom: Array[Char], amount: Int): Array[Char] = {
    prom.takeRight(amount) ++ prom.take(prom.length-amount)
  }
  def exchange(prom: Array[Char], positions: Array[Int]): Array[Char] = {
    val temp = prom(positions(0))
    prom(positions(0)) = prom(positions(1))
    prom(positions(1)) = temp
    prom
  }
  def partners(prom: Array[Char], dancers: Array[Char]): Array[Char] = {
    exchange(prom, dancers.map(x => prom.indexOf(x)))
  }
  def dance(prom: Array[Char], order: String): Array[Char] = {
    order(0) match {
      case 's' => spin(prom, order.drop(1).toInt)
      case 'x' => exchange(prom, order.drop(1).split('/').map(_.toInt))
      case 'p' => partners(prom, order.drop(1).split('/').map(x => x(0)))
    }
  }
  def buildDance(size: Int, prom: Array[Char]): Array[String] = {
    var promenade = prom
    var results: Array[String] = Array()
    for (i <- 0 to size) {
      for (order <- input) {
        promenade = dance(promenade, order)
      }
      val str = promenade.mkString("")
      if (results.contains(str)) {
        return results;
      } else {
        results = results :+ str
      }
    }
    results
  }

  val input = scala.io.StdIn.readLine().split(',')
  var promenade = List.range('a','q').toArray
  val results = buildDance(1000000000, promenade)
  println(results(999999999 % results.length))
}
