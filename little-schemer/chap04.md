
# 4章 数遊び

関数`o+`

``` scm
(define o+
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (add1 (o+ n (sub1 m)))))))
```

    ;; o+

``` scm
(o+ 46 12)
```

    ;; 58

関数`o-`

``` scm
(define o-
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (sub1 (o- n (sub1 m)))))))
```

    ;; o-

``` scm
(o- 14 3)
```

    ;; 11

関数`addtup`

``` scm
(define addtup
  (lambda (tup)
    (cond
     ((null? tup) 0)
     (else (o+ (car tup) (addtup (cdr tup)))))))
```

    ;; addtup

``` scm
(addtup '(3 5 2 8))
```

    ;; 18

関数`×`

``` scm
(define ×
  (lambda (n m)
    (cond
     ((zero? m) 0)
     (else (o+ n (× n (sub1 m)))))))
```

    ;; ×

``` scm
(× 12 3)
```

    ;; 36

p.70の`tup+`

``` scm
(define tup+
  (lambda (tup1 tup2)
    (cond
     ((and (null? tup1) (null? tup2))
      (quote ()))
     (else
      (cons (o+ (car tup1) (car tup2))
            (tup+ (cdr tup1) (cdr tup2)))))))
```

    ;; tup+

``` scm
(tup+ '(3 7) '(4 6))
```

    ;; (7 13)

p.73のどんな2つのタップでも動く`tup+`

``` scm
(define tup+
  (lambda (tup1 tup2)
    (cond
     ((null? tup1) tup2)
     ((null? tup2) tup1)
     (else
      (cons (o+ (car tup1) (car tup2))
            (tup+ (cdr tup1) (cdr tup2)))))))
```

    ;; tup+

``` scm
(tup+ '(3 7) '(4 6 8 1))
```

    ;; (7 13 8 1)

関数`＞`

``` scm
(define ＞
  (lambda (n m)
    (cond
     ((zero? n) #f)
     ((zero? m) #t)
     (else (＞ (sub1 n) (sub1 m))))))
```

    ;; ＞

``` scm
(＞ 12 133)
```

    ;; #f

``` scm
(＞ 120 11)
```

    ;; #t

``` scm
(＞ 3 3)
```

    ;; #f

関数`＜`

``` scm
(define ＜
  (lambda (n m)
    (cond
     ((zero? m) #f)
     ((zero? n) #t)
     (else (＜ (sub1 n) (sub1 m))))))
```

    ;; ＜

``` scm
(＜ 4 6)
```

    ;; #t

``` scm
(＜ 8 3)
```

    ;; #f

``` scm
(＜ 6 6)
```

    ;; #f

関数`＝`

``` scm
(define ＝
  (lambda (n m)
    (cond
     ((＞ n m) #f)
     ((＜ n m) #f)
     (else #t))))
```

    ;; ＝

``` scm
(＝ 2 3)
```

    ;; #f

``` scm
(＝ 3 3)
```

    ;; #t

関数`↑`

``` scm
(define ↑
  (lambda (n m)
    (cond
     ((zero? m) 1)
     (else (× n (↑ n (sub1 m)))))))
```

    ;; ↑

``` scm
(↑ 2 3)
```

    ;; 8

関数`÷`

``` scm
(define ÷
  (lambda (n m)
    (cond
     ((＜ n m) 0)
     (else (add1 (÷ (o- n m) m))))))
```

    ;; ÷

``` scm
(÷ 15 4)
```

    ;; 3

関数`length`

``` scm
(define length
  (lambda (lat)
    (cond
     ((null? lat) 0)
     (else (add1 (length (cdr lat)))))))
```

    ;; length

``` scm
(length '(ham and cheese on rye))
```

    ;; 5

関数`pick`

``` scm
(define pick
  (lambda (n lat)
    (cond
     ((zero? (sub1 n)) (car lat))
     (else (pick (sub1 n) (cdr lat))))))
```

    ;; pick

``` scm
(pick 4 '(lasagna spaghetti ravioli macaroni meatball))
```

    ;; macaroni

関数`rempick`

``` scm
(define rempick
  (lambda (n lat)
    (cond
     ((zero? (sub1 n)) (cdr lat))
     (else (cons (car lat)
                 (rempick (sub1 n)
                          (cdr lat)))))))
```

    ;; rempick

``` scm
(rempick 3 '(hotdogs with hot mustard))
```

    ;; (hotdogs with mustard)

関数`no-nums`

``` scm
(define no-nums
  (lambda (lat)
    (cond
     ((null? lat) (quote ()))
     ((number? (car lat)) (no-nums (cdr lat)))
     (else
      (cons (car lat)
            (no-nums (cdr lat)))))))
```

    ;; no-nums

``` scm
(no-nums '(5 pears 6 prunes 9 dates))
```

    ;; (pears prunes dates)

関数`all-nums`

``` scm
(define all-nums
  (lambda (lat)
    (cond
     ((null? lat) (quote ()))
     ((number? (car lat))
      (cons (car lat)
            (all-nums (cdr lat))))
     (else
      (all-nums (cdr lat))))))
```

    ;; all-nums

``` scm
(all-nums '(5 pears 6 prunes 9 dates))
```

    ;; (5 6 9)
