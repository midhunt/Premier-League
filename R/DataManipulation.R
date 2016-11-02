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
                                     Reduce(function(...) merge(..., all=T), 
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

# checking the structure of the table
str(FPL_Player_Statistics)
