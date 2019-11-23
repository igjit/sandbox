#' @import purrr
#' @import dequer
#' @importFrom magrittr %>%
NULL

instructions <- c(bipush = 16,
                  ldc = 18,
                  return = 177,
                  getstatic = 178,
                  invokevirtual = 182)

instruction_name_of <- name_lookup(instructions)

as_u2 <- function(byte1, byte2) bitwShiftL(byte1, 8) + byte2

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
  code_vec <- main_method$attributes %>%
    detect(~ .$attribute_name == "Code") %>%
    .$code
  code <- as.queue(as.list(code_vec))

  st <- stack()

  exec1 <- function() {
    instruction <- pop(code)
    instruction_name <- instruction_name_of(instruction)
    if (length(instruction_name) == 0) stop("Unknown instruction: ", instruction)
    switch(instruction_name,
           bipush = push(st, pop(code)),
           getstatic = {
             cp_index <- as_u2(pop(code), pop(code))
             symbol_name_index <- constant_pool[[cp_index]]
             cls <- constant_pool[[constant_pool[[symbol_name_index$class_index]]$name_index]]$bytes
             field <- constant_pool[[constant_pool[[symbol_name_index$name_and_type_index]]$name_index]]$bytes
             name <- paste(cls, field, sep = ".")
             push(st, name)
           },
           ldc = {
             index <- pop(code)
             name <- constant_pool[[constant_pool[[index]]$string_index]]$bytes
             push(st, name)
           },
           invokevirtual = {
             index <- as_u2(pop(code), pop(code))
             callee <- constant_pool[[constant_pool[[index]]$name_and_type_index]]
             method_name <- constant_pool[[callee$name_index]]$bytes
             descriptor <- constant_pool[[callee$descriptor_index]]$bytes
             params <- parse_method_descriptor(descriptor)$parameter
             argc <- length(params)
             args <- replicate(argc, pop(st), simplify = FALSE)
             object_name <- pop(st)
             object <- java_objects[[object_name]]
             do.call(object[[method_name]], args)
           },
           return = NULL,
           stop("Not implemented: ", instruction_name))
  }

  while(length(code) > 0) exec1()
}

parse_method_descriptor <- function(s) {
  matches <- stringr::str_match(s, "\\((.+)\\)(.+)")
  list(parameter = parse_field_descriptors(matches[2]),
       return = parse_field_descriptors(matches[3]))
}

parse_field_descriptors <- function(s) {
  stringr::str_extract_all(s, "([BCDFIJSZ]|L.+;)")[[1]]
}
