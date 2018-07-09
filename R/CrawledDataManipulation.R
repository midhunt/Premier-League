# Loading Required libraries ----------------------------------------------

library(data.table)

# Crawled Data Manipulation --------------------------------------------------

# Extracting player ids to a seperate table
player_ids <- player_current_status[,.(id, player_fullname, team, element_type)]

player_current_status[, c("photo", "first_name", "second_name", "player_fullname",
                          "loans_in", "loans_out", "loaned_out", "loaned_in",
                          "code", "web_name", "squad_number") := NULL]

player_season_history[, c("player_fullname", "loaned_in", 
                          "loaned_out", "id", "kickoff_time") := NULL]

player_past_history[, c("id", "element_code", "player_fullname",
                        "influence", "creativity", "threat") := NULL]

# Converting player value to actual value on FPL
player_season_history[, value := value/10]

# Converting player start and end cost to actual values similar to FPL
player_past_history[, (c("start_cost", "end_cost")) := lapply(.SD, function(x)  {
  x/10
}), 
.SDcols = c("start_cost", "end_cost")]

# converting ict_index from string to numeric
player_past_history[, ict_index := as.numeric(ict_index)]

# cost columns that need to be changed to match the website
cost_columns <- c("now_cost", "cost_change_start", "cost_change_event",
                  "cost_change_start_fall", "cost_change_event_fall")

# Coverting cost as actual cost of FPL site
player_current_status[, (cost_columns) := lapply(.SD, function(x){
  x/10
}), .SDcols = cost_columns]

# converting string to numeric
numeric_cols <- c("value_form", "value_season", "selected_by_percent",
                  "form", "influence", "creativity", "threat", "ict_index",
                  "points_per_game", "ep_this", "ep_next")

player_current_status[, (numeric_cols) := lapply(.SD, function(x){
  as.numeric(x)
}), .SDcols = numeric_cols]

