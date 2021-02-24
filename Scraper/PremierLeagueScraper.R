url <- "https://www.espn.com/soccer/standings/_/league/eng.1"

htmlRef <- read_html(url) %>% 
  html_nodes("body") 

# Creating an empty Premier League Table
premier_league_table <- as.data.frame(matrix(NA, ncol = 1, nrow = 20))

# Scraping TeamNames
teamNames <- htmlRef %>% 
  html_nodes(".hide-mobile .AnchorLink") %>% 
  html_text()

# Pasting TeamNames in the rows
premier_league_table$V1 <- teamNames

# Renaming the columns for TeamNames

premier_league_table <- premier_league_table %>% 
  rename(TeamNames = "V1")

# Scraping other Table headers
table_headers <- htmlRef %>% 
  html_nodes(".underline .AnchorLink") %>% 
  html_text()




# Extracting the stats

node_numbers <- 1:20

nodes <-  paste0(".Table__even:nth-child(", node_numbers, ")", " ", ".stat-cell")

node1 <- ".Table__even:nth-child(1) .stat-cell"

get_stats <- function(nodes){
  htmlRef %>% 
    html_nodes(nodes) %>% 
    html_text()
}

# Creating a tibble for stats
points <- map(nodes, get_stats) %>% 
  as_tibble_col() %>% 
  unnest_wider(col = value)

# Renaming colnames
colnames(points) <- table_headers

# Replicating ESPN's Premier League Table
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

