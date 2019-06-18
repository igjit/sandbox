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

gmm_img <- blc_raw %>%
  lens_shading_correction(lsc) %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors) %>%
  demosaic(raw$raw_colors, raw$raw_pattern) %>%
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
