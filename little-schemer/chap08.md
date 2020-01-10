
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

関数`yyy`

``` scm
(define seqrem
  (lambda (new old l)
    l))

(define yyy
  (lambda (a l)
    ((insert-g seqrem) #f a l)))
```

``` scm
(yyy 'sausage '(pizza with sausage and bacon))
```

    ;; (pizza with and bacon)

関数`atom-to-function`

``` scm
(define atom-to-function
  (lambda (x)
    (cond
     ((eq? x (quote +)) o+)
     ((eq? x (quote ×)) ×)
     (else ↑))))
```

`atom-to-function`を使った`value`

``` scm
(define value
  (lambda (nexp)
    (cond
     ((atom? nexp) nexp)
     (else
      ((atom-to-function (operator nexp))
       (value (1st-sub-exp nexp))
       (value (2nd-sub-exp nexp)))))))
```

``` scm
(value '(1 + (2 ↑ 3)))
```

    ;; 9

関数`multirember-f`

``` scm
(define multirember-f
  (lambda (test?)
    (lambda (a lat)
      (cond
       ((null? lat) (quote ()))
       ((test? (car lat) a)
        ((multirember-f test?) a (cdr lat)))
       (else (cons (car lat)
                   ((multirember-f test?) a (cdr lat))))))))
```

``` scm
((multirember-f eq?) 'tuna '(shrimp salad tuna salad and tuna))
```

    ;; (shrimp salad salad and)

`multirember-f`を使った関数`multirember-eq?`

``` scm
(define multirember-eq?
  (multirember-f eq?))
```

``` scm
(multirember-eq? 'tuna '(shrimp salad tuna salad and tuna))
```

    ;; (shrimp salad salad and)

補助関数`eq?-tuna`

``` scm
(define eq?-tuna
  (eq?-c 'tuna))
```

関数`multiremberT`

``` scm
(define multiremberT
  (lambda (test? lat)
    (cond
     ((null? lat) (quote ()))
     ((test? (car lat))
      (multiremberT test? (cdr lat)))
     (else (cons (car lat)
                 (multiremberT test? (cdr lat)))))))
```

``` scm
(multiremberT eq?-tuna '(shrimp salad tuna salad and tuna))
```

    ;; (shrimp salad salad and)

関数`multirember&co`

``` scm
(define multirember&co
  (lambda (a lat col)
    (cond
     ((null? lat)
      (col (quote ()) (quote ())))
     ((eq? (car lat) a)
      (multirember&co
       a
       (cdr lat)
       (lambda (newlat seen)
         (col newlat
              (cons (car lat) seen)))))
     (else
      (multirember&co
       a
       (cdr lat)
       (lambda (newlat seen)
         (col (cons (car lat) newlat)
              seen)))))))
```

収集子`a-friend`

``` scm
(define a-friend
  (lambda (x y)
    (null? y)))
```

``` scm
(multirember&co 'tuna '() a-friend)
```

    ;; #t

``` scm
(multirember&co 'tuna '(tuna) a-friend)
```

    ;; #f

``` scm
(multirember&co 'tuna '(and tuna) a-friend)
```

    ;; #f

収集子`last-friend`

``` scm
(define last-friend
  (lambda (x y)
    (length x)))
```

``` scm
(multirember&co 'tuna '(strawberries tuna and swordfish) last-friend)
```

    ;; 3

関数`multiinsertLR&co`

``` scm
(define multiinsertLR&co
  (lambda (new oldL oldR lat col)
    (cond
     ((null? lat)
      (col (quote ()) 0 0))
     ((eq? (car lat) oldL)
      (multiinsertLR&co
       new oldL oldR
       (cdr lat)
       (lambda (newlat L R)
         (col (cons new (cons oldL newlat))
              (add1 L) R))))
     ((eq? (car lat) oldR)
      (multiinsertLR&co
       new oldL oldR
       (cdr lat)
       (lambda (newlat L R)
         (col (cons oldR (cons new newlat))
              L (add1 R)))))
     (else
      (multiinsertLR&co
       new oldL oldR
       (cdr lat)
       (lambda (newlat L R)
         (col (cons (car lat) newlat)
              L R)))))))
```

``` scm
(multiinsertLR&co 'salty 'fish 'chips '(chips and fish or fish and chips) list)
```

    ;; ((chips salty and salty fish or salty fish and chips salty) 2 2)

関数`evens-only*`

``` scm
(define evens-only*
  (lambda (l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((even? (car l))
        (cons (car l)
              (evens-only* (cdr l))))
       (else (evens-only* (cdr l)))))
     (else (cons (evens-only* (car l))
                 (evens-only* (cdr l)))))))
```

``` scm
(evens-only* '((9 1 2 8) 3 10 ((9 9) 7 6) 2))
```

    ;; ((2 8) 10 (() 6) 2)
