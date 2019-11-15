
# 7章 友達と親類

(準備)
[equal?](http://practical-scheme.net/gauche/man/gauche-refj/Deng-Jia-Xing-toBi-Jiao-.html#index-equal_003f)を使った`member?`と`multirember`

``` scm
(define member?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     (else
      (or (equal? (car lat) a)
          (member? a (cdr lat)))))))

(define multirember
  (lambda (a lat)
    (cond
     ((null? lat) (quote ()))
     ((equal? (car lat) a)
      (multirember a (cdr lat)))
     (else (cons (car lat)
                 (multirember a (cdr lat)))))))
```

関数`set?`

``` scm
(define set?
  (lambda (lat)
    (cond
     ((null? lat) #t)
     ((member? (car lat) (cdr lat)) #f)
     (else (set? (cdr lat))))))
```

``` scm
(set? '(apple peaches apple plum))
```

    ;; #f

``` scm
(set? '(apple peaches pears plum))
```

    ;; #t

`member?`を使った`markeset`

``` scm
(define makeset
  (lambda (lat)
    (cond
     ((null? lat) (quote ()))
     ((member? (car lat) (cdr lat))
      (makeset (cdr lat)))
     (else
      (cons (car lat) (makeset (cdr lat)))))))
```

``` scm
(makeset '(apple peach pear peach plum apple lemon peach))
```

    ;; (pear plum apple lemon peach)

`multirember`を使った`markeset`

``` scm
(define makeset
  (lambda (lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cons (car lat)
            (makeset
             (multirember (car lat)
                          (cdr lat))))))))
```

``` scm
(makeset '(apple peach pear peach plum apple lemon peach))
```

    ;; (apple peach pear plum lemon)

※ 本の`(makeset lat)`の結果は誤植と思われる。
