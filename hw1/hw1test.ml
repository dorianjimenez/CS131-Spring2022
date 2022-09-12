let my_subset_test0 = not (subset [5;5;1;2;7;7;1;0] [1;6;7;0;2])
let my_subset_test1 = subset [5;5;1;2;7;7;1;0] [1;6;7;0;2;5]

let my_equal_sets_test0 = not (equal_sets [3;2;1] [1;1;1;1;2;2;2;2;2;3;3;3;3;3;3;3;4])
let my_equal_sets_test1 = (equal_sets [3;1;2] [1;1;1;1;2;2;2;2;2;3;3;3;3;3;3;3])
let my_equal_sets_test2 = not (equal_sets [1;1;1;1;2;2;2;2;2;3;3;3;3;3;3;3;4] [3;1;2])
let my_equal_sets_test3 =  (equal_sets [1;1;1;1;2;2;2;2;2;3;3;3;3;3;3;3] [3;2;1])

let my_set_union_test0 = equal_sets (set_union [] [1]) [1]
let my_set_union_test1 = equal_sets (set_union [1;1;1] []) [1]
let my_set_union_test2 = equal_sets (set_union [2;2;2;2;1;1] [1;3]) [3;1;2;1]

let my_set_all_union_test0 = equal_sets (set_all_union [[1;2;3];[4;5;6]]) [1;2;3;4;5;6]
let my_set_all_union_test1 = equal_sets (set_all_union [[];[];[]]) []
let my_set_all_union_test2 = equal_sets (set_all_union [[1;1;2;2;2;1;2;1;2;1];[3;1;3;1;2;1;2;3;1;2;3;1;2;2;1;3;1;2;4;1;2;3;1];[5];[6;6]]) [1;2;3;4;5;6]

let my_computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> x / 3) 1000000000 = 0
let my_computed_fixed_point_test1 = computed_fixed_point (=) (fun x -> x /. 3.) 1000000000. = 0.

let my_computed_periodic_point_test0 = computed_periodic_point (=) (fun x -> x / 2) 1 10000000 = 0
let my_computed_periodic_point_test1 = computed_periodic_point (=) (fun x -> x / 3) 3 10000000 = 0
let my_computed_periodic_point_test2 = computed_periodic_point (=) (fun x -> x /. 3.) 1 10000000. = 0.
let my_computed_periodic_point_test3 = computed_periodic_point (=) (fun x -> x /. 5.) 4 10000000. = 0.

let my_whileseq_test0 = ((whileseq ((+) 3) ((>) 10) 0) = [0;3;6;9])
let my_whileseq_test1 = ((whileseq (( *. ) 3.) ((>) 10.) 1.) = [1.;3.;9.])

type awksub_nonterminals =
  | Expr | Lvalue | Incrop | Binop | Num

let awksub_rules =
   [Expr, [T"("; N Expr; T")"];
    Expr, [N Num];
    Expr, [N Expr; N Binop; N Expr];
    Lvalue, [T"$"; N Expr];
    Incrop, [T"++"];
    Incrop, [T"--"];
    Binop, [T"+"];
    Binop, [T"-"]]

let awksub_rules1 =
   [Expr, [N Expr]]

let awksub_grammar = Expr, awksub_rules
let awksub_grammar1 = Expr, awksub_rules1



let my_filter_blind_alleys_test0 = filter_blind_alleys awksub_grammar = 
   (Expr,
   [(Incrop, [T "++"]); (Incrop, [T "--"]); (Binop, [T "+"]);
    (Binop, [T "-"])])


let my_filter_blind_alleys_test1 = filter_blind_alleys awksub_grammar1 = 
    (Expr, [])




