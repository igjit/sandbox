
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

関数`firsts`

``` scm
(define firsts
  (lambda (l)
    (cond
     ((null? l) (quote ()))
     (else (cons (car (car l)) (firsts (cdr l)))))))
```

    ;; firsts

``` scm
(firsts '((a b) (c d) (e f)))
```

    ;; (a c e)

関数`insertR`

``` scm
(define insertR
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((eq? (car lat) old)
        (cons old
              (cons new (cdr lat))))
       (else (cons (car lat)
                   (insertR new old
                            (cdr lat)))))))))
```

    ;; insertR

``` scm
(insertR 'topping 'fudge '(ice cream with fudge for dessert))
```

    ;; (ice cream with fudge topping for dessert)

関数`insertL`

``` scm
(define insertL
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((eq? (car lat) old)
        (cons new lat))
       (else (cons (car lat)
                   (insertL new old
                            (cdr lat)))))))))
```

    ;; insertL

``` scm
(insertL 'x 'b '(a b c d))
```

    ;; (a x b c d)

関数`subst`

``` scm
(define subst
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((eq? (car lat) old)
        (cons new (cdr lat)))
       (else (cons (car lat)
                   (subst new old
                            (cdr lat)))))))))
```

    ;; subst

``` scm
(subst 'topping 'fudge '(ice cream with fudge for dessert))
```

    ;; (ice cream with topping for dessert)

関数`subst2`

``` scm
(define subst2
  (lambda (new o1 o2 lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((or (eq? (car lat) o1)
            (eq? (car lat) o2))
        (cons new (cdr lat)))
       (else (cons (car lat)
                   (subst2 new o1 o2
                           (cdr lat)))))))))
```

    ;; subst2

``` scm
(subst2 'vanilla 'chocolate 'banana '(banana ice creamwith chocolate topping))
```

    ;; (vanilla ice creamwith chocolate topping)

関数`multirember`

``` scm
(define multirember
  (lambda (a lat)
    (cond
     ((null? lat) (quote ()))
     ((eq? (car lat) a)
      (multirember a (cdr lat)))
     (else (cons (car lat)
                 (multirember a (cdr lat)))))))
```

    ;; multirember

``` scm
(multirember 'cup '(coffee cup tea cup and hick cup))
```

    ;; (coffee tea and hick)

関数`multiinsertR`

``` scm
(define multiinsertR
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     ((eq? (car lat) old)
      (cons old
            (cons new
                  (multiinsertR new old (cdr lat)))))
     (else (cons (car lat)
                 (multiinsertR new old (cdr lat)))))))
```

    ;; multiinsertR

``` scm
(multiinsertR 'x 'b '(a b c d b e))
```

    ;; (a b x c d b x e)

関数`multiinsertL`

``` scm
(define multiinsertL
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     ((eq? (car lat) old)
      (cons new
            (cons old
                  (multiinsertL new old (cdr lat)))))
     (else (cons (car lat)
                 (multiinsertL new old (cdr lat)))))))
```

    ;; multiinsertL

``` scm
(multiinsertL 'x 'b '(a b c d b e))
```

    ;; (a x b c d x b e)

関数`multisubst`

``` scm
(define multisubst
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     ((eq? (car lat) old)
      (cons new (multisubst new old (cdr lat))))
     (else (cons (car lat)
                 (multisubst new old (cdr lat)))))))
```

    ;; multisubst

``` scm
(multisubst 'x 'b '(a b c d b e))
```

    ;; (a x c d x e)
