write_metadata_from_index_to_csv_comments <- function(){

  matrices <- jsonlite::fromJSON("output/index.json")$matrices

  matrices %>% rowwise() %>% write_metadata_to_csv_comments()

}

write_metadata_to_csv_comments <- function(metadata){
  path <- paste0("output/", metadata$path)
  denylist_metadata_keys <- c('path')

  lines <- read_lines(path)

  sanitize_for_csv_comment <- function(x){
    x %>% 
      str_replace_all("[\\r\\n]", " - ") %>%
      str_replace_all("(\\d),(\\d)", "\\1\\2") %>%
      str_replace_all(",\\s?", " - ")
  }

  cols_of_interest <- setdiff(colnames(metadata), denylist_metadata_keys)
  pad_to <- cols_of_interest %>% str_length() %>% max()

  for(c in cols_of_interest){

    key <- paste0("# ", str_pad(sanitize_for_csv_comment(c), pad_to, 'left'), ": ")
    key_for_search <- paste0("^#\\s+", sanitize_for_csv_comment(c), ":")

    lines <- lines[!str_detect(lines, key_for_search)]

    comment_line <- paste0(key, sanitize_for_csv_comment(metadata[[c]]))

    lines <- c(lines, comment_line)
  }

  lines %>% write_lines(path)

}