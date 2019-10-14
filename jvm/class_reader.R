cp_tags <- c(CONSTANT_Utf8 = 1,
             CONSTANT_Class = 7,
             CONSTANT_String = 8,
             CONSTANT_Fieldref = 9,
             CONSTANT_Methodref = 10,
             CONSTANT_NameAndType = 12)

cp_tag_names <- names(cp_tags)
names(cp_tag_names) <- cp_tags

reset <- function(con) seek(con, 0, "start")

read_u1 <- function(con) readBin(con, "integer", 1, 1, FALSE, "big")

read_u2 <- function(con) readBin(con, "integer", 1, 2, FALSE, "big")

read_cp_info <- function(con) {
  tag <- read_u1(con)
  tag_name <- cp_tag_names[as.character(tag)]
  info <- switch(tag_name,
                 CONSTANT_Utf8 = {
                   length <- read_u2(con)
                   list(length = length,
                        bytes = intToUtf8(readBin(con, "integer", length, 1, FALSE, "big")))
                 },
                 CONSTANT_Class = list(name_index = read_u2(con)),
                 CONSTANT_String = list(string_index = read_u2(con)),
                 CONSTANT_Fieldref = list(class_index = read_u2(con), name_and_type_index = read_u2(con)),
                 CONSTANT_Methodref = list(class_index = read_u2(con), name_and_type_index = read_u2(con)),
                 CONSTANT_NameAndType = list(name_index = read_u2(con),
                                             descriptor_index = read_u2(con)))

  c(tag = tag, info)
}

class_file <- "Hello.class"
con <- file(class_file, "rb")
on.exit(close(con))

reset(con)

magic <- readBin(con, "raw", 4, NA, FALSE, "big")
minor_version <- read_u2(con)
major_version <- read_u2(con)
constant_pool_count <- read_u2(con)
constant_pool <- replicate(constant_pool_count - 1, read_cp_info(con))
