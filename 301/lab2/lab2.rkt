#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301, Winter 2021
;;
;; Lab #2
;;
;; 
;; 
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide distribute
         subsets
         element-ordered?
         length-ordered?
         )
(define subsets (lambda (ls)
                  (display ls)
              (sort (sublists (ls length-ordered?)))
               )
)
(define sublists (lambda (ls)
                  (display ls)
                 (cond ((null? ls) '(()))
                       (else (let ((sub (sublists (cdr ls))))
                        (append (distribute (car ls) sub) sub)
                        ))
                       )
              )  
  )
(define element-ordered? (lambda (ls1 ls2)
                           (cond ((and (null? ls1) (null? ls2)) #t)
                                 ((<(car ls1) (car ls2)) #t)
                                 ((>(car ls1) (car ls2)) #f)
                                 (else (element-ordered? (cdr ls1) (cdr ls2)))
                            )     
                         )
  )
(define length-ordered? (lambda (ls1 ls2)
                           (cond ((and (null? ls1) (null? ls2)) element-ordered? (ls1 ls2))
                                 ((null? ls1) #t)
                                 ((null? ls2) #f)
                                 (else (length-ordered? (cdr ls1) (cdr ls2)))
                             )
                        )
 )
(define distribute (lambda (ls1 ls2)
                     (cond ((null? ls2) '())
                     (else (cons(cons ls1 (car ls2)))
                                (distribute ls1 (cdr ls2))
                          ))
                     )
)

