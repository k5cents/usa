
<!-- README.md is generated from README.Rmd. Please edit that file -->

# usa <a href='https://k5cents.github.io/usa/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/usa)](https://CRAN.R-project.org/package=usa)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/usa)
[![Codecov test
coverage](https://codecov.io/gh/k5cents/usa/graph/badge.svg?token=ubolhKW81u)](https://app.codecov.io/gh/k5cents/usa?branch=master)
[![R build
status](https://github.com/k5cents/usa/workflows/R-CMD-check/badge.svg)](https://github.com/k5cents/usa/actions)
<!-- badges: end -->

The goal of ‘usa’ is to provide updated versions of the ‘datasets’
objects included with R. This package provides updated vectors covering
all fifty states and the District of Columbia, alongside tidy tibbles
with richer data. Puerto Rico and the other US territories are provided
in separate objects.

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

This package provides updated vectors covering all 51 entries (50
states + DC).

``` r
# DC is the only entry not in datasets::state.abb
setdiff(usa::state_abbs, datasets::state.abb)
#> [1] "DC"
unique(usa::state_regions)
#> [1] South     West      Northeast Midwest  
#> Levels: Northeast Midwest South West
usa::territory_abbs
#> [1] "AS" "GU" "MP" "PR" "UM" "VI"
```

The package contains [tibbles](https://tibble.tidyverse.org/)
identifying the states and providing updated facts and figures.

``` r
usa::state_ids
#> # A tibble: 51 × 6
#>   name       abb   fips  icp   ap     iso  
#>   <chr>      <chr> <chr> <chr> <chr>  <chr>
#> 1 Alabama    AL    01    41    Ala.   US-AL
#> 2 Alaska     AK    02    81    Alaska US-AK
#> 3 Arizona    AZ    04    61    Ariz.  US-AZ
#> 4 Arkansas   AR    05    42    Ark.   US-AR
#> 5 California CA    06    71    Calif. US-CA
#> 6 Colorado   CO    08    62    Colo.  US-CO
#> # ℹ 45 more rows
```

``` r
usa::state_geo
#> # A tibble: 51 × 10
#>   abb   region division  area_land area_water   lat   long contiguous landlocked
#>   <chr> <fct>  <fct>         <dbl>      <dbl> <dbl>  <dbl> <lgl>      <lgl>     
#> 1 AL    South  East Sou…    50652.      1768.  32.7  -86.8 TRUE       FALSE     
#> 2 AK    West   Pacific     571391.     94334.  63.4 -153.  FALSE      FALSE     
#> 3 AZ    West   Mountain    113655.       330.  34.3 -112.  TRUE       TRUE      
#> 4 AR    South  West Sou…    51992.      1206.  34.9  -92.4 TRUE       TRUE      
#> 5 CA    West   Pacific     155860.      7833.  37.2 -120.  TRUE       FALSE     
#> 6 CO    West   Mountain    103637.       458.  39.0 -106.  TRUE       TRUE      
#> # ℹ 45 more rows
#> # ℹ 1 more variable: peak_elev <int>
```

``` r
usa::state_capitals
#> # A tibble: 51 × 5
#>   abb   capital       lat   long population
#>   <chr> <chr>       <dbl>  <dbl>      <int>
#> 1 AL    Montgomery   32.3  -86.3     200603
#> 2 AK    Juneau       58.4 -134.       32255
#> 3 AZ    Phoenix      33.6 -112.     1608139
#> 4 AR    Little Rock  34.7  -92.4     202591
#> 5 CA    Sacramento   38.6 -121.      524943
#> 6 CO    Denver       39.8 -105.      715522
#> # ℹ 45 more rows
```

``` r
usa::state_facts
#> # A tibble: 51 × 9
#>   name       population electors admission  income life_exp murder college frost
#>   <chr>           <dbl>    <dbl> <date>      <dbl>    <dbl>  <dbl>   <dbl> <dbl>
#> 1 Alabama       5024279        9 1819-12-14  33777     72    10.8    0.288  53.1
#> 2 Alaska         733391        3 1959-01-03  43054     74.5   9.74   0.306 198. 
#> 3 Arizona       7151502       11 1912-02-14  39819     75     7.18   0.33   75.4
#> 4 Arkansas      3011524        6 1836-06-15  31380     72.5  10.4    0.254  68.3
#> 5 California   39538223       54 1850-09-09  46661     78.3   5.81   0.37   44.6
#> 6 Colorado      5773714       10 1876-08-01  49071     77.7   6.77   0.459 189. 
#> # ℹ 45 more rows
```

``` r
usa::territory
#> # A tibble: 6 × 7
#>   name                        abb   fips  area_land area_water   lat   long
#>   <chr>                       <chr> <chr>     <dbl>      <dbl> <dbl>  <dbl>
#> 1 American Samoa              AS    60         76.4       505. -14.0 -170. 
#> 2 Guam                        GU    66        210.        361.  13.4  145. 
#> 3 Northern Mariana Islands    MP    69        182.       1793.  16.8  146. 
#> 4 Puerto Rico                 PR    72       3424.       1901.  18.2  -66.4
#> 5 U.S. Minor Outlying Islands UM    74         NA          NA   NA     NA  
#> 6 U.S. Virgin Islands         VI    78        134.        599.  18.1  -64.8
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
