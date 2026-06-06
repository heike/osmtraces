segmentize <- function(time, seconds = 5) {
  dtime = diff(as.numeric(time))
  increase_by_one <- dtime <= seconds
  increase_by_one[is.na(increase_by_one)] <- FALSE
  c(1, cumsum(!increase_by_one)+1)
}
