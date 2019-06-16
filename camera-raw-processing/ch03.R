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

horizontal_shading_profile <- function(img, w, y) {
  seq(1, w - 32, 32) %>%
    map_dfr(function(x) list(r = mean(img[y:(y + 32), x:(x + 32), 1, 1]),
                             g = mean(img[y:(y + 32), x:(x + 32), 1, 2]),
                             b = mean(img[y:(y + 32), x:(x + 32), 1, 3]))) %>%
    map_dfr(~ . / max(.)) %>%
    mutate(pos = 1:n())
}

shading_profile <- horizontal_shading_profile(original_img, w, y)

ggplot(gather(shading_profile, "color", "value", -pos), aes(x = pos, y = value)) +
  geom_line(aes(color = color)) +
  ylim(0, 1) +
  scale_color_manual(values = c(r = "red", g = "green", b = "blue"))

# レンズシェーディングのモデル化
value_df <- map_dfr(seq(1, h - 32, 32), function(y) {
  map_dfr(seq(1, w - 32, 32), function(x) {
    xx <- x + 16
    yy <- y + 16
    list(
      xx = xx,
      yy = yy,
      radial = (yy - center_y) * (yy - center_y) + (xx - center_x) * (xx - center_x),
      b = mean(blc_raw[seq(y, y + 32, 2), seq(x, x + 32, 2)]),
      g1 = mean(blc_raw[seq(y, y + 32, 2), seq(x + 1, x + 32, 2)]),
      g2 = mean(blc_raw[seq(y + 1, y + 32, 2), seq(x, x + 32, 2)]),
      r = mean(blc_raw[seq(y + 1, y + 32, 2), seq(x + 1, x + 32, 2)]))
  })
})

norm_value_df <- value_df %>%
  transmute(radial,
            b = b / max(b),
            g1 = g1 / max(g1),
            g2 = g2 / max(g2),
            r = r / max(r))

colors <- c(r = "red", g1 = "green", g2 = "green", b = "blue")

ggplot(gather(norm_value_df, "color", "value", -radial), aes(x = radial, y = value)) +
  geom_point(aes(color = color)) +
  ylim(0, 1) +
  scale_color_manual(values = colors)

inv_norm_value_df <- norm_value_df %>%
  select(-radial) %>%
  map_dfc(~ 1 / .) %>%
  add_column(radial = norm_value_df$radial, .before = TRUE)

ggplot(gather(inv_norm_value_df, "color", "value", -radial), aes(x = radial, y = value)) +
  geom_point(aes(color = color)) +
  scale_color_manual(values = colors)

models <- colnames(inv_norm_value_df)[-1] %>%
  paste("~ radial") %>%
  map(~ lm(as.formula(.), inv_norm_value_df))

model_df <- models %>%
  map_dfr(~ as.list(.$coefficients)) %>%
  transmute(color = colnames(inv_norm_value_df)[-1], intercept = `(Intercept)`, slope = radial)

ggplot(model_df) +
  geom_abline(aes(intercept = intercept, slope = slope, color = color)) +
  xlim(0, 4e6) +
  ylim(0, 6) +
  scale_color_manual(values = colors)

# ブラックレベル補正のみをかけたRAW画像
blc_raw %>% t %>% as.cimg %>% plot(interpolate = FALSE)

gain_map <- array(0, dim(raw_array))
for (y in seq(1, h, 2)) {
  for (x in seq(1, w, 2)) {
    x + y
    r2 <- (y - center_y) ^ 2 + (x - center_x) ^ 2
    gain <- model_df$intercept + model_df$slope * r2
    gain_map[y, x] <- gain[1]
    gain_map[y, x + 1] <- gain[2]
    gain_map[y + 1, x] <- gain[3]
    gain_map[y + 1, x + 1] <- gain[4]
  }
}

lsc_raw <- blc_raw * gain_map
lsc_raw %>% normalize %>% t %>% as.cimg %>% plot

# レンズシェーディング補正後
shading_img <- lsc_raw %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors) %>%
  demosaic(raw$raw_colors, raw$raw_pattern) %>%
  color_correction_matrix(color_matrix) %>%
  `/`(white_level) %>%
  gamma_correction(2.2)
shading_img %>% ta %>% as.cimg %>% plot

shading_after <- horizontal_shading_profile(shading_img, w, center_y - 16)

ggplot(gather(shading_after, "color", "value", -pos), aes(x = pos, y = value)) +
  geom_line(aes(color = color)) +
  ylim(0, 1) +
  scale_color_manual(values = c(r = "red", g = "green", b = "blue"))

raw_file <- "chart.jpg"
raw <- rawpy$imread(raw_file)
raw_array <- raw$raw_image

blc_raw <- raw_array %>%
  black_level_correction(raw$black_level_per_channel, raw$raw_pattern)

no_shading_img <- blc_raw %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors) %>%
  demosaic(raw$raw_colors, raw$raw_pattern) %>%
  color_correction_matrix(color_matrix) %>%
  `/`(white_level) %>%
  gamma_correction(2.2)

shading_img <- blc_raw %>%
  `*`(gain_map) %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors) %>%
  demosaic(raw$raw_colors, raw$raw_pattern) %>%
  color_correction_matrix(color_matrix) %>%
  `/`(white_level) %>%
  gamma_correction(2.2)

par(mfrow = c(1, 2))
no_shading_img %>% ta %>% as.cimg %>% plot
shading_img %>% ta %>% as.cimg %>% plot

lens_shading_correction <- function(raw_array, coef) {
  gain_map <- array(0, dim(raw_array))
  h <- nrow(raw_array)
  w <- ncol(raw_array)
  center_y <- h / 2
  center_x <- w / 2

  x <- 1:w - center_x
  y <- 1:h - center_y
  r2 <- matrix(y, h, w, byrow = FALSE) ^ 2 + matrix(x, h, w, byrow = TRUE) ^ 2

  gain_map[c(T, F), c(T, F)] <- r2[c(T, F), c(T, F)] * coef[1,]$slope + coef[1,]$intercept
  gain_map[c(T, F), c(F, T)] <- r2[c(T, F), c(F, T)] * coef[2,]$slope + coef[2,]$intercept
  gain_map[c(F, T), c(T, F)] <- r2[c(F, T), c(T, F)] * coef[3,]$slope + coef[3,]$intercept
  gain_map[c(F, T), c(F, T)] <- r2[c(F, T), c(F, T)] * coef[4,]$slope + coef[4,]$intercept

  raw_array * gain_map
}

coef <- model_df[, -1]
shading_img2 <- blc_raw %>%
  lens_shading_correction(coef) %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors) %>%
  demosaic(raw$raw_colors, raw$raw_pattern) %>%
  color_correction_matrix(color_matrix) %>%
  `/`(white_level) %>%
  gamma_correction(2.2)

shading_img2 %>% ta %>% as.cimg %>% plot
