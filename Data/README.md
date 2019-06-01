# Data

You will find two R files here. 

The first is called "webscraping.R" and it contains all of the code used to gather the movie data in this repo. 

All of the data was scraped from boxofficemojo.com. 
This file contains two main functions, one that grabs the data for an individual movie and another that grabs the uniqe "movie ids" that Box Office Mojo uses. 
These functions are then linked using other loop functions to collect all of the data on top movies for the last 30 years. 
Unfortunately, these functions are not perfect and some movies will be missing information due to occasionally varying webpage layouts. 

You can find comments in the code that give additional inscructions on how these functions work.


The second R file is called "data analysis.R". This file contains all of the code used to explore the movie data, after it was collected. 
This consists of data summaries, plots, and histograms to get a better understanding of how to model this data properly. 

It also contains several iterations of model fitting, to get an idea of what was done to create the model used in the Shiny App. 


