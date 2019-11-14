
# 7章 友達と親類

[equal?](http://practical-scheme.net/gauche/man/gauche-refj/Deng-Jia-Xing-toBi-Jiao-.html#index-equal_003f)を使った`member?`

``` scm
(define member?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     (else
      (or (equal? (car lat) a)
          (member? a (cdr lat)))))))
```

``` scm
(member? 'meat '(mashed potatos and meat gravy))
```

    ;; #t

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
