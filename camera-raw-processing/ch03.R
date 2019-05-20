raw_file <- "chart.jpg"
raw <- rawpy$imread(raw_file)

# 簡易デモザイク処理
raw_array <- raw$raw_image
white_level <- 1024

dms_img <- raw_array %>%
  black_level_correction(raw$black_level_per_channel, raw$raw_pattern) %>%
  white_balance(raw$camera_whitebalance, raw$raw_colors) %>%
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

mirror <- function(x, min, max) {
  if (x < min) {
    min - x
  } else if (x >= max) {
    2 * max - x - 2
  } else {
    x
  }
}
