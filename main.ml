type opt =
    {
      arg : string list ref;
      w : float ref;
      h : float ref;
    }

      
let opt = {arg = ref []; w = ref 1920.; h = ref 1080.}

let anon_fun str = opt.arg := str::!(opt.arg)

let opt_list =
  ("-w", Arg.Set_float opt.w, "weight of graph")::
  ("-h", Arg.Set_float opt.h, "height of graph")::
  ("-", Arg.String anon_fun, "put a anounymous arg start with -")::
  []
let usage = "./203hotline k n | ./203hotline s"

let calc_coef k n = 
  let t1 = Unix.gettimeofday () in
  let k = try Num.num_of_string k with
    | _ -> prerr_endline (k ^ " n'est pas un nombre entier valide"); exit 2 in
  let n = try Num.num_of_string n with
    | _ -> prerr_endline (n ^ " n'est pas un nombre entier valide"); exit 2 in
  Printf.printf "\027[1;33mcombinaison de \027[31m%s\027[33m parmis \027[31m%s \027[33m: \027[31m%s\n\027[0m" (Num.string_of_num(k)) (Num.string_of_num(n)) (Num.string_of_num (Coef_bino.binomial n k));
  Printf.printf "\027[1;33mTemps de calcul:\t\t  \027[1;31m%.2f\027[1;33m ms\027[1;0m\n" ((Unix.gettimeofday () -. t1) *. 1000.)

let show_graph s w h =
  let name_of_graph = ("graph pour " ^ s) in
  let s = try Num.num_of_string s with
    | _ -> prerr_endline (s ^ " n'est pas un nombre entier valide"); exit 2 in
  if Num.sign_num s = -1
  then begin prerr_endline "Des secondes negative bienvenue dans une nouvelle dimension"; exit 2 end
  else Do_graph.draw_graph name_of_graph w h s

let () =
  Arg.parse opt_list (fun str -> opt.arg := str::!(opt.arg); ()) usage;
  opt.arg := List.rev !(opt.arg);
  match !(opt.arg) with
    | a::[] -> show_graph a !(opt.w) !(opt.h)
    | a::b::[] -> calc_coef a b
    | _ -> Arg.usage opt_list usage; exit 2
