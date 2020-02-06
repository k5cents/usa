
<!-- README.md is generated from README.Rmd. Please edit that file -->

# usa <a href='https:/kiernann.com/usa'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/aaa)](https://CRAN.R-project.org/package=aaa)
[![Travis build
status](https://travis-ci.org/kiernann/aaa.svg?branch=master)](https://travis-ci.org/kiernann/aaa)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/aaa/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/aaa?branch=master)
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

R ships with seven outdated “state” objects in the `datasets` package:

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
      - `Murder`: murder and manslaughter rate per 100,000 population
        (1976)
      - `HS Grad`: percent high-school graduates (1970)
      - `Frost`: mean number of days with temperature below freezing
        (1931–1960)
      - `Area`: land area in square miles

<!-- end list -->

``` r
head(base.vectors)
#>         name abb region           division   area  center.x center.y
#> 1    Alabama  AL  South East South Central  51609  -86.7509  32.5901
#> 2     Alaska  AK   West            Pacific 589757 -127.2500  49.2500
#> 3    Arizona  AZ   West           Mountain 113909 -111.6250  34.2192
#> 4   Arkansas  AR  South West South Central  53104  -92.2992  34.7336
#> 5 California  CA   West            Pacific 158693 -119.7730  36.5341
#> 6   Colorado  CO   West           Mountain 104247 -105.5130  38.6777
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
package will **overwrite** these vectors with newer, longer versions.
The new versions maintain the same class and content.

``` r
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
#> # A tibble: 6 x 8
#>   name       abb   fips  region division              area   lat   long
#>   <chr>      <chr> <chr> <fct>  <fct>                <dbl> <dbl>  <dbl>
#> 1 Alabama    AL    01    South  East South Central  50647.  32.7  -86.8
#> 2 Alaska     AK    02    West   Pacific            571017.  63.4 -153. 
#> 3 Arizona    AZ    04    West   Mountain           113653.  34.3 -112. 
#> 4 Arkansas   AR    05    South  West South Central  52038.  34.9  -92.4
#> 5 California CA    06    West   Pacific            155854.  37.2 -120. 
#> 6 Colorado   CO    08    West   Mountain           103638.  39.0 -106.
head(usa::info)
#> # A tibble: 6 x 9
#>   name       population admission  income life_exp murder  high  bach   heat
#>   <chr>           <dbl> <date>      <dbl>    <dbl>  <dbl> <dbl> <dbl>  <dbl>
#> 1 Alabama       4887871 1819-12-14  49861     75.3    7.8 0.866 0.234  65.9 
#> 2 Alaska         737438 1959-01-03  74346     78.3    6.4 0.927 0.271 -26.6 
#> 3 Arizona       7171646 1912-02-14  59246     79.7    5.1 0.871 0.271  73.6 
#> 4 Arkansas      3013825 1836-06-15  47062     75.9    7.2 0.873 0.214  62.4 
#> 5 California   39557045 1850-09-09  75277     81.5    4.4 0.845 0.314  38.1 
#> 6 Colorado      5695564 1876-08-01  71953     80.3    3.7 0.913 0.384   6.24
```

Zipcodes and counties are also included.

``` r
head(usa::zipcodes)
#> # A tibble: 6 x 5
#>   zip   city       state   lat  long
#>   <chr> <chr>      <chr> <dbl> <dbl>
#> 1 00210 Portsmouth NH     43.0 -71.0
#> 2 00211 Portsmouth NH     43.0 -71.0
#> 3 00212 Portsmouth NH     43.0 -71.0
#> 4 00213 Portsmouth NH     43.0 -71.0
#> 5 00214 Portsmouth NH     43.0 -71.0
#> 6 00215 Portsmouth NH     43.0 -71.0
head(usa::counties)
#> # A tibble: 6 x 3
#>   fips  name    state
#>   <chr> <chr>   <chr>
#> 1 01001 Autauga AL   
#> 2 01003 Baldwin AL   
#> 3 01005 Barbour AL   
#> 4 01007 Bibb    AL   
#> 5 01009 Blount  AL   
#> 6 01011 Bullock AL
```

The `people` tibble contains 20,000 synthetic survey respondents created
by the [Pew Research Center](http://pewrsr.ch/2rNawC7). Statistically
accurate first and last names have been added to feel more authentic.

``` r
head(usa::people)[, 1:8]
#> # A tibble: 6 x 8
#>      id fname   lname    gender   age race     edu          div               
#>   <int> <chr>   <chr>    <fct>  <dbl> <fct>    <fct>        <fct>             
#> 1     1 Marquez Minnick  M         25 White    Some college Mountain          
#> 2     2 Sandra  Medina   F         70 Hispanic HS Grad      West South Central
#> 3     3 John    Samples  M         85 White    Less than HS Middle Atlantic   
#> 4     4 David   Mcneely  M         59 White    HS Grad      Mountain          
#> 5     5 Emily   Tsang    F         19 Asian    Some college Pacific           
#> 6     6 Rodney  Matheson M         67 White    HS Grad      West North Central
```

-----

Please note that the `usa` project is released with a [Contributor Code
of Conduct](https://kiernann.com/usa/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.

<!-- refs: start -->

<!-- refs: end -->
