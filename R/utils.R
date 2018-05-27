find_osquery <- function() {
  osq <- Sys.which("osqueryi")
  if (osq == "") stop("osqueryi not found. please install osquery.")
  return(unname(osq))
}

osquery_help <- function() {
  cat(call_osquery("--help"))
}

call_osquery <- function(args) { # TODO this needs massive edge case detection
  res <- sys::exec_internal(find_osquery(), args)
  res$stdout <- rawToChar(res$stdout)
  res
}

ssh_osquery <- function(session, osquery_remote_path = "/usr/local/bin", args) {
  if (is.null(osquery_remote_path)) osquery_remote_path <- "/usr/local/bin"
  ssh_exec_internal(
    session,
    paste0(
      c(file.path(osquery_remote_path, "osqueryi"), " ", args[1], ' ', shQuote(args[2])),
      # c(file.path(osquery_remote_path, "osqueryi"), " ", args[1], ' "', args[2], '"'),
      collapse = ""
    )
  ) -> res
  res$stdout <- rawToChar(res$stdout)
  res
}