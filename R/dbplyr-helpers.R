#' @keywords internal
#' @export
db_query_fields.OsqueryConnection <- function(con, sql, ...) {
  call_osquery(
    c(sprintf(".schema %s", as.character(sql)))
  ) -> ret
  stri_match_all_regex(ret$stdout, "`([[:alnum:]_\\-]+)`")[[1]][,2]
}
