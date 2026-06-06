# Read pre-downloaded traces from a folder

Read pre-downloaded traces from a folder

## Usage

``` r
read_osm_traces(folder)
```

## Arguments

- folder:

  character vector of the file path at which the gpx files are located

## Value

data frame with one row for each trace; other variables usually include
the file name, a description, and a url. Traces are included as a list
variable of data frames. Each trace is a sequence of time stamped
geographic locations.

## Examples

``` r
# example code
if (interactive()) {
library(ggplot2)
folder <- system.file("ames", package = "osmtraces")
ames <- read_osm_traces(folder)
ames$data[[1]] |> ggplot(aes(x = lon, y = lat)) + geom_point()


download_osm_tracks(lon = -96.707931, lat = 40.811909, zoom = 16,
 folder="lincoln")
lincoln_tracks <- read_osm_traces("lincoln")

lincoln_tracks <- lincoln_tracks |> dplyr::mutate(
  data = data |> purrr::map(.f = function(df) {
    df$gps_heading = gps_heading(lon=df$lon, lat=df$lat)
    df$gps_speed = gps_speed_mph(lon=df$lon, lat=df$lat, df$time)
    df
    })
 )

library(dplyr)
lincoln_trackpoints <- lincoln_tracks |>
  mutate(rowid = 1:n()) |> tidyr::unnest(data)

lincoln_trackpoints |> ggplot(aes(x = lon, y = lat, colour = gps_heading)) +
  geom_path(aes(group=rowid)) + scale_colour_gradientn(
    colours = grDevices::hcl(
      h = seq(0, 360, length.out = 361),
      c = 100,
      l = 65
    ),
    limits = c(0, 360),
    breaks = seq(0, 360, by = 45)
  )
}
```
