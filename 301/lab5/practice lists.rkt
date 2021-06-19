#lang racket
(define e1  (map list
                 '(     a  b  c)
                 (list 10 20 30)))

(display e1)
(let ([d 40]) d)
(cons '(d 40) e1)

(define e2  (map list
                 '(     e  f  g)
                 (list 10 20 30)))
(append e2 e1)

(let ((x (+ 2 2)) (y x) (z (* 3 3))))