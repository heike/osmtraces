# Read OSM traces from a gpx file

The OpenStreetMap API returns traces in form of paged gpx (v1.0) files.
This function should not be used as a stand-alone gpx reader - it is
meant only to read the downloaded trace files.

## Usage

``` r
read_gpx(file)
```

## Arguments

- file:

  file path to a gpx file

## Value

data frame of the traces

## Examples

``` r
# example code
if (interactive()) {
library(ggplot2)
read_gpx(system.file("ames/page-0.gpx", package = "osmtraces")) |>
  tidyr::unnest(trkseg) |>
  ggplot(aes(x = lon, y = lat)) + geom_point()
}
```
