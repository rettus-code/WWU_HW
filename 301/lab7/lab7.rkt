#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301, Winter 2021
;;
;; Lab #7
;;
;; 
;; Michael Rettus
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require racket/trace)
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
(define evaluate (lambda (exp b)
                   (cond
                        ((number? exp) exp)
                        ((symbol? exp)(lookup exp b))
                        ((special-form? exp b)(evaluate exp b)) 
                        ((list? exp)(apply-function (evaluate (car exp) b)(map (lambda (new) (evaluate new b)) (cdr exp))b))
                        (else (error "Invalid expression"))
                        )
                        )
  )
;Lookup
;Takes in symbols finds them in the environment as keys and returns their values
;Uses recursion to itereate through the environment
(define lookup (lambda (exp b)
                   (cond
                     ((null? b)(error "Symbol not in environment or environment is empty"))
                     ((symbol? exp)
                     (cond
                        ((eqv? exp (caar b))(cadar b))
                        (else (lookup exp (cdr b)))))
                     (else (error "Not a symbol")))
                 )
  )
;This just simply checks the first value in a list to see if it's a "special-form", in this case "cond" or "if"
;it returns true if either are present so the interpreter knows to evaluate the "special form"
;added test for special form let that returns true for lab 5

(define (special-form? exp b)
  (cond((equal? 'if (car exp))(evaluate-if exp b))
       ((equal? 'cond (car exp))(evaluate-cond exp b))
       ((equal? 'let (car exp))(evaluate-special-form exp b))
       ((equal? 'lambda (car exp))(evaluate-special-form exp b))
       ((equal? 'letrec (car exp))(evaluate-letrec (cdr exp) b))
       (else #f)))



;interprets the special form and evaluates the statements for truthiness returning the appropriate values based on the let, 
;cond and if special forms added one line for lab 5 to test for let and pass the portion of the list after let to function 
;joiner in reverse order It's passed in reverse order to ensure new values are tested against old environment before being 
;added so they take on the appropriate values. the new environment is then used to evaluate and resolve the argument by
;calling evaluate and passing the argument and new environment
(define evaluate-special-form (lambda (exp b)
                               (cond((equal? 'let (car exp))(define e2 (joiner (reverse(cadr exp)) b))(evaluate (caddr exp) e2))
                                    ((equal? 'lambda (car exp))(closure (cadr exp)(caddr exp)b))
                                    (else (error "Not an acceptable special form")))))

(define evaluate-if (lambda (exp env)
                          (cond((evaluate (cadr exp) env)(caddr exp))
                                          (not (evaluate (cadddr exp) env))
                                          (apply (evaluate(car(cdr exp)) env)(map (lambda (x) env)) (cdr(cadr exp))))))

(define evaluate-cond (lambda (exp env)
                      (cond((evaluate (caadr exp) env)(evaluate (cadadr exp) env))
                                          (else (special-form? (cons (car exp)(cddr exp)) env)))))
;I used this helper function to simplify readability and easy recusrion responsible for resolving the appropriate values for
;keys that are then paired added to a list and then appended to the environment returning the updated environment to
;evaluate-special-form function to be used to evaluate and later resolve the argument of the special form
(define joiner (lambda(exp b)
  (define e3 (append (list(list (caar exp) (evaluate (cadar exp) b)))b))
  (cond
    ((not(null? (cdr exp)))
     (joiner (cdr exp) e3))
    (else e3))
  ))
;tests non-special-form procedures and runs the racket apply function on them passes closures to apply-closure function
(define apply-function (lambda (ar dr b)
                           (cond ((procedure? ar )(apply ar dr))
                                 ((closure? ar)(apply-closure ar dr))
                                 (else (error "invalid function")))))
;evaluates closure and assigns closure values uses closure-recurse function to perform recursion
(define apply-closure (lambda (ar dr)
                           (evaluate (closure-body ar) (closure-recurse (closure-vars ar) dr (closure-env ar)))))
 ;handles recursion for closures to populate environment                       
(define closure-recurse (lambda (ar dr env)
                         (cond((= (length dr) 1) (cons (list (car ar) (car dr)) env))
                               (else (closure-recurse (cdr ar)(cdr dr)(cons (list (car ar) (car dr)) env))))))


 ;definitions provided in lab document                                                   
(define closure
  (lambda (vars body env)
    (mcons 'closure (mcons env (mcons vars body)))))
(define closure?
  (lambda (clos) (and (mpair? clos) (eq? (mcar clos) 'closure))))
(define closure-env
  (lambda (clos) (mcar (mcdr clos))))
(define closure-vars
  (lambda (clos) (mcar (mcdr (mcdr clos)))))
(define closure-body
  (lambda (clos) (mcdr (mcdr (mcdr clos)))))
(define set-closure-env!
  (lambda (clos new-env) (set-mcar! (mcdr clos) new-env)))
;Takes in the expression and old environment and constructs the new environment
(define evaluate-letrec (lambda (exp b)
                          (define new-env (joiner2 (car exp) b null))
                          (env-const new-env b)
                          (evaluate (cadr exp) (append new-env b))))
;Searches for pairs in the expression to add to the new environment
(define joiner2 (lambda (exp b new-env)
                  (cond
                    ((pair? exp) (define temp (append (list (list (caar exp) (evaluate (cadar exp) b))) new-env))
                     (joiner2 (cdr exp) b temp))
                    (else new-env)
                     )))
                  
;Iterates the environment setting pointers of the minature env to new env
(define env-const (lambda (min-env b)
                    (cond((null? min-env)null)
                      ((closure? (cadar min-env))(set-closure-env! (cadar min-env) (append min-env b))(env-const (cdr min-env) (append min-env b)))
                      (else (env-const (cdr min-env)(append min-env b))))))
