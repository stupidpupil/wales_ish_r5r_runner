filter_to_most_efficient_departures <- function(journeys){
  journeys %>%
    arrange(from_id, to_id, arrival_time, departure_time) %>%
    filter(!(from_id == lead(from_id) & to_id == lead(to_id) & arrival_time == lead(arrival_time)))
}