add_matrix_to_index_json <- function(new_matrix){

  if(file.exists("output/index.json")){
    index_json <- read_json("output/index.json")
  }else{
    index_json <- list()
  }

  if(is.null(index_json$matrices)){
    index_json$matrices <- list()
  }

  index_json$matrices[[length(index_json$matrices)+1]] <- new_matrix

  index_json %>% write_json("output/index.json", pretty=TRUE, auto_unbox=TRUE)
}
