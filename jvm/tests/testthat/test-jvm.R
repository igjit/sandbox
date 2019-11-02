test_that("println works", {
  expect_output(System.out[["println"]]("foo"), "foo")
  expect_output(System.out$println("bar"), "bar")
})
