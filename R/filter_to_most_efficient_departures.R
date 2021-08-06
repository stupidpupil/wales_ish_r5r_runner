# Removes all but the latest known departure for each known arrival time 
# (for each from_id/to_id pair).
#
filter_to_most_efficient_departures <- function(journeys){
  journeys %>%
    arrange(from_id, to_id, arrival_time, departure_time) %>%
    filter(
      !(from_id == lead(from_id) & to_id == lead(to_id) & arrival_time == lead(arrival_time)) |
      ( is.na(lead(from_id)) & is.na(lead(to_id)) & is.na(lead(arrival_time)) )
    )
}