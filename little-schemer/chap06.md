
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
