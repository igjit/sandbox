
# 5章 \*すごい\*星がいっぱいだ

関数`rember*`

``` scm
(define rember*
  (lambda (a l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((eq? (car l) a)
        (rember* a (cdr l)))
       (else
        (cons (car l) (rember* a (cdr l))))))
     (else
      (cons (rember* a (car l))
            (rember* a (cdr l)))))))
```

``` scm
(rember* 'cup '((coffee) cup ((tea) cup) (and (hick)) cup))
```

    ;; ((coffee) ((tea)) (and (hick)))

関数`insertR*`

``` scm
(define insertR*
  (lambda (new old l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((eq? (car l) old)
        (cons (car l)
              (cons new (insertR* new old (cdr l)))))
       (else
        (cons (car l) (insertR* new old (cdr l))))))
     (else
      (cons (insertR* new old (car l))
            (insertR* new old (cdr l)))))))
```

``` scm
(insertR* 'roast 'chuck
          '((how much (wood)) could ((a (wood) chuck))
            (((chuck))) (if (a) ((wood chuck))) could chuck wood))
```

    ;; ((how much (wood)) could ((a (wood) chuck roast)) (((chuck roast))) (if (a) ((wood chuck roast))) could chuck roast wood)

関数`occur*`

``` scm
(define occur*
  (lambda (a l)
    (cond
     ((null? l) 0)
     ((atom? (car l))
      (cond
       ((eq? (car l) a)
        (add1 (occur* a (cdr l))))
       (else
        (occur* a (cdr l)))))
     (else
      (+ (occur* a (car l))
         (occur* a (cdr l)))))))
```

``` scm
(occur* 'banana
        '((banana) (split ((((banana ice))) (cream (banana)) sherbet))
          (banana) (bread) (banana brandy)))
```

    ;; 5

関数`subst*`

``` scm
(define subst*
  (lambda (new old l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((eq? (car l) old)
        (cons new (subst* new old (cdr l))))
       (else
        (cons (car l) (subst* new old (cdr l))))))
     (else
      (cons (subst* new old (car l))
            (subst* new old (cdr l)))))))
```

``` scm
(subst* 'orange 'banana
        '((banana) (split ((((banana ice))) (cream (banana)) sherbet))
          (banana) (bread) (banana brandy)))
```

    ;; ((orange) (split ((((orange ice))) (cream (orange)) sherbet)) (orange) (bread) (orange brandy))

関数`insertL*`

``` scm
(define insertL*
  (lambda (new old l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((eq? (car l) old)
        (cons new
              (cons old (insertL* new old (cdr l)))))
       (else
        (cons (car l) (insertL* new old (cdr l))))))
     (else
      (cons (insertL* new old (car l))
            (insertL* new old (cdr l)))))))
```

``` scm
(insertL* 'pecker 'chuck
          '((how much (wood)) could ((a (wood) chuck))
            (((chuck))) (if (a) ((wood chuck))) could chuck wood))
```

    ;; ((how much (wood)) could ((a (wood) pecker chuck)) (((pecker chuck))) (if (a) ((wood pecker chuck))) could pecker chuck wood)

関数`member*`

``` scm
(define member*
  (lambda (a l)
    (cond
     ((null? l) #f)
     ((atom? (car l))
      (or (eq? (car l) a)
          (member* a (cdr l))))
     (else
      (or (member* a (car l))
          (member* a (cdr l)))))))
```

``` scm
(member* 'chips '((potato) (chips ((with) fish) (chips))))
```

    ;; #t
