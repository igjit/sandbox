
# 3章 偉大なるCons

p.35の未完成な`rember`

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

p.38の`rember`

``` scm
(define rember
  (lambda (a lat)
    (cond
     ((null? lat) (quote ()))
     (else (cond
            ((eq? (car lat) a) (cdr lat))
            (else (cons (car lat)
                        (rember a (cdr lat)))))))))
```

    ;; rember

``` scm
(rember 'and '(bacon lettuce and tomato))
```

    ;; (bacon lettuce tomato)

p.41の簡単化した`rember`

``` scm
(define rember
  (lambda (a lat)
    (cond
     ((null? lat) (quote ()))
     ((eq? (car lat) a) (cdr lat))
     (else (cons (car lat)
                 (rember a (cdr lat)))))))
```

    ;; rember

``` scm
(rember 'and '(bacon lettuce and tomato))
```

    ;; (bacon lettuce tomato)

``` scm
(rember 'sauce '(soy sauce and tomato sauce))
```

    ;; (soy and tomato sauce)
