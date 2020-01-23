## code to prepare `people` dataset goes here
library(tidyverse)
library(babynames)
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

# convert types
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
    children = children == "One or more children",
    us_citizen = us_citizen == "Yes, a U.S. citizen",
    us_born = us_born == "Inside the United States",
    mil = mil == "Have been on active duty",
    metro = metro == "Metropolitan",
    house_moved = house_moved != "Same house",
    volunteer = volunteer == "Volunteered",
    vote = vote == "Voted"
  )

sys.year <- as.numeric(format(Sys.Date(), "%Y"))
x <- people %>%
  select(1:4) %>%
  mutate(
    year = sys.year - age,
    gender = str_sub(gender, end = 1)
  )

x <- mutate(
  .data = x,
  name = NA_character_,
  id = as.integer(id)
)

for (id in x$id) {
  x$name[id] <- sample(
    x = subset(babynames$name, babynames$sex == x$gender[id], babynames$year == x$year[id]),
    size = 1,
    prob = subset(babynames$prop, babynames$sex == x$gender[id], babynames$year == x$year[id])
  )
}

surname_file <- file_temp(ext = "xlsx")
download.file(
  url = "https://www2.census.gov/topics/genealogy/2010surnames/Names_2010Census_Top1000.xlsx",
  destfile = surname_file
)
read_excel(
  path = surname_file,
  range = "A3:K1003",
  .name_repair = janitor::make_clean_names
)

usethis::use_data(people, overwrite = TRUE)
