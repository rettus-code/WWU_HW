#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301, Winter 2021
;;
;; Lab #3
;;
;; 
;; Michael Rettus
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide lookup
         evaluate
         )
;Though I wrote lookup first it felt more natural for operation flow to write evaluate above lookup
;Evaluate
;Evaluates expressions and returns the values those epressions represent ie variables or procedures
;Numbers are returned as numbers, symbols are validated against the environment then returned and lists
;are converted into procedures and processed for final values
;Purposely chose not to use ! or not something something changes state something....
(define evaluate (lambda (a b)
                   (cond
                        ((symbol? a)(lookup a b));calls on lookup to validate symbol as a key in the environment and returns the keys value
                        ((number? a) a);Returns valid numbers
                        ((list? a);checks if an expression is a list if it is then the condition checks if it's a procedure and process it using apply and map functions
                         (cond((procedure? (lookup (car a) b))(apply (lookup (car a) b)(map (lambda (a) (evaluate a b))(cdr a))))
                              (else(error "List not a procedure"))));throws an error if the list is not a procedure
                        (else(error "Invalid expression"));throws an error if value tested is not a number, symbol, or list
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
