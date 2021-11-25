write_arrive_by_matrix_csv <- function(journeys, arrive_by){

  journeys <- journeys %>%
    filter(arrival_time <= arrive_by)

  journeys <- journeys %>%
    group_by(from_id, to_id) %>%
    summarise(departure_time = max(departure_time)) %>%
    ungroup() %>%
    collect() 

  journeys <- journeys %>%
    mutate(end_to_end_minutes = as.numeric(arrive_by - departure_time, unit="mins") %>% as.integer())

  csv_name <- paste0("output/arrive_by_", arrive_by %>% strftime("%a%H%M", tz="Europe/London"), "_public.csv")

  journeys %>% 
    select(from_id, to_id, end_to_end_minutes) %>%
    pivot_wider(names_from="to_id", values_from="end_to_end_minutes") %>%
    write_csv(csv_name, na="")

  add_matrix_to_index_json(list(
    path = basename(csv_name),
    units = "minutes",
    name = paste0("Public transport, arriving by ", arrive_by %>% strftime("%H:%M %a %d %B %Y", tz="Europe/London")),
    mode = "public_transport",
    time_ref_type = "arrive_by",
    time_ref = arrive_by %>% lubridate::format_ISO8601(usetz = TRUE),
    license = "ODbL-1.0",
    license_ref = "https://github.com/stupidpupil/wales_ish_r5r_runner/tree/matrix-releases#licence",
    created = lubridate::now() %>% lubridate::format_ISO8601(usetz = TRUE)
  ))

}