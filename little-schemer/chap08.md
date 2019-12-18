
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

関数`eq?-c`

``` scm
(define eq?-c
  (lambda (a)
    (lambda (x)
      (eq? x a))))
```

`eq?-c`を使った関数`eq?-salad`

``` scm
(define eq?-salad
  (eq?-c 'salad))
```

``` scm
(eq?-salad 'salad)
```

    ;; #t

``` scm
(eq?-salad 'tuna)
```

    ;; #f

名前を付ける必要はない

``` scm
((eq?-c 'salad) 'tuna)
```

    ;; #f

`test?`を受け取って関数を返すように書き換えた`rember-f`

``` scm
(define rember-f
  (lambda (test?)
    (lambda (a l)
      (cond
       ((null? l) (quote ()))
       ((test? (car l) a) (cdr l))
       (else (cons (car l)
                   ((rember-f test?) a (cdr l))))))))
```

``` scm
((rember-f eq?) 'tuna '(tuna salad is good))
```

    ;; (salad is good)
