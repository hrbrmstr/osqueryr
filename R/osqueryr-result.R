#' @include osqueryr-connection.R
NULL

OsqueryResult <- function(connection, statement) {
  # TODO: Initialize result
  new("OsqueryResult", connection = connection, statement = statement)
}

#' @rdname DBI
#' @export
setClass(
  "OsqueryResult",
  contains = "DBIResult",
  slots = list(
    connection = "OsqueryConnection",
    statement = "character"
  )
)

#' @rdname DBI
#' @inheritParams methods::show
#' @export
setMethod(
  "show", "OsqueryResult",
  function(object) {
    cat("<OsqueryResult>\n")
    # TODO: Print more details
  })

#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @export
setMethod(
  "dbClearResult", "OsqueryResult",
  function(res, ...) {
    TRUE
  })

#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @export
setMethod(
  "dbFetch", "OsqueryResult",
  function(res, ...) {

    # message("dbFetch")

    if (is.null(res@connection@session)) {
      call_osquery(
        c("--json", res@statement)
      ) -> ret
    } else {
      ssh_osquery(
        res@connection@session,
        res@connection@osquery_remote_path,
        c("--json", res@statement)
      ) -> ret
    }

    out <- jsonlite::fromJSON(ret$stdout)

    # browser()

    class(out) <- c("tbl_df", "tbl", "data.frame")

    out

  })

#' @rdname DBI
#' @inheritParams DBI::dbHasCompleted
#' @export
setMethod(
  "dbHasCompleted", "OsqueryResult",
  function(res, ...) {
    TRUE
  })

# @rdname DBI
# @inheritParams DBI::dbGetInfo
# @export
# setMethod(
#   "dbGetInfo", "OsqueryResult",
#   function(dbObj, ...) {
#     # Optional
#     getMethod("dbGetInfo", "DBIResult", asNamespace("DBI"))(dbObj, ...)
#   })

#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @export
setMethod(
  "dbIsValid", "OsqueryResult",
  function(dbObj, ...) {
    TRUE
  })

#' @rdname DBI
#' @inheritParams DBI::dbGetStatement
#' @export
setMethod(
  "dbGetStatement", "OsqueryResult",
  function(res, ...) {
    res@statement
  })

# @rdname DBI
# @inheritParams DBI::dbColumnInfo
# @export
# setMethod(
#   "dbColumnInfo", "OsqueryResult",
#   function(res, ...) {
#   })

# @rdname DBI
# @inheritParams DBI::dbGetRowCount
# @export
# setMethod(
#   "dbGetRowCount", "OsqueryResult",
#   function(res, ...) {
#     testthat::skip("Not yet implemented: dbGetRowCount(Result)")
#   })

# @rdname DBI
# @inheritParams DBI::dbGetRowsAffected
# @export
# setMethod(
#   "dbGetRowsAffected", "OsqueryResult",
#   function(res, ...) {
#     testthat::skip("Not yet implemented: dbGetRowsAffected(Result)")
#   })

# @rdname DBI
# @inheritParams DBI::dbBind
# @export
# setMethod(
#   "dbBind", "OsqueryResult",
#   function(res, params, ...) {
#     testthat::skip("Not yet implemented: dbBind(Result)")
#   })
