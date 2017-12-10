let rec next_square n x =
    if (x * x) >= n then x else next_square n (x+2);;

let wave base distance =
    let position = (distance mod base) in
    if position < (base / 2) then (base - position) else position;;

let spiral n =
    let power = (next_square n 1) in
    let base = (power - 1) in
    let high = (power * power) in
    let distance = (high - n) in
    wave base distance;;

Printf.printf "%d\n" (spiral (int_of_string Sys.argv.(1)));;
