## code to prepare `people` dataset goes here
library(tidyverse)
library(lubridate)
library(babynames)
library(magrittr)
library(janitor)
library(readxl)
library(haven)
library(fs)

# get file ----------------------------------------------------------------

# Appendix B: Synthetic population dataset
# By Andrew Mercer, Arnold Lau and Courtney Kennedy

zip_file <- file_temp(ext = "zip")
download.file(
  url = "https://assets.pewresearch.org/datasets/methods/online_opt_in_2016.zip",
  destfile = zip_file
)

zip_list <- unzip(zip_file, list = TRUE)
sav_file <- zip_list$Name[3]

unzip(
  zipfile = zip_file,
  exdir = path_temp(),
  file = sav_file
)

# read file ---------------------------------------------------------------

sav_file <- dir_ls(path_temp(), recurse = TRUE, regexp = sav_file)
people <- read_sav(sav_file)

# convert from labels to factors
people <- as_factor(people)

# rename and remove
people <- people %>%
  select(
    id,
    gender = GENDER,
    age = AGE,
    race = RACETHN,
    edu = EDUCCAT5,
    div = DIVISION,
    married = MARITAL_ACS,
    house_size = HHSIZECAT,
    children = CHILDRENCAT,
    us_citizen = CITIZEN_REC,
    us_born = BORN_ACS,
    house_income = FAMINC5,
    emp_status = EMPLOYED,
    emp_sector = worker_class,
    hours_work = usual_hrs_per_week,
    hours_vary = hours_vary,
    mil = MIL_ACS_REC,
    house_own = HOME_ACS_REC,
    metro = metropolitan,
    internet = internet_access,
    foodstamp = FDSTMP_CPS,
    house_moved = TENURE_ACS,
    pub_contact = PUB_OFF_CPS,
    boycott = boycott,
    hood_group = COMGRP_CPS,
    hood_talks = TALK_CPS,
    hood_trust = TRUST_CPS,
    tablet = TABLET_CPS,
    texting = TEXTIM_CPS,
    social = SOCIAL_CPS,
    volunteer = VOLSUM,
    register = REGISTERED,
    vote = VOTE14,
    party = PARTYSCALE5,
    religion = RELIGCAT,
    ideology = IDEO3,
    govt = FOLGOV,
    guns = OWNGUN_GSS
  ) %>%
  clean_names("snake")

# recode vars --------------------------------------------------------------------------------

yesno <- function(x) {
  if (all(levels(x) %in% c("Yes", "No"))) {
    x == "Yes"
  } else {
    return(x)
  }
}

people <- people %>%
  # most cols are really logical
  mutate_if(is.factor, yesno) %>%
  mutate(
    id = as.integer(labels(id)),
    gender = as_factor(str_sub(gender, end = 1)),
    race = as_factor(str_remove(race, "\\snon-Hispanic")),
    children = children == "One or more children",
    us_citizen = us_citizen == "Yes, a U.S. citizen",
    us_born = us_born == "Inside the United States",
    mil = mil == "Have been on active duty",
    metro = metro == "Metropolitan",
    house_moved = house_moved != "Same house",
    volunteer = volunteer == "Volunteered",
    vote = vote == "Voted",
  )

# add last names -----------------------------------------------------------------------------

# last names are sampled using proportion of that name with a given race/ethnicity

# download and extract the zip
download.file(
  url = surname_url <- "https://www2.census.gov/topics/genealogy/2010surnames/names.zip",
  destfile = surname_zip <- file_temp(ext = "zip")
)
surname_file <- unzip(
  zipfile = surname_zip,
  files = "Names_2010Census.csv",
  exdir = path_temp()
)

surnames <- read_csv(
  file = surname_file,
  na = c("", "(S)"),
  col_types = cols(
    .default = col_double(),
    name = col_character()
  )
)

surnames <- surnames %>%
  filter(prop100k > 2, rank >= 1) %>%
  arrange(rank) %>%
  select(name, prop100k, starts_with("pct")) %>%
  mutate_at(vars(name), str_to_title) %>%
  mutate_at(vars(prop100k), ~divide_by(., 100000)) %>%
  mutate_at(vars(starts_with("pct")), ~divide_by(., 100)) %>%
  mutate_if(is.numeric, ~replace(., is.na(.), mean(., na.rm = TRUE)))

race_names <- people %>%
  mutate(
    year = year(now()) - age,
    lname = NA_character_
  ) %>%
  group_split(race) %>%
  set_names(make_clean_names(sort(unique(people$race))))

race_names$asian$lname <- sample(
  x = surnames$name,
  prob = surnames$pctapi,
  size = length(race_names$asian$lname),
  replace = TRUE
)

race_names$black$lname <- sample(
  x = surnames$name,
  prob = surnames$pctblack,
  size = length(race_names$black$lname),
  replace = TRUE
)

race_names$hispanic$lname <- sample(
  x = surnames$name,
  prob = surnames$pcthispanic,
  size = length(race_names$hispanic$lname),
  replace = TRUE
)

race_names$white$lname <- sample(
  x = surnames$name,
  prob = surnames$pctwhite,
  size = length(race_names$white$lname),
  replace = TRUE
)

race_names$other_race$lname <- sample(
  x = surnames$name,
  prob = surnames$pctaian,
  size = length(race_names$other_race$lname),
  replace = TRUE
)

people <- race_names %>%
  bind_rows() %>%
  arrange(id)

# add first names ----------------------------------------------------------------------------

# first names are taken from the `babynames` package
# includes all SSA baby names with at least five occurances
# assigned to people based on year and sex not race/ethnicity

age_names <- people %>%
  mutate(fname = NA_character_) %>%
  # split by gender and birthyear
  group_split(gender, year)

# for every gender/year combo
for (i in seq_along(age_names)) {
  s.year <- unique(age_names[[i]]$year)
  s.gender <- as.character(unique(age_names[[i]]$gender))
  # randomly assign first names
  age_names[[i]]$fname <- sample(
    # from the set of names for that sex and year
    x = babynames$name[babynames$sex == s.gender & babynames$year == s.year],
    # weighted by proportion of names
    prob = babynames$prop[babynames$sex == s.gender & babynames$year == s.year],
    size = length(age_names[[i]]$fname),
    # with replacement
    replace = TRUE
  )
}

# bind back together
people <-
  # put names at front
  bind_rows(age_names) %>%
  select(id, fname, lname, everything(), -year) %>%
  arrange(id)

# save ---------------------------------------------------------------------------------------

usethis::use_data(people, overwrite = TRUE, compress = "bzip2")
write_csv(people, "data-raw/people.csv")
zip("data-raw/people.zip", "data-raw/people.csv")
file_delete("data-raw/people.csv")
