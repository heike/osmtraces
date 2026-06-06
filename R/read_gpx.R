#' Read OSM traces from a gpx file
#'
#' The OpenStreetMap API returns traces in form of paged gpx (v1.0) files.
#' This function should not be used as a stand-alone gpx reader - it is meant only
#' to read the downloaded trace files.
#' @param file file path to a gpx file
#' @returns data frame of the traces
#' @export
#' @importFrom xml2 read_xml xml_ns xml_find_all
#' @importFrom purrr map list_rbind
#' @examples
#' # example code
#' if (interactive()) {
#' library(ggplot2)
#' read_gpx(system.file("ames/page-0.gpx", package = "osmtraces")) |>
#'   tidyr::unnest(trkseg) |>
#'   ggplot(aes(x = lon, y = lat)) + geom_point()
#' }
read_gpx <- function(file) {
  doc <- read_xml(file)
  ns <- xml2::xml_ns(doc)
  nodes <- xml2::xml_find_all(doc, ".//d1:trk", ns)

  traces <- map(nodes, trace_to_df)

  traces |> list_rbind()
}
