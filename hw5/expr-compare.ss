#lang racket
(provide (all-defined-out))
(define ns (make-base-namespace))  


; PART 1 ----------------------------------------------------------------------------

; Judging lambda
(define (diff-lambda? x y)
    (or
        (and
            (equal? (car x) 'λ) 
            (equal? (car y) 'lambda)   
            (equal? (length x) 3)
            (equal? (length y) 3)
            (list? x)
            (list? y)
        )
        (and
            (equal? (car x) 'lambda) 
            (equal? (car y) 'λ)   
            (equal? (length x) 3)
            (equal? (length y) 3)
            (list? x)
            (list? y)
        )
    )
)

; Judging if
(define (if? x)
    (and 
        (equal? (car x) 'if)
        (equal? (length x) 4)
        (list? x)
    )
)

(define (lambda? x)
    (and 
        (equal? (car x) 'lambda)
        (equal? (length x) 3)
    )
)

(define (cons? x)
    (and 
        (equal? (car x) 'cons)
        (equal? (length x) 3)
    )
)

; Judging if same lambda symbol
(define (same-lambda? x y)
    (or
        (and 
            (equal? (car x) 'lambda)
            (equal? (car y) 'lambda)
        )

        (and
            (equal? (car x) 'λ)
            (equal? (car y) 'λ)
        
        )
    
    )

)

; Comparing Variables
(define (compare-variables x y vars)
    (if (and (equal? (length x) 0) (equal? (length y) 0)) vars 
        (if (equal? (car x) (car y)) (compare-variables (cdr x) (cdr y) (append vars (list (car x))))
            (compare-variables (cdr x) (cdr y) 
                (append vars 
                    (list (string->symbol (string-append (symbol->string (car x)) "!" (symbol->string (car y)))))
                ))
        )
    )
)

; Changes one variable in lambda expression to match binded variable
(define (modify-variable-in-expression x var original-var l)

    (if (equal? 0 (length x))
        l
        (if (not (list? (car x)))

            ; If the symbol we are looking for is (car x), we replace, otherwise we just put the symbol back in the list
            (if (equal? (car x) original-var)
                (modify-variable-in-expression (cdr x) var original-var (append l (list var)) )
                (modify-variable-in-expression (cdr x) var original-var (append l (list (car x))))
            )

            (modify-variable-in-expression (cdr x) var original-var (append l (list (modify-variable-in-expression (car x) var original-var '()))))
        )

    )

)

; Changes variables in lambda expression to match binded variables
(define (modify-expression x vars original-vars)
    (if (equal? (length vars) 0)
        x
        (if (equal? (car vars) (car original-vars)) 
            (modify-expression x (cdr vars) (cdr original-vars))
            (modify-expression (modify-variable-in-expression x (car vars) (car original-vars) '()) (cdr vars) (cdr original-vars))

        ) 
    )

)

(define (expr-compare x y)
    (cond 
        ; Both are Equal
        [(equal? x y) 
            x
        ]

        ; Both booleans but not equal
        [(and (boolean? x) (boolean? y)) 
            (if x '% '(not %))
        ]
        
        ; If one of them is not list - which means that not function
        [(or (not (list? x)) (not (list? y)))
            (list 'if '% x y)
        ]

        ; One list is an if statement, other is not
        [(or (and (if? x) (not (if? y))) (and (if? y) (not (if? x))))
            (list 'if '% x y)
        ]

        ; Both list but of different length, and neither quote expression
        [(and (list? x) (list? y) (not (equal? (length x) (length y))) (not (equal? (car x) 'quote)) (not (equal? (car y) 'quote)))
            (list 'if '% x y)
        ]

        ; If lambda initialization variables are not in a list
        [(and (list? x) (list? y) (equal? (length x) (length y)) (equal? 3 (length x)) (same-lambda? x y) (or (not (list? (cadr x))) (not (list? (cadr y)))))
            (if (not (list? (cadr x)))
                (if (not (list? (cadr y)))
                    (let ((new-x (append (append (list (car x)) (list (list (cadr x)))) (cddr x)))
                          (new-y (append (append (list (car y)) (list (list (cadr y)))) (cddr y))))
                        (let ((answer (expr-compare new-x new-y)))
                            (append (append (list (car answer)) (cadr answer)) (cddr answer))
                        )
                    )
                    (let ((new-x (cons (cons (car x) (list (cadr x))) (cddr x))))
                        (expr-compare new-x y)
                    ) 
                )
                (if (not (list? (cadr y)))
                    (let ((new-y (cons (cons (car y) (list (cadr y))) (cddr y))))
                        (expr-compare x new-y)
                    )
                    (expr-compare x y)
                )
            )

        ]
        
    
        ; Both list of same length, and both different (lambda λ) expressions
        [(and (list? x) (list? y) (equal? (length x) (length y)) (diff-lambda? x y))
            ; If lambda variable instantiation is not the same size, return, else change to λ and recurse
            (if (not (equal? (length (cadr x)) (length (cadr y)))) (list 'if '% x y) (expr-compare (cons 'λ (cdr x)) (cons 'λ (cdr y))))
            
        ]

        ; One Cons and one Lambda of same Length
        [(and (list? x) (list? y) (or (and (cons? x) (lambda? y)) (and (cons? y) (lambda? x))))          
            ; If lambda variable instantiation is not the same size, return, else change to λ and recurse
            (list 'if '% x y)        
        ]

        ; Both list of same length, and both lambda expressions 
        ; Check if have diff # of arguments, if so can't compare
        [(and (same-lambda? x y) (equal? (length x) 3) (equal? (length y) 3))
            
            ; If lambda variable instantiation is not the same size return uncombined, else 
            (if (not (equal? (length (cadr x)) (length (cadr y)))) (list 'if '% x y) 
                (let ((combined-variables (compare-variables (cadr x) (cadr y) '())))
                    
                    (let ((new-x (cons (car x) (modify-expression (cdr x) combined-variables (cadr x))))
                         (new-y (cons (car y) (modify-expression (cdr y) combined-variables (cadr y)))))
                            (cons
                                (expr-compare (car new-x) (car new-y))
                                (expr-compare (cdr new-x) (cdr new-y))
                            )
                    )

                )
            )
    
        ]


        ; If one or more is a quote expression
        [(or (equal? (car x) 'quote) (equal? (car y) 'quote))
            (list 'if '% x y)
        ]

        ; Both list of same length and neither quote expression, recursively check each element
        [(and (list? x) (list? y) (equal? (length x) (length y)) (not (equal? (car x) 'quote)) (not (equal? (car y) 'quote)))
            (cons
                (expr-compare (car x) (car y))
                (expr-compare (cdr x) (cdr y))
            )
        ]

    )
)


; PART 2 ----------------------------------------------------------------------------

(define (test-expr-compare x y) 
    (and 
        (equal? (eval x ns)
                (eval `(let ((% #t)) ,(expr-compare x y)) ns))
        (equal? (eval y ns)
                (eval `(let ((% #f)) ,(expr-compare x y)) ns))
    )
)


; PART 3 ----------------------------------------------------------------------------

; WARNING: IT MUST BE A SINGLE TEST CASE
; You need to cover all grammars including:
;     constant literals, variables, procedure calls, quote, lambda, if
(define test-expr-x
    '(cons 
        '25
        ((lambda (a b) (+ (if (equal? a #t) 1 2) b)) 
                #f (- 5 2))
    )
)

(define test-expr-y
    '(cons 
        '10
        ((λ (c d) (- (if (equal? c #f) 9 20) d)) 
                #t (- 7 1))
    )
)

