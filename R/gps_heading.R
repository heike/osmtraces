#' Derive heading based on consecutive geographic locations
#'
#'
gps_heading <- function(lon, lat, degree = TRUE) {

  lat1 <- head(lat, -1) * pi / 180
  lat2 <- tail(lat, -1) * pi / 180

  lon1 <- head(lon, -1) * pi / 180
  lon2 <- tail(lon, -1) * pi / 180

  dlon <- lon2 - lon1

  x <- sin(dlon) * cos(lat2)

  y <- cos(lat1) * sin(lat2) -
    sin(lat1) * cos(lat2) * cos(dlon)

  bearing <- atan2(x, y) * 180 / pi

  bearing <- (bearing + 360) %% 360

  c(bearing, NA)
}
