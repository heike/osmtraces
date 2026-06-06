# Derive heading based on consecutive geographic locations

The heading of a device with a gps unit can be determined by calculating
the angle between the last gps location and the current location. It is
assumed that lon and lat are sorted temporally.

## Usage

``` r
gps_heading(lon, lat, type = "degree")
```

## Arguments

- lon:

  vector of geographic longitudes

- lat:

  vector of geographic latitudes

- type:

  character value describing the type of angle value - either "degree"
  (default) or "radians"

## Value

a vector of gps heading in the same type as the input.
