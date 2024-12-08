(ns main)

(defn can-create
  [current goal line]
  (if (empty? line)
    (= current goal)
    (let [n (first line)
          restofline (next line)]
      (or (can-create (clojure.edn/read-string (str current n)) goal restofline)
          (can-create (+ current n) goal restofline)
          (can-create (* current n) goal restofline)))))


(defn handle-line
  [line]
  (let [colonsplit (clojure.string/split line #": " )
        goal (clojure.edn/read-string (first colonsplit))
        nums (map clojure.edn/read-string (clojure.string/split (second colonsplit) #" "))]
        (if (can-create (first nums) goal (next nums))
          goal
          0 )))

(println (reduce + (map handle-line (clojure.string/split-lines (slurp "./input.txt")))))


