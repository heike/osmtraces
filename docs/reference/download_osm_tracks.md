# Download all public traces from a geographic location

All publicly available traces traversing the bounding box specified by
`lat`, `lon` and `zoom` are downloaded from OpenStreetMaps. Downloads
are paginated; each page contains a maximum of 5000 track points and is
saved as file `folder/page-X.gpx`, where `folder` is either
user-specified or a temporary folder. A message informs the user in case
the download is complete.

## Usage

``` r
download_osm_tracks(lon, lat, zoom = 16, first_page = 0, folder = NULL)
```

## Arguments

- lon:

  geographic longitude

- lat:

  geographic latitude

- zoom:

  value specifying the zoom value (and with it the bounding box centered
  around specified latitude and longitude)

- first_page:

  integer value indicating page number to start the scrape; the API
  allows a download of 5000 points on each page. By default up to 20
  pages are downloaded. In case more points exist, re-run the download
  with increased values of `first_page` = 20, 40, ...

- folder:

  character string of the destination folder. Any existing files will be
  overwritten.

## Value

a character string of the download folder.

## Examples

``` r
# The website
# https://www.openstreetmap.org/#map=15/42.00709/-93.57195&layers=PG
# translates to
if (interactive()) {
  download_osm_tracks( -93.57195, 42.00709, 15, first_page = 0,
                       folder = "ames")
  download_osm_tracks( -93.57195, 42.00709, 15, first_page = 20,
                       folder = "ames")
  download_osm_tracks( -93.57195, 42.00709, 15, first_page = 40,
                       folder = "ames")
}
```
