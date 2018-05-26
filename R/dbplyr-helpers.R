#' @keywords internal
#' @export
db_query_fields.OsqueryConnection <- function(con, sql, ...) {
  # message("db_query_fields")
  call_osquery(
    c(sprintf(".schema %s", as.character(sql)))
  ) -> ret
  unique(stri_match_all_regex(ret$stdout, "`([[:alnum:]_\\-]+)`")[[1]][,2])
}

#' @keywords internal
#' @export
db_data_type.OsqueryConnection <- function(con, fields, ...) {
  # message("db_data_type")
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

#' @keywords internal
#' @export
sql_escape_ident.OsqueryConnection <- function(con, x) {
  # message("sql_escape_ident")
  # message(paste0(sprintf("[%s]", x)), collaspe=", ")
  ifelse(grepl("`", x), sql_quote(x, ' '), sql_quote(x, '`'))
}
