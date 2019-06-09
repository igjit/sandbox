raw_file <- "chart.jpg"
raw <- rawpy$imread(raw_file)

# 簡易デモザイク処理
raw_array <- raw$raw_image
white_level <- 1024

wb_raw <- raw_array %>%
  black_level_correction(raw$black_level_per_channel, raw$raw_pattern) %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors)
dms_img <- wb_raw %>%
  simple_demosaic %>%
  `/`(white_level)
gmm_img <- gamma_correction(dms_img, 2.2)

gmm_img %>% ta %>% as.cimg %>% plot

# jpg
jpg_img <- imager::load.image(raw_file)

x1 <- 836
y1 <- 741
dx1 <- 100
dy1 <- 100

# 比較
par(mfrow = c(1, 2))
gmm_img %>% ta %>% as.cimg %>% imsub(x %inr% c(x1, x1 + dx1), y %inr% c(y1, y1 + dy1)) %>% plot(interpolate = FALSE)
jpg_img %>% imsub(x %inr% (c(x1, x1 + dx1) * 2), y %inr% (c(y1, y1 + dy1) * 2)) %>% plot(interpolate = FALSE)

# 線形補完法
mirror <- function(x, min, max) {
  if (x < min) {
    min - x
  } else if (x > max) {
    2 * max - x - 2
  } else {
    x
  }
}

.demosaic <- function(raw_array, raw_colors, pattern) {
  h <- nrow(raw_array)
  w <- ncol(raw_array)
  dms_img <- array(0, c(h, w, 1, 3))
  for (y in 1:h) {
    for (x in 1:w) {
      color <- pattern[((y - 1) %% 2) + 1, ((x - 1) %% 2) + 1]
      y0 <- mirror(y - 1, 1, h)
      y1 <- mirror(y + 1, 1, h)
      x0 <- mirror(x - 1, 1, w)
      x1 <- mirror(x + 1, 1, w)
      if (color == 0)  {
        dms_img[y, x, 1, 1] <- raw_array[y, x]
        dms_img[y, x, 1, 2] <- (raw_array[y0, x] + raw_array[y, x0] + raw_array[y, x1] + raw_array[y1, x]) / 4
        dms_img[y, x, 1, 3] <- (raw_array[y0, x0] + raw_array[y0, x1] + raw_array[y1, x0] + raw_array[y1, x1]) / 4
      } else if (color == 1)  {
        dms_img[y, x, 1, 1] <- (raw_array[y, x0] + raw_array[y, x1]) / 2
        dms_img[y, x, 1, 2] <- raw_array[y, x]
        dms_img[y, x, 1, 3] <- (raw_array[y0, x] + raw_array[y1, x]) / 2
      } else if (color == 2)  {
        dms_img[y, x, 1, 1] <- (raw_array[y0, x0] + raw_array[y0, x1] + raw_array[y1, x0] + raw_array[y1, x1]) / 4
        dms_img[y, x, 1, 2] <- (raw_array[y0, x] + raw_array[y, x0] + raw_array[y, x1] + raw_array[y1, x]) / 4
        dms_img[y, x, 1, 3] <- raw_array[y, x]
      } else {
        dms_img[y, x, 1, 1] <- (raw_array[y0, x] + raw_array[y1, x]) / 2
        dms_img[y, x, 1, 2] <- raw_array[y, x]
        dms_img[y, x, 1, 3] <- (raw_array[y, x0] + raw_array[y, x1]) / 2
      }
    }
  }
  dms_img
}

# 高速化
demosaic <- function(raw_array, raw_colors, pattern) {
  dms_img <- array(0, c(dim(raw_array), 1, 3))

  g <- raw_array
  g[raw_colors %in% c(0, 2)] <- 0
  g_filter <- array(c(0, 1, 0,
                      1, 4, 1,
                      0, 1, 0) / 4,
                    c(3, 3, 1, 1))
  G(dms_img) <- convolve(as.cimg(g), g_filter)

  r <- raw_array
  r[raw_colors != 0] <- 0
  r_filter <- array(c(1/4, 1/2, 1/4,
                      1/2,   1, 1/2,
                      1/4, 1/2, 1/4),
                    c(3, 3, 1, 1))
  R(dms_img) <- convolve(as.cimg(r), r_filter)

  b <- raw_array
  b[raw_colors != 2] <- 0
  # 青のフィルターは赤と共通
  B(dms_img) <- convolve(as.cimg(b), r_filter)

  dms_img
}

dms_full_img <- wb_raw %>% demosaic(raw$raw_colors, raw$raw_pattern)
gmm_full_img <- gamma_correction(dms_full_img / white_level, 2.2)
gmm_full_img %>% ta %>% as.cimg %>% plot

# 比較
par(mfrow = c(1, 2))
gmm_img %>% ta %>% as.cimg %>% imsub(x %inr% c(x1, x1 + dx1), y %inr% c(y1, y1 + dy1)) %>% plot(interpolate = FALSE)
gmm_full_img %>% ta %>% as.cimg %>% imsub(x %inr% (c(x1, x1 + dx1) * 2), y %inr% (c(y1, y1 + dy1) * 2)) %>% plot(interpolate = FALSE)

# カラーマトリクス補正
color_matrix <- matrix(c(6022, -2314, 394,
                         -936, 4728, 310,
                         300, -4324, 8126) / 4096,
                       3, 3, byrow = TRUE)

color_correction_matrix <- function(rgb_array, color_matrix) {
  ccm_img <- array(0, dim(rgb_array))
  for (col in 1:3) {
    ccm_img[,, 1, col] <-
      color_matrix[col, 1] * R(rgb_array) +
      color_matrix[col, 2] * G(rgb_array) +
      color_matrix[col, 3] * B(rgb_array)
  }
  ccm_img
}

dms_full_img %>%
  color_correction_matrix(color_matrix) %>%
  `/`(white_level) %>%
  gamma_correction(2.2) %>%
  ta %>% as.cimg %>% plot

# シェーディング補正
raw_file <- "flat.jpg"
raw <- rawpy$imread(raw_file)
raw_array <- raw$raw_image

# レンズシェーディング補正前
blc_raw <- raw_array %>%
  black_level_correction(raw$black_level_per_channel, raw$raw_pattern)
original_img <- blc_raw %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors) %>%
  demosaic(raw$raw_colors, raw$raw_pattern) %>%
  color_correction_matrix(color_matrix) %>%
  `/`(white_level) %>%
  gamma_correction(2.2)
original_img %>% ta %>% as.cimg %>% plot

w <- ncol(raw_array)
h <- nrow(raw_array)
center_y <- h / 2
center_x <- w / 2
y <- center_y - 16

library(tidyverse)

shading_profile <- seq(1, w - 32, 32) %>%
  map_dfr(function(x) list(r = mean(original_img[y:(y + 32), x:(x + 32), 1, 1]),
                           g = mean(original_img[y:(y + 32), x:(x + 32), 1, 2]),
                           b = mean(original_img[y:(y + 32), x:(x + 32), 1, 3]))) %>%
  map_dfr(~ . / max(.)) %>%
  mutate(pos = 1:n())

ggplot(gather(shading_profile, "color", "value", -pos), aes(x = pos, y = value)) +
  geom_line(aes(color = color)) +
  ylim(0, 1) +
  scale_color_manual(values = c(r = "red", g = "green", b = "blue"))
