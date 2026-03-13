# usa 1.0.0 — Release TODO

## Priority Order

### 1. Rename `facts` → `state_facts` (and consider `territory` → `territories`)

`facts` is too ambiguous without the `usa::` prefix — it reads as a descriptor, not a noun.
`state_facts` makes the object self-describing in any context.

- Rename the dataset, the `data-raw/facts.R` script, the CSV, and all documentation
- `states`, `counties`, `zipcodes`, `people` all read naturally as nouns and don't need changes
- `territory` is singular and inconsistent with the others — consider renaming to `territories`
  and aligning `territory.*` vectors to `territories.*` if renaming
- These are breaking changes; note them prominently in NEWS.md

### 2. Remove `state.x19`

`state.x19` is a matrix version of `facts`/`state_facts` intended to mirror `datasets::state.x77`.
The docs and generating code don't match (Rd describes `high`/`bach` columns that no longer exist).
The tibble `state_facts` is a better replacement for `state.x77`. Remove the matrix entirely.

- Delete from `data-raw/facts.R` (last ~6 lines)
- Delete `data/state.x19.rda`
- Delete `man/state.x19.Rd`
- Remove from NAMESPACE

### 3. `state_facts` data — Full refresh (highest priority for data work)

All columns need updating to 2020 Census era or newer:

| Column | Current vintage | Target | Source |
|---|---|---|---|
| `population` | 2019 estimate | 2020 Decennial Census | Census P1 table |
| `votes` | 2010 apportionment | 2020 apportionment (effective 2024) | National Archives |
| `admission` | static | no change | — |
| `income` | 2018 ACS | 2022 or 2023 ACS 1-year | Census S1903 |
| `life_exp` | 2017-18 NCHS | 2020-22 NCHS | CDC WONDER (note COVID dip) |
| `murder` | 2018 UCR | 2022 NIBRS | FBI (note UCR→NIBRS transition) |
| `college` | 2019 ACS | 2022 or 2023 ACS | Census S1501 |
| `heat` | 1981-2010 normals | 1991-2020 normals | NOAA Climate Normals |

Rewrite `data-raw/facts.R` with reproducible scripts pulling from Census/CDC/FBI APIs.
Fix broken/placeholder `\source{}` entries in Rd (several are `(Moved ...)` / `(Noved ...)` stubs).

### 4. `counties` — Rebuild from authoritative source

- Replace archived FCC/NRCS source with Census Bureau official FIPS county list:
  https://www.census.gov/library/reference/code-lists/ansi.html
- Handle Connecticut's 2022 transition: 8 historic counties → 9 planning regions (FIPS changed)
- Consider adding a `population` column from 2020 Census (makes the table significantly more useful)

### 5. `territory` / `territories` — Resolve DC overlap

DC currently appears in both `states` (52 rows = 50 states + DC + PR) and `territory` (7 rows).
The tibble and the vectors describe *different* sets: DC and PR are in the tibble but not in
`territory.abb` etc. (which are 5 entries: AS, GU, MP, UM, VI). This is silently inconsistent.

- Remove DC from `territory`; document it as the 5 non-state, non-DC/PR territories: AS, GU, MP, UM, VI
- Update territory populations from 2020 Census

### 6. `zipcodes` — Replace with 2020 ZCTA data

Current data is CivicSpace 2004 + 2012 augment — very stale.
- Replace with Census 2020 ZCTA (ZIP Code Tabulation Area) centroids
- Accessible via `tidycensus` or Census TIGER/Line shapefiles
- Document clearly that these are ZCTAs, not exact USPS ZIP centroids
- Column rename: `lat`/`long` → `latitude`/`longitude` (Rd docs already say latitude/longitude
  but the actual data uses lat/long — currently mismatched)

### 7. `state_convert()` — Fix default argument + typo

The `to` argument has an implicit `NULL` default and a typo in the choice vector (`"names"` should
be `"name"`, singular, matching the column name in `states`). The typo also appears in the tests.

```r
# Current (implicit default, typo in choices):
state_convert <- function(x, to = NULL) {
  to <- match.arg(to, c("abb", "names", "fips"), several.ok = FALSE)

# Fix:
state_convert <- function(x, to = c("abb", "name", "fips")) {
  to <- match.arg(to)
```

Also update `tests/testthat/test-convert.R` which calls `state_convert(x, "names")`.

### 8. Documentation bugs — Fix before CRAN submission

Errors found in existing Rd files (all must be corrected):

| File | Bug |
|---|---|
| `zipcodes.Rd` | Format says "52 rows and 9 variables" — copy-pasted from `states`; should be ~44,336 rows, 5 variables |
| `territory.abb.Rd` | "A character vector of length 52" — should be 5 |
| `county.name.Rd` | "A character vector of length 19108" — should be ~1,924 unique county names |
| `city.name.Rd` | "A character vector of length 19108" — verify actual length and correct |
| `state.x19.Rd` | Describes "A tibble" — it is a matrix (moot if object is removed) |
| `people.Rd` | `boycott` item has an **empty description** — `\item{boycott}{}` |
| `territory.Rd` | Says "6 non-state territories and federal district" but has 7 rows |
| `state_convert.Rd` | `to` argument docs say `"name"` but code uses `"names"` — fix both together |

### 9. `people` — Minor doc cleanup only

Synthetic Pew 2018 population is hard to regenerate; keep as-is.
- Update `vote` column description — currently says "voted in the 2014 midterm elections"; make year-neutral
- Fill in the empty `\item{boycott}{}` description (see above)

### 10. Remove `data-raw/documents.R` (dead code)

This script scrapes the US Constitution into a tibble but never saves it — no `use_data()`,
no Rd file, not in NAMESPACE. Either finish it as a `documents` dataset or delete it.
Decision: delete unless there's a plan to finish it for 1.0.0.

### 11. Fix `data-raw/states.R` — `state-abb.csv` write bug

Line 113 writes the wrong object to disk:
```r
write_lines(state.area, "data-raw/state-abb.csv")  # BUG: should be state.abb
```
The file currently contains numeric area values. Low priority since this file is only used
for human reference, not read back by any script.

### 12. Package metadata

- Bump version to `1.0.0` in `DESCRIPTION`
- Update `R (>= 3.2)` minimum — consider 4.1+
- Change lifecycle badge from `maturing` → `stable` in README.Rmd
- The badge URL says `lifecycle-maturing` but links to `stages.html#experimental` — fix the link
- Audit all remaining `\source{}` entries in Rd files for dead/archived URLs
- Write a `NEWS.md` documenting the breaking changes (renames, removals)
- Fill out `_pkgdown.yml` with a curated reference index (currently empty/default)
