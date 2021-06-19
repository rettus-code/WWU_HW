0#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301, Spring 2018
;; 
;; Lab #1
;;
;; Michael Rettus
;; W01530314
;;
;; The purpose of this program is to 
;; bla bla bla
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide make-pi)
(define make-pi
    (lambda (tolerance) 
      (letrec
            (
             (approx-pi (lambda (num den sum)
                         (cond ((< (abs (- pi sum)) tolerance) sum)
                         (else
                          (begin
                            (set! sum (- sum (/ num den)))
                            (set! num (* num -1.0))
                            (display tolerance)
                            (set! den(+ den 2.0))
                            (approx-pi num den sum)))
        ))))
             (approx-pi -4.0 1.0 0.0)
  )))


