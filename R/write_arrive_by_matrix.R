write_arrive_by_matrix_csv <- function(journeys, arrive_by, pre_sorted = FALSE){

  journeys <- journeys %>%
    filter(arrival_time <= arrive_by)

  if(!pre_sorted){
    journeys <- journeys %>% 
      arrange(from_id, to_id, arrival_time, departure_time)
  }

  journeys <- journeys %>%
    filter(
      !(from_id == lead(from_id) & to_id == lead(to_id)) | 
      ( is.na(lead(from_id)) & is.na(lead(to_id)) )
    )


  journeys <- journeys %>%
    mutate(end_to_end_minutes = as.numeric(arrive_by - departure_time, unit="mins") %>% as.integer())

  csv_name <- paste0("output/arrive_by_", arrive_by %>% strftime("%a%H%M"), "_public.csv")

  journeys %>% 
    select(from_id, to_id, end_to_end_minutes) %>%
    pivot_wider(names_from="to_id", values_from="end_to_end_minutes") %>%
    write_csv(csv_name, na="")

  add_matrix_to_index_json(list(
    path = basename(csv_name),
    name = paste0("Public transport, arriving by ", arrive_by %>% strftime("%H:%M %a %d %B %Y")),
    time_ref_type = "arriveby",
    time_ref = arrive_by %>% lubridate::format_ISO8601(withtz = TRUE)
  ))

}