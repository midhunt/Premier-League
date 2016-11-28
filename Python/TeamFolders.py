#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 28 10:25:40 2016

@author: midhunthaduru
"""
import os

RootDirectory = os.environ['MyGitRepo']


TEAMS_DICT = {"Arsenal":"te_1", "Bournemouth":"te_2","Burnley":"te_3",
"Chelsea":"te_4","Crystal Palace":"te_5","Everton":"te_6", "Hull":"te_7", 
"Leicester":"te_8", "Liverpool":"te_9", "Man City":"te_10", "Man Utd":"te_11",
"Middlesbrough":"te_12","Southampton":"te_13","Stoke":"te_14", 
"Sunderland":"te_15", "Swansea":"te_16", "Totenham":"te_17",
"Watford":"te_18", "West Brom":"te_19", "West Ham":"te_20"}


for key in sorted(TEAMS_DICT):
    if not os.path.exists(RootDirectory + "/Premier-League/Teams/" + key):
        os.makedirs(RootDirectory + "/Premier-League/Teams/" + key)