ta <- function(a) aperm(a, c(2, 1, 3, 4))

white_balance <- function(raw_array, wb_gain, raw_colors) {
  norm <- wb_gain[2]
  gain_matrix <- array(0, c(dim(raw_array)))
  for (color in 0:3) {
    gain_matrix[raw_colors == color] <- wb_gain[color + 1] / norm
  }
  raw_array * gain_matrix
}

black_level_correction <- function(raw_array, blc, pattern) {
  pattern <- pattern + 1
  raw_array[c(T, F), c(T, F)] <- raw_array[c(T, F), c(T, F)] - blc[pattern[1, 1]]
  raw_array[c(T, F), c(F, T)] <- raw_array[c(T, F), c(F, T)] - blc[pattern[1, 2]]
  raw_array[c(F, T), c(T, F)] <- raw_array[c(F, T), c(T, F)] - blc[pattern[2, 1]]
  raw_array[c(F, T), c(F, T)] <- raw_array[c(F, T), c(F, T)] - blc[pattern[2, 2]]
  raw_array
}

gamma_correction <- function(input_img, gamma) {
  input_img[input_img < 0] <- 0
  input_img[input_img > 1] <- 1
  input_img ^ (1 / gamma)
}

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
