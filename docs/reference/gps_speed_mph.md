# Derive speed based on geographic location

Time and distance between consecutive geographic locations are used to
derive the speed at which a trace is traversed.

## Usage

``` r
gps_speed_mph(lon, lat, time)
```

## Arguments

- lon:

  vector of geographic longitudes

- lat:

  vector of geographic latitudes

- time:

  vector of time stamps

## Value

vector of speed in miles per hour (mph)
