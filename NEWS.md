# usa 1.0.0

## Breaking changes

* `states` split into two tibbles: `state_ids` (naming and coding systems) and
  `state_geo` (geographic and classificatory properties).

* `facts` renamed to `state_facts`; `state.x19` removed.

* Puerto Rico removed from all `state_*` objects. It is now included in
  `territory` and the `territory_*` vectors alongside AS, GU, MP, UM, and VI.
  All `state_*` objects now cover exactly 51 rows (50 states + DC).

* `state.abb`, `state.area`, `state.center`, `state.division`, `state.name`,
  and `state.region` dot-named vectors replaced with `state_abbs`,
  `state_areas`, `state_centers`, `state_divisions`, `state_names`, and
  `state_regions`.

* `zip.code`, `zip.center`, `city.name`, and `county.name` renamed to
  `zip_codes`, `zip_centers`, `city_names`, and `county_names`.

## New data

* `state_capitals`: capital city name, coordinates (TIGER 2020 internal
  points), and population (2020 Decennial Census) for the 50 states and DC.

* `state_geo` gains `peak_elev` (state high point in feet, USGS) and adds DC.

## Updated data

* `state_facts` population updated to 2020 Decennial Census (was 2010 ACS).

* `state_facts` income updated to 2022 ACS 1-year per capita income
  (was 2019 median household income).

* `state_facts` Electoral College votes updated to 2020 Census reapportionment
  (applies 2022–2032).

* `state_facts` murder rate updated to 2022 FBI NIBRS homicide rate per
  100,000 via the Crime Data Explorer API (was 2018 UCR).

* `state_facts` education updated to 2022 ACS 1-year; `college` now stored as
  a proportion (0–1) rather than a percentage.

* `state_facts` `heat` (1981–2010 cooling degree days, dead FTP source)
  replaced by `frost`: mean days per year with minimum temperature below
  freezing, from the NCEI 1991–2020 Climate Normals.

* `state_facts` life expectancy updated to 2021 NCHS state life tables via
  CDC (was 2017–18 data from a Wikipedia scrape).

* `counties` source updated from archived FCC file to Census TIGER 2020
  national county reference file. Row count 3,232 → 3,235.

* `state_ids` gains `icp` (IPUMS STATEICP codes) and `ap` (AP style
  abbreviations) columns.

## Other changes

* `sp` and `rgdal` dependencies removed; spatial operations use `sf` and
  `tigris` throughout.

* `state_capitals` coordinates and population now sourced from the Census API
  rather than hardcoded.

# usa 0.1.3

* Fix logo URL in README

# usa 0.1.2

* Update maintainer email, website URL, and GitHub URL.

# usa 0.1.1

* Add `state_convert()` helper function.
* Add Electoral College votes to `facts`.
* Remove the invalid negative degree days in the mean.
* Rename the `bach` column to `college` and remove the `high` column.

# usa 0.1.0

* Rename `info` data to `facts`.
* Separate territories from `states` to `territory`, etc (for now).

# usa 0.0.9

* Finish the `info` data set:
    * Find degree days for Washington, DC.
    * Use state names instead of abbreviations.
    * Remove outdated literacy rates.
    * Add admission date (age in matrix).
    * Use https://data.census.gov sources.
    * Save `.zip` and `.xlsx` data sources.

# usa 0.0.8

* Add the data from the archived `zipcode` package.
* Export the columns from the `zipcodes` data frame as `zip.*` vectors.

# usa 0.0.7

* Add the synthetic `people` data set from PEW Research.

# usa 0.0.6

* Replace geocodes data with census sources.
* Combine state info into single table.
* Delete unfinished data.

# usa 0.0.4

* Save `state_centers` tibble from Wikipedia.
* Overwrite `state.center` list with territories.
* Update `README.md` with newest object differences.

# usa 0.0.3

* Improve draft objects and tibbles.
* Add overall `states` tibble.

# usa 0.0.2

* Overwrite the base `state.*` objects.
* Add draft versions of most relational tibbles:
  
# usa 0.0.1

* Rename package to usa
* Create `fips`, `regions`, `divisions`, and `populations` tibbles.

# state2 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
