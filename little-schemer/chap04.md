
# 4章 数遊び

関数`o+`

``` scm
(define o+
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (add1 (o+ n (sub1 m)))))))
```

    ;; o+

``` scm
(o+ 46 12)
```

    ;; 58

関数`o-`

``` scm
(define o-
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (sub1 (o- n (sub1 m)))))))
```

    ;; o-

``` scm
(o- 14 3)
```

    ;; 11

関数`addtup`

``` scm
(define addtup
  (lambda (tup)
    (cond
     ((null? tup) 0)
     (else (o+ (car tup) (addtup (cdr tup)))))))
```

    ;; addtup

``` scm
(addtup '(3 5 2 8))
```

    ;; 18

関数`×`

``` scm
(define ×
  (lambda (n m)
    (cond
     ((zero? m) 0)
     (else (o+ n (× n (sub1 m)))))))
```

    ;; ×

``` scm
(× 12 3)
```

    ;; 36
