import  Data.Bits (xor)
import Numeric (showHex, readHex, showIntAtBase, showInt)
import Data.Char (ord, chr)

wrap_reverse :: [Int] -> Int -> Int -> [Int]
wrap_reverse circ_list len position = 
    let list_length = length circ_list
        overflow = max (len + position - list_length) 0
        remainder = len - overflow
        rev_list = reverse ((take remainder (drop position circ_list))
                            ++ (take overflow circ_list))
    in
    (drop remainder rev_list) ++
    (take (position - overflow) (drop overflow circ_list)) ++
    (take remainder rev_list) ++
    (drop (position + remainder) circ_list)

dense_head :: [Int] -> Int
dense_head list = foldl xor 0 list

dense_hash :: [Int] -> [Int] -> [Int]
dense_hash sparse_hash result =
    let front = take 16 sparse_hash
        back = drop 16 sparse_hash
    in
    if back == []
        then result ++ [dense_head front]
        else dense_hash back (result ++ [dense_head front])

show_hex num a =
    let res = showHex num a in
    if (length res) < 2 then "0" ++ res else res

hex_hash :: [Int] -> String
hex_hash num_list =
    let dense_list = dense_hash num_list [] in
    foldl (\x y -> x ++ show_hex y "") "" dense_list

knot_hash :: String -> Int -> Int -> [Int] -> [Int]
knot_hash key position skip result =
    let order = ord (head key) in
    if key == ""
        then [position] ++ ([skip] ++ result)
        else knot_hash
            (tail key)
            (mod (position + (order + skip)) (length result))
            (skip + 1)
            (wrap_reverse result order position)


knot_hashes :: String -> Int -> [[Int]] -> [[Int]]
knot_hashes key knots result =
    let base = last result
        position:skip:playground = base
    in
    if knots <= 0
        then result
        else knot_hashes
            key
            (knots - 1)
            (result ++ [(knot_hash key position skip playground)])

hash_it :: String -> String
hash_it key =
    let suffix = map chr [17,31,73,47,23] 
        hashes = knot_hashes (key ++ suffix) 64 ([[0,0]++[0..255]])
    in
    hex_hash (tail (tail (last hashes)))

bin :: Int -> [Char]
bin number =
    let x = showIntAtBase 2 conv number "" in
    replicate (4 - length x) '0' ++ x
    where conv n = ['0','1'] !! n

binify hexes =
    let hex_to_bin = map (\x -> bin (fst (head (readHex [x]))))
        concatenate = foldl (\x y -> x ++ y) ""
    in
    map (\x -> concatenate (hex_to_bin x)) hexes

count_ones :: [Char] -> Int
count_ones bin_string =
    length (filter (== '1') bin_string)

add_ones :: [String] -> Int
add_ones hex_list =
    foldl (\x y -> x + (count_ones y)) 0 hex_list

new_hash :: String -> Int -> [String] -> [String]
new_hash key rows result =
    let suffix = map chr [17,31,73,47,23] in
    if rows < 0
        then result
        else new_hash
            key
            (rows - 1)
            ([hash_it ((key ++ "-") ++ (showInt rows ""))] ++ result)

hash_grid key = new_hash key 127 []

-- This is where the magic happens
-- Essentially, this transforms each point into a region of only itself
-- so the result is a list of regions, where a "region" is a [(Int,Int)]
regionize :: [String] -> [[(Int,Int)]]
regionize grid =
    let h_marked = map (zip [0..]) grid
        filtered = map (filter (\x -> (snd x) == '1')) h_marked
        h_coords = map (map fst) filtered
        v_marked = zip [0..] h_coords
        coords = map (\x -> map (\y -> ((fst x),y)) (snd x)) v_marked
    in
    map (\x -> [x]) (concat coords)

adjacent_region :: [(Int,Int)] -> [(Int,Int)] -> Bool
adjacent_region a b =
    let combined = [(x,y) | x <- a, y <- b]
        diffx i j = abs ((fst i) - (fst j))
        diffy i j = abs ((snd i) - (snd j))
        adjacent i j = (((diffx i j) == 1) && ((diffy i j) == 0)) ||
                       (((diffx i j) == 0) && ((diffy i j) == 1))
    in
    foldl (\x y -> x || adjacent (fst y) (snd y)) False combined
        
groupBy :: ([a] -> [a] -> Bool) -> [[a]] -> [[a]]
groupBy f [] = []
groupBy f x =
    let grouped = groupBy f (tail x)
        current = head x
        yes = current:filter (f current) grouped
        no = filter (\y -> not (f current y)) grouped
    in
    [(concat yes)] ++ no

    

group_region :: [[(Int,Int)]] -> [[(Int,Int)]]
group_region grid =
    groupBy adjacent_region grid

merge_regions grid =
    let regions = group_region grid in
    if regions == grid
        then grid
        else merge_regions regions

smash_regions :: [String] -> Int
smash_regions grid =
    length $ merge_regions (regionize grid)
    

main :: IO()
main = do
    input <- getLine
    let simple = hash_grid input
    let bingrid = binify simple
    putStrLn $ show (add_ones bingrid)
    putStrLn $ show (smash_regions bingrid)
