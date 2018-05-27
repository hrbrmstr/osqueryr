#' @name dbplyr_helpers
#' @title dbplyr_helpers
#' @description Some small helpers to deal with the DBI<->dbplyr bridge
#' @keywords internal
#' @export
db_query_fields.OsqueryConnection <- function(con, sql, ...) {
  call_osquery(
    c(sprintf(".schema %s", as.character(sql)))
  ) -> ret
  unique(stri_match_all_regex(ret$stdout, "`([[:alnum:]_\\-]+)`")[[1]][,2])
}

#' @rdname dbplyr_helpers
#' @keywords internal
#' @export
db_data_type.OsqueryConnection <- function(con, fields, ...) {
  data_type <- function(x) {
    switch(
      class(x)[1],
      # logical = "BOOLEAN",
      integer = "INTEGER",
      numeric = "DOUBLE",
      factor =  "TEXT",
      character = "TEXT",
      # Date = "DATE",
      # POSIXct = "TIMESTAMP",
      stop("Can't map type ", paste(class(x), collapse = "/"),
           " to a supported database type.")
    )
  }
  vapply(fields, data_type, character(1))
}

#' @rdname dbplyr_helpers
#' @keywords internal
#' @export
sql_escape_ident.OsqueryConnection <- function(con, x) {
  ifelse(grepl("`", x), sql_quote(x, ' '), sql_quote(x, '`'))
}


#' @rdname dbplyr_helpers
#' @keywords internal
#' @export
db_desc.OsqueryConnection <- function(x) {

  print(x@session)
  NextMethod("db_desc", x)

}