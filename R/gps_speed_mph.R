#' Derive speed based on geographic location
#'
#' Time and distance between consecutive geographic locations are used to
#' derive the speed at which a trace is traversed.
#' @param lon vector of geographic longitudes
#' @param lat vector of geographic latitudes
#' @param time vector of time stamps
#' @returns vector of speed in miles per hour (mph)
#' @importFrom geosphere distHaversine
#' @importFrom lubridate ymd_hms
#' @importFrom purrr pluck
#' @importFrom dplyr left_join summarise group_by mutate
#' @importFrom rlang .data
#' @export
gps_speed_mph <- function(lon, lat, time) {
#  browser()
  stopifnot(length(lon) == length(lat), length(lat) == length(time))
  time = lubridate::ymd_hms(time) # timezone doesn't matter
  n <- length(lon)
  if (n < 2) return(NA)

  data <- data.frame(time, lat, lon) # do we have sub second records?
  data <- data |> group_by(time) |> summarise(
    lon = mean(lon),
    lat = mean(lat)
    )
  n <- nrow(data)
  if (n < 2) return(NA)

  data <- data |> mutate(
      distance_m = c(geosphere::distHaversine(
          cbind(lon[-n], lat[-n]),
          cbind(lon[-1],  lat[-1])
        ), NA),
      dt_hours = c(
        diff(as.numeric(time)) / 3600, # seconds to hours
        NA_real_
      ),
      speed = .data$distance_m / 1609.344 / .data$dt_hours
    )

  # now scale back by time:
  data.frame(time = time) |>
    dplyr::left_join(data, by="time") |> purrr::pluck("speed")
}
