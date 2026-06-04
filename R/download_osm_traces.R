#' Download all public traces from a geographic location
#'
#' All publicly available traces traversing the bounding box specified by `lat`,
#' `lon` and `zoom` are downloaded from OpenStreetMaps. Downloads are paginated;
#' each page contains a maximum of 5000 track points and is saved as file `folder/page-X.gpx`, where
#' `folder` is either user-specified or a temporary folder.
#' A message informs the user in case the download is complete.
#' @param lon geographic longitude
#' @param lat geographic latitude
#' @param zoom value specifying the zoom value (and with it the bounding box
#' centered around specified latitude and longitude)
#' @param first_page integer value indicating page number to start the scrape;
#' the API allows a download of 5000 points on each page. By default up to 20
#' pages are downloaded. In case more points exist, re-run the download with
#' increased values of `first_page` = 20, 40, ...
#' @param folder character string of the destination folder. Any existing files will be overwritten.
#' @returns a character string of the download folder.
#' @importFrom httr2 request req_perform resp_body_string
#' @export
#' @examples
#' # The website
#' # https://www.openstreetmap.org/#map=15/42.00709/-93.57195&layers=PG
#' # translates to
#' if (interactive()) {
#'   download_osm_tracks( -93.57195, 42.00709, 15, first_page = 0,
#'                        folder = "ames")
#'   download_osm_tracks( -93.57195, 42.00709, 15, first_page = 20,
#'                        folder = "ames")
#'   download_osm_tracks( -93.57195, 42.00709, 15, first_page = 40,
#'                        folder = "ames")
#' }
download_osm_tracks <- function(
    lon,
    lat,
    zoom = 16,
    first_page = 0,
    folder = NULL
) {
  if (is.null(folder)) folder <- tempdir()

  # approximate visible extent
  width_deg <- 360 / 2^zoom
  height_deg <- width_deg

  xmin <- lon - width_deg
  xmax <- lon + width_deg
  ymin <- lat - height_deg
  ymax <- lat + height_deg

  files <- dir(folder, recursive = TRUE, full.names = TRUE)
  if (length(files) > 0) {
    message(sprintf("folder <%s> exists and is non-empty, overwriting files", folder))
  }
  if (!dir.exists(folder)) dir.create(folder)

  for(page in first_page + 0:19) {

    url <- sprintf(
      paste0(
        "https://api.openstreetmap.org/api/0.6/",
        "trackpoints?bbox=%f,%f,%f,%f&page=%d"
      ),
      xmin, ymin, xmax, ymax, page
    )

    message("Downloading page ", page)

    xml <- request(url) |>
      req_perform() |>
      resp_body_string()

    trk_found <- grep("<trk>", xml)
    if (length(trk_found) == 0) {
      last_page <- page
      message("Download complete with page ", last_page)
      return(folder)
    } else {
      writeLines(xml, con=sprintf(file.path(folder, sprintf("page-%d.gpx", page))))
    }
  }
  return(folder)
}
