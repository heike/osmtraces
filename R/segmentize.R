#' Turn a track into multiple segments
#'
#' If the time between successive time points exceeds the interval specified
#' in seconds, it is assumed hat a new segment has started.
#' @param time vector of time stamps
#' @param seconds positive value indicating the time allowed between successive time
#' points before a new segment is started.
#' @returns integer vector of segment ids
#' @export
segmentize <- function(time, seconds = 5) {
  dtime = diff(as.numeric(time))
  increase_by_one <- dtime <= seconds
  increase_by_one[is.na(increase_by_one)] <- FALSE
  res <- cumsum(!increase_by_one)+1
  c(res, res[length(res)])
}
