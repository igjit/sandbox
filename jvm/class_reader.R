class_file <- "Hello.class"
con <- file(class_file, "rb")
on.exit(close(con))

reset <- function(con) seek(con, 0, "start")

read_u2 <- function(con) readBin(con, "integer", 1, 2, FALSE, "big")

reset(con)

magic <- readBin(con, "raw", 4, NA, FALSE, "big")
minor_version <- read_u2(con)
major_version <- read_u2(con)
constant_pool_count <- read_u2(con)
