#' Driver for osquery
#'
#' @keywords internal
#' @export
#' @import DBI
#' @import methods
setClass("OsqueryDriver", contains = "DBIDriver")

#' Osquery class
#'
#' @export
#' @rdname Osquery-class
setMethod("dbUnloadDriver", "OsqueryDriver", function(drv, ...) {
  TRUE
})

#' Osquery show
#'
#' @export
#' @rdname Osquery-class
setMethod("show", "OsqueryDriver", function(object) {
  cat("<OsqueryDriver>\n")
})


#' @export
Osquery <- function() {
  new("OsqueryDriver")
}

#' Osquery connection class.
#'
#' @export
#' @keywords internal
setClass("OsqueryConnection",
         contains = "DBIConnection",
         slots = list(
         )
)

#' Osquery dbConnect
#'
#' @param drv An object created by \code{Osquery()}
#' @rdname Osquery
#' @export
#' @examples
#' \dontrun{
#' db <- dbConnect(osqueryr::Osquery())
#' }
setMethod("dbConnect", "OsqueryDriver", function(drv, ...) {
  new("OsqueryConnection", ...)
})

#' Osquery dbDisconnect
#'
#' @param conn An object created by \code{OsqueryConnection()}
#' @rdname Osquery
#' @export
#' @examples
#' \dontrun{
#' db <- dbConnect(osqueryr::Osquery())
#' }
setMethod("dbDisconnect", "OsqueryConnection", function(conn, ...) {
  TRUE
}, valueClass = "logical")

#' Osquery results class.
#'
#' @keywords internal
#' @export
setClass("OsqueryResult",
         contains = "DBIResult",
         slots = list(
           statement = "character"
         )
)

#' Send a query to Osquery
#'
#' @export
#' @examples
#' # This is another good place to put examples
setMethod("dbSendQuery", "OsqueryConnection", function(conn, statement, ...) {

  new("OsqueryResult", statement = statement, ...)

})

#' @export
setMethod("dbClearResult", "OsqueryResult", function(res, ...) {
  # free resources
  TRUE
})

#' Retrieve records from Osquery query
#'
#' @export
setMethod("dbFetch", "OsqueryResult", function(res, ...) {

  call_osquery(
    c("--json", res@statement)
  ) -> ret

  out <- jsonlite::fromJSON(ret$stdout)

  # browser()

  class(out) <- c("tbl_df", "tbl", "data.frame")

  out

})

#' Find the database data type associated with an R object
#' @export
setMethod("dbDataType", "OsqueryConnection", function(dbObj, obj, ...) {
    if (is.integer(obj)) "INTEGER"
    else if (is.numeric(obj)) "DOUBLE"
    else "TEXT"
}, valueClass = "character")

#' @export
setMethod("dbHasCompleted", "OsqueryResult", function(res, ...) {
  TRUE
})


#' @rdname OsqueryConnection-class
#' @export
setMethod(
  'dbIsValid',
  'OsqueryConnection',
  function(dbObj, ...) {
    TRUE
  }
)

#' Statement
#'
#' @rdname OsqueryResult-class
#' @export
setMethod(
  'dbGetStatement',
  'OsqueryResult',
  function(res, ...) { return(res@statement) }
)

#' @rdname OsqueryConnection-class
#' @export
setMethod(
  'dbListFields',
  c('OsqueryConnection', 'character'),
  function(conn, name, ...) {
    # quoted.name <- dbQuoteIdentifier(conn, name)
    quoted.name <- name
    names(dbGetQuery(conn, paste('SELECT * FROM', quoted.name, 'LIMIT 1')))
  }
)

#' @rdname OsqueryConnection-class
#' @export
setMethod(
  'dbListTables',
  c('OsqueryConnection'),
  function(conn, ...) {
    ret <- call_osquery(".tables")
    out <- strsplit(ret$stdout, "\n")[[1]]
    out <- gsub("^[[:space:]]*=>[[:space:]]*", "", out)
    out
  }
)



