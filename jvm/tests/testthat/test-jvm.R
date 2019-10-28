test_that("Stack works", {
  stack <- Stack$new()
  stack$push("foo")
  stack$push("bar")
  expect_equal(stack$stack, list("bar", "foo"))
  expect_equal(stack$pop(), "bar")
  expect_equal(stack$pop(), "foo")
})

test_that("println works", {
  expect_output(System.out[["println"]]("foo"), "foo")
  expect_output(System.out$println("bar"), "bar")
})
