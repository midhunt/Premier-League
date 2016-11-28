import os
import csv
import time
import dryscrape
from bs4 import BeautifulSoup

RootDirectory = os.environ['MyGitRepo']

STATS_TYPE_url = ["event_points", "minutes", "goals_scored", "assists", "clean_sheets", "goals_conceded", 
				  "own_goals","penalties_saved", "penalties_missed", "yellow_cards", "red_cards", 
				  "saves", "bonus", "bps", "influence", "creativity", "threat", "ict_index", 
				  "dreamteam_count", "value_form", "value_season", "points_per_game", "transfers_in", 
				  "transfers_out", "transfers_in_event", "transfers_out_event", "cost_change_start", 
				  "cost_change_start_fall", "cost_change_event", "cost_change_event_fall"]

TEAMS_DICT = {"Arsenal":"te_1", "Bournemouth":"te_2","Burnley":"te_3","Chelsea":"te_4","Crystal Palace":"te_5",
"Everton":"te_6", "Hull":"te_7", "Leicester":"te_8", "Liverpool":"te_9", "Man City":"te_10", "Man Utd":"te_11",
"Middlesbrough":"te_12","Southampton":"te_13","Stoke":"te_14", "Sunderland":"te_15", "Swansea":"te_16", "Tottenham":"te_17",
"Watford":"te_18", "West Brom":"te_19", "West Ham":"te_20"}

Table_columns = ['player_name', 'player_team', 'player_location', 'now_cost', 'selected_by_percent', 'form', 'total_points']

for stats_type in STATS_TYPE_url:
	for key in sorted(TEAMS_DICT):
           # creating folder if they don't exist  
		if not os.path.exists(RootDirectory + "/Premier-League/Teams/" + key):
			os.makedirs(RootDirectory + "/Premier-League/Teams/" + key)
			
		file = csv.writer(open(RootDirectory+"/Premier-League/Teams/"+key+"/"+stats_type+".csv", "w"))
		url = "https://fantasy.premierleague.com/a/statistics/"+stats_type+"/"+TEAMS_DICT[key]

		session = dryscrape.Session()
		session.visit(url)
		time.sleep(5)
		response = session.body()

		# writing column names of csv file
		Table_columns.append(stats_type)
		file.writerow(Table_columns)
		Table_columns.pop()

		soup = BeautifulSoup(response, "lxml")

		MainContent = soup.findAll('div', {'class':'table ism-scroll-table'})

		for i in MainContent:
			TableBody = i.findAll('tbody')
			for j in TableBody:
				TableRow = j.findAll('tr')
				for k in TableRow:
					TableCells = k.findAll('td')
					for l in TableCells:
						PlayerDetailsDiv = l.findAll('div', {'class':'ism-media__body ism-table--el__primary-text'})
						for m in PlayerDetailsDiv:
							PlayerName_a = m.findAll('a', {'class':'ismjs-show-element ism-table--el__name'})
							try:
								player_name = str(PlayerName_a[0].get_text().encode('utf-8'))
							except:
								print 'bad string'
								continue
						for n in PlayerDetailsDiv:
							player_other_details = n.findAll('span')
							try:
								player_team = str(player_other_details[0].get_text().encode('utf-8'))
								player_location = str(player_other_details[1].get_text().encode('utf-8'))
							except:
								print 'bad string'
								continue


					# Extracting Values from the table 
					try:
						val = str(TableCells[2].get_text().encode('utf-8'))
						sel_pct = str(TableCells[3].get_text().encode('utf-8'))
						form = str(TableCells[4].get_text().encode('utf-8'))
						pts = str(TableCells[5].get_text().encode('utf-8'))
						col = str(TableCells[6].get_text().encode('utf-8'))
					except:
						print "bad string"
						continue

					# Writing to extracted values to csv file
					file.writerow([player_name, player_team, player_location, 
						val, sel_pct, form, pts, col])

		print stats_type+" data is scraped for "+key

	session.reset()
