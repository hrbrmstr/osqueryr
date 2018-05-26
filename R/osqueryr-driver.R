#' DBI methods
#'
#' Implementations of pure virtual functions defined in the `DBI` package.
#' @name DBI
NULL

#' Osquery driver
#'
#' TBD.
#'
#' @export
#' @import methods DBI
#' @examples
#' \dontrun{
#' #' library(DBI)
#' ROsquery::Osquery()
#' }
Osquery <- function() {
  new("OsqueryDriver")
}

#' @rdname DBI
#' @export
setClass("OsqueryDriver", contains = "DBIDriver")

#' @rdname DBI
#' @inheritParams methods::show
#' @export
setMethod(
  "show", "OsqueryDriver",
  function(object) {
    cat("<OsqueryDriver>\n")
    # TODO: Print more details
  })

#' @rdname DBI
#' @inheritParams DBI::dbConnect
#' @export
setMethod(
  "dbConnect", "OsqueryDriver",
  function(drv, host = NULL, keyfile = NULL, osquery_remote_path = NULL, ...) {
    if (!is.null(host)) {
      sess <- ssh_connect(host = host, keyfile = keyfile)
    } else {
      sess <- NULL
    }
    OsqueryConnection(
      host = host,
      keyfile = keyfile,
      session = sess,
      osquery_remote_path = osquery_remote_path
    )
  }
)

#' @rdname DBI
#' @inheritParams DBI::dbDataType
#' @export
setMethod(
  "dbDataType", "OsqueryDriver",
  function(dbObj, obj, ...) {
    # Optional: Can remove this if all data types conform to SQL-92
    tryCatch(
      getMethod("dbDataType", "DBIObject", asNamespace("DBI"))(dbObj, obj, ...),
      error = function(e) testthat::skip("Not yet implemented: dbDataType(Driver)"))
  })

#' @rdname DBI
#' @inheritParams DBI::dbDataType
#' @export
setMethod(
  "dbDataType", c("OsqueryDriver", "list"),
  function(dbObj, obj, ...) {
    # rstats-db/DBI#70
    testthat::skip("Not yet implemented: dbDataType(Driver, list)")
  })

#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @export
setMethod(
  "dbIsValid", "OsqueryDriver",
  function(dbObj, ...) {
    testthat::skip("Not yet implemented: dbIsValid(Driver)")
  })

#' @rdname DBI
#' @inheritParams DBI::dbGetInfo
#' @export
setMethod(
  "dbGetInfo", "OsqueryDriver",
  function(dbObj, ...) {
    testthat::skip("Not yet implemented: dbGetInfo(Driver)")
  })
