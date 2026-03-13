## code to prepare state_capitals dataset
library(tidyverse)

# State capital cities with coordinates and 2020 Census population.
# Coordinates are for the capitol building / city center (decimal degrees).
# Population is city proper from the 2020 Decennial Census.

state_capitals <- tribble(
  ~abb, ~capital,          ~lat,      ~long,     ~population,
  "AL", "Montgomery",      32.3615,   -86.2791,   200603L,
  "AK", "Juneau",          58.3019,  -134.4197,    32061L,
  "AZ", "Phoenix",         33.4485,  -112.0738,  1608139L,
  "AR", "Little Rock",     34.7360,   -92.3311,   202591L,
  "CA", "Sacramento",      38.5556,  -121.4689,   524943L,
  "CO", "Denver",          39.7392,  -104.9847,   715522L,
  "CT", "Hartford",        41.7670,   -72.6770,   121054L,
  "DE", "Dover",           39.1619,   -75.5268,    39403L,
  "FL", "Tallahassee",     30.4380,   -84.2809,   196169L,
  "GA", "Atlanta",         33.7600,   -84.3900,   498715L,
  "HI", "Honolulu",        21.3090,  -157.8262,   350964L,
  "ID", "Boise",           43.6137,  -116.2377,   235685L,
  "IL", "Springfield",     39.7833,   -89.6504,   114394L,
  "IN", "Indianapolis",    39.7609,   -86.1476,   887642L,
  "IA", "Des Moines",      41.5909,   -93.6209,   214133L,
  "KS", "Topeka",          39.0400,   -95.6900,   126587L,
  "KY", "Frankfort",       38.1973,   -84.8631,    28602L,
  "LA", "Baton Rouge",     30.4581,   -91.1402,   227470L,
  "ME", "Augusta",         44.3235,   -69.7653,    18899L,
  "MD", "Annapolis",       38.9729,   -76.5012,    40812L,
  "MA", "Boston",          42.3601,   -71.0589,   675647L,
  "MI", "Lansing",         42.7335,   -84.5467,   112644L,
  "MN", "Saint Paul",      44.9500,   -93.0940,   311527L,
  "MS", "Jackson",         32.3200,   -90.2070,   153701L,
  "MO", "Jefferson City",  38.5767,   -92.1735,    43228L,
  "MT", "Helena",          46.5958,  -112.0270,    32091L,
  "NE", "Lincoln",         40.8099,   -96.6753,   291082L,
  "NV", "Carson City",     39.1609,  -119.7539,    58639L,
  "NH", "Concord",         43.2201,   -71.5491,    43976L,
  "NJ", "Trenton",         40.2217,   -74.7561,    90871L,
  "NM", "Santa Fe",        35.6672,  -105.9646,    87505L,
  "NY", "Albany",          42.6598,   -73.7813,    99224L,
  "NC", "Raleigh",         35.7710,   -78.6380,   467665L,
  "ND", "Bismarck",        48.1333,  -100.7790,    73622L,
  "OH", "Columbus",        39.9622,   -83.0006,   905748L,
  "OK", "Oklahoma City",   35.4823,   -97.5350,   681054L,
  "OR", "Salem",           44.9311,  -123.0292,   175535L,
  "PA", "Harrisburg",      40.2698,   -76.8756,    50099L,
  "RI", "Providence",      41.8236,   -71.4221,   190934L,
  "SC", "Columbia",        34.0000,   -81.0350,   136632L,
  "SD", "Pierre",          44.3680,  -100.3364,    14091L,
  "TN", "Nashville",       36.1650,   -86.7840,   689447L,
  "TX", "Austin",          30.2667,   -97.7500,   961855L,
  "UT", "Salt Lake City",  40.7547,  -111.8926,   199723L,
  "VT", "Montpelier",      44.2664,   -72.5719,     8074L,
  "VA", "Richmond",        37.5400,   -77.4600,   226610L,
  "WA", "Olympia",         47.0424,  -122.8931,    55605L,
  "WV", "Charleston",      38.3495,   -81.6333,    48864L,
  "WI", "Madison",         43.0747,   -89.3844,   269840L,
  "WY", "Cheyenne",        41.1455,  -104.8020,    65132L,
  "DC", "Washington",      38.8951,   -77.0364,   705749L,
  "PR", "San Juan",        18.4663,   -66.1057,   342259L
)

usethis::use_data(state_capitals, overwrite = TRUE)
write_csv(state_capitals, "data-raw/state_capitals.csv")
