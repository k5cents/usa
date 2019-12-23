
<!-- README.md is generated from README.Rmd. Please edit that file -->

# usa <a href='https:/kiernann.com/usa'><img src='man/figures/logo.png' align="right" height="139" /></a>

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
sets included with R. When attached, this package **overwrites** these
original vectors. The vectors from this package contain information for
the District of Columbia, Puerto Rico, and the other sovereign
territories of the United States of America.

## Installation

You can install the development version of `usa` from
[GitHub](https://github.com/kiernann/usa) with:

``` r
# install.packages("remotes")
remotes::install_github("kiernann/usa")
```

## Base Data

R ships with seven outdated “state” objects:

  - `state.abb`: character vector of 2-letter abbreviations for the
    state names.
  - `state.area`: numeric vector of state areas (in square miles).
  - `state.center`: list giving the approximate geographic center of
    each state.
  - `state.division`: factor giving state geographic census divisions.
  - `state.name`: character vector giving the full state names.
  - `state.region`: factor giving the census region.
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
base <- data.frame(
  abb = state.abb,
  name = state.name,
  region = state.region,
  division = state.division,
  center.x = state.center$x,
  center.y = state.center$y
)
head(base)
#>   abb       name region           division  center.x center.y
#> 1  AL    Alabama  South East South Central  -86.7509  32.5901
#> 2  AK     Alaska   West            Pacific -127.2500  49.2500
#> 3  AZ    Arizona   West           Mountain -111.6250  34.2192
#> 4  AR   Arkansas  South West South Central  -92.2992  34.7336
#> 5  CA California   West            Pacific -119.7730  36.5341
#> 6  CO   Colorado   West           Mountain -105.5130  38.6777
head(state.x77)
#>            Population Income Illiteracy Life Exp Murder HS Grad Frost   Area
#> Alabama          3615   3624        2.1    69.05   15.1    41.3    20  50708
#> Alaska            365   6315        1.5    69.31   11.3    66.7   152 566432
#> Arizona          2212   4530        1.8    70.55    7.8    58.1    15 113417
#> Arkansas         2110   3378        1.9    70.66   10.1    39.9    65  51945
#> California      21198   5114        1.1    71.71   10.3    62.6    20 156361
#> Colorado         2541   4884        0.7    72.06    6.8    63.9   166 103766
```

## New Data

This package contains new versions of these objects. Attaching the
package with `library()` will **overwrite** these vectors with newer,
longer versions. The new versions maintain the same class and content.

``` r
library(tibble)
library(usa)
setdiff(usa::state.abb, datasets::state.abb)
#> [1] "DC" "AS" "GU" "MP" "PR" "UM" "VI"
unique(usa::state.region)
#> [1] South     West      Northeast Midwest   <NA>     
#> Levels: Northeast Midwest South West
unique(datasets::state.region)
#> [1] South         West          Northeast     North Central
#> Levels: Northeast South North Central West
```

The package also contains two [tibbles](https://tibble.tidyverse.org/)
identifying the states and territories and providing various updated
statistics.

``` r
head(usa::states)
#> # A tibble: 6 x 9
#>   abb   name       fips  ansi     region division              area   lat   long
#>   <chr> <chr>      <chr> <chr>    <fct>  <fct>                <dbl> <dbl>  <dbl>
#> 1 AL    Alabama    01    01779775 South  East South Central  50647.  32.7  -86.8
#> 2 AK    Alaska     02    01785533 West   Pacific            571017.  63.4 -153. 
#> 3 AZ    Arizona    04    01779777 West   Mountain           113653.  34.3 -112. 
#> 4 AR    Arkansas   05    00068085 South  West South Central  52038.  34.9  -92.4
#> 5 CA    California 06    01779778 West   Pacific            155854.  37.2 -120. 
#> 6 CO    Colorado   08    01779779 West   Mountain           103638.  39.0 -106.
head(usa::info)
#> # A tibble: 6 x 8
#>   abb   population income life_exp murder  high  bach   heat
#>   <chr>      <dbl>  <dbl>    <dbl>  <dbl> <dbl> <dbl>  <dbl>
#> 1 AL       4887871  48123     74.9    7.8 0.866 0.234  65.9 
#> 2 AK        737438  73181     77.8    6.4 0.927 0.271 -26.6 
#> 3 AZ       7171646  56581     79.2    5.1 0.871 0.271  73.6 
#> 4 AR       3013825  45869     75.4    7.2 0.873 0.214  62.4 
#> 5 CA      39557045  71805     80.9    4.4 0.845 0.314  38.1 
#> 6 CO       5695564  69117     79.9    3.7 0.913 0.384   6.24
```

-----

Please note that the `usa` project is released with a [Contributor Code
of Conduct](https://kiernann.com/usa/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
