
# 10章 このすべての値は何だ

関数`new-entry`

``` scm
(define new-entry build)
```

関数`lookup-in-entry`

``` scm
(define lookup-in-entry
  (lambda (name entry entry-f)
    (lookup-in-entry-help
     name
     (first entry)
     (second entry)
     entry-f)))

(define lookup-in-entry-help
  (lambda (name names values entry-f)
    (cond
     ((null? names) (entry-f name))
     ((eq? (car names) name) (car values))
     (else (lookup-in-entry-help
            name
            (cdr names)
            (cdr values)
            entry-f)))))
```

関数`extend-table`

``` scm
(define extend-table cons)
```

関数`lookup-in-table`

``` scm
(define lookup-in-table
  (lambda (name table table-f)
    (cond
     ((null? table) (table-f name))
     (else (lookup-in-entry
            name
            (car table)
            (lambda (name)
              (lookup-in-table
               name
               (cdr table)
               table-f)))))))
```

テーブル

``` scm
(define table
  '(((entrée dessert)
     (spaghetti spumoni))
    ((appetizer entrée beverage)
     (food tastes good))))
```

``` scm
(lookup-in-table 'entrée table (lambda (name) '()))
```

    ;; spaghetti

``` scm
(lookup-in-table 'beverage table (lambda (name) '()))
```

    ;; good

関数`expression-to-action`

``` scm
(define expression-to-action
  (lambda (e)
    (cond
     ((atom? e) (atom-to-action e))
     (else (list-to-action e)))))

(define atom-to-action
  (lambda (e)
    (cond
     ((number? e) *const)
     ((eq? e #t) *const)
     ((eq? e #f) *const)
     ((eq? e (quote cons)) *const)
     ((eq? e (quote car)) *const)
     ((eq? e (quote cdr)) *const)
     ((eq? e (quote null?)) *const)
     ((eq? e (quote eq?)) *const)
     ((eq? e (quote atom?)) *const)
     ((eq? e (quote zero?)) *const)
     ((eq? e (quote add1)) *const)
     ((eq? e (quote sub1)) *const)
     ((eq? e (quote number?)) *const)
     (else *identifier))))

(define list-to-action
  (lambda (e)
    (cond
     ((atom? (car e))
      (cond
       ((eq? (car e) (quote quote))
        *quote)
       ((eq? (car e) (quote lambda))
        *lambda)
       ((eq? (car e) (quote cond))
        *cond)
       (else *application)))
     (else *application))))
```

関数`value`

``` scm
(define value
  (lambda (e)
    (meaning e (quote ()))))
```

関数`meaning`

``` scm
(define meaning
  (lambda (e table)
    ((expression-to-action e) e table)))
```

アクション`*const`

``` scm
(define *const
  (lambda (e table)
    (cond
     ((number? e) e)
     ((eq? e #t) #t)
     ((eq? e #f) #f)
     (else
      (build (quote primitive) e)))))
```

アクション`*quote`

``` scm
(define *quote
  (lambda (e table)
    (text-of e)))

(define text-of second)
```

アクション`*identifier`

``` scm
(define *identifier
  (lambda (e table)
    (lookup-in-table e table initial-table)))

(define initial-table
  (lambda (name)
    (car (quote ()))))
```

アクション`*lambda`

``` scm
(define *lambda
  (lambda (e table)
    (build (quote non-primitive)
           (cons table (cdr e)))))
```

``` scm
(meaning '(lambda (x) (cons x y)) '(((y z) ((8) 9))))
```

    ;; (non-primitive ((((y z) ((8) 9))) (x) (cons x y)))

3要素(テーブル、仮引数、本体)のリストから構成部分を取り出すための補助関数

``` scm
(define table-of first)
(define formals-of second)
(define body-of third)
```

関数`evcon`

``` scm
(define evcon
  (lambda (lines table)
    (cond
     ((else? (question-of (car lines)))
      (meaning (answer-of (car lines)) table))
     ((meaning (question-of (car lines)) table)
      (meaning (answer-of (car lines)) table))
     (else
      (evcon (cdr lines) table)))))

(define else?
  (lambda (x)
    (and (atom? x)
         (eq? x (quote else)))))

(define question-of first)
(define answer-of second)
```

アクション`*cond`

``` scm
(define *cond
  (lambda (e table)
    (evcon (cond-lines-of e) table)))

(define cond-lines-of cdr)
```

``` scm
(*cond '(cond (coffee klatsch) (t party))
       '(((coffee) (t))
         ((klatsch party) (5 (6)))))
```

    ;; 5

関数`evlis`

``` scm
(define evlis
  (lambda (args table)
    (cond
     ((null? args) '())
     (else
      (cons (meaning (car args) table)
            (evlis (cdr args) table))))))
```

アクション`*application`

``` scm
(define *application
  (lambda (e table)
    (apply-
     (meaning (function-of e) table)
     (evlis (arguments-of e) table))))

(define function-of car)
(define arguments-of cdr)
```

関数`primitive?`、`non-primitive?`

``` scm
(define primitive?
  (lambda (l)
    (eq? (first l) 'primitive)))

(define non-primitive?
  (lambda (l)
    (eq? (first l) 'non-primitive)))
```

関数`apply-`

([apply](https://practical-scheme.net/gauche/man/gauche-refj/Shou-Sok-kitoJi-Sok-.html#index-apply)とかぶらないように名前を変えている)

``` scm
(define apply-
  (lambda (fun vals)
    (cond
     ((primitive? fun)
      (apply-primitive (second fun) vals))
     ((non-primitive? fun)
      (apply-closure (second fun) vals)))))
```

関数`apply-primitive`

``` scm
(define apply-primitive
  (lambda (name vals)
    (cond
     ((eq? name (quote cons))
      (cons (first vals) (second vals)))
     ((eq? name (quote car))
      (car (first vals)))
     ((eq? name (quote cdr))
      (cdr (first vals)))
     ((eq? name (quote null?))
      (null? (first vals)))
     ((eq? name (quote eq?))
      (eq? (first vals) (second vals)))
     ((eq? name (quote atom?))
      (*atom? (first vals)))
     ((eq? name (quote zero?))
      (zero? (first vals)))
     ((eq? name (quote add1))
      (add1 (first vals)))
     ((eq? name (quote sub1))
      (sub1 (first vals)))
     ((eq? name (quote number?))
      (number (first vals))))))
```

関数`apply-closure`

``` scm
(define apply-closure
  (lambda (closure vals)
    (meaning (body-of closure)
             (extend-table
              (new-entry
               (formals-of closure)
               vals)
              (table-of closure)))))
```

``` scm
(apply-closure '((((u v w)
                   (1 2 3))
                  ((x y z)
                   (4 5 6)))
                 (x y)
                 (cons z x))
               '((a b c) (d e f)))
```

    ;; (6 a b c)

インタプリタの完成。

``` scm
(value '(add1 2))
```

    ;; 3

``` scm
(value '(cons 1 (cons 2 (quote ()))))
```

    ;; (1 2)

再帰はYコンビネータによって得られる。

``` scm
(value
 '(((lambda (le)
      ((lambda (f)
         (f f))
       (lambda (f)
         (le (lambda (x)
               ((f f) x))))))
    (lambda (length)
      (lambda (l)
        (cond
         ((null? l) 0)
         (else (add1 (length (cdr l))))))))
   '(ham and cheese on rye)))
```

    ;; 5
