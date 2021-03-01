# Loading Libraries -------------------------------------------------------

library(rvest)
library(tidyverse)


# html tidying ----------------------------------------------------------


url <- "https://www.espn.com/soccer/standings/_/league/eng.1"

htmlRef <- read_html(url) %>%
  html_nodes("body")

teamID <- htmlRef %>%
  html_nodes(".hide-mobile .AnchorLink") %>%
  html_attr("href") %>%
  str_extract("\\d+")


PremierLeagueTeamID <-
  paste0("https://www.espn.com/soccer/team/stats/_/id/", teamID)


# Reading all teams HTML --------------------------------------------------


ReadAllTeamsHTML <- function(clubsLinks) {
  read_html(clubsLinks)
}


# Applying ReadAllTeamsHTML function to PremierLeagueTeamID ---------------

listsOfNodes <- map(PremierLeagueTeamID, ReadAllTeamsHTML)

rowNumber <- 1:25


# Writing players names' selectors for each player in the table -----------



PlayerNamesNode <-
  paste0(
    ".InnerLayout__child--dividers:nth-child(",
    rowNumber,
    ") .InnerLayout__child--dividers .Table__TD:nth-child(",
    2 ,
    ")"
  )


# Scraping names of each player -------------------------------------------



PlayersName <- as.list(1:20)

for (i in 1:20) {
  PlayersName[[i]] <- listsOfNodes[[i]] %>%
    html_nodes(PlayerNamesNode) %>%
    html_text()
  i = i + 1
}



# Writing games played selectors for each player in the table -------------



PlayersGamePlayedStats <-
  paste0(
    ".InnerLayout__child--dividers:nth-child(",
    rowNumber,
    ") .InnerLayout__child--dividers .Table__TD:nth-child(3) .tar"
  )

GamesPlayedbyPlayers <- as.list(1:20)


# Scraping games played by each player in the row -------------------------



for (j in 1:20) {
  GamesPlayedbyPlayers[[j]] <- listsOfNodes[[j]] %>%
    html_nodes(PlayersGamePlayedStats) %>%
    html_text()
  j = j + 1
}



# Writing goals scored selectors for each player in the table -------------



GoalsScored <-
  paste0(
    ".InnerLayout__child--dividers:nth-child(",
    rowNumber,
    ") .InnerLayout__child--dividers .tar+ .Table__TD"
  )


# Scraping goals scored by each player in the row -------------------------



GoalsScoredByPlayers <- as.list(1:20)

for (k in 1:20) {
  GoalsScoredByPlayers[[k]] <- listsOfNodes[[k]] %>%
    html_nodes(GoalsScored) %>%
    html_text()
  k = k + 1
}

map(GoalsScoredByPlayers, as_tibble)



# Writing assists selectors for each player in the table ------------------




# Try using mutate_if -----------------------------------------------------







