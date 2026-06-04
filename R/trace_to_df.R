#' Convert a trace into a data frame
#'
#' Turns a GPX defined track from a format as xml node into a data frame.
#' All elements are turned into variables, the track is a single-entry
#' list variable with a data frame of time-stamped geographic locations.
#' This function is called as part of `read_gpx`. There should be no need to call
#' this function by itself.
#' @param trk xml node with elements and attributes
#' @importFrom xml2 xml_children xml_length xml_text xml_name
#' @importFrom xml2 xml_attr xml_find_first
#' @importFrom dplyr as_tibble tibble
#' @importFrom purrr map list_rbind
#' @export
#' @returns single row dataframe with a nested dataframe of the trace
#' in form of a tibble with variables latitude, longitude, and time.
trace_to_df <- function(trk) {
  # trk is an xml_node

  lst <- xml_children(trk)
  values <- as.list(
    na.omit(sapply(lst, function(x) if (xml_length(x) == 0) xml_text(x) else NA)))

  if (length(values) > 3) browser()

  if (length(values) > 0)
    names(values) <- sapply(lst, xml_name)[1:length(values)]
  dframe <- as_tibble(values)

  segments <- xml_find_all(trk, ".//d1:trkseg")

  trkseg = map(segments, function(trkseg) {
    pts <- xml_find_all(trkseg, ".//d1:trkpt")
    tibble(
      lat = as.numeric(xml_attr(pts, "lat")),
      lon = as.numeric(xml_attr(pts, "lon")),
      time = xml_text(
        xml_find_first(
          pts,
          "./*[local-name()='time']"
        )
      )
    )
  })

  if (length(trkseg) > 1) {
    trkseg <- trkseg |> list_rbind(names_to = "segment_id") |> list()
  }

  dframe$trkseg <- trkseg
  dframe
}
