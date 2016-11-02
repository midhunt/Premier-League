# Remove previous objects from the environment
rm(list = ls())

# setting path to the working directory
setwd(paste(
  Sys.getenv("MyGitRepo"), 
  "Premier-League", 
  sep = "/")
)

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