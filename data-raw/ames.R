library(dplyr)
library(tidyr)
ames <- read_osm_traces(system.file("ames", package = "osmtraces"))
ames <- read_osm_traces("ames")

ames_trackpoints <- ames |>
  tidyr::unnest(trkseg)
summary(duplicated(ames_trackpoints))
ames_trackpoints <- ames_trackpoints[-duplicated(ames_trackpoints),]

ames_tracks <- ames_trackpoints |>
  group_by(name) |> # name is the file name of the trace
  mutate(
    time = lubridate::ymd_hms(time)
  ) |>
  arrange(time) |>
  mutate(
    dtime = c(diff(as.numeric(time)),NA),
    segment = segmentize(time, seconds = 60)
  ) |>
  group_by(name, segment) |>
  tidyr::nest()


# ames_tracks <- ames_trackpoints |>
#   separate_wider_delim(url, delim="/",
#                        names = c("foo","foo2","user","foo3", "trace")) |>
#   select(-starts_with("foo")) |>
#   group_by(user) |>
#   mutate(
#     time = lubridate::ymd_hms(time)
#   ) |>
#   arrange(time) |>
#   mutate(
#     dtime = c(diff(as.numeric(time)),NA),
#     segment = segmentize(time, seconds = 60)
#   ) |>
#   group_by(user, segment) |>
#   tidyr::nest()




# # now split by segment
# ames_tracks <- ames_trackpoints |>
#   group_by(url, desc, segment) |>
#   tidyr::nest()

# identify length of traces, remove all singletons
ames_tracks <- ames_tracks |> mutate(track_length = data |> purrr::map_int(.f = nrow))


ames_tracks[1:10,] |>
  tidyr::unnest(data) |>
  ggplot(aes(x = lon, y = lat)) + geom_path(aes(colour = factor(track_length), group = name))
