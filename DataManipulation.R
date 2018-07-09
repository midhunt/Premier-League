# Loading the required libraries
library(data.table)

# Extracting Element Type Details
element_types <- as.data.table(lPremierLeague$element_types)

# Extracting Team details from the list
teams <- as.data.table(lPremierLeague$teams)


# Player Season History ---------------------------------------------------

# Changing the time format 
player_season_history[, kickoff_time := gsub("T|Z", " ", kickoff_time)]
player_season_history[, kickoff_time := gsub(" $", "", kickoff_time)]
player_season_history[, kickoff_time := as.POSIXct(kickoff_time,
                                                   tz = "UTC",
                                                   origin = "1970-01-01",
                                                   format = "%Y-%m-%d %H:%M:%S")]

# Calculating Win/Draw/Loss from the goal differences
player_season_history[, match_status := ifelse((was_home == TRUE) & (team_h_score > team_a_score), 
                                               "Win", 
                                               ifelse((was_home == TRUE) & team_h_score == team_a_score,
                                                      "Draw", ifelse((was_home == FALSE) & (team_a_score > team_h_score), 
                                                                     "Win", ifelse((was_home == FALSE) & (team_a_score == team_h_score),
                                                                                   "Draw", "Lose"))))]



# Player Current Status ---------------------------------------------------

# Merging  element types to know player position
player_current_status <- merge(
  player_current_status,
  element_types[,.(id, singular_name_short)],
  by.x = "element_type",
  by.y = "id",
  all = T)

# Merging teams to know which team a player belongs to
player_current_status <- merge(
  player_current_status,
  teams[,.(id, short_name)],
  by.x = "team",
  by.y = "id",
  all = T)

# Formatting timestamps from player current status
player_current_status[, news_added := gsub("T", " ", news_added)]
player_current_status[, news_added := gsub("Z", "", news_added)]
player_current_status[, news_added := as.POSIXct(news_added,
                                                   tz = "UTC",
                                                   origin = "1970-01-01",
                                                   format = "%Y-%m-%d %H:%M:%S")]


# Removing unnecessary columns from the table
player_current_status[, photo := NULL]

# Calculating player now cost
player_current_status[, now_cost := now_cost/10]

# Converting numeric columns to numeric data type
player_current_status[, c("value_form", "value_season",
                          "selected_by_percent", "form",
                          "points_per_game", "ep_this",
                          "ep_next", "influence", "creativity",
                          "threat", "ict_index") := lapply(.SD, function(x){
                            as.numeric(x)
                          }),
                      .SDcols = c("value_form", "value_season",
                                  "selected_by_percent", "form",
                                  "points_per_game", "ep_this",
                                  "ep_next", "influence", "creativity",
                                  "threat", "ict_index")]

library(ggplot2)

ggplot(player_current_status) +
  geom_point(aes(x = now_cost, y = total_points)) +
  facet_wrap(~ singular_name_short, scales = "free")

player_current_status[singular_name_short == "DEF" & now_cost < 5 & total_points > 75]

# Player Past History -----------------------------------------------------

