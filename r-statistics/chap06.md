
# 第6章 2つの平均値を比較する

## 6.2 独立な2群のt検定

``` r
統計1男 <- c(6,10,6,10,5,3,5,9,3,3)
統計1女 <- c(11,6,11,9,7,5,8,7,7,9)
プール標準偏差 <- sqrt(((length(統計1男)-1)*var(統計1男)+(length(統計1女)-1)*var(統計1女)) / (length(統計1男)+length(統計1女)-2))
プール標準偏差
```

    ## [1] 2.426703

``` r
t統計量 <- (mean(統計1男)-mean(統計1女)) / (プール標準偏差*sqrt(1/length(統計1男)+1/length(統計1女)))
t統計量
```

    ## [1] -1.842885

p値

``` r
2*pt(-1.842885,18)
```

    ## [1] 0.08187807

``` r
t.test(統計1男,統計1女,var.equal=TRUE)
```

    ## 
    ##  Two Sample t-test
    ## 
    ## data:  統計1男 and 統計1女
    ## t = -1.8429, df = 18, p-value = 0.08188
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -4.2800355  0.2800355
    ## sample estimates:
    ## mean of x mean of y 
    ##         6         8

## 6.3 t検定の前提条件

分散の等質性

``` r
クラスA <- c(54, 55, 52, 48, 50, 38, 41, 40, 53, 52)
クラスB <- c(67, 63, 50, 60, 61, 69, 43, 58, 36, 29)
var.test(クラスA, クラスB)
```

    ## 
    ##  F test to compare two variances
    ## 
    ## data:  クラスA and クラスB
    ## F = 0.21567, num df = 9, denom df = 9, p-value = 0.03206
    ## alternative hypothesis: true ratio of variances is not equal to 1
    ## 95 percent confidence interval:
    ##  0.05356961 0.86828987
    ## sample estimates:
    ## ratio of variances 
    ##          0.2156709

Welchの検定

``` r
t.test(クラスA, クラスB, var.equal=FALSE)
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  クラスA and クラスB
    ## t = -1.1191, df = 12.71, p-value = 0.2838
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -15.554888   4.954888
    ## sample estimates:
    ## mean of x mean of y 
    ##      48.3      53.6

## 6.4 対応のあるt検定

``` r
統計テスト1 <- c(6,10,6,10,5,3,5,9,3,3,11,6,11,9,7,5,8,7,7,9)
統計テスト2 <- c(10,13,8,15,8,6,9,10,7,3,18,14,18,11,12,5,7,12,7,7)
変化量 <- 統計テスト2 - 統計テスト1
```

``` r
t統計量 <- mean(変化量) / (sd(変化量)/sqrt(length(変化量)))
t統計量
```

    ## [1] 4.839903

``` r
qt(0.025,19,lower.tail=FALSE)
```

    ## [1] 2.093024

``` r
t.test(統計テスト1,統計テスト2,paired=TRUE)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  統計テスト1 and 統計テスト2
    ## t = -4.8399, df = 19, p-value = 0.0001138
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -4.297355 -1.702645
    ## sample estimates:
    ## mean of the differences 
    ##                      -3

## 練習問題

(1)

``` r
統計好き <- c(6,10,6,10,11,6,11,7)
統計嫌い <- c(5,3,5,9,3,3,9,5,8,7,7,9)
var.test(統計好き,統計嫌い)
```

    ## 
    ##  F test to compare two variances
    ## 
    ## data:  統計好き and 統計嫌い
    ## F = 0.94598, num df = 7, denom df = 11, p-value = 0.9781
    ## alternative hypothesis: true ratio of variances is not equal to 1
    ## 95 percent confidence interval:
    ##  0.2516814 4.4550605
    ## sample estimates:
    ## ratio of variances 
    ##          0.9459792

(2)

``` r
心理男 <- c(13,14,7,12,10,6,8,15,4,14)
心理女 <- c(9,6,10,12,5,12,8,8,12,15)
var.test(心理男,心理女)
```

    ## 
    ##  F test to compare two variances
    ## 
    ## data:  心理男 and 心理女
    ## F = 1.5575, num df = 9, denom df = 9, p-value = 0.5196
    ## alternative hypothesis: true ratio of variances is not equal to 1
    ## 95 percent confidence interval:
    ##  0.3868588 6.2704508
    ## sample estimates:
    ## ratio of variances 
    ##           1.557491

(3)

``` r
参加前 <- c(61,50,41,55,51,48,46,55,65,70)
参加後<- c(59,48,33,54,47,52,38,50,64,63)
t.test(参加後,参加前,paired=TRUE)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  参加後 and 参加前
    ## t = -2.8465, df = 9, p-value = 0.0192
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -6.1019918 -0.6980082
    ## sample estimates:
    ## mean of the differences 
    ##                    -3.4
