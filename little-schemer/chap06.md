
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
