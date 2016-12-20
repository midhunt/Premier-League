# Remove previous objects from the environment
rm(list = ls())

# setting path to the working directory
setwd(paste(
  Sys.getenv("MyGitRepo"), 
  "Premier-League", 
  sep = "/")
)

# getwd()

# load the required packages
library(data.table)
library(reshape)

# Merging all the files from same folder and binding all teams data into a single file
FPL_Player_Statistics <- do.call("rbind",
                                 lapply(
                                   list.dirs("Teams", 
                                             recursive = F, 
                                             full.names = T),
                                   FUN = function(folder) {
                                     Reduce(function(...) merge(..., 
                                                                by = c("player_name", "player_team",
                                                                       "player_location", "now_cost",
                                                                       "selected_by_percent", "form",
                                                                       "total_points"),
                                                                all=T), 
                                            lapply(list.files(folder, 
                                                              full.names = T),
                                                   FUN = function(files){
                                                     fread(files)
                                                   }
                                            )
                                     )
                                   }
                                 )
)

# Cleaning the data
# Removing "%" symbol from column
FPL_Player_Statistics[, selected_by_percent := as.numeric(
  gsub("%$", 
       "", 
       selected_by_percent
  )
)]

# Removing pounds symbol from the columns
cost_columns <- c("now_cost", "cost_change_event",
                  "cost_change_event_fall", "cost_change_start",
                  "cost_change_start_fall")

FPL_Player_Statistics[, (cost_columns) := lapply(.SD, 
                                                FUN = function(x){
                                                  as.numeric(gsub("^£", "", x))
                                                  }
                                                ), .SDcols = cost_columns]

cost_columns_newnames <- c("now_cost_pounds", "cost_change_event_pounds",
                           "cost_change_event_fall_pounds", "cost_change_start_pounds",
                           "cost_change_start_fall_pounds")
  
# Renaming cost related columns
setnames(x = FPL_Player_Statistics,
         old = cost_columns, 
         new = cost_columns_newnames)


# Crawled Data ------------------------------------------------------------

player_current_status[, c("photo", "loans_in", "loans_out", "loaned_out", "loaned_in",
                          "code", "web_name", "squad_number") := NULL]

write.csv(player_current_status, 
          "ExtractedData/Player_Current_Status.csv", 
          row.names = F)

player_season_history[, c("loaned_in", "loaned_out", "id", "kickoff_time") := NULL]

write.csv(player_season_history,
          "ExtractedData/Player_Season_History.csv",
          row.names = F)

player_past_history[, c("id", "element_code",
                        "influence", "creativity", "threat") := NULL]

write.csv(player_past_history,
          "ExtractedData/Player_Past_History.csv",
          row.names = F)
