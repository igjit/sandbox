test_that("Stack works", {
  stack <- Stack$new()
  stack$push("foo")
  stack$push("bar")
  expect_equal(stack$stack, list("bar", "foo"))
  expect_equal(stack$pop(), "bar")
  expect_equal(stack$pop(), "foo")
})
