#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301, Winter 2021
;;
;; Lab #4
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
;Purposely chose not to use ! or not something something changes state something....
;added new cond ((special-form?  a)(evaluate-special-form a b)) for this weeks lab
(define evaluate (lambda (a b)
                   (cond
                        ((number? a) a);Returns valid numbers
                      
                        ((symbol? a)(lookup a b));calls on lookup to validate symbol as a key in the environment and returns the keys value
                        ((list? a);checks if an expression is a list if it is then the condition checks if it's a procedure and process it using apply and map functions
                         (cond((special-form?  a)(evaluate-special-form a b))
                              ((procedure? (lookup (car a) b))(apply (lookup (car a) b)(map (lambda (a) (evaluate a b))(cdr a))))
                              (else(error "List not a procedure"))));throws an error if the list is not a procedure
                        (else (error "Invalid expression"));throws an error if value tested is not a number, symbol, or list
                        )
                        )
  )
;Lookup
;Takes in symbols finds them in the environment as keys and returns their values
;Uses recursion to itereate through the environment
(define lookup (lambda (a b)
                   (cond; Null? is to verify environment is not empty and stops recursion after all keys check against input symbol
                     ((null? b)(error "Symbol not in environment or environment is empty"))
                     ((symbol? a);verifies a is a symbol
                     (cond
                        ((eqv? a (caar b))(cadar b));tests input symbol against environments first key and returns the value if matches
                        (else (lookup a (cdr b)))));if previous test fails calls lookup recursively and drops the environments fisrt key so second key is now the first
                     (else (error "Not a symbol")));Throws error if input was not a symbol
                 )
  )
;This just simply checks the first value in a list to see if it's a "special-form", in this case "cond" or "if"
;it returns true if either are present so the interpreter knows to evaluate the "special form"
(define (special-form? a)
  (cond((equal? 'if (car a))#t)
       ((equal? 'cond (car a))#t)
       (else #f)))

;interprets the special form and evaluates the statements for truthiness returning the appropriate values
(define evaluate-special-form (lambda (a b)
                               (cond((equal? 'if (car a));checks for if statment
                                     (cond((evaluate (cadr a) b)(caddr a));evaluates if statements truthiness, if true returns first value
                                          (else (cadddr a))));if false this returns second value
                                    ((equal? 'cond (car a));checks for cond statement
                                     (cond((evaluate (caadr a) b)(evaluate (cadadr a) b));evaluates if top cond value is true or an else statement, then evaluates it return data to be returned after processing
                                          (else (evaluate-special-form (cons (car a)(cddr a)) b))));if cond is false recursively goes to the next line until a true cond (else is always true) is found
                                    (else (error "Not an acceptable special form")))));error for invalid forms, but not likely to be necessary since they were previously tested










