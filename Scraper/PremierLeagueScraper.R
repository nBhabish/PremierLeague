
# Reading in url ----------------------------------------------------------


url <- "https://www.espn.com/soccer/standings/_/league/eng.1"

htmlRef <- read_html(url) %>% 
  html_nodes("body") 


# Creating an empty PL table ----------------------------------------------
premier_league_table <- as.data.frame(matrix(NA, ncol = 1, nrow = 20))


# Scraping Team Names -----------------------------------------------------


teamNames <- htmlRef %>% 
  html_nodes(".hide-mobile .AnchorLink") %>% 
  html_text()


# Pasting Team Names in Rows ----------------------------------------------


premier_league_table$V1 <- teamNames


# Renaming column for Team Names ------------------------------------------

premier_league_table <- premier_league_table %>% 
  rename(TeamNames = "V1")


# Scraping Table Headers --------------------------------------------------

table_headers <- htmlRef %>% 
  html_nodes(".underline .AnchorLink") %>% 
  html_text()



# Extracting the stats ----------------------------------------------------

node_numbers <- 1:20

nodes <-  paste0(".Table__even:nth-child(", node_numbers, ")", " ", ".stat-cell")

node1 <- ".Table__even:nth-child(1) .stat-cell"

get_stats <- function(nodes){
  htmlRef %>% 
    html_nodes(nodes) %>% 
    html_text()
}


# Creating tibble for stats -----------------------------------------------


points <- map(nodes, get_stats) %>% 
  as_tibble_col() %>% 
  unnest_wider(col = value)


# Renaming Columns --------------------------------------------------------


colnames(points) <- table_headers


# Replicating ESPN's PL table ---------------------------------------------


premier_league_table <- cbind(premier_league_table, points) %>% 
  mutate(GP = as.integer(GP),
         W = as.integer(W),
         D = as.integer(D),
         L = as.integer(L),
         `F` = as.integer(`F`),
         A = as.integer(A),
         GD = as.integer(GD),
         P = as.integer(P)) %>% 
  as_tibble()




# Datapasta ---------------------------------------------------------------


premier_league_table %>% 
  select(TeamNames) %>% 
  arrange(TeamNames) %>% 
  pull() %>% 
  datapasta::vector_paste_vertical()



