#' @export
#' @examples
#' # example code
#' download_osm_tracks(lon = -96.707931, lat = 40.811909, zoom = 16,
#'  folder="lincoln")
#' lincoln_tracks <- read_osm_traces("lincoln")
#'
#' lincoln_tracks <- lincoln_tracks |> dplyr::mutate(
#'   trkseg = trkseg |> purrr::map(.f = function(df) {
#'     df$gps_heading = gps_heading(lon=df$lon, lat=df$lat)
#'     df$gps_speed = gps_speed_mph(lon=df$lon, lat=df$lat, df$time)
#'     df
#'     })
#'  )
#'
#' library(dplyr)
#' lincoln_trackpoints <- lincoln_tracks |>
#'   mutate(rowid = 1:n()) |> tidyr::unnest(trkseg)
#'
#' lincoln_trackpoints |> ggplot(aes(x = lon, y = lat, colour = gps_heading)) +
#'   geom_path(aes(group=rowid)) + scale_colour_gradientn(
#'     colours = grDevices::hcl(
#'       h = seq(0, 360, length.out = 361),
#'       c = 100,
#'       l = 65
#'     ),
#'     limits = c(0, 360),
#'     breaks = seq(0, 360, by = 45)
#'   )
read_osm_traces <- function (folder) {
  files <- dir(path=folder, pattern=".gpx", full.names = TRUE)
  tracks <- NULL
  if (length(files) > 0) {
    for (file in files) {
      tmp_tracks <- read_gpx(file)

      if (is.null(tracks)) tracks <- tmp_tracks
      else {
        tracks <- rbind(tracks, tmp_tracks)
      }
    }
  }
  tracks
}
