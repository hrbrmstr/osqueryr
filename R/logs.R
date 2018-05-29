#' @include logs.R
NULL

#' List all the logs on our local system
#'
#' @md
#' @param pattern,full.names passed on to [list.files()]
#' @param log_dir Defaults to `/var/log/osquery/`. Change this if you modified the location
#' @export
osq_fs_logs <- function(pattern = NULL, full.names = TRUE,
                        log_dir = "/var/log/osquery") {

  list.files(log_dir, full.names = TRUE)

}
