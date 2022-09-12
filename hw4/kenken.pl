/* ---------------------------------------------------------------------------------------------------------------- */
/* KENKEN */
/* ---------------------------------------------------------------------------------------------------------------- */

kenken(N, C, T) :- 

    /* Make sure the rows and columns are correct length */
    len_row(T, N),
    len_col(T, N), 
       
    /* Make sure the numbers are within the domain of 1 to N */
    within_domain(T, N),

    /* Makes sure all numbers are different in row and column */
    maplist(fd_all_different, T),
    transpose(T, X),
    maplist(fd_all_different, X),

    /* Cage Constraints */
    cage_constraints(N, C, T),

    /* Find a solution */
    maplist(fd_labeling, T).


/* 
C =   
[
   +(11, [[1|1], [2|1]]),
   /(2, [1|2], [1|3]),
   *(20, [[1|4], [2|4]])
]
*/
cage_constraints(N, C, T) :- maplist(parse(T), C).


/* 
Constraint = +(11, [[1|1], [2|1]])
*/
parse(T, Constraint) :- Constraint =.. ParsedConstraint, check_constraint(ParsedConstraint, T).


/*
ParsedConstraint = [+, 11, [[1|1], [2|1]]]
*/
check_constraint(ParsedConstraint, T) :- 
    /* Addition */
    (length(ParsedConstraint, 3), nth(1, ParsedConstraint, +),
    nth(2, ParsedConstraint, Result),
    nth(3, ParsedConstraint, Operands),
    addition_check(Result, Operands, T));

    /* Subtraction */
    (length(ParsedConstraint, 4), nth(1, ParsedConstraint, -), 
    nth(2, ParsedConstraint, Result),
    nth(3, ParsedConstraint, Operand1),
    nth(4, ParsedConstraint, Operand2), 
    subtraction_check(Result, Operand1, Operand2, T));

    /* Multiplication */
    (length(ParsedConstraint, 3), nth(1, ParsedConstraint, *),
    nth(2, ParsedConstraint, Result),
    nth(3, ParsedConstraint, Operands),
    multiplication_check(Result, Operands, T));

    /* Division */
    (length(ParsedConstraint, 4), nth(1, ParsedConstraint, /), 
    nth(2, ParsedConstraint, Result),
    nth(3, ParsedConstraint, Operand1),
    nth(4, ParsedConstraint, Operand2), 
    division_check(Result, Operand1, Operand2, T)).




/*
Result = 11
Operand1 = [1|1]
Operand2 = [1|3]
*/
subtraction_check(Result, Operand1, Operand2, T) :- 
    get_value(Operand1, T, Val1),  
    get_value(Operand2, T, Val2), 
    fd_labeling(Val1),
    fd_labeling(Val2),
    (Val1 - Val2 =:= Result ; Val2 - Val1 =:= Result).


/*
Result = 11
Operand1 = [1|1]
Operand2 = [1|3]
*/
division_check(Result, Operand1, Operand2, T) :- 
    get_value(Operand1, T, Val1),  
    get_value(Operand2, T, Val2),
    fd_labeling(Val1),
    fd_labeling(Val2),
    (Val1 / Val2 =:= Result ; Val2 / Val1 =:= Result).


/*
Result = 11
[HD | TL] = [[1|1], [2|1]]
*/

addition_check(Result, [], T) :-
    Result = 0.

addition_check(Result, [HD | TL], T) :- 
    get_value(HD, T, Val1),  
    fd_labeling(Val1),
    NewResult is Result - Val1,
    addition_check(NewResult, TL, T).


/*
Result = 11
[HD | TL] = [[1|1], [2|1]]
*/

multiplication_check(Result, [], T) :-
    Result = 1.0.

multiplication_check(Result, [HD | TL], T) :- 
    get_value(HD, T, Val1), 
    fd_labeling(Val1),
    NewResult is Result / Val1,
    multiplication_check(NewResult, TL, T).



/* ---------------------------------------------------------------------------------------------------------------- */
/* PLAIN KENKEN */
/* ---------------------------------------------------------------------------------------------------------------- */

plain_kenken(N, C, T) :-   

    /* Make 2d list with all permutations from 1 to N */
    make_list(T, N),

    /* Makes sure all numbers are different in row and column */
    maplist(unique, T),
    transpose(T, X),
    maplist(unique, X),

    /* Constraints */
    cage_constraints_no_fd(N, C, T).



cage_constraints_no_fd(N, C, T) :-
    maplist(parse_no_fd(T), C).
    

parse_no_fd(T, Constraint) :- Constraint =.. ParsedConstraint, check_constraint_no_fd(ParsedConstraint, T).


/*
ParsedConstraint = [+, 11, [[1|1], [2|1]]]
*/
check_constraint_no_fd(ParsedConstraint, T) :- 
    /* Addition */
    (length(ParsedConstraint, 3), nth(1, ParsedConstraint, +),
    /* write(addition), nl,*/
    nth(2, ParsedConstraint, Result),
    nth(3, ParsedConstraint, Operands),
    addition_check_no_fd(Result, Operands, T));

    /* Subtraction */
    (length(ParsedConstraint, 4), nth(1, ParsedConstraint, -), 
    /*write(subtraction), nl, */
    nth(2, ParsedConstraint, Result),
    nth(3, ParsedConstraint, Operand1),
    nth(4, ParsedConstraint, Operand2), 
    subtraction_check_no_fd(Result, Operand1, Operand2, T));

    /* Multiplication */
    (length(ParsedConstraint, 3), nth(1, ParsedConstraint, *),
    /* write(multiplication), nl,*/
    nth(2, ParsedConstraint, Result),
    nth(3, ParsedConstraint, Operands),
    multiplication_check_no_fd(Result, Operands, T));

    /* Division */
    (length(ParsedConstraint, 4), nth(1, ParsedConstraint, /), 
    /*write(division), nl,*/
    nth(2, ParsedConstraint, Result),
    nth(3, ParsedConstraint, Operand1),
    nth(4, ParsedConstraint, Operand2), 
    division_check_no_fd(Result, Operand1, Operand2, T)).



/*
Result = 11
Operand1 = [1|1]
Operand2 = [1|3]
*/
subtraction_check_no_fd(Result, Operand1, Operand2, T) :- 
    get_value(Operand1, T, Val1),  
    get_value(Operand2, T, Val2), 
    (Val1 - Val2 =:= Result ; Val2 - Val1 =:= Result).


/*
Result = 11
Operand1 = [1|1]
Operand2 = [1|3]
*/
division_check_no_fd(Result, Operand1, Operand2, T) :- 
    get_value(Operand1, T, Val1),  
    get_value(Operand2, T, Val2),
    (Val1 / Val2 =:= Result ; Val2 / Val1 =:= Result).


/*
Result = 11
[HD | TL] = [[1|1], [2|1]]
*/

addition_check_no_fd(Result, [], T) :-
    Result = 0.

addition_check_no_fd(Result, [HD | TL], T) :- 
    get_value(HD, T, Val1),  
    NewResult is Result - Val1,
    addition_check_no_fd(NewResult, TL, T).


/*
Result = 11
[HD | TL] = [[1|1], [2|1]]
*/

multiplication_check_no_fd(Result, [], T) :-
    Result = 1.0.

multiplication_check_no_fd(Result, [HD | TL], T) :- 
    get_value(HD, T, Val1), 
    NewResult is Result / Val1,
    multiplication_check_no_fd(NewResult, TL, T).



unique([]).
unique([HD | TL]) :-
    not_in(HD, TL), unique(TL).

not_in(Element, []).

not_in(Element, [HD|TL]):-
    Element \= HD,
    not_in(Element, TL).



make_list(List, N) :-
    length(List, N),
    maplist(unique_list(N), List).

unique_list(N, List) :-
    length(List, N),
    elements_between(List, 1, N),
    all_unique(List).

elements_between(List,  Min, Max) :- maplist(between(Min, Max), List).

all_unique([]).
all_unique([H|T]) :- member(H, T), !, fail.
all_unique([_|T]) :- all_unique(T).
    

/* 
[HD | TL] = [1|1]
*/
get_value([HD | TL], T, Val) :- nth(HD, T, Row), nth(TL, Row, Value),  Val = Value.


/* ---------------------------------------------------------------------------------------------------------------- */
/* TA Code and Test Cases */   
/* ---------------------------------------------------------------------------------------------------------------- */


within_domain([], _).
within_domain([HD | TL], N) :-
    fd_domain(HD, 1, N),
    within_domain(TL, N).

len_row(X, N) :-
    length(X, N).

len_col([], _).
len_col([HD | TL], N) :-
    length(HD, N),
    len_col(TL, N).


transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).
transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).
lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).





