find_osquery <- function() {
  osq <- Sys.which("osqueryi")
  if (osq == "") stop("osqueryi not found. please install osquery.")
  return(unname(osq))
}

call_osquery <- function(args) { # TODO this needs massive edge case detection
  res <- sys::exec_internal(find_osquery(), args)
  res$stdout <- rawToChar(res$stdout)
  res
}

osquery_help <- function() {
  cat(call_osquery("--help"))
}




call_osquery(
  c(
    "--json",
    "SELECT pid, name, path FROM processes"
  )
) -> a

a
