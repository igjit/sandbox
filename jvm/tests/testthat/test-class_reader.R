test_that("name_lookup works", {
  name_of <- name_lookup(c(a = 2, b = 3))
  expect_equal(name_of(2), "a")
})
