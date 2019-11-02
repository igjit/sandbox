#' @import purrr
#' @importFrom magrittr %>%
NULL

instructions <- c(ldc = 18,
                  return = 177,
                  getstatic = 178,
                  invokevirtual = 182)

instruction_name_of <- name_lookup(instructions)

as_u2 <- function(byte1, byte2) bitwShiftL(byte1, 8) + byte2

Stack <- setRefClass("Stack",
                     fields = c(stack = "list"),
                     methods = list(push = function(x) stack <<- c(list(x), stack),
                                    pop = function() {
                                      x <- stack[[1]]
                                      stack <<- stack[-1]
                                      x
                                    },
                                    is_empty = function() length(stack) == 0))

PrintStream <- setRefClass("PrintStream",
                           methods = list(println = function(x) cat(x, "\n", sep = "")))
System.out <- PrintStream$new()
java_objects <- list("java/lang/System.out" = System.out)
# FIXME
System.out$println

exec <- function(java_class) {
  constant_pool <- java_class$constant_pool
  main_method <- java_class$methods %>%
    detect(~ .$name == "main")
  code <- main_method$attributes %>%
    detect(~ .$attribute_name == "Code") %>%
    .$code

  stack <- Stack$new()
  pc <- 1

  exec1 <- function() {
    instruction <- code[pc]
    pc <<- pc + 1
    instruction_name <- instruction_name_of(instruction)
    switch(instruction_name,
           getstatic = {
             cp_index <- as_u2(code[pc], code[pc + 1])
             pc <<- pc + 2
             symbol_name_index <- constant_pool[[cp_index]]
             cls <- constant_pool[[constant_pool[[symbol_name_index$class_index]]$name_index]]$bytes
             field <- constant_pool[[constant_pool[[symbol_name_index$name_and_type_index]]$name_index]]$bytes
             name <- paste(cls, field, sep = ".")
             stack$push(name)
           },
           ldc = {
             index <- code[pc]
             pc <<- pc + 1
             name <- constant_pool[[constant_pool[[index]]$string_index]]$bytes
             stack$push(name)
           },
           invokevirtual = {
             index <- as_u2(code[pc], code[pc + 1])
             pc <<- pc + 2
             callee <- constant_pool[[constant_pool[[index]]$name_and_type_index]]
             method_name <- constant_pool[[callee$name_index]]$bytes
             descriptor <- constant_pool[[callee$descriptor_index]]$bytes
             argc <- stringr::str_count(descriptor, ";")
             args <- replicate(argc, stack$pop(), simplify = FALSE)
             object_name <- stack$pop()
             object <- java_objects[[object_name]]
             do.call(object[[method_name]], args)
           },
           return = NULL,
           stop("Not Implemented"))
  }

  while(pc <= length(code)) exec1()
}
