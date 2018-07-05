#' @include expose.R
NULL

#' Expose all (or selected) local or remote osquery tables as global environment dbplyr tibbles
#' or as a named list.
#'
#' This is intended as a shortcut for building a connection and wiring up to `src_dbi()`.
#' Exposing all of the tables is not recommended unless you're performing a large number
#' of diverse queries.
#'
#' [osq_load_tables()] is a tad safer than [osq_expose_tables()] since it does not
#' pollute the global environment and you can use a variable name for host
#' identification vs a prefix (though prefixes are still supported in [osq_load_tables()]).
#'
#' @md
#' @param tables defaults to `.*` or all tables. Use a valid regular expression to match table names.
#' @param prefix if not `NULL`, each table in `tables` will be prefixed with this string.
#' @param host,keyfile same as for [dbConnect()]
#' @param quiet if `TRUE`, display a message with each table being exposed to the global environment.
#' @export
osq_expose_tables <- function(tables = ".*", prefix = NULL, host = NULL, keyfile = NULL, quiet=TRUE) {

  con <- osqueryr::dbConnect(Osquery(), host = host, keyfile = keyfile)
  osqdb <- dbplyr::src_dbi(con)

  tbls <- grep(tables, DBI::dbListTables(con), value=TRUE)

  if (length(tbls) == 0) {
    message("No tables found with that pattern.")
    return(invisible(NULL))
  }

  for (tbln in tbls) {
    genv_name <- paste0(prefix, tbln, collapse="")
    if (!quiet) message("Exposing '", tbln, "' as '", genv_name, ".")
    assign(genv_name, tbl(osqdb, tbln), envir = .GlobalEnv)
  }

}

#' @md
#' @rdname osq_expose_tables
#' @param tables defaults to `.*` or all tables. Use a valid regular expression to match table names.
#' @param prefix if not `NULL`, each table in `tables` will be prefixed with this string.
#' @param host,keyfile same as for [dbConnect()]
#' @param quiet if `TRUE`, display a message with each table being wired up
#' @export
osq_load_tables <- function(tables = ".*", prefix = NULL, host = NULL, keyfile = NULL, quiet=TRUE) {

  con <- osqueryr::dbConnect(Osquery(), host = host, keyfile = keyfile)
  osqdb <- dbplyr::src_dbi(con)

  tbls <- grep(tables, DBI::dbListTables(con), value=TRUE)

  if (length(tbls) == 0) {
    message("No tables found with that pattern.")
    return(invisible(NULL))
  }

  lapply(tbls, function(tbln) {
    genv_name <- paste0(prefix, tbln, collapse="")
    if (!quiet) message("Wiring up '", tbln, "' as '", genv_name, ".")
    dplyr::tbl(osqdb, tbln)
  }) -> out

  stats::setNames(out, tbls)

}
