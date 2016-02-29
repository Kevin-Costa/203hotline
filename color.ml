(* color by Antoine PLAKOWSKI : Librement pompé sur https://realworldocaml.org/v1/en/html/variants.html *)

type basic_color =
  | Black
  | Red
  | Green
  | Yellow
  | Blue
  | Magenta
  | Cyan
  | White

let basic_color_to_int = function
  | Black -> 0
  | Red -> 1
  | Green -> 2
  | Yellow -> 3
  | Blue -> 4
  | Magenta -> 5
  | Cyan -> 6
  | White -> 7

let color_string_by_int number = "\027[38;5;" ^ string_of_int number ^ "m"

type color =
  | Color of basic_color
  | Color_bold of basic_color
  | RGB of int * int * int
  | Color_gray of int
      
let color_to_int = function
  | Color basic_color -> basic_color_to_int basic_color
  | Color_bold basic_color -> 8 + basic_color_to_int basic_color
  | RGB (r, g, b) -> 16 + b + g * 6 + r * 36
  | Color_gray i -> 232 + i

let put_color color =
  print_string (color_string_by_int (color_to_int color))

let print_color color s =
  print_string ((color_string_by_int (color_to_int color)) ^ s ^ "\027[0m")

let print_color_endline color s =
  print_newline (print_color color s)

let print_color_bool = function
  | true -> print_color_endline (Color Green) "true";
  | false -> print_color_endline (Color Red) "false";
