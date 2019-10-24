(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

(define add1
  (lambda (n) (+ n 1)))

(define sub1
  (lambda (n) (- n 1)))
