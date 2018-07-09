library(streamgraph)

player_season_points <- my_current_team[, .(round, player_fullname, total_points)]

setorder(player_season_points, "round")
player_season_points[, round := as.numeric(round)]

player_season_points %>% streamgraph("player_fullname", "total_points", 
                                     "round", offset="zero")

