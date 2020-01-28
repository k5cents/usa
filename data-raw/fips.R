fips_url <- "https://www2.census.gov/programs-surveys/popest/geographies/2017/all-geocodes-v2017.xlsx"
fips_path <- path_temp(basename(fips_url))
download.file(fips_url, fips_path)
fips <- read_excel(fips_path, range = "A5:G43915")
fips <- fips %>%
  rename_all(
    ~ word(., 1, 2) %>%
      str_to_lower() %>%
      str_replace("\\s", "_")
  )

fips.state <- fips %>%
  filter(summary_level == "040") %>%
  select(state_code, area_name)

fips.county <- fips %>%
  filter(summary_level == "050") %>%
  select(state_code, county_code, area_name) %>%
  separate(
    col = area_name,
    into = c("area_name", "area_type"),
    sep = "\\s(?=\\w+$)",
    extra = "merge",
    fill = "right"
  )

fips.city <- fips %>%
  filter(summary_level == "061") %>%
  rename(city_code = county_subdivision) %>%
  select(state_code, county_code, city_code, area_name) %>%
  separate(
    col = area_name,
    into = c("area_name", "area_type"),
    sep = "\\s(?=\\w+$)",
    extra = "merge",
    fill = "right"
  ) %>%
  mutate_at(
    vars(area_type),
    ~str_replace(., "UT", "unorganized")
  )

fips.city %>%
  left_join(fips.state, by = "state_code") %>%
  left_join(fips.county,  by = c("state_code", "county_code")) %>%
  select(-starts_with("area_type")) %>%
  unite(
    ends_with("code"),
    col = code,
    sep = "-"
  )

fips %>%
  group_split(place_code)
