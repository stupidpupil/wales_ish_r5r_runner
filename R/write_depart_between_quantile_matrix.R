write_depart_between_quantile_matrix <- function(journeys, depart_after, depart_by, q){
  journeys <- journeys %>%
    filter(departure_time >= depart_after, departure_time <= depart_by)

  lsoa_groups_n <- 10
  lsoa_ids <- joined_slices() %>% select(from_id) %>% distinct %>% pull(from_id)
  lsoa_group_length <- floor((lsoa_ids %>% length())/lsoa_groups_n)

  journeys_temp <- tibble()

  for (i in 1:lsoa_groups_n) {
    start_i <- (i-1)*lsoa_group_length+1
    end_i <- i*lsoa_group_length

    if (i == lsoa_groups_n){
      end_i <- length(lsoa_ids)
    }

    selected_lsoa_ids <- lsoa_ids[start_i:end_i]

    journeys_for_selected_lsoa_ids <- journeys %>% 
      filter(to_id %in% selected_lsoa_ids) %>%
      group_by(from_id, to_id) %>%
      summarise(travel_time_minutes = quantile_cont(travel_time_minutes,q)) %>%
      ungroup() %>%
      collect()

    journeys_temp <- journeys_temp %>% 
      bind_rows(journeys_for_selected_lsoa_ids)
  }

  journeys <- journeys_temp

  journeys <- mutate(journeys,
    travel_time_minutes = if_else(travel_time_minutes > 7*60, NA_integer_, as.integer(travel_time_minutes)))

  csv_name <- paste0(
    "output/depart_between_", 
    depart_after %>% strftime("%a%H%M-", tz="Europe/London"),
    depart_by %>% strftime("%a%H%M", tz="Europe/London"), 
    "_p", as.integer(q*100), "_public.csv")

  journeys %>%
    pivot_wider(names_from="to_id", values_from="travel_time_minutes") %>%
    write_csv(csv_name, na="")

  add_matrix_to_index_json(list(
    path = basename(csv_name),
    units = "minutes",
    name = paste0(
      "Public transport, depart", 
      depart_by %>% strftime("%H:%M-", tz="Europe/London"),  
      depart_after %>% strftime("%H:%M %a %d %B %Y", tz="Europe/London"),
      " p", as.integer(q*100)
      ),
    mode = "public_transport",
    time_ref_type = "depart_between_quantile",
    time_ref_start = depart_after %>% lubridate::format_ISO8601(usetz = TRUE),
    time_ref_end   = depart_by %>% lubridate::format_ISO8601(usetz = TRUE),
    quantile = q,
    license = "ODbL-1.0",
    license_ref = "https://github.com/stupidpupil/wales_ish_r5r_runner/tree/matrix-releases#licence"
  ))

}