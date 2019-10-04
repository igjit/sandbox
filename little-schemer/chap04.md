
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
