let accept_all string = Some string
let accept_empty_suffix = function
   | _::_ -> None
   | x -> Some x

let accept_plus_symbol = function
  | h :: t -> 
    match h with 
    | "+" -> Some ("+" :: [])
    | _ -> None
  | x -> None


type awksub_nonterminals =
  | A | B | C | D 



let my_grammar =
  (A,
   function
     | A ->
         [[N B; N C; N B];
          [N D]]
     | B ->
	 [[T"x"; N A; T"y"]]
     | C ->
	 [[T"z"; N D]]
     | D ->
	 [[T"a"];
	  [T"b"]]
  )

(* Didn't use this grammar, but this is impossible. 
   I described why in my report. *)
let impossible_grammar = 
    (A,
    function 
        | A -> 
            [[N B];
             [T "+"]]
        | B -> 
            [[N A];
             [T "-"]])


(* Regular Match *)
let make_matcher_test = 
  ((make_matcher my_grammar accept_all ["x"; "a"; "y"; "z"; "b"; "x"; "a"; "y"]) = Some [])

(* Regular Match w/ added unmatched symbols *)
let make_matcher_test2 = 
  ((make_matcher my_grammar accept_all ["x"; "a"; "y"; "z"; "b"; "x"; "a"; "y"; "x"; "a"; "y"; "z"; "b"; "x"; "a"; "y"]) 
    = Some ["x"; "a"; "y"; "z"; "b"; "x"; "a"; "y"])

(* Regular Match w/ added unaccepted symbol*)
let make_matcher_test3 = 
  ((make_matcher my_grammar accept_plus_symbol ["x"; "a"; "y"; "z"; "b"; "x"; "a"; "y"; "-"]) = None)

(* Regular Match w/ added accepted symbol *)
let make_matcher_test4 = 
  ((make_matcher my_grammar accept_plus_symbol ["x"; "a"; "y"; "z"; "b"; "x"; "a"; "y"; "+"]) = Some ["+"])



(* Regular Match *)
let make_parser_test = 
  ((make_parser my_grammar ["x"; "a"; "y"; "z"; "b"; "x"; "a"; "y"]) =
  Some
   (Node (A,
     [Node (B, 
      [Leaf "x"; Node (A, 
        [Node (D, 
          [Leaf "a"])
        ]); 
      Leaf "y"]);
      Node (C, 
        [Leaf "z"; Node (D, 
          [Leaf "b"])
        ]);
      Node (B, 
        [Leaf "x"; Node (A, 
          [Node (D, 
            [Leaf "a"])
          ]); 
        Leaf "y"])
      ])))

(* No Match *)
let make_parser_test2 = 
  ((make_parser my_grammar ["x"; "a"; "y"; "z"; "b"; "x"; "a"]) = None)


(* Match but with extra unmatched symbols *)
let make_parser_test3 = 
  ((make_parser my_grammar ["x"; "a"; "y"; "z"; "b"; "x"; "a"; "y"; "x"]) = None)