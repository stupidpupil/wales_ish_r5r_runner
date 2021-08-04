joined_slices <- function(){
  do.call(bind_rows, lapply(list.files("output/", pattern="*.rds", full.names=TRUE), readRDS))
}