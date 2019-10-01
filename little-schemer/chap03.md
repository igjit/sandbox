
# 3章 偉大なるCons

p.35の`rember`(未完成)

``` scm
(define rember
  (lambda (a lat)
    (cond
     ((null? lat) (quote ()))
     (else (cond
            ((eq? (car lat) a) (cdr lat))
             (else (rember a (cdr lat))))))))
```

    ;; rember

baconを除く

``` scm
(rember 'bacon '(bacon lettuce and tomato))
```

    ;; (lettuce and tomato)

andを除いたときにandの前にある全ての要素を失ってしまう

``` scm
(rember 'and '(bacon lettuce and tomato))
```

    ;; (tomato)
