# Prepare Data for Modelling
library(feather)
library(stringi)
library(dplyr)
library(tidyr)

combine.table <- read_feather('data/combines.feather')
draft.table <- read_feather('data/drafts.feather')
college.stats <- read_feather('data/college_stats.feather')

stri_sub(draft.table$url, 5, 4) <- "s"

draft.table <- draft.table %>%
  filter(pos == "QB") %>%
  select(year,round,pick,team,player,pos,age,college,url) %>%
  mutate(key = ifelse(is.na(url), paste(player, year, sep = '-'), url)) 
  

combine.table <- combine.table %>%
  filter(pos == "QB") %>%
  mutate(key = ifelse(is.na(url),
                      paste(player, year, sep = '-'),
                      url))

draft_combine <- left_join(draft.table,combine.table,by="key")

# College Stats
college.stats$key <- college.stats$url
stri_sub(college.stats$key, 5, 4) <- "s"
college.stats$url <- NULL
college.stats$section <- NULL

college.stats <- college.stats %>%
  spread(stat,value)


full_data <- left_join(draft_combine,college.stats,by="key")

