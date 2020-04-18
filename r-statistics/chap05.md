
# 第5章 統計的仮説検定

## 5.3 標準正規分布を用いた検定

``` r
心理学テスト <- c(13,14,7,12,10,6,8,15,4,14,9,6,10,12,5,12,8,8,12,15)
Z統計量 <- (mean(心理学テスト)-12) / sqrt(10/length(心理学テスト))
Z統計量
```

    ## [1] -2.828427

``` r
qnorm(0.025)
```

    ## [1] -1.959964

``` r
qnorm(0.025,lower.tail=FALSE)
```

    ## [1] 1.959964

``` r
curve(dnorm(x),-3,3)
abline(v=qnorm(0.025))
abline(v=qnorm(0.975))
```

![](chap05_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

p値を求める

``` r
2*pnorm(2.828427,lower.tail=FALSE)
```

    ## [1] 0.004677737

有意水準0.05よりも小さいので、帰無仮説は棄却される。

## 5.4 t分布を用いた検定

``` r
t統計量 <- (mean(心理学テスト)-12) / sqrt(var(心理学テスト)/length(心理学テスト))
t統計量
```

    ## [1] -2.616648

p値

``` r
2*pt(2.616648,19,lower.tail=FALSE)
```

    ## [1] 0.01697092

``` r
t.test(心理学テスト,mu=12)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  心理学テスト
    ## t = -2.6166, df = 19, p-value = 0.01697
    ## alternative hypothesis: true mean is not equal to 12
    ## 95 percent confidence interval:
    ##   8.400225 11.599775
    ## sample estimates:
    ## mean of x 
    ##        10

## 5.5 相関係数の検定

``` r
統計テスト1 <- c(6,10,6,10,5,3,5,9,3,3,11,6,11,9,7,5,8,7,7,9)
統計テスト2 <- c(10,13,8,15,8,6,9,10,7,3,18,14,18,11,12,5,7,12,7,7)
```

``` r
標本相関 <- cor(統計テスト1, 統計テスト2)
サンプルサイズ <- length(統計テスト1)
t統計量 <- 標本相関*sqrt(サンプルサイズ-2) / sqrt(1-標本相関^2)
t統計量
```

    ## [1] 4.805707

p値

``` r
2*pt(4.805707,18,lower.tail=FALSE)
```

    ## [1] 0.0001416228

## 5.6 独立性の検定

``` r
数学 <- c("嫌い","嫌い","好き","好き","嫌い","嫌い","嫌い","嫌い","嫌い","好き","好き","嫌い","好き","嫌い","嫌い","好き","嫌い","嫌い","嫌い","嫌い")
統計 <- c("好き","好き","好き","好き","嫌い","嫌い","嫌い","嫌い","嫌い","嫌い","好き","好き","好き","嫌い","好き","嫌い","嫌い","嫌い","嫌い","嫌い")
table(数学,統計)
```

    ##       統計
    ## 数学 好き 嫌い
    ##   好き    4    2
    ##   嫌い    4   10

``` r
期待度数 <- c(12*14/20, 12*6/20, 8*14/20, 8*6/20)
観測度数 <- c(10,2,4,4)
カイ二乗 <- sum((観測度数-期待度数)^2/期待度数)
カイ二乗
```

    ## [1] 2.539683

p値

``` r
pchisq(2.539683,1,lower.tail=FALSE)
```

    ## [1] 0.1110171

## 5.7 サンプルサイズの検定結果への影響について

``` r
履修A <- matrix(c(16,12,4,8),2,2,
                dimnames=list(c("文系","理系"),c("履修した", "履修しない")))
履修A
```

    ##      履修した 履修しない
    ## 文系       16          4
    ## 理系       12          8

独立性の検定

``` r
chisq.test(履修A,correct=FALSE)
```

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  履修A
    ## X-squared = 1.9048, df = 1, p-value = 0.1675

人数を10倍にする

``` r
履修B <- 履修A * 10
履修B
```

    ##      履修した 履修しない
    ## 文系      160         40
    ## 理系      120         80

``` r
chisq.test(履修B,correct=FALSE)
```

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  履修B
    ## X-squared = 19.048, df = 1, p-value = 1.275e-05

サンプルサイズが大きくなると、検定の結果は有意になりやすい

## 練習問題

(1)

``` r
height <- c(165,150,170,168,159,170,167,178,155,159,
            161,162,166,171,155,160,168,172,155,167)
t.test(height, mu = 170)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  height
    ## t = -3.8503, df = 19, p-value = 0.001079
    ## alternative hypothesis: true mean is not equal to 170
    ## 95 percent confidence interval:
    ##  160.584 167.216
    ## sample estimates:
    ## mean of x 
    ##     163.9

(2)

``` r
時間 <- c(1,3,10,12,6,3,8,4,1,5)
テスト <- c(20,40,100,80,50,50,70,50,10,60)
```

``` r
cor.test(時間, テスト)
```

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  時間 and テスト
    ## t = 6.1802, df = 8, p-value = 0.0002651
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  0.6542283 0.9786369
    ## sample estimates:
    ##       cor 
    ## 0.9092974

(3)

``` r
cor.test(時間, テスト, method="spearman")
```

    ## Warning in cor.test.default(時間, テスト, method = "spearman"): Cannot compute
    ## exact p-value with ties

    ## 
    ##  Spearman's rank correlation rho
    ## 
    ## data:  時間 and テスト
    ## S = 10.182, p-value = 5.887e-05
    ## alternative hypothesis: true rho is not equal to 0
    ## sample estimates:
    ##       rho 
    ## 0.9382895

``` r
cor.test(時間, テスト, method="kendall")
```

    ## Warning in cor.test.default(時間, テスト, method = "kendall"): Cannot compute
    ## exact p-value with ties

    ## 
    ##  Kendall's rank correlation tau
    ## 
    ## data:  時間 and テスト
    ## z = 3.2937, p-value = 0.0009889
    ## alternative hypothesis: true tau is not equal to 0
    ## sample estimates:
    ##       tau 
    ## 0.8471174

(4)

``` r
和洋 <- c("洋食","和食","和食","洋食","和食","洋食","洋食","和食","洋食","洋食",
          "和食","洋食","和食","洋食","和食","和食","洋食","洋食","和食","和食")
甘辛 <- c("甘党","辛党","甘党","甘党","辛党","辛党","辛党","辛党","甘党","甘党",
          "甘党","甘党","辛党","辛党","甘党","辛党","辛党","甘党","辛党","辛党")

クロス集計 <- table(和洋, 甘辛)
chisq.test(クロス集計, correct=FALSE)
```

    ## Warning in chisq.test(クロス集計, correct = FALSE): Chi-squared approximation
    ## may be incorrect

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  クロス集計
    ## X-squared = 1.8182, df = 1, p-value = 0.1775

(5)

``` r
国語 <- c(60,40,30,70,55)
社会 <- c(80,25,35,70,50)
cor.test(国語, 社会)
```

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  国語 and 社会
    ## t = 2.6952, df = 3, p-value = 0.07408
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.1590624  0.9892731
    ## sample estimates:
    ##      cor 
    ## 0.841263

``` r
国語2 <- rep(国語, 2)
社会2 <- rep(社会, 2)
cor.test(国語2, 社会2)
```

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  国語2 and 社会2
    ## t = 4.4013, df = 8, p-value = 0.002283
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  0.4499858 0.9615658
    ## sample estimates:
    ##      cor 
    ## 0.841263
