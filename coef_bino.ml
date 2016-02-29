let binomial n p =
  let m = Num.min_num p (Num.sub_num n p)
  in if Num.sign_num m = -1
    then Num.Int 1
    else
      let rec binomial k accu =
	if Num.compare_num k m = 0
	then accu
	else binomial (Num.succ_num k) (Num.div_num (Num.mult_num accu (Num.sub_num n k)) (Num.succ_num k))
      in binomial (Num.Int 0) (Num.Int 1);;
