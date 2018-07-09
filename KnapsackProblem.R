library(ggplot2)
library(data.table)

# Understanding Player Season History
names(player_season_history)

# Checking the data type of player season history
str(player_season_history)

player_season_history[, player_fullname := as.character(player_fullname)]

player_season_history[, c("influence", "creativity",
                          "threat", "ict_index") := lapply(.SD, 
                                                           function(x){
                            as.numeric(x)
                          }), .SDcols = c("influence", "creativity",
                                          "threat", "ict_index")]

player_season_history[, kickoff_time := gsub("T", " ", kickoff_time)]

player_season_history[, kickoff_time := gsub("Z", "", kickoff_time)]

player_season_history[, kickoff_time := as.POSIXct(kickoff_time,
                                                   tz = "UTC",
                                                   format = "%Y-%m-%d %H:%M:%S")]

# Winning Goals
WinningGoals <- player_season_history[winning_goals > 0, 
                                      .(TotalWinningGoals = sum(winning_goals)), 
                                      by = player_fullname]

setorder(WinningGoals, -TotalWinningGoals)

# Player Current status
str(player_current_status)

player_current_status[, c("influence", "creativity",
                          "threat", "ict_index",
                          "points_per_game",
                          "ep_this", "ep_next") := lapply(.SD,
                                                           function(x){
                                                             as.numeric(x)
                                                           }),
                      .SDcols = c("influence", "creativity",
                                  "threat", "ict_index",
                                  "points_per_game",
                                  "ep_this", "ep_next")]

# Goal keeper
penaltiesSaved <- player_current_status[penalties_saved > 0, .(id, first_name, 
                                                               second_name, now_cost,
                                                               saves, 
                                                               penalties_saved,
                                                               penalties_missed, 
                                                               total_points)]
