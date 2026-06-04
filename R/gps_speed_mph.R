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
#' @export
gps_speed_mph <- function(lon, lat, time) {
#  browser()
  stopifnot(length(lon) == length(lat), length(lat) == length(time))
  time = lubridate::ymd_hms(time) # timezone doesn't matter
  n <- length(lon)
  if (n < 2) return(rep(NA_real_, n))

  distance_m = c(
    geosphere::distHaversine(
      cbind(lon[-n], lat[-n]),
      cbind(lon[-1],  lat[-1])
    ),
    NA_real_
  )

  dt_hours = c(
    diff(as.numeric(time)) / 3600, # seconds to hours
    NA_real_
  )

  distance_m / 1609.344 / dt_hours
}
