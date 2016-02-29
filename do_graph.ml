let pi = acos (-1.)

(* nombre d'appel en une journée *)
let n = Num.num_of_string "3500"

(* nombre de seconde en 8 heure soit le temps d'une journée de taf *)
let t = Num.num_of_string "28800"

let rec get_graph acu fct xmin xmax =
  if xmin > xmax
  then acu
  else get_graph ((float_of_int xmax, fct xmax)::acu) fct xmin (xmax - 1)

let rec exp_1 acu n =
  if Num.sign_num n == -1
  then acu
  else exp_1 (Num.add_num acu (Num.div_num (Num.Int 1) (Fact.fact n))) (Num.pred_num n)

let e = exp_1 (Num.Int 0) (Num.Int 42)

let draw_graph name w h s =
  let vp =
    try Archimedes.init ~w:w ~h:h ~text:24. ~bg:Archimedes.Color.dark_slate_grey
	  ["Graphics"; "BMP"; name ^ ".bmp"; "hold"]
    with
      | Graphics.Graphic_failure str -> Archimedes.init ~w:w ~h:h ~text:24. ~bg:Archimedes.Color.dark_slate_grey
	["Cairo"; "PNG"; name ^ ".png";] in
  let enc_bino = ref 0. in
  let loi_bino k =
    let c_bino = Num.float_of_num (Coef_bino.binomial n (Num.num_of_int k)) in
    let k = float_of_int k in
    let s = Num.float_of_num s in
    let t = Num.float_of_num t in
    let n = Num.float_of_num n in
    let p = s /. t in
    let p_pp_k = p ** k in
    let p_c = 1. -. p in
    let p_pp_k_c = p_c ** (n -. k) in
    let res = c_bino *. p_pp_k *. p_pp_k_c in
    if k > 25.
    then enc_bino := !enc_bino +. res;
    res in

  let enc_poi = ref 0. in
  let loi_poi k =
    let fact_k = Num.float_of_num (Fact.fact (Num.Int k)) in
    let s = Num.float_of_num s in
    let k = float_of_int k in
    let m = s *. (Num.float_of_num n) /. (Num.float_of_num t) in
    let e_mm = exp (-.m) in
    let m_pp_k = m ** k in
    let res = e_mm *. m_pp_k /. fact_k in
    if k > 25.
    then enc_poi := !enc_poi +. res;
    res in
  let t1 = Unix.gettimeofday () in
  let graph_bino = get_graph [] loi_bino 0 50 in
  print_endline "\027[1;33mloi binomiale:";
  Printf.printf "\t\ttemps de calcul:\t    \027[1;31m%.2f\027[1;33m ms\n" ((Unix.gettimeofday () -. t1) *. 1000.);
  Printf.printf "\t\tprobabilite d\'encombrement: \027[1;31m%.1f \027[1;33m%%\n" (!enc_bino *. 100.);
  let t1 = Unix.gettimeofday () in
  let graph_poi = get_graph [] loi_poi 0 50 in
  print_endline "loi de poisson:";
  Printf.printf "\t\ttemps de calcul:\t    \027[1;31m%.2f \027[1;33mms\n" ((Unix.gettimeofday () -. t1) *. 1000.);
  Printf.printf "\t\tprobabilite d\'encombrement: \027[1;31m%.1f\027[1;33m %%\027[1;0m\n" (!enc_bino *. 100.);
  Archimedes.Viewport.set_color vp Archimedes.Color.yellow;
  Archimedes.Viewport.xlabel vp "nb d'appels simultanes";
  Archimedes.Viewport.ylabel vp "probabilite";
  Archimedes.Viewport.title vp name;
  Archimedes.Axes.box ~grid:true vp;
  Archimedes.Viewport.set_color vp Archimedes.Color.magenta;
  Archimedes.Viewport.text vp 35. (loi_poi 35) "poisson";
  Archimedes.List.xy_pairs ~style:(`Linesmarkers "*")vp graph_bino;
  Archimedes.Viewport.set_color vp Archimedes.Color.green;
  Archimedes.List.xy_pairs ~style:(`Linesmarkers "h")vp graph_poi;
  Archimedes.Viewport.text vp 15. (loi_bino 15) "binomial";
  Archimedes.close vp
