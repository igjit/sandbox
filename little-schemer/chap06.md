
# 6章 影法師

関数`numbered?`

``` scm
(define numbered?
  (lambda (aexp)
    (cond
     ((atom? aexp) (number? aexp))
     (else
      (and (numbered? (car aexp))
           (numbered? (car (cdr (cdr aexp)))))))))
```

``` scm
(numbered? '(3 + (4 ↑ 5)))
```

    ;; #t

``` scm
(numbered? '(2 × sausage))
```

    ;; #f

関数`value`

``` scm
(define value
  (lambda (nexp)
    (cond
     ((atom? nexp) nexp)
     ((eq? (car (cdr nexp)) (quote +))
      (o+ (value (car nexp))
          (value (car (cdr (cdr nexp))))))
     ((eq? (car (cdr nexp)) (quote ×))
      (× (value (car nexp))
          (value (car (cdr (cdr nexp))))))
     (else
      (↑ (value (car nexp))
          (value (car (cdr (cdr nexp)))))))))
```

``` scm
(value '(1 + 3))
```

    ;; 4

``` scm
(value '(1 + (3 ↑ 4)))
```

    ;; 82

補助関数`1st-sub-exp`

``` scm
(define 1st-sub-exp
  (lambda (aexp)
    (car (cdr aexp))))
```

補助関数`2nd-sub-exp`

``` scm
(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))
```

補助関数`operator`

``` scm
(define operator
  (lambda (aexp)
    (car aexp)))
```

前置記法の算術式に対する`value`

``` scm
(define value
  (lambda (nexp)
    (cond
     ((atom? nexp) nexp)
     ((eq? (operator nexp) (quote +))
      (o+ (value (1st-sub-exp nexp))
          (value (2nd-sub-exp nexp))))
     ((eq? (operator nexp) (quote +))
      (× (value (1st-sub-exp nexp))
          (value (2nd-sub-exp nexp))))
     (else
      (↑ (value (1st-sub-exp nexp))
          (value (2nd-sub-exp nexp)))))))
```

``` scm
(value '(+ 1 (↑ 3 4)))
```

    ;; 82

補助関数を書き換えて中置記法に戻す

``` scm
(define 1st-sub-exp
  (lambda (aexp)
    (car aexp)))
```

``` scm
(define operator
  (lambda (aexp)
    (car (cdr aexp))))
```

``` scm
(value '(1 + (3 ↑ 4)))
```

    ;; 82

数の他の表現

``` scm
(define sero?
  (lambda (n)
    (null? n)))
```

``` scm
(define edd1
  (lambda (n)
    (cons (quote ()) n)))
```

``` scm
(define zub1
  (lambda (n)
    (cdr n)))
```

この表現を使って書き直した`o+`

``` scm
(define o+
  (lambda (n m)
    (cond
     ((sero? m) n)
     (else (edd1 (o+ n (zub1 m)))))))
```

``` scm
(o+ '(() ()) '(() () ()))
```

    ;; (() () () () ())
