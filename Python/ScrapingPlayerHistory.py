#%% importing packages
from selenium import webdriver
from selenium.webdriver.common.by import By

#%% Navigate to the page
driver = webdriver.Chrome()
driver.get("https://fantasy.premierleague.com/a/statistics/total_points/te_1")

#%% View player information
driver.find_element_by_class_name('ismjs-show-element ism-table--el__name').click()

#%% close the driver window
driver.close()