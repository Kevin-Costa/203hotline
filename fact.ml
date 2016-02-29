let fact n =
  if Num.sign_num n = -1
  then Num.Int 0
  else
    let rec fact acu = function
      | Num.Int 0 -> acu
      | n -> fact (Num.mult_num n acu) (Num.pred_num n)
    in fact (Num.Int 1) n
