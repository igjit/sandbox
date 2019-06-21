library(reticulate)
library(imager)
library(tidyverse)

source("./raw_process.R")

use_virtualenv("./venv")
rawpy <- import("rawpy")

raw_file <- "chart.jpg"
raw <- rawpy$imread(raw_file)
raw_array <- raw$raw_image

lsc <- data.frame(intercept = c(9.60556906e-01, 9.70694361e-01, 9.72493898e-01, 9.29427169e-01),
                  slope = c(6.07106808e-07, 6.32044369e-07, 6.28455183e-07, 9.58743579e-07))
color_matrix <- matrix(c(6022, -2314, 394,
                         -936, 4728, 310,
                         300, -4324, 8126) / 4096,
                       3, 3, byrow = TRUE)
white_level <- 1024

blc_raw <- raw_array %>%
  black_level_correction(raw$black_level_per_channel, raw$raw_pattern)
dms_img <- blc_raw %>%
  lens_shading_correction(lsc) %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors) %>%
  demosaic(raw$raw_colors, raw$raw_pattern)
gmm_img <- dms_img %>%
  color_correction_matrix(color_matrix) %>%
  `/`(white_level) %>%
  gamma_correction(2.2)

gmm_img %>% ta %>% as.cimg %>% plot

gmm_img %>% ta %>% as.cimg %>% imsub(x %inr% c(800, 1000), y %inr% c(1950, 2150)) %>% plot(interpolate = FALSE)

patches <- data.frame(y = c(2086, 2092, 2090, 2090, 2086, 2094, 2096, 2090, 2090, 2086, 2084, 2084,
                            482, 480, 476, 474, 470, 466, 462, 460, 452, 452, 448, 442) + 1,
                      x = c(2586, 2430, 2272, 2112, 1958, 1792, 1642, 1486, 1328, 1172, 1016, 860,
                            866, 1022, 1172, 1328, 1480, 1634, 1788, 1944, 2110, 2266, 2424, 2586) + 1)

noise_df <- patches %>% pmap_dfr(function(y, x) {
  list(c(0, 1, 0, 1), c(0, 0, 1, 1)) %>% pmap_dfr(function(dx, dy) {
    v <- blc_raw[seq(y + dy, y + 100, 2), seq(x + dx, x + 100, 2)] %>% as.vector
    list(mean = mean(v), var = var(v))
  })
})

ggplot(noise_df, aes(x = mean, y = var)) +
  geom_point()

par <- lm(var ~ mean, noise_df)

ggplot(noise_df, aes(x = mean, y = var)) +
  geom_point() +
  geom_abline(intercept = par$coefficients[1], slope = par$coefficients[2])

mono_dms_img <- dms_img %>% grayscale %>% array(dim(dms_img)[1:2])

dms_noise_df <- patches %>% pmap_dfr(function(y, x) {
  v <- mono_dms_img[y:(y + 100), x:(x + 100)] %>% as.vector
  list(mean = mean(v), var = var(v))
})

dms_par <- lm(var ~ mean, dms_noise_df)

ggplot(dms_noise_df, aes(x = mean, y = var)) +
  geom_point() +
  geom_abline(intercept = dms_par$coefficients[1], slope = dms_par$coefficients[2])

# バイラテラルノイズフィルター (低速)
coef <- 0.1
img_flt <- array(0, dim(dms_img))
h <- nrow(img_flt)
w <- ncol(img_flt)

# for (y in 3:(h - 2)) {
#   for (x in 3:(w - 2)) {
for (y in c(1950:2150, 1500:1700)) {
  for (x in c(800:1000, 1650:1850)) {
    average <- mono_dms_img[(y - 2):(y + 2), (x - 2):(x + 2)] %>% mean
    sigma <- dms_par$coefficients[2] * average
    sigma <- if (sigma > 0) sigma else 1

    diff <- mono_dms_img[(y - 2):(y + 2), (x - 2):(x + 2)] - mono_dms_img[y, x]
    diff_norm <- diff ^ 2 / sigma
    weight <- exp(-coef * diff_norm)
    out_pixel <- (array(weight, c(dim(weight), 3)) * dms_img[(y - 2):(y + 2), (x - 2):(x + 2),,]) %>%
      apply(3, mean)
    img_flt[y, x, 1,] <- out_pixel / sum(weight)
  }
}

# 比較
par(mfrow = c(1, 2))
dms_img %>% ta %>% as.cimg %>% imsub(x %inr% c(800, 1000), y %inr% c(1950, 2150)) %>% plot(interpolate = FALSE, main = "Before")
img_flt %>% ta %>% as.cimg %>% imsub(x %inr% c(800, 1000), y %inr% c(1950, 2150)) %>% plot(interpolate = FALSE, main = "After")

par(mfrow = c(1, 2))
dms_img %>% ta %>% as.cimg %>% imsub(x %inr% c(1650, 1850), y %inr% c(1500, 1700)) %>% plot(interpolate = FALSE, main = "Before")
img_flt %>% ta %>% as.cimg %>% imsub(x %inr% c(1650, 1850), y %inr% c(1500, 1700)) %>% plot(interpolate = FALSE, main = "After")
