
<!-- README.md is generated from README.Rmd. Please edit that file -->

# usa <a href='https:/kiernann.com/usa'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/usa)](https://CRAN.R-project.org/package=usa)
[![Travis build
status](https://travis-ci.org/kiernann/usa.svg?branch=master)](https://travis-ci.org/kiernann/usa)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/usa/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/usa?branch=master)
<!-- badges: end -->

The goal of ‘usa’ is to provide updated versions of the ‘state’ data
sets included with R. When attached, this package **overwrites** these
original vectors. The new vectors contain information on all fifty
states, the District of Columbia, and Puerto Rico. As of this version,
information on the other territories are provided in separate objects.

## Installation

You can install the development version of ‘usa’ from
[GitHub](https://github.com/kiernann/usa) with:

``` r
# install.packages("remotes")
remotes::install_github("kiernann/usa")
```

## Base Data

R ships with eight outdated objects in the ‘datasets’ package, 7 vectors
and a matrix of statistics.

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

This package contains new versions of these objects.

``` r
setdiff(usa::state.abb, datasets::state.abb)
#> [1] "DC" "PR"
unique(usa::state.region)
#> [1] South     West      Northeast Midwest   <NA>     
#> Levels: Northeast Midwest South West
show(usa::territory.abb)
#> [1] "AS" "GU" "MP" "UM" "VI"
```

The package also contains two [tibbles](https://tibble.tidyverse.org/)
identifying the states and and providing various updated facts and
figures.

``` r
usa::states
#> # A tibble: 52 x 8
#>    name              abb   fips  region    division            area   lat   long
#>    <chr>             <chr> <chr> <fct>     <fct>              <dbl> <dbl>  <dbl>
#>  1 Alabama           AL    01    South     East South Cent…  5.06e4  32.7  -86.8
#>  2 Alaska            AK    02    West      Pacific           5.71e5  63.4 -153. 
#>  3 Arizona           AZ    04    West      Mountain          1.14e5  34.3 -112. 
#>  4 Arkansas          AR    05    South     West South Cent…  5.20e4  34.9  -92.4
#>  5 California        CA    06    West      Pacific           1.56e5  37.2 -120. 
#>  6 Colorado          CO    08    West      Mountain          1.04e5  39.0 -106. 
#>  7 Connecticut       CT    09    Northeast New England       4.84e3  41.6  -72.7
#>  8 Delaware          DE    10    South     South Atlantic    1.95e3  39.0  -75.5
#>  9 District of Colu… DC    11    South     South Atlantic    6.11e1  38.9  -77.0
#> 10 Florida           FL    12    South     South Atlantic    5.36e4  28.5  -82.4
#> # … with 42 more rows
usa::facts
#> # A tibble: 52 x 9
#>    name          population admission  income life_exp murder  high  bach   heat
#>    <chr>              <dbl> <date>      <dbl>    <dbl>  <dbl> <dbl> <dbl>  <dbl>
#>  1 Alabama          4887871 1819-12-14  49861     75.3    7.8 0.866 0.234  65.9 
#>  2 Alaska            737438 1959-01-03  74346     78.3    6.4 0.927 0.271 -26.6 
#>  3 Arizona          7171646 1912-02-14  59246     79.7    5.1 0.871 0.271  73.6 
#>  4 Arkansas         3013825 1836-06-15  47062     75.9    7.2 0.873 0.214  62.4 
#>  5 California      39557045 1850-09-09  75277     81.5    4.4 0.845 0.314  38.1 
#>  6 Colorado         5695564 1876-08-01  71953     80.3    3.7 0.913 0.384   6.24
#>  7 Connecticut      3572665 1788-01-09  76348     81      2.3 0.908 0.368  20.4 
#>  8 Delaware          967171 1787-12-07  64805     78.6    5   0.895 0.288  40.5 
#>  9 District of …     702455 1790-07-16  85203     78.5   22.8 0.920 0.557  50.7 
#> 10 Florida         21299325 1845-03-03  55462     80      5.2 0.881 0.282 115.  
#> # … with 42 more rows
```

An additional tibble and vectors for just the territories.

``` r
usa::territory
#> # A tibble: 7 x 6
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

ZIP codes and counties are also included. ZIP codes are from the
archived [zipcodes](https://cran.r-project.org/package=zipcodes)
package.

``` r
usa::zipcodes
#> # A tibble: 44,336 x 5
#>    zip   city       state   lat  long
#>    <chr> <chr>      <chr> <dbl> <dbl>
#>  1 00210 Portsmouth NH     43.0 -71.0
#>  2 00211 Portsmouth NH     43.0 -71.0
#>  3 00212 Portsmouth NH     43.0 -71.0
#>  4 00213 Portsmouth NH     43.0 -71.0
#>  5 00214 Portsmouth NH     43.0 -71.0
#>  6 00215 Portsmouth NH     43.0 -71.0
#>  7 00501 Holtsville NY     40.9 -72.6
#>  8 00544 Holtsville NY     40.9 -72.6
#>  9 00601 Adjuntas   PR     18.2 -66.7
#> 10 00602 Aguada     PR     18.4 -67.2
#> # … with 44,326 more rows
usa::counties
#> # A tibble: 3,232 x 3
#>    fips  name     state
#>    <chr> <chr>    <chr>
#>  1 01001 Autauga  AL   
#>  2 01003 Baldwin  AL   
#>  3 01005 Barbour  AL   
#>  4 01007 Bibb     AL   
#>  5 01009 Blount   AL   
#>  6 01011 Bullock  AL   
#>  7 01013 Butler   AL   
#>  8 01015 Calhoun  AL   
#>  9 01017 Chambers AL   
#> 10 01019 Cherokee AL   
#> # … with 3,222 more rows
```

The `people` tibble contains 20,000 synthetic survey respondents created
by the [Pew Research Center](http://pewrsr.ch/2rNawC7). Statistically
accurate first and last names have been added to improve authenticity.

``` r
dplyr::select(usa::people, 1:8)
#> # A tibble: 20,000 x 8
#>       id fname   lname    gender   age race     edu          div               
#>    <int> <chr>   <chr>    <fct>  <dbl> <fct>    <fct>        <fct>             
#>  1     1 Marquez Minnick  M         25 White    Some college Mountain          
#>  2     2 Sandra  Medina   F         70 Hispanic HS Grad      West South Central
#>  3     3 John    Samples  M         85 White    Less than HS Middle Atlantic   
#>  4     4 David   Mcneely  M         59 White    HS Grad      Mountain          
#>  5     5 Emily   Tsang    F         19 Asian    Some college Pacific           
#>  6     6 Rodney  Matheson M         67 White    HS Grad      West North Central
#>  7     7 Joseph  Ammons   M         70 White    HS Grad      West North Central
#>  8     8 Ryan    Allen    M         26 Black    Less than HS Pacific           
#>  9     9 Lane    Burchett M         50 White    Some college East North Central
#> 10    10 William Slater   M         73 White    Some college South Atlantic    
#> # … with 19,990 more rows
```

-----

Please note that the ‘usa’ project is released with a [Contributor Code
of Conduct](https://kiernann.com/usa/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.

<!-- refs: start -->

<!-- refs: end -->
