from selenium import webdriver
from selenium.webdriver.common.keys import Keys

driver = webdriver.Chrome()
driver.get("https://fantasy.premierleague.com/a/statistics/total_points/te_1")

playerInfo = driver.find_element_by_tag_name("use")
