##' Create a new Scheme subprocess
##'
##' @param ... params
##' @export
run_scheme <- function(...) {
  handle <- subprocess::spawn_process(...)
  # discard a prompt
  subprocess::process_read(handle, subprocess::PIPE_STDOUT, timeout = subprocess::TIMEOUT_INFINITE)
  handle
}

##' Kill a Scheme subprocess
##'
##' @param handle handle
##' @export
kill_scheme <- function(handle) {
  subprocess::process_kill(handle)
}

scheme_engine <- function(options) {
  subprocess::process_write(options$handle, paste(options$code, collapse = "\n"))
  # FIXME: flush buffer
  if (length(options$code) > 1) Sys.sleep(0.1)
  res <- subprocess::process_read(options$handle, subprocess::PIPE_STDOUT, timeout = subprocess::TIMEOUT_INFINITE)
  options$comment <- ";;"
  knitr::engine_output(options, options$code, head(res, -1))
}

.onLoad <- function(lib, pkg) {
  knitr::knit_engines$set(scm = scheme_engine)
}
