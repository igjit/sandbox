library(reticulate)
library(imager)
library(magrittr)

use_virtualenv("./venv")
rawpy <- import("rawpy")

# RAW画像の読み込み
raw_file <- "chart.jpg"
raw <- rawpy$imread(raw_file)
raw_array <- raw$raw_image

# Bayer画像をそのまま表示
raw_array %>% t %>% as.cimg %>% plot

# RAW画像の確認
raw_array %>% t %>% as.cimg %>% imsub(x %inr% c(2641, 2701), y %inr% c(1341, 1401)) %>% plot(interpolate = FALSE)

# 簡易デモザイク処理
raw$raw_pattern

raw_color <- array(0, c(dim(raw_array), 1, 3))
raw_color[c(T, F), c(T, F), 1, 3] <- raw_array[c(T, F), c(T, F)]
raw_color[c(T, F), c(F, T), 1, 2] <- raw_array[c(T, F), c(F, T)]
raw_color[c(F, T), c(T, F), 1, 2] <- raw_array[c(F, T), c(T, F)]
raw_color[c(F, T), c(F, T), 1, 1] <- raw_array[c(F, T), c(F, T)]

ta <- function(a) aperm(a, c(2, 1, 3, 4))

raw_color %>% ta %>% as.cimg %>% imsub(x %inr% c(2641, 2701), y %inr% c(1341, 1401)) %>% plot(interpolate = FALSE)

dms_img <- array(0, c(dim(raw_array) / 2, 1, 3))
h <- dim(raw_array)[1]
w <- dim(raw_array)[2]

for (y in seq(1, h, 2)) {
  for (x in seq(1, w, 2)) {
    dms_img[y / 2, x / 2, 1, 3] <- raw_array[y, x]
    dms_img[y / 2, x / 2, 1, 2] <- mean(raw_array[y + 1, x], raw_array[y, x + 1])
    dms_img[y / 2, x / 2, 1, 1] <- raw_array[y + 1, x + 1]
  }
}

dms_img %>% ta %>% as.cimg %>% plot

# 処理の高速化
simple_demosaic <- function(raw_array) {
  dms_img <- array(0, c(dim(raw_array) / 2, 1, 3))
  dms_img[,, 1, 3] <- raw_array[c(T, F), c(T, F)]
  dms_img[,, 1, 2] <- (raw_array[c(T, F), c(F, T)] + raw_array[c(F, T), c(T, F)]) / 2
  dms_img[,, 1, 1] <- raw_array[c(F, T), c(F, T)]
  dms_img
}

raw_array %>% simple_demosaic %>% ta %>% as.cimg %>% plot
