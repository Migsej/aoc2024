#load  "str.cma";;
let read_file file = In_channel.with_open_bin file In_channel.input_all

let parse s = List.map int_of_string (Str.split (Str.regexp "[ \n\r\x0c\t]+") s)

let numbers = parse (read_file "./input")

let blink_stone stone = let strstone = string_of_int stone in
  if stone == 0 then [1]
  else if (String.length strstone) mod 2 == 0 then 
  [int_of_string (String.sub strstone 0 (String.length strstone / 2 )) ;
   int_of_string (String.sub strstone (String.length strstone / 2 ) (String.length strstone / 2 )) ]
  else [stone * 2024]

let rec repeat f x n =
  if n == 0 then x
  else repeat f (f x) (n - 1);;

let () = Printf.printf "%d \n" (List.length (repeat (List.concat_map blink_stone) numbers 75))
let () = List.iter (Printf.printf "%d ") (repeat (List.concat_map blink_stone) numbers 0)
(* let () = Printf.printf "%d" (repeat (fun x -> x +1 ) 2 4)*)
(*  let () = List.iter (Printf.printf "%d ") (List.concat_map blink_stone numbers)*)
let () = Printf.printf "\n"
(* let () = List.iter (Printf.printf "%d ") numbers *)
let () = List.iter (Printf.printf "%d ") (blink_stone 202412)

