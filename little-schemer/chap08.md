
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

関数`insertL-f`

``` scm
(define insertL-f
  (lambda (test?)
    (lambda (new old l)
      (cond
       ((null? l) (quote ()))
       ((test? (car l) old)
        (cons new (cons old (cdr l))))
       (else
        (cons (car l)
              ((insertL-f test?) new old (cdr l))))))))
```

``` scm
((insertL-f eq?) 'x 'b '(a b c d))
```

    ;; (a x b c d)

関数`insertR-f`

``` scm
(define insertR-f
  (lambda (test?)
    (lambda (new old l)
      (cond
       ((null? l) (quote ()))
       ((test? (car l) old)
        (cons old (cons new (cdr l))))
       (else
        (cons (car l)
              ((insertR-f test?) new old (cdr l))))))))
```

``` scm
((insertR-f eq?) 'x 'b '(a b c d))
```

    ;; (a b x c d)

関数`insert-g`

``` scm
(define insert-g
  (lambda (seq)
    (lambda (new old l)
      (cond
       ((null? l) (quote ()))
       ((eq? (car l) old)
        (seq new old (cdr l)))
       (else
        (cons (car l)
              ((insert-g seq) new old (cdr l))))))))
```

`insert-g`を使って定義した`insertL`

``` scm
(define insertL
  (insert-g
   (lambda (new old l)
     (cons new (cons old l)))))
```

``` scm
(insertL 'x 'b '(a b c d))
```

    ;; (a x b c d)

補助関数`seqS`

``` scm
(define seqS
  (lambda (new old l)
    (cons new l)))
```

`seqS`を使って定義した`subst`

``` scm
(define subst (insert-g seqS))
```

``` scm
(subst 'x 'b '(a b c d))
```

    ;; (a x c d)
