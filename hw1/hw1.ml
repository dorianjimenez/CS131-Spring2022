(* Copied and pasted from spec *)
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal


(* 1 *)
let rec subset a b = 
    match a with 
    | [] -> true
    | h :: t -> 
        (* If element of a is in b, then recurse and move on to next element *)
        if List.mem h b 
            then (subset t b)
        else 
            false

(* 2 *)
let rec equal_sets a b =
    (* Check if a is a subset of b, and b is a subset of a. If so, then true *)
    if (subset a b) = true then 
        if (subset b a) = true then
            true
        else
            false
    else
        false

(* 3 *)
let rec set_union a b = 
    (* Recursively add b to a by using the cons operator. Then return a *)
    match b with 
    | [] -> a
    | h :: t -> (set_union (h :: a) t)


(* 4 *)
let rec set_all_union a = (* instead make this a : 'a list list *)
    (* Same thing as above mainly. For some reason I had to add [[]] as a case. Not entirely sure why, but it works *)
    match a with 
    | [] -> []
    | [[]] -> [] (* any way to get rid of this? *)
    | h :: t -> (set_union h (set_all_union t)) (* called set_union *)


(* 5 *)
(* 
 * This function is not possible.
 * After reading a bit about Russel's Paradox and modern set theory,
 * I believe that it is impossible to write this function in OCaml. 
 * If a set was a member of itself, then it would have itself as a member, which would
 * then have itself as a member, and this would continue infinitely. Assuming
 * that you can't go recurse infinitely in OCaml, this function is impossible to write. 
 * 
 * One thing to note is that the only input we can be sure of without recursing infinitely 
 * is the empty list / empty set. Since this set has no elements, it cannot be a 
 * member of itself, therefore this would return false. 
 *)


(* 6 *)
let rec computed_fixed_point eq f x = 
    (* Check if f(x) is equal to x. If not, then recursively call *)
    if (eq (f x)) x 
        then x
    else
        computed_fixed_point eq f (f x)

(* 7 *)
(* Helper Function *)
let rec period f p x = 
    (* p is basically a counter variable for how many times to apply f(x). It decrements by one per recursive call. *)
    if p = 0
        then x
    else
        period f (p - 1) (f x)


let rec computed_periodic_point eq f p x = 
    (* Uses period function to apply f however many times necessary and then checks if x is equal to that. Else recursively call *)
     if x = (period f p x)
        then x
    else
        computed_periodic_point eq f p (f x)
        

(* 8 *)
let rec whileseq s p x = 
    (* Recursively add s(x) as long as p(x) is true. Used cons operator to append. *)
    if (p x) = true
        then x :: (whileseq s p (s x))
    else []


(* 9 *)
(* 
 * 1. Figure out which types have Terminals (T), do this by checking the type of each element of the RHS
 * 2. Figure out which other types call these types only, and then they are also good.
 * 3. Repeat 2.
 *)

(*h = T or NT symbol 
 *accepted_element = element of accepted rules list
 *)
let rec safe h accepted_element =
    (* If the symbol is equal to the element in the accepted list, then true, else false *)
    let nonterminal, rhs = accepted_element in 
    if nonterminal = h then true else false

    
(*rhs = right hand side of a rule
 *accepted = accepted rules list
 *)
let rec check rhs accepted  =  
    (* Go through each of the symbols in the RHS *)
    match rhs with
    | [] -> true
    | h :: t -> 
        (* See if the symbol is a Nonterminal or Terminal *)
        (* If it's a Terminal, go to the next element. *)
        (* If it's a Nonterminal, then we must check if the symbol exists in the accepted list (we know it can terminate basically) *)
        (* I do this by using List.exists. If it does exist in the list, then move to next element. Otherwise, it does not terminate (as we know it so far) *)
        match h with 
        | N h -> 
            if List.exists(safe h) accepted = true
                then (check t accepted)
            else 
                false

        | T h -> (check t accepted)


    

let rec filter rules accepted = 
    (* Goes through all rules one by one starting from the top *)
    match rules with 
    | [] -> accepted
    | h :: t -> 
        (* Check if the rule leads to a termination *)
        let nonterminal, rhs = h in
        if (check rhs accepted) = true
            (* If so, then check if it's already in the accepted list *)
            (* If so, then don't add it to the accepted list and move on to the next element *)
            (* Else, add it to the list and move on to the next element *)
            then if (subset [(nonterminal, rhs)] accepted) = false
                then filter t (accepted @ [(nonterminal, rhs)])
                else filter t accepted
        else 
            filter t accepted


let rec sort g unsorted_accepted sorted_accepted = 
    (* For each element of the original grammar (from top to bottom), check to see if it is in our accepted list *)
    (* If so, @ it to our sorted_accepted list, recursively call. Else, move on to next element *)
    match g with
    | [] -> sorted_accepted
    | h :: t ->
        if (subset [h] unsorted_accepted)= true
            then sort t unsorted_accepted (sorted_accepted @ [h])
        else 
            sort t unsorted_accepted sorted_accepted
    



let rec filter_blind_alleys1 g accepted = 
    (* Find the rules which we are positive ends in a termination *)
    let new_accepted = (filter (snd g) accepted) in 
    (* If this is equal to the original accepted we had, then we didn't add anything new. Therefore, we can stop recursion as we will not get anywhere farther *)
    (* However, if we did get a different list, then recursively call with the new accepted list *)
    if (accepted = new_accepted) 
        (* Also, have to sort list because my implementation will not maintain original ordering *)
        then ((fst g), (sort (snd g) (filter (snd g) accepted) []))
    else 
        filter_blind_alleys1 g new_accepted


(* Call filter_blind_alleys1. I do this because I want to meet specifications of spec but also need to add an accepted list as an argument for recursion reasons *)
let rec filter_blind_alleys g = 
    filter_blind_alleys1 g []



