#' @import purrr
#' @import dequer
#' @importFrom magrittr %>%
NULL

instructions <- c(bipush = 16,
                  ldc = 18,
                  iinc = 132,
                  ifne = 154,
                  if_icmpge = 162,
                  goto = 167,
                  return = 177,
                  getstatic = 178,
                  invokevirtual = 182)

instruction_name_of <- name_lookup(instructions)

is_iconst_i <- function(instruction) instruction %in% 2:8
i_of_iconst <- function(instruction) instruction - 3

is_istore_n <- function(instruction) instruction %in% 59:62
n_of_istore <- function(instruction) instruction - 59

is_iload_n <- function(instruction) instruction %in% 26:29
n_of_iload <- function(instruction) instruction - 26

int_arith <- c(iadd = 96,
               isub = 100,
               imul = 104,
               idiv = 108)
int_arith_op <- list(iadd = `+`,
                     isub = `-`,
                     imul = `*`,
                     idiv = `%/%`)
int_arith_name_of <- name_lookup(int_arith)

as_u2 <- function(byte1, byte2) bitwShiftL(byte1, 8) + byte2

as_s2 <- function(byte1, byte2) {
  u2 <- as_u2(byte1, byte2)
  bitwAnd(u2, 0x7fff) - bitwAnd(u2, 0x8000)
}

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

  pc <- 1
  pop_code <- function() {
    if (length(code) < pc) stop()
    ret <- code[pc]
    pc <<- pc + 1
    ret
  }

  st <- stack()
  frame <- list()

  exec1 <- function() {
    instruction <- pop_code()
    instruction_name <- instruction_name_of(instruction)
    if (length(instruction_name) == 0) {
      if (is_iconst_i(instruction)) {
        push(st, i_of_iconst(instruction))
      } else if (is_istore_n(instruction)) {
        frame[[n_of_istore(instruction)]] <<- pop(st)
      } else if (is_iload_n(instruction)) {
        push(st, frame[[n_of_iload(instruction)]])
      } else if (instruction %in% int_arith) {
        op <- int_arith_op[[int_arith_name_of(instruction)]]
        value2 <- pop(st)
        value1 <- pop(st)
        result <- op(value1, value2)
        push(st, result)
      } else {
        stop("Unknown instruction: ", instruction)
      }
    } else {
      switch(instruction_name,
             bipush = push(st, pop_code()),
             getstatic = {
               cp_index <- as_u2(pop_code(), pop_code())
               symbol_name_index <- constant_pool[[cp_index]]
               cls <- constant_pool[[constant_pool[[symbol_name_index$class_index]]$name_index]]$bytes
               field <- constant_pool[[constant_pool[[symbol_name_index$name_and_type_index]]$name_index]]$bytes
               name <- paste(cls, field, sep = ".")
               push(st, name)
             },
             ldc = {
               index <- pop_code()
               name <- constant_pool[[constant_pool[[index]]$string_index]]$bytes
               push(st, name)
             },
             iinc = {
               index <- pop_code()
               const <- pop_code()
               frame[[index]] <<- frame[[index]] + const
             },
             ifne = {
               adr <- pc - 1
               offset <- as_s2(pop_code(), pop_code())
               value <- pop(st)
               if (value != 0) pc <<- adr + offset
             },
             if_icmpge = {
               adr <- pc - 1
               offset <- as_s2(pop_code(), pop_code())
               value2 <- pop(st)
               value1 <- pop(st)
               if (value1 >= value2) pc <<- adr + offset
             },
             goto = {
               adr <- pc - 1
               offset <- as_s2(pop_code(), pop_code())
               pc <<- adr + offset
             },
             invokevirtual = {
               index <- as_u2(pop_code(), pop_code())
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
  }

  while(pc <= length(code)) exec1()
}

# https://docs.oracle.com/javase/specs/jvms/se11/html/jvms-4.html#jvms-4.3.3
parse_method_descriptor <- function(s) {
  matches <- stringr::str_match(s, "\\((.+)\\)(.+)")
  list(parameter = parse_field_descriptors(matches[2]),
       return = parse_field_descriptors(matches[3]))
}

parse_field_descriptors <- function(s) {
  stringr::str_extract_all(s, "([BCDFIJSZ]|L.+;)")[[1]]
}
