#' Derive heading based on consecutive geographic locations
#'
#' The heading of a device with a gps unit can be determined by
#' calculating the angle between the last gps location and the
#' current location.
#' It is assumed that lon and lat are sorted temporally.
#' @param lon vector of geographic longitudes
#' @param lat vector of geographic latitudes
#' @param type character value describing the type of angle value -
#'        either "degree" (default) or "radians"
#' @returns a vector of gps heading in the same type as the input.
#' @export
gps_heading <- function(lon, lat, type = "degree") {
  n <- length(lon)
  stopifnot(length(lat) == length(lon))
  if (type == "degree") {
    lat <- lat * pi / 180 # convert to radians
    lon <- lon * pi / 180 # convert to radians
  }

  lat1 <- lat[-n]
  lat2 <- lat[-1]
  lon1 <- lon[-n]
  lon2 <- lon[-1]

  dlon <- lon2 - lon1

  x <- sin(dlon) * cos(lat2)

  y <- cos(lat1) * sin(lat2) -
    sin(lat1) * cos(lat2) * cos(dlon)

  bearing <- atan2(x, y)
  bearing <- (bearing + 2*pi) %% 2*pi

  if (type == "degree") bearing <- bearing * 180 / pi

  c(bearing, NA)
}
