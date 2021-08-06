
produce_departures_slice <- function(start_time, fifteen_minute_intervals=(6*4)-1){
  r5r_core <- setup_r5("data")

  lsoa_trip_points <- st_read("data/lsoa11_nearest_road_points.geojson") %>%
    mutate(id = LSOA11CD)

  departure_time_offsets <- (0:(fifteen_minute_intervals-1))*15

  ret <- tibble()

  for (offset in departure_time_offsets) {

    departure_time <- start_time + lubridate::dminutes(offset)
    print(departure_time)

    ttm <- travel_time_matrix(r5r_core = r5r_core,
      origins = lsoa_trip_points,
      destinations = lsoa_trip_points,
      mode = c('WALK', 'TRANSIT'),
      departure_datetime = departure_time,
      max_walk_dist = 3000,
      max_trip_duration = (6*60),
      verbose = FALSE
      ) 

    ttm <- ttm %>%
      mutate(
        from_id = factor(fromId, levels=lsoa_trip_points$id), 
        to_id =   factor(toId,   levels=lsoa_trip_points$id),
        fromId = NULL,
        toId = NULL
      ) %>%
      rename(
        travel_time_minutes = travel_time
      ) %>%
      mutate(
        departure_time = departure_time,
        arrival_time = departure_time + lubridate::dminutes(travel_time_minutes)
      ) %>%
      filter(to_id != from_id)

    ret <- ret %>% 
    bind_rows(ttm)
    ttm <- NULL
  }

  #ret <- ret %>%
  #group_by(from_id, to_id, arrival_time) %>% arrange(departure_time) %>% slice_tail() %>% ungroup()

  filename = paste0(
    "departures_slice_", 
    start_time %>% strftime("%Y-%m-%dT%H-%M"),
    "_", fifteen_minute_intervals, "x15.rds")

  ret %>% saveRDS(paste0("output/", filename), compress="xz")

}