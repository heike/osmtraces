# Turn a track into multiple segments

If the time between successive time points exceeds the interval
specified in seconds, it is assumed hat a new segment has started.

## Usage

``` r
segmentize(time, seconds = 5)
```

## Arguments

- time:

  vector of time stamps

- seconds:

  positive value indicating the time allowed between successive time
  points before a new segment is started.

## Value

integer vector of segment ids
