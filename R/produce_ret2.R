
produce_ret2 <- function(){
  r5r_core <- setup_r5("data")

  lsoa_trip_points <- st_read("data/lsoa11_nearest_road_points.geojson") %>%
  mutate(id = LSOA11CD)

  target_arrival_time <- lubridate::ymd_hms("2021-07-20 20:05:00", tz="Europe/London")
  departure_time_offsets <- 1:(6*4)*-15

  ret_ret <- tibble(from_id=character(0), to_id=character(0))
  origins <- lsoa_trip_points

  for (offset in departure_time_offsets) {

    departure_time <- target_arrival_time + lubridate::dminutes(offset)
    print(departure_time)

    departure_time %>% as.character() %>% write("departure_time")

    ttm <- travel_time_matrix(r5r_core = r5r_core,
      origins = lsoa_trip_points,
      destinations = lsoa_trip_points,
      mode = c('WALK', 'TRANSIT'),
      departure_datetime = departure_time,
      max_walk_dist = 3000,
      max_trip_duration = max(-offset,120),
      verbose = FALSE
      ) 

    print("here")

    ttm <-ttm %>%
    rename(
      from_id = fromId, to_id = toId,
      travel_time_minutes = travel_time) %>%
    mutate(
      departure_time = departure_time,
      arrival_time = departure_time + lubridate::dminutes(travel_time_minutes)
      )

    ret <- ret %>% 
    bind_rows(ttm) %>%
    group_by(from_id, to_id, arrival_time) %>% arrange(departure_time) %>% slice_tail() %>% ungroup()

    ret_ret <- ret_ret %>% bind_rows(ret)
    saveRDS(ret_ret, "ret.rds")

  }


}