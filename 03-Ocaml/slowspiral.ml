let rec next_square n x =
    if (x * x) >= n then x else next_square n (x+2);;

let get_dir = function
    | 3 -> (0,1)
    | 2 -> (-1,0)
    | 1 -> (0,-1)
    | 0 -> (1,0)
    | _ -> (0,0);;

let add_coords (a,b) (c,d) =
    ((a+c),(b+d));;

let get_coords = function
    | 1 -> (0,0)
    | n ->
        let power = (next_square n 1) in
        let base = (power - 1) in
        let size = (power / 2) in
        let high = (power * power) in
        let distance = (high - n) in
        let side = (distance / base) in
        let position = (distance mod base) in
        match side with
            | 0 -> ((size - position), (-size))
            | 1 -> ((-size), (position - size))
            | 2 -> ((position - size),size)
            | 3 -> (size, (size - position))
            | _ -> (0,0);;

let max x y =
    if x > y then x else y;;

let min x y =
    if x > y then y else x;;

let abs x =
    if x >= 0 then x else (-x);;

let difference (x,y) (a,b) =
    (abs ((x - a) + (y - b)));;

let find_side top = function
    | (_,y) when (y == (-top)) -> 0
    | (x,_) when (x == (-top)) -> 1
    | (_,y) when (y == top) -> 2
    | (x,_) when (x == top) -> 3
    | (_,_) -> 0;;

let find_coords (x,y) =
    let a = (abs x) in
    let b = (abs y) in
    let higher = (max a b) in
    let power = ((higher * 2) - 1) in
    let next_power = (power + 2) in
    let base = (next_power - 1) in
    let side = (find_side higher (x,y)) in
    let start = (power * power) in
    let corner = (start + (base * (3 - side))) in
    (corner + (difference (get_coords corner) (x,y)));;

let get_adjacents x =
    let coords = (get_coords x) in
    let matrix = [(1,1);(0,1);(-1,1);(-1,0);(-1,-1);(0,-1);(1,-1);(1,0)] in
    let adjacents = (List.map (fun x -> add_coords x coords) matrix) in
    List.map find_coords adjacents;;

let rec get_sum = function
    | 1 -> 1
    | x ->
            let adjacents = (get_adjacents x) in
            List.fold_left (fun i adj -> 
                if adj < x then i + (get_sum adj) else i) 0 adjacents;;

let get_value x =
    let rec get_greater_sum n s =
        let res = (get_sum s) in
        if res > n then res
        else get_greater_sum n (s+1)
    in
    get_greater_sum x 1;;


let arg = (int_of_string Sys.argv.(1)) in
let x, y = (get_coords arg) in
Printf.printf "%d,%d\n" x y;
let z = (find_coords (x,y)) in
Printf.printf "%d\n" z;
Printf.printf "%d\n" (get_value arg);;
