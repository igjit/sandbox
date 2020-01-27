
# 9章 …… もう一度、もう一度、もう一度、……

関数`keep-looking`

``` scm
(define keep-looking
  (lambda (a sorn lat)
    (cond
     ((number? sorn)
      (keep-looking a (pick sorn lat) lat))
     (else (eq? sorn a)))))
```

関数`looking`

``` scm
(define looking
  (lambda (a lat)
    (keep-looking a (pick 1 lat) lat)))
```

``` scm
(looking 'caviar '(6 2 4 caviar 5 7 3))
```

    ;; #t

``` scm
(looking 'caviar '(6 2 grits caviar 5 7 3))
```

    ;; #f

関数`shift`

``` scm
(define shift
  (lambda (pair)
    (build (first (first pair))
           (build (second (first pair))
                  (second pair)))))
```

``` scm
(shift '((a b) c))
```

    ;; (a (b c))

``` scm
(shift '((a b) (c d)))
```

    ;; (a (b (c d)))

関数`align`

``` scm
(define align
  (lambda (para)
    (cond
     ((atom? para) para)
     ((a-pair? (first para))
      (align (shift para)))
     (else (build (first para)
                  (align (second para)))))))
```

`align`の引数中のアトムの数を数える関数`length*`

``` scm
(define length*
  (lambda (para)
    (cond
     ((atom? para) 1)
     (else
      (+ (length* (first para))
         (length* (second para)))))))
```

``` scm
(length* '((a b) c))
```

    ;; 3
