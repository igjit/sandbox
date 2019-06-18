library(reticulate)
library(imager)
library(magrittr)

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
