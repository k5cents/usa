
<!-- README.md is generated from README.Rmd. Please edit that file -->

# usa

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/usa)](https://CRAN.R-project.org/package=usa)
[![Travis build
status](https://travis-ci.org/kiernann/usa.svg?branch=master)](https://travis-ci.org/kiernann/usa)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/usa/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/usa?branch=master)
<!-- badges: end -->

The goal of `usa` is to provide updated versions of the `state` data
sets included in base R. These versions include newer statistics in the
modern data frame format.

## Installation

You can install the development version of `usa` from
[GitHub](https://github.com) with:

``` r
# install.packages("remotes")
remotes::install_github("kiernann/usa")
```

## Old Data

``` r
library(tidyverse)
```

R ships with seven outdated built-in “state” objects:

  - `state.abb`: character vector of 2-letter abbreviations for the
    state names.
  - `state.area`: numeric vector of state areas (in square miles).
  - `state.center`: list giving the approximate geographic center of
    each state.
  - `state.division`: factor giving state divisions.
  - `state.name`: character vector giving the full state names.
  - `state.region`: factor giving the region.
  - `state.x77`: matrix with 50 rows and 8 columns:
      - `Population`: population estimate as of July 1, 1975
      - `Income`: per capita income (1974)
      - `Illiteracy`: illiteracy (1970, percent of population)
      - `Life Exp`: life expectancy in years (1969–71)
      - `Murder`: murder and non-negligent manslaughter rate per 100,000
        population (1976)
      - `HS Grad`: percent high-school graduates (1970)
      - `Frost`: mean number of days with minimum temperature below
        freezing (1931–1960)
      - `Area`: land area in square miles

<!-- end list -->

``` r
library(datasets)
vectors <- data.frame(
  abb = state.abb,
  name = state.name,
  region = state.region,
  division = state.division,
  x = state.center$x,
  y = state.center$y
)
head(vectors, 3)
#>   abb    name region           division         x       y
#> 1  AL Alabama  South East South Central  -86.7509 32.5901
#> 2  AK  Alaska   West            Pacific -127.2500 49.2500
#> 3  AZ Arizona   West           Mountain -111.6250 34.2192
head(state.x77, 3)
#>         Population Income Illiteracy Life Exp Murder HS Grad Frost   Area
#> Alabama       3615   3624        2.1    69.05   15.1    41.3    20  50708
#> Alaska         365   6315        1.5    69.31   11.3    66.7   152 566432
#> Arizona       2212   4530        1.8    70.55    7.8    58.1    15 113417
```

## New Data

This package contains new versions of these objects\!

``` r
library(usa)
states
#> # A tibble: 57 x 8
#>    fips  name            abb   ansi    region   division            x     y
#>    <chr> <chr>           <chr> <chr>   <fct>    <fct>           <dbl> <dbl>
#>  1 01    Alabama         AL    017797… South    East South Ce…  -86.8  32.8
#>  2 02    Alaska          AK    017855… West     Pacific        -152.   64.1
#>  3 04    Arizona         AZ    017797… West     Mountain       -112.   34.3
#>  4 05    Arkansas        AR    000680… South    West South Ce…  -92.4  34.9
#>  5 06    California      CA    017797… West     Pacific        -119.   37.2
#>  6 08    Colorado        CO    017797… West     Mountain       -106.   39.0
#>  7 09    Connecticut     CT    017797… Northea… New England     -72.7  41.6
#>  8 10    Delaware        DE    017797… South    South Atlantic  -75.5  39.0
#>  9 11    District of Co… DC    017023… South    South Atlantic  -77.0  38.9
#> 10 12    Florida         FL    002944… South    South Atlantic  -82.4  28.6
#> # … with 47 more rows
```

The updated data includes the District of Columbia and all the other
sovereign territories of the United States of America.

``` r
setdiff(usa::state.name, datasets::state.name)
#> [1] "District of Columbia"        "American Samoa"             
#> [3] "Guam"                        "Northern Mariana Islands"   
#> [5] "Puerto Rico"                 "U.S. Minor Outlying Islands"
#> [7] "U.S. Virgin Islands"
```

-----

Please note that the `usa` project is released with a [Contributor Code
of Conduct](https://kiernann.com/usa/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
