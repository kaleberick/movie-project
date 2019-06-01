# Webscraping Instructions

This R file contains all of the code used to gather the movie data in this repo. 

All of the data was scraped from boxofficemojo.com. 
This file contains two main functions, one that grabs the data for an individual movie and another that grabs the uniqe "movie ids" that Box Office Mojo uses. 
These functions are then linked using other loop functions to collect all of the data on top movies for the last 30 years. 
Unfortunately, these functions are not perfect and some movies will be missing information due to occasionally varying webpage layouts. 

You can find comments in the code that give additional inscructions on how these functions work.