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

demosaic <- function(raw_array, raw_colors, pattern) {
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

dms_full_img <- wb_raw %>% demosaic(raw$raw_colors, raw$raw_pattern)
gmm_full_img <- gamma_correction(dms_full_img / white_level, 2.2)
gmm_full_img %>% ta %>% as.cimg %>% plot

# 比較
par(mfrow = c(1, 2))
gmm_img %>% ta %>% as.cimg %>% imsub(x %inr% c(x1, x1 + dx1), y %inr% c(y1, y1 + dy1)) %>% plot(interpolate = FALSE)
gmm_full_img %>% ta %>% as.cimg %>% imsub(x %inr% (c(x1, x1 + dx1) * 2), y %inr% (c(y1, y1 + dy1) * 2)) %>% plot(interpolate = FALSE)
