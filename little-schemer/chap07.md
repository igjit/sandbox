
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

関数`subset?`

``` scm
(define subset?
  (lambda (set1 set2)
    (cond
     ((null? set1) #t)
     ((member? (car set1) set2)
      (subset? (cdr set1) set2))
     (else #f))))
```

``` scm
(subset? '(5 chicken wings)
         '(5 hamburgers
           2 pieces fried chicken and
           light duckling wings))
```

    ;; #t

``` scm
(subset? '(4 pounds of horseradish)
         '(four pounds chicken and5
           ounces horseradish))
```

    ;; #f

関数`eqset?`

``` scm
(define eqset?
  (lambda (set1 set2)
    (and (subset? set1 set2)
         (subset? set2 set1))))
```

``` scm
(eqset? '(6 large chickens with wings)
        '(6 chickens with large wings))
```

    ;; #t

関数`intersect?`

``` scm
(define intersect?
  (lambda (set1 set2)
    (cond
     ((null? set1) #f)
     (else
      (or (member? (car set1) set2)
          (intersect? (cdr set1) set2))))))
```

``` scm
(intersect? '(stewed tomatoes and macaroni)
            '(macaroni and cheese))
```

    ;; #t

関数`intersect`

``` scm
(define intersect
  (lambda (set1 set2)
    (cond
     ((null? set1) (quote ()))
     ((member? (car set1) set2)
      (cons (car set1) (intersect (cdr set1) set2)))
     (else
      (intersect (cdr set1) set2)))))
```

``` scm
(intersect '(stewed tomatoes and macaroni)
           '(macaroni and cheese))
```

    ;; (and macaroni)

関数`union`

``` scm
(define union
  (lambda (set1 set2)
    (cond
     ((null? set1) set2)
     ((member? (car set1) set2)
      (union (cdr set1) set2))
     (else
      (cons (car set1) (union (cdr set1) set2))))))
```

``` scm
(union '(stewed tomatoes and macaroni casserole)
       '(macaroni and cheese))
```

    ;; (stewed tomatoes casserole macaroni and cheese)

関数`intersectall`

``` scm
(define intersectall
  (lambda (l-set)
    (cond
     ((null? (cdr l-set)) (car l-set))
     (else (intersect (car l-set)
                      (intersectall (cdr l-set)))))))
```

``` scm
(intersectall '((6 pears and)
                (3 peaches and 6 peppers)
                (8 pears and 6 plums)
                (and 6 prunes with lots of apples)))
```

    ;; (6 and)
