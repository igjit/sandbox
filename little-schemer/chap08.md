
# 8章 究極のlambda

関数`rember-f`

``` scm
(define rember-f
  (lambda (test? a l)
    (cond
     ((null? l) (quote ()))
     ((test? (car l) a) (cdr l))
     (else (cons (car l)
                 (rember-f test? a (cdr l)))))))
```

``` scm
(rember-f = 5 '(6 2 5 3))
```

    ;; (6 2 3)

``` scm
(rember-f eq? 'jelly '(jelly beans are good))
```

    ;; (beans are good)
