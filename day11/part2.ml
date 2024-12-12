#load  "str.cma";;

let memo f =
  let m = ref [] in
    fun x ->
      try
        List.assoc x !m
      with
      Not_found ->
        let y = f x in
          m := (x, y) :: !m ;
          y
let memo_rec f =
  let m = ref [] in
  let rec g x =
    try
      List.assoc x !m
    with
    Not_found ->
      let y = f g x in
        m := (x, y) :: !m ;
        y
  in
    g

let read_file file = In_channel.with_open_bin file In_channel.input_all

let parse s = List.map int_of_string (Str.split (Str.regexp "[ \n\r\x0c\t]+") s)

let numbers = parse (read_file "./input")

let split stone = let strstone = string_of_int stone in
  [int_of_string (String.sub strstone 0 (String.length strstone / 2 )) ;
   int_of_string (String.sub strstone (String.length strstone / 2 ) (String.length strstone / 2 )) ] ;;

let sum = List.fold_left ( + ) 0;;

let rec repeat f n x =
  if n == 0 then x
  else repeat f (n - 1) (f x) ;;

let rec blink (n, stone)= let strstone = string_of_int stone in
  if n == 0 then 1
  else if stone == 0 then blink ((n-1), 1)
  else if (String.length strstone) mod 2 == 0 then (sum (List.map (fun x -> blink (n-1, x)) (split stone)))
  else blink (n-1, stone*2024)


let () = (Printf.printf "%d ") (sum (List.map (fun x -> blink (25, x)) numbers))
