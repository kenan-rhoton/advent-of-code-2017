(ns hash.core
  (:gen-class))

(require '[clojure.string :as str])

(defn wrap_reverse
  "Reverses length members of a list from position wrapping around,
  asuming we can and will exceed the length of the list"
  [circ_list length position]
  (let [list_length (count circ_list)
        overflow (max (- (+ length position) list_length) 0)
        remainder (- length overflow)]
    (let [rev_list (reverse
                     (concat
                       (take remainder (drop position circ_list))
                       (take overflow circ_list)))]
      (concat
        (drop remainder rev_list)
        (take (- position overflow) (drop overflow circ_list))
        (take remainder rev_list)
        (drop (+ position remainder) circ_list)
        )
      )
    )
  )

(defn dense_hash
  "Merges chunks of 16 values into one by XORing"
  [sparse_hash]
  (loop [head (take 16 sparse_hash)
         tail (drop 16 sparse_hash)
         result [] ]
    (let [dense_head (reduce bit-xor head)]
      (if (empty? tail)
        (concat result [dense_head])
        (recur (take 16 tail) (drop 16 tail) (concat result [dense_head]))
        )
      )
    )
  )

(defn hex_hash
  "Crafts a Hash from a list"
  [num_list]
  (let [dense_list (dense_hash num_list)]
    (reduce
      (fn [hex n] (str hex (format "%02x" n)))
      ""
      dense_list
      )
    )
  )

(defn -main
  "Solve the world's problems"
  [& args]
  (let [lengths (concat (.getBytes (read-line)) [17,31,73,47,23])
        length_last (dec (count lengths))]
    (println
      (loop [num_list (range 0 256)
             position 0
             skip 0
             order 0
             round 0]
        (let [length (nth lengths order)]
          (if (>= round 64)
            (hex_hash num_list)
            (recur (wrap_reverse num_list length position)
                   (mod (+ position skip length) 256)
                   (inc skip)
                   (if (>= order length_last) 0 (inc order))
                   (if (>= order length_last) (inc round) round)
                   )
            )
          )
        )
      )
    )
  )
