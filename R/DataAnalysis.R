# Loading the required pacakges
library(ggplot2)
library(data.table)
library(streamgraph)

names(FPL_Player_Statistics)

hist(FPL_Player_Statistics$value_season, 
     breaks = 100,
     main = "Value in Season Histogram",
     xlab = "Value Season",
     ylab = "Frequency")

hist(FPL_Player_Statistics$value_form, 
     breaks = 100,
     main = "Value Form Histogram",
     xlab = "Value Form",
     ylab = "Frequency")

# Player form histogram
hist(FPL_Player_Statistics$form, 
     breaks = 100,
     main = "Form Histogram",
     xlab = "Form",
     ylab = "Frequency")

# Player position vs ICT values 
ggplot(FPL_Player_Statistics) +
  geom_point(aes(x = total_points, y = influence, color = "red")) +
  geom_point(aes(x = total_points, y = creativity, color = "blue")) +
  geom_point(aes(x = total_points, y = threat, color = "green")) +
  scale_color_manual(name = "Points", 
                     values = c("red" = "red",
                                "blue" = "blue",
                                "green" = "green"),
                     labels = c("Influence", "Creativity", "Threat")) +
  theme(legend.position = "bottom") +
  xlab("Total Points") +
  ylab("Influence, Creativity and Threat") +
  labs(title = "Influence, Creativity and Threat vs Total Points w.r.t Player Position") +
  facet_wrap(~ player_location)

# Form vs Event Points
ggplot(FPL_Player_Statistics) +
  geom_point(aes(x = value_form, y = event_points)) +
  facet_wrap(~ player_location) +
  xlab("Value Form") +
  ylab("Match Points") +
  labs(title = "Does Form Really Have Impact on Points")

ggplot(FPL_Player_Statistics) +
  geom_point(aes(x = form, y = points_per_game)) +
  facet_wrap(~ player_location) +
  xlab("Form") +
  ylab("Average Points") +
  labs(title = "Does Form Really Have Impact on Points")


# Checking Fonte stats
FPL_Player_Statistics[player_name == "Fonte"]

# range goals conceded when player location is "DEF"
range(FPL_Player_Statistics[player_location == "DEF", goals_conceded], na.rm = T)

# Finding Prospective Defender 
FPL_Player_Statistics[player_name %in% c("Blind", "Fonte", "McAuley")]

# Finding forward player
FPL_Player_Statistics[event_points >= 14]

# My team
CurrentTeamStats <- FPL_Player_Statistics[player_name %in% c("Monreal", "Gibson", 
                                                             "McAuley", "Walker", 
                                                             "Ibrahimovic", "Firmino", 
                                                             "Cech", "Keane", "Kante", 
                                                             "Austin", "Hazard", 
                                                             "Walcott", "Capoue", 
                                                             "Kolarov")]


my_current_team <- player_season_history[player_fullname %in% c("Zlatan Ibrahimovic",
                                                                "Eden Hazard", "Kyle Walker",
                                                                "Ben Gibson", "Theo Walcott",
                                                                "Fernando Llorente", "Gylfi Sigurdsson",
                                                                "Aleksandar Kolarov", "Etienne Capoue",
                                                                "Christian Benteke", "Gareth McAuley",
                                                                "Charlie Daniels", "N'Golo Kanté",
                                                                "Petr Cech", "Artur Boruc")]

# My team home and away performance
ggplot(my_current_team) + 
  geom_point(aes(x = round, 
                 y = total_points, 
                 colour = was_home)) +
  facet_wrap(~ player_fullname) +
  theme(legend.position = "bottom")



# Injured Players
injured_players <- player_current_status[status == "i", .(player_fullname, 
                                                         news, 
                                                         cost_change_event_fall,
                                                         cost_change_start_fall)]
# Suspended Players
suspended_players <- player_current_status[status == "s", .(player_fullname, 
                                                            news, 
                                                            cost_change_event_fall,
                                                            cost_change_start_fall)]


## Plotting Players past points on to streamgraph --------------------------------------
# subsetting the data
player_past_points <- player_past_history[, .(season_name, player_fullname, total_points)]

# arranging the table according to season_name
setorder(player_past_points, "season_name")

# change the season names to season ending year
player_past_points[, season_name := as.numeric(gsub("20[0-1][0-9]/", "20", season_name))]

# plotting streamgraph
player_past_points %>% 
  streamgraph("player_fullname", "total_points", 
              "season_name", offset="zero") %>%
  sg_axis_x(1, "season_name", "%Y") %>%
  sg_legend(show = TRUE, label = "Player Name:")

## Whos and whats -------------------------------------------------------------------

# worst goal keeper 
player_past_history[goals_conceded == max(goals_conceded), .(player_fullname, season_name, goals_conceded)]

# Best goal keeper
player_past_history[saves == max(saves), .(player_fullname, season_name, saves, goals_conceded)]

# maximum goals scored
player_past_history[goals_scored == max(goals_scored), .(player_fullname, season_name, goals_scored, assists)]

# maximum assists
player_past_history[assists == max(assists), .(player_fullname, season_name, goals_scored, assists)]

player_season_history[player_fullname %in% player_current_status[element_type == 1, player_fullname], .(player_fullname, saves, goals_conceded, clean_sheets, total_points, own_goals)]


# Player Past Analysis ----------------------------------------------------
library(ggplot2)

ggplot(player_past_history) +
  geom_point(aes(x = start_cost, y = total_points))
