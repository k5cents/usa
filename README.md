
<!-- README.md is generated from README.Rmd. Please edit that file -->

# usa <a href='https://k5cents.github.io/usa/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/usa)](https://CRAN.R-project.org/package=usa)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/usa)
[![Codecov test
coverage](https://codecov.io/gh/k5cents/usa/graph/badge.svg?token=ubolhKW81u)](https://app.codecov.io/gh/k5cents/usa?branch=master)
[![R build
status](https://github.com/k5cents/usa/workflows/R-CMD-check/badge.svg)](https://github.com/k5cents/usa/actions)
<!-- badges: end -->

The goal of ‘usa’ is to provide updated versions of the ‘datasets’
objects included with R. When attached, this package **overwrites**
these original vectors with information on all fifty states, the
District of Columbia, and Puerto Rico. As of now, information on the
other territories are provided in separate objects.

## Installation

You can install the release version of ‘usa’ from
[CRAN](https://cran.r-project.org/package=usa) with:

``` r
install.packages("usa")
```

Or the development version from [GitHub](https://github.com/k5cents/usa)
with:

``` r
# install.packages("remotes")
remotes::install_github("k5cents/usa")
```

## Base Data

R ships with eight outdated objects in the ‘datasets’ package: 7 vectors
and a matrix of statistics from the 1970’s.

``` r
head(base.vectors)
#>         name abb region           division   area  center.x center.y
#> 1    Alabama  AL  South East South Central  51609  -86.7509  32.5901
#> 2     Alaska  AK   West            Pacific 589757 -127.2500  49.2500
#> 3    Arizona  AZ   West           Mountain 113909 -111.6250  34.2192
#> 4   Arkansas  AR  South West South Central  53104  -92.2992  34.7336
#> 5 California  CA   West            Pacific 158693 -119.7730  36.5341
#> 6   Colorado  CO   West           Mountain 104247 -105.5130  38.6777
```

``` r
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

This package contains new, expanded versions of these vectors.

``` r
setdiff(usa::state.abb, datasets::state.abb)
#> [1] "DC" "PR"
unique(usa::state.region)
#> [1] South     West      Northeast Midwest   <NA>     
#> Levels: Northeast Midwest South West
show(usa::territory.abb)
#> [1] "AS" "GU" "MP" "UM" "VI"
```

The package contains [tibbles](https://tibble.tidyverse.org/)
identifying the states and providing updated facts and figures.

``` r
usa::states
#> # A tibble: 52 × 8
#>   name       abb   fips  region division              area   lat   long
#>   <chr>      <chr> <chr> <fct>  <fct>                <dbl> <dbl>  <dbl>
#> 1 Alabama    AL    01    South  East South Central  50647.  32.7  -86.8
#> 2 Alaska     AK    02    West   Pacific            571017.  63.4 -153. 
#> 3 Arizona    AZ    04    West   Mountain           113653.  34.3 -112. 
#> 4 Arkansas   AR    05    South  West South Central  52038.  34.9  -92.4
#> 5 California CA    06    West   Pacific            155854.  37.2 -120. 
#> 6 Colorado   CO    08    West   Mountain           103638.  39.0 -106. 
#> # ℹ 46 more rows
```

``` r
usa::facts
#> # A tibble: 52 × 9
#>   name       population votes admission  income life_exp murder college  heat
#>   <chr>           <dbl> <dbl> <date>      <dbl>    <dbl>  <dbl>   <dbl> <dbl>
#> 1 Alabama       4887871     9 1819-12-14  49861     75.3    7.8   0.234 65.9 
#> 2 Alaska         737438     3 1959-01-03  74346     78.3    6.4   0.271  0.37
#> 3 Arizona       7171646    11 1912-02-14  59246     79.7    5.1   0.271 73.6 
#> 4 Arkansas      3013825     6 1836-06-15  47062     75.9    7.2   0.214 62.4 
#> 5 California   39557045    55 1850-09-09  75277     81.5    4.4   0.314 38.9 
#> 6 Colorado      5695564     9 1876-08-01  71953     80.3    3.7   0.384 15.5 
#> # ℹ 46 more rows
```

``` r
usa::territory
#> # A tibble: 7 × 6
#>   name                        abb   fips    area   lat   long
#>   <chr>                       <chr> <chr>  <dbl> <dbl>  <dbl>
#> 1 American Samoa              AS    60      76.4 -14.0 -170. 
#> 2 District of Columbia        DC    11      61.1  38.9  -77.0
#> 3 Guam                        GU    66     210.   13.4  145. 
#> 4 Northern Mariana Islands    MP    69     182.   16.8  146. 
#> 5 Puerto Rico                 PR    72    3424.   18.2  -66.4
#> 6 U.S. Minor Outlying Islands UM    74      NA    NA     NA  
#> 7 U.S. Virgin Islands         VI    78     134.   18.1  -64.8
```

ZIP codes from the archived
[‘zipcode’](https://cran.r-project.org/package=zipcode) package are also
included

``` r
usa::zipcodes
#> # A tibble: 44,336 × 5
#>   zip   city       state   lat  long
#>   <chr> <chr>      <chr> <dbl> <dbl>
#> 1 00210 Portsmouth NH     43.0 -71.0
#> 2 00211 Portsmouth NH     43.0 -71.0
#> 3 00212 Portsmouth NH     43.0 -71.0
#> 4 00213 Portsmouth NH     43.0 -71.0
#> 5 00214 Portsmouth NH     43.0 -71.0
#> 6 00215 Portsmouth NH     43.0 -71.0
#> # ℹ 44,330 more rows
```

These synthetic survey respondents from
[Pew](https://www.pewresearch.org/methods/2018/01/26/for-weighting-online-opt-in-samples-what-matters-most/)
provide a statistically accurate sample of the American people.

``` r
dplyr::select(usa::people, 1:8)
#> # A tibble: 20,000 × 8
#>      id fname   lname    gender   age race     edu          div               
#>   <int> <chr>   <chr>    <fct>  <dbl> <fct>    <fct>        <fct>             
#> 1     1 Marquez Minnick  M         25 White    Some college Mountain          
#> 2     2 Sandra  Medina   F         70 Hispanic HS Grad      West South Central
#> 3     3 John    Samples  M         85 White    Less than HS Middle Atlantic   
#> 4     4 David   Mcneely  M         59 White    HS Grad      Mountain          
#> 5     5 Emily   Tsang    F         19 Asian    Some college Pacific           
#> 6     6 Rodney  Matheson M         67 White    HS Grad      West North Central
#> # ℹ 19,994 more rows
```

------------------------------------------------------------------------

Please note that the ‘usa’ project is released with a [Contributor Code
of Conduct](https://k5cents.github.io/usa/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.

<!-- refs: start -->
<!-- refs: end -->
