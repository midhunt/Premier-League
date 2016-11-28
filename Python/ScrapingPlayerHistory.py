from selenium import webdriver
from selenium.webdriver.common.keys import Keys

driver = webdriver.Chrome()
driver.get("https://fantasy.premierleague.com/a/statistics/total_points/te_1")
# 
driver.find_element_by_id('View player information').click()

#View player information