# Shiny App - Box Office Predictions - 418

This repo contains R code used to scrape movie data from Box Office Mojo and then create a model to estimate domestic box office earnings.

The final result of this repo is a Shiny App that can be accessed at https://kalebe.shinyapps.io/Box-Office-Predictions/

This app takes a user inputted movie budget, the widest release of a movie, the rating of the movie, and the release season to predict what the domestic box office earnings will look like. 
It was created using the top weekly films from Box Office Mojo.



There are three R files included in this repo and one csv file that contains all of the movie data. 

The first R file is found in the Scraping Instructions file and is titled "webscraping.R".
It contains code and instructions on how to re-create the movie_dataset.csv file. 
All of the data used in this app were pulled from boxofficemojo.com using code from this file. 


The next R file is found in the Shiny App folder and it is titled "app.R".
It contains all of the code used to create the Shiny App. 
This file can also be used to re-create the same app locally on your own machine. 


The last R file is also found in the Shiny App folder, titled "shiny permissions.R".
This contains simple instructions for deploying your own version of the app to shinyapps.io.
Note that this will require you to create your own shinyapps account, which can be done here: https://www.shinyapps.io






