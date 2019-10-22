args <- commandArgs(trailingOnly = TRUE)

pkgload::load_all(quiet = TRUE)

class_file <- args[1]
con <- file(class_file, "rb")
on.exit(close(con))
class <- read_class(con)
exec(class)
