context("DBI components work")
test_that("DBI components work", {

  con <- DBI::dbConnect(Osquery())
  expect_true(inherits(con, "OsqueryConnection"))

  expect_true("osquery_info" %in% dbListTables(con))
  x <- capture.output(show(con)) # just exercising it

  res <- dbSendQuery(con, "SELECT * FROM dns_resolvers")
  expect_true(inherits(res, "OsqueryResult"))

  expect_true(inherits(dbFetch(res), "data.frame"))

  expect_true(dbIsValid(res))

  expect_true(grepl("SELECT", dbGetStatement(res)))

  expect_true(inherits(dbGetQuery(con, "SELECT * FROM dns_resolvers"), "data.frame"))

  expect_true(dbExistsTable(con, "dns_resolvers"))
  expect_true("address" %in% dbListFields(con, "dns_resolvers"))
  expect_true(inherits(dbReadTable(con, "dns_resolvers"), "data.frame"))
  expect_true(dbIsValid(con))

})

context("dbplyr/dplyr components work")
test_that("dbplyr/dplyr components work", {

  con <- DBI::dbConnect(Osquery())
  expect_true(inherits(con, "OsqueryConnection"))

  local_db <- dbplyr::src_dbi(con)
  expect_true(inherits(local_db, "src_dbi"))

  expect_true(inherits(dplyr::tbl(local_db, "dns_resolvers"), "tbl_dbi"))

})
