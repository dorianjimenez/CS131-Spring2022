(* Copied and pasted from project spec 1 *)
type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal

(* Copied and pasted from project spec 2 *)
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal



(* 1 *)
let rec grammar1_to_grammar2 rules accumulator non_terminal =
  match rules with 
  | [] -> List.rev accumulator
  | h :: t -> 
    if non_terminal = (fst h)
      then (grammar1_to_grammar2 t ((snd h) :: accumulator) non_terminal)
    else
      (grammar1_to_grammar2 t accumulator non_terminal)
  
  
(* We will pass in rules into grammar1_to_grammar2, and we will be left with a function that takes in a symbol *)
let rec convert_grammar gram1 =
  (fst gram1), (grammar1_to_grammar2 (snd gram1) [] )


(* --------------------------------------------------------------------------------------------- *)


(* 2 *)
let rec get_leaves tree accumulator= 
  match tree with 
  | [] -> accumulator
  | h :: t ->  
    match h with 
    | Node (x, y) -> get_leaves y accumulator @ get_leaves t []
    | Leaf x -> get_leaves t (accumulator @ [x])


let rec parse_tree_leaves tree =
  get_leaves (tree :: []) []

  
(* 
let rec take_out_list x = 
  match x with 
  | [] -> []
  | h :: t -> h

let rec test x = 
  match x with 
  | [] -> []
  | h :: t -> take_out_list h :: test t

let rec parse_tree_leaves tree =
  match tree with 
  | Node (x, y) -> let x = List.map(parse_tree_leaves) y in (test x)
  | Leaf x -> [x]
*)


(* --------------------------------------------------------------------------------------------- *)


(* 3 *)
(* let rec clean data accumulator = 
  match data with 
  | [] -> accumulator
  | h :: t -> 
    match h with 
    | (x, y) -> 
      match y with 
      | [] -> clean t accumulator
      | _ -> clean t accumulator @ [h] *)


let rec make_matcher gram = 
  match gram with
  | (start_symbol, rules) -> (fun accept frag -> (ex_ruleset gram (rules start_symbol) accept frag))


(* 
ex: current_ruleset = 
    [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N Expr; T")"]]
*)
and ex_ruleset gram current_ruleset accept frag = 
  match current_ruleset with
  | [] -> None
  | h :: t -> 
     let temp = (ex_rule gram h accept frag) in 
      if temp = None
        then (ex_ruleset gram t accept frag)
        else temp



(* 
ex: current_rule = 
  [T"("; N Expr; T")"]
*)
and ex_rule gram current_rule accept frag = 
  match current_rule with 
  | [] -> (accept frag)
  | h :: t -> (ex_symbol gram h t accept frag)



(* 
ex: current_symbol = T"("     or        N Expr
*)
and ex_symbol gram current_symbol next_symbols accept frag = 
  match current_symbol with
  | N symbol ->      
      ex_ruleset gram ((snd gram) symbol) (ex_ruleset gram (next_symbols :: []) accept) frag
      (* ex_ruleset gram ((snd gram) symbol) (ex_rule gram next_symbols accept) frag *)
  | T symbol -> 
      match frag with 
      | [] -> None
      | h :: t -> 
        if symbol = h 
          then (ex_rule gram next_symbols accept t)
          else None



(* --------------------------------------------------------------------------------------------- *)


(* I didn't have enough time to implement this unfortunately *)
let rec make_parser gram frag = None








