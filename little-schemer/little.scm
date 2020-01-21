(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

(define add1
  (lambda (n) (+ n 1)))

(define sub1
  (lambda (n) (- n 1)))

(define eqan?
  (lambda (a1 a2)
    (cond
     ((and (number? a1) (number? a2))
      (= a1 a2))
     ((or (number? a1) (number? a2))
      #f)
     (else (eq? a1 a2)))))

(define firsts
  (lambda (l)
    (cond
     ((null? l) (quote ()))
     (else (cons (car (car l)) (firsts (cdr l)))))))

(define pick
  (lambda (n lat)
    (cond
     ((zero? (sub1 n)) (car lat))
     (else (pick (sub1 n) (cdr lat))))))
