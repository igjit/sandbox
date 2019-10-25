
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
          '(((how much (wood)) could ((a (wood) chuck))
             (((chuck))) (if (a) ((wood chuck))) could chuck wood)))
```

    ;; (((how much (wood)) could ((a (wood) chuck roast)) (((chuck roast))) (if (a) ((wood chuck roast))) could chuck roast wood))

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
