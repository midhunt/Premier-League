import csv
import time
import urllib2
import cookielib
import dryscrape
from bs4 import BeautifulSoup

# STATS_TYPE_url = ["event_points", "minutes", "goals_scored", "assists", "clean_sheets", "goals_conceded", 
# 				  "own_goals","penalties_saved", "penalties_missed", "yellow_cards", "red_cards", 
# 				  "saves", "bonus", "bps", "influence", "creativity", "threat", "ict_index", 
# 				  "dreamteam_count", "value_form", "value_season", "points_per_game", "transfers_in", 
# 				  "transfers_out", "transfers_in_event", "transfers_out_event", "cost_change_start", 
# 				  "cost_change_start_fall", "cost_change_event", "cost_change_event_fall"]

STATS_TYPE_url = ["minutes"]

# TEAMS_DICT = {"Arsenal":"te_1", "Bournemouth":"te_2","Burnley":"te_3","Chelsea":"te_4","Crystal Palace":"te_5",
# "Everton":"te_6", "Hull":"te_7", "Leicester":"te_8", "Liverpool":"te_9", "Man City":"te_10", "Man Utd":"te_11",
# "Middlesbrough":"te_12","Southampton":"te_13","Spurs":"te_14", "Stoke":"te_15", "Sunderland":"te_16", "Swansea":"te_17",
# "Watford":"te_18", "West Brom":"te_19", "West Ham":"te_20"}

TEAMS_DICT = {"Arsenal":"te_1"}

Table_columns = ['player_name', 'player_team', 'player_location', 'now_cost', 'selected_by_percent', 'form', 'total_points']

# hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
#        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
#        'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
#        'Accept-Encoding': 'none',
#        'Accept-Language': 'en-US,en;q=0.8',
#        'Connection': 'keep-alive'}

for stats_type in STATS_TYPE_url:
	for key in sorted(TEAMS_DICT):
		file = csv.writer(open("Teams/"+key+"/"+stats_type+".csv", "w"))
		# url = "/home/midhunthaduru/Dropbox/Kaggle/FootBallAnalytics/"+key+"/"+stats_type+".html"
		url = "https://fantasy.premierleague.com/a/statistics/"+stats_type+"/"+TEAMS_DICT[key]

		# session.set_timeout(30)
		session = dryscrape.Session()

		session.visit(url)
		response = session.body()
		

		# writing column names of csv file
		Table_columns.append(stats_type)
		file.writerow(Table_columns)
		Table_columns.pop()

		# # requesting from the web to avoid 403 error
		# req = urllib2.Request(url, headers=hdr)

		# try:
		#     page = urllib2.urlopen(req)
		# except urllib2.HTTPError, e:
		#     print e.fp.read()

		# page = open(url, "r").read()
		# page = urllib2.urlopen(url, 'r')
		# soup = BeautifulSoup(page, "lxml")

		soup = BeautifulSoup(response, "lxml")
		# print soup.prettify()

		MainContent = soup.findAll('div', {'class':'table ism-scroll-table'})
		# print MainContent

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

					# print player_name, player_team, player_location, val, sel_pct, form, pts, col

					# Writing to extracted values to csv file
					file.writerow([player_name, player_team, player_location, 
						val, sel_pct, form, pts, col])

		session.reset()
		# time.sleep(30)