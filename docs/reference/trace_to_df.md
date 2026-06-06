# Convert a trace into a data frame

Turns a GPX defined track from a format as xml node into a data frame.
All elements are turned into variables, the track is a single-entry list
variable with a data frame of time-stamped geographic locations. This
function is called as part of `read_gpx`. There should be no need to
call this function by itself.

## Usage

``` r
trace_to_df(trk)
```

## Arguments

- trk:

  xml node with elements and attributes

## Value

single row dataframe with a nested dataframe of the trace in form of a
tibble with variables latitude, longitude, and time.
