
# 9章 …… もう一度、もう一度、もう一度、……

関数`keep-looking`

``` scm
(define keep-looking
  (lambda (a sorn lat)
    (cond
     ((number? sorn)
      (keep-looking a (pick sorn lat) lat))
     (else (eq? sorn a)))))
```

関数`looking`

``` scm
(define looking
  (lambda (a lat)
    (keep-looking a (pick 1 lat) lat)))
```

``` scm
(looking 'caviar '(6 2 4 caviar 5 7 3))
```

    ;; #t

``` scm
(looking 'caviar '(6 2 grits caviar 5 7 3))
```

    ;; #f

答えを返さない関数 `eternity`

``` scm
(define eternity
  (lambda (x)
    (eternity x)))
```

関数`shift`

``` scm
(define shift
  (lambda (pair)
    (build (first (first pair))
           (build (second (first pair))
                  (second pair)))))
```

``` scm
(shift '((a b) c))
```

    ;; (a (b c))

``` scm
(shift '((a b) (c d)))
```

    ;; (a (b (c d)))

関数`align`

``` scm
(define align
  (lambda (para)
    (cond
     ((atom? para) para)
     ((a-pair? (first para))
      (align (shift para)))
     (else (build (first para)
                  (align (second para)))))))
```

`align`の引数中のアトムの数を数える関数`length*`

``` scm
(define length*
  (lambda (para)
    (cond
     ((atom? para) 1)
     (else
      (+ (length* (first para))
         (length* (second para)))))))
```

``` scm
(length* '((a b) c))
```

    ;; 3

関数`weight*`

``` scm
(define weight*
  (lambda (para)
    (cond
     ((atom? para) 1)
     (else
      (+ (* (weight* (first para)) 2)
         (weight* (second para)))))))
```

``` scm
(weight* '((a b) c))
```

    ;; 7

``` scm
(weight* '(a (b c)))
```

    ;; 5

`align`の引数の`weight*`が次第に小さくなるので`align`は全関数、ということらしい。

関数`shuffle`

``` scm
(define shuffle
  (lambda (para)
    (cond
     ((atom? para) para)
     ((a-pair? (first para))
      (shuffle (revpair para)))
     (else (build (first para)
                  (shuffle (second para)))))))
```

``` scm
(shuffle '(a (b c)))
```

    ;; (a (b c))

``` scm
(shuffle '(a b))
```

    ;; (a b)

``` scm
(shuffle '((a b) '(c d)))
```

答えが出ないので`shuffle`は全関数ではない。

関数`C`

``` scm
(define C
  (lambda (n)
    (cond
     ((one? n) 1)
     ((even? n) (C (÷ n 2)))
     (else (C (add1 (× 3 n)))))))
```

これは[コラッツの問題](https://ja.wikipedia.org/wiki/%E3%82%B3%E3%83%A9%E3%83%83%E3%83%84%E3%81%AE%E5%95%8F%E9%A1%8C)という未解決問題。

コラッツ数列を得る関数`Cseq`

``` scm
(define Cseq
  (lambda (n)
    (cond
     ((one? n) '(1))
     ((even? n) (cons n (Cseq (÷ n 2))))
     (else (cons n (Cseq (add1 (× 3 n))))))))
```

``` scm
(Cseq 6)
```

    ;; (6 3 10 5 16 8 4 2 1)

関数`A`
([アッカーマン関数](https://ja.wikipedia.org/wiki/%E3%82%A2%E3%83%83%E3%82%AB%E3%83%BC%E3%83%9E%E3%83%B3%E9%96%A2%E6%95%B0))

``` scm
(define A
  (lambda (n m)
    (cond
     ((zero? n) (add1 m))
     ((zero? m) (A (sub1 n) 1))
     (else (A (sub1 n)
              (A n (sub1 m)))))))
```

``` scm
(A 1 1)
```

    ;; 3

``` scm
(A 2 2)
```

    ;; 7

空リストに対して、ある関数が停止するかどうかを調べる関数`will-stop?`があるとする。

``` scm
(define will-stop?
  (lambda (f)
    ...))
```

関数`last-try`

``` scm
(define last-try
  (lambda (x)
    (and (will-stop? last-try)
         (eternity x))))
```

> そのようなチューリング機械の存在を仮定すると「自身が停止すると判定したならば無限ループを行い、停止しないと判定したならば停止する」ような別のチューリング機械が構成でき、矛盾となる。
> 
> [停止性問題](https://ja.wikipedia.org/wiki/%E5%81%9C%E6%AD%A2%E6%80%A7%E5%95%8F%E9%A1%8C)

空リストの長さを決める関数`length0`

``` scm
(lambda (l)
  (cond
   ((null? l) 0)
   (else (add1 (eternity (cdr l))))))
```

1つ以下の要素からなるリストの長さを決める関数`length<=1`

``` scm
(lambda (l)
  (cond
   ((null? l) 0)
   (else (add1 (length0 (cdr l))))))
```

中の`lenth0`をその定義で置き換えると

``` scm
(lambda (l)
  (cond
   ((null? l) 0)
   (else (add1
          ((lambda (l)
             (cond
              ((null? l) 0)
              (else (add1 (eternity (cdr l))))))
           (cdr l))))))
```

`length0`を生成する

``` scm
((lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (length (cdr l)))))))
 eternity)
```

`length<=1`を生成する

``` scm
((lambda (f)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (f (cdr l)))))))
 ((lambda (g)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (g (cdr l)))))))
  eternity))
```

`mk-length`を使って`length0`を生成する

``` scm
((lambda (mk-length)
   (mk-length eternity))
 (lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (length (cdr l))))))))
```

`mk-length`を使って`length<=1`を生成する

``` scm
((lambda (mk-length)
   (mk-length
    (mk-length eternity)))
 (lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (length (cdr l))))))))
```

`eternity`を使わずに`length0`を生成する

``` scm
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (mk-length (cdr l))))))))
```

`mk-length`を1回適用して`length<=1`を得る

``` scm
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 ((mk-length eternity)
                   (cdr l))))))))
```

動作確認

``` scm
(((lambda (mk-length)
    (mk-length mk-length))
  (lambda (mk-length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 ((mk-length eternity)
                    (cdr l))))))))
 '(apples))
```

    ;; 1

関数`length`

``` scm
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 ((mk-length mk-length)
                   (cdr l))))))))
```

動作確認

``` scm
(((lambda (mk-length)
    (mk-length mk-length))
  (lambda (mk-length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 ((mk-length mk-length)
                    (cdr l))))))))
 '(ham and cheese on rye))
```

    ;; 5

p.170の動かない`length`

``` scm
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   ((lambda (length)
      (lambda (l)
        (cond
         ((null? l) 0)
         (else (add1 (length (cdr l)))))))
    (mk-length mk-length))))
```

p.174の動く`length`

``` scm
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   ((lambda (length)
      (lambda (l)
        (cond
         ((null? l) 0)
         (else (add1 (length (cdr l)))))))
    (lambda (x)
      ((mk-length mk-length) x)))))
```

中の関数をくくり出すと

``` scm
((lambda (le)
   ((lambda (mk-length)
      (mk-length mk-length))
    (lambda (mk-length)
      (le (lambda (x)
            ((mk-length mk-length) x))))))
 (lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (length (cdr l))))))))
```

ここでlengthを生成している関数は

``` scm
(lambda (le)
  ((lambda (mk-length)
     (mk-length mk-length))
   (lambda (mk-length)
     (le (lambda (x)
           ((mk-length mk-length) x))))))
```

適用順Yコンビネータと呼ばれている。

``` scm
(define Y
  (lambda (le)
    ((lambda (f)
       (f f))
     (lambda (f)
       (le (lambda (x)
             ((f f) x)))))))
```

``` scm
((Y
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l))))))))
 '(ham and cheese on rye))
```

    ;; 5
