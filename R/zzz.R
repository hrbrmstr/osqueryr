#' @include zzz.R
NULL

.onLoad <- function(libname, pkgname) {

  if ((find_osquery() == "") & (interactive())) {
    stop(
      "osquery not found. Please install it and ensure it is on the system PATH.\n",
      "See <https://osquery.readthedocs.io> for more information on how to install osquery.",
      call.=FALSE
    )
  }

}
