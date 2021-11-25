joined_slices <- function(){
  con <- dbConnect(duckdb::duckdb())
  dbSendQuery(con, "CREATE VIEW departures AS SELECT * FROM parquet_scan('output/*.parquet');")
  tbl(con, "departures")
}