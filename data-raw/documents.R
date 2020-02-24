library(tidyverse)
library(tidytext)
library(rvest)

a <- read_html("https://www.archives.gov/founding-docs/constitution-transcript")

text <- a %>%
  html_nodes("#main-col") %>%
  html_nodes("p") %>%
  html_text()

text <- text[3:86] %>%
  str_replace_all("\"" ,"\'") %>%
  str_trim() %>%
  str_squish()

a1 <- 1 # start art 1
a2 <- str_which(text, "The executive Power shall be vested")  # start art 2
a3 <- str_which(text, "The judicial Power of the United")  # start art 3
a4 <- str_which(text, "Full Faith and Credit")  # start art 4
a5 <- str_which(text, "The Congress, whenever two thirds")  # start art 5
a6 <- str_which(text, "All Debts contracted")  # start art 6

article_nums <- c(
  rep(1, a2 - a1),
  rep(2, a3 - a2),
  rep(3, a4 - a3),
  rep(4, a5 - a4),
  rep(5, a6 - a5),
  rep(6, length(text) - a6 + 1)
)

text <- text %>%
  enframe(name = "graph", value = "text") %>%
  mutate(article = article_nums, .before = "graph")
