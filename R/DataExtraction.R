# Removing old objects from the environment
rm(list = ls())

# Loading the required packages
library(jsonlite)
library(data.table)

# Getting complete premier league statistics
lPremierLeague <- fromJSON(readLines("https://fantasy.premierleague.com/drf/bootstrap-static"), 
                           simplifyVector = F, 
                           simplifyDataFrame = T)

# removing unnecessary data from the list
lPremierLeague$`game-settings` <- NULL

# converting Elements table data.table format
lPremierLeague$elements <- as.data.table(lPremierLeague$elements)

# creating player history links to access player current season history, previous 
# seasons data, fixture list etc.
lPremierLeague$elements[, player_hist_link := paste0("https://fantasy.premierleague.com/drf/element-summary/", id)]
lPremierLeague$elements[, player_fullname := paste(first_name, second_name)]

# creating empty lists
lPlayerPastHistory <- list()
lPlayerSeasonHistory <- list()

# Getting each individual player past history, season history and details
for(i in seq(nrow(lPremierLeague$elements))){
  print(i)
  player_id <- lPremierLeague$elements$id[i]
  player_fullname <- lPremierLeague$elements$player_fullname[i]
  lPlayerData <- fromJSON(readLines(lPremierLeague$elements$player_hist_link[i]),
                          simplifyVector = F,
                          simplifyDataFrame = T)
  
  if(length(lPlayerData$history_past) != 0){
    
    lPlayerPastHistory[[i]] <- cbind.data.frame(player_id = player_id,
                                                player_fullname = player_fullname,
                                                lPlayerData$history_past)
  }
  
  lPlayerSeasonHistory[[i]] <- cbind.data.frame(player_id = player_id,
                                            player_fullname = player_fullname,
                                            lPlayerData$history)
  
  Sys.sleep(1)
  
}

# Binding the data together
player_season_history <- as.data.table(
  do.call("rbind", lPlayerSeasonHistory)
  )

write.csv(player_season_history, 
          "Datasets/player_season_history_2017_18.csv", 
          row.names = F)

player_past_history <- as.data.table(
  do.call("rbind", lPlayerPastHistory)
  )

write.csv(player_past_history,
          "Datasets/player_past_history_2017_18.csv",
          row.names = F)

player_current_status <- as.data.table(lPremierLeague$elements)

write.csv(player_current_status,
          "Datasets/player_current_status_2017_18.csv",
          row.names = F)

teams <- as.data.table(lPremierLeague$teams)

teams[, c("current_event_fixture", 
          "next_event_fixture", "link_url") := NULL]

write.csv(teams,
          "Datasets/teams_2017_18.csv",
          row.names = F)
