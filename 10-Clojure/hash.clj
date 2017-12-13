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

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (let [lengths (str/split (read-line) #",")]
    (println
      (loop [num_list (range 0 256)
             position 0
             skip 0
             order 0]
        (if (>= order (count lengths))
          (* (nth num_list 0) (nth num_list 1))
          (let [length (Integer. (nth lengths order))]
            (recur (wrap_reverse num_list length position)
                   (mod (+ position skip length) 256)
                   (inc skip)
                   (inc order)
                   )
            )
          )
        )
      )
    )
  )
