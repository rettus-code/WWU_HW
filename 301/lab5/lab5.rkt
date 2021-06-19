#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301, Winter 2021
;;
;; Lab #5
;;
;; 
;; Michael Rettus
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide lookup
         evaluate
         special-form?
         evaluate-special-form
         )
;Though I wrote lookup first it felt more natural for operation flow to write evaluate above lookup
;Evaluate
;Evaluates expressions and returns the values those epressions represent ie variables or procedures
;Numbers are returned as numbers, symbols are validated against the environment then returned and lists
;are converted into procedures and processed for final values
;I kept the variables simple, a is what is currently being evaluated and b is the current environment other
;other variables are defined within the scope intended to be used only
;added new cond ((special-form?  a)(evaluate-special-form a b)) for lab 4
(define evaluate (lambda (a b)
                   (cond
                        ((number? a) a)
                        ((symbol? a)(lookup a b))
                        ((list? a)
                         (cond((special-form?  a)(evaluate-special-form a b)) 
                              ((procedure? (lookup (car a) b))(apply (lookup (car a) b)(map (lambda (a) (evaluate a b))(cdr a))))
                              (else(error "List not a procedure"))))
                        (else (error "Invalid expression"))
                        )
                        )
  )
;Lookup
;Takes in symbols finds them in the environment as keys and returns their values
;Uses recursion to itereate through the environment
(define lookup (lambda (a b)
                   (cond
                     ((null? b)(error "Symbol not in environment or environment is empty"))
                     ((symbol? a)
                     (cond
                        ((eqv? a (caar b))(cadar b))
                        (else (lookup a (cdr b)))))
                     (else (error "Not a symbol")))
                 )
  )
;This just simply checks the first value in a list to see if it's a "special-form", in this case "cond" or "if"
;it returns true if either are present so the interpreter knows to evaluate the "special form"
;added test for special form let that returns true for lab 5
(define (special-form? a)
  (cond((equal? 'if (car a))#t)
       ((equal? 'cond (car a))#t)
       ((equal? 'let (car a))#t)
       (else #f)))

;interprets the special form and evaluates the statements for truthiness returning the appropriate values based on the let, 
;cond and if special forms added one line for lab 5 to test for let and pass the portion of the list after let to function 
;joiner in reverse order It's passed in reverse order to ensure new values are tested against old environment before being 
;added so they take on the appropriate values. the new environment is then used to evaluate and resolve the argument by
;calling evaluate and passing the argument and new environment
(define evaluate-special-form (lambda (a b)
                               (cond((equal? 'if (car a))
                                     (cond((evaluate (cadr a) b)(caddr a))
                                          (else (cadddr a))))
                                    ((equal? 'cond (car a))
                                     (cond((evaluate (caadr a) b)(evaluate (cadadr a) b))
                                          (else (evaluate-special-form (cons (car a)(cddr a)) b))))
                                    ((equal? 'let (car a))(define e2 (joiner (reverse(cadr a)) b))(evaluate (caddr a) e2))
                                    (else (error "Not an acceptable special form")))))

;I used this helper function to simplify readability and easy recusrion responsible for resolving the appropriate values for
;keys that are then paired added to a list and then appended to the environment returning the updated environment to
;evaluate-special-form function to be used to evaluate and later resolve the argument of the special form
(define joiner (lambda(a b)
  (define e3 (append (list(list (caar a) (evaluate (cadar a) b)))b))
  (cond
    ((not(null? (cdr a)))
     (joiner (cdr a) e3))
    (else e3))
  ))






