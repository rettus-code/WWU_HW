#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301, Winter 2021
;;
;; Lab #8
;;
;; 
;; Michael Rettus
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide parse)
;The purpose of this code is to parse incoming strings into characters, that are converted to symbols or numbers
;that are concatenated into a list in the same order or basic structure as the original string to be evaluated
;with the evaluste function built in previous labs. Nearly all the code was duplicated from the RPN-parse II
;Program provided by Aran Clauson.
(define parse
  (lambda (str)
    (first (first(L (string->list str))))
    )
  )

;Originally I planned to start with E but it started to feel easier to start with L Still E is the work horse as
;far as directing function calls for most of the grammer calls L for (L), D followed by N and A followed by S
;ensuring the processes are handled in the proper order
(define E
  (lambda (input)
    (cond
     ( (eq? #\((first input)) (L (rest input)))
     [(null? input) (cons null null)]
     ((D? (first input)) (let* ((d-rest (D input))
                                (n-rest (N (rest d-rest)
                                           (first d-rest))))
                           n-rest))
     [(A? (first input)) (let* ((a-rest (A input))
                                (s-rest (S (rest a-rest)(first a-rest))))
                                s-rest)]
       (else (error (string-append "Not a digit:"
                                  (list->string input))))
     )
    )
  )
;Start function that handles empty space, closing ) and passing expresions to E
(define L
  (lambda (input)
    (cond
     [(null? input) (cons input null)]
     [(char-whitespace? (first input))(L (rest input))]
     ((eq? #\)(first input)) (cons null (rest input)))
     (else  (let* ((e-rest (E input))
                                (l-rest (L (rest e-rest))))
                           (cons (cons (first e-rest)
                                       (first l-rest))
                                 (rest l-rest))))
     )
    )
  )
;Designed to handle symbols/charachters in the same way N handles numbers. It calls on A to
;Test for char-symbolic and uses string->symbol and string append to concatenate the symbols
;within the list
(define S
  (lambda (input inhert)
    (cond
     [(null? input) (cons inhert input)]
     ((A? (first input)) (let* ((a-rest (A input))
                                (s-rest (S (rest a-rest)
                        (string->symbol(string-append (symbol->string inhert)
                                                      (symbol->string (first a-rest)))))))
                                   s-rest))
     (else (cons inhert input))
     )
    )
  )
;boiler plate code directly from RPN-Parse2 used to link charecter numbers together if they are a multidigit
;values (any |value| greater than 9)used as a model for S function
(define N
  (lambda (input inhert)
    (cond
     [(null? input) (cons inhert input)]
     [(D? (first input)) (let* ((d-rest (D input))
                                (n-rest (N (rest d-rest)
                                           (+ (* 10 inhert)
                                              (first d-rest)))))
                           
                           (cons (first n-rest)
                                 (rest n-rest)))]
     [else (cons inhert input)]
     )
    )
  )

(define D? char-numeric?)

;boiler plate code directly from RPN-Parse2 used to check a char for a number value in conjuntion with N
;to convert strings to lists of numbers.
(define D
  (lambda (input)
    (cond
     [(D? (first input)) (cons (char->number (first input))
                               (rest input))]
      [else (error (string-append "Not a digit:"
                                  (list->string input)))]
      )
    )
  )

(define char->number
  (lambda (char)
    (- (char->integer char)
       (char->integer #\0))
    )
  )
;boiler plate code from the lab document to determine if a char is any symbol except _,(, or)
(define char-symbolic?
  (lambda (char)
    (and (not (char-whitespace? char))
         (not (eq? char #\())
         (not (eq? char #\))))))

(define A? char-symbolic? )
;boiler plate code directly from RPN-Parse2 except it uses A vice P and helper function determines
; symbol vice an operator.
(define A
  (lambda (input)
    (cond
    [(A? (first input)) (cons (string->symbol (string (first input)))(rest input))]
      [else (error (string-append "Not a symbol:"
                                  (list->string input)))]
      )
    )
  )


