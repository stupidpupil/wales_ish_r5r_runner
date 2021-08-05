joined_slices <- function(){
  do.call(bind_rows, lapply(list.files("output/", pattern="departures_slice_.+\\.rds", full.names=TRUE), readRDS))
}