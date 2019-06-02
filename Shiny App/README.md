# Shiny App Instructions

There are two R files here. The first and most relevant is called "app.R". 

### Running the Shiny App Locally
This file contains all of the code necessary to create the Shiny App, which can be found [here](https://kalebe.shinyapps.io/Box-Office-Predictions/).
You will need to install the shiny package on your computer in order for this script to work. 
You can do so with the following code in R: install.packages("shiny").

Using this R file, you can create your own local version of this Shiny App (and even make your own adjustments or changes). 

The file consists of three functions, as well as a little bit of pre-processing. 
The first function creates the user interface for the app. This controls how the various parts of the app appear to the user. 
The second function creates the actual calculations used to return a prediction and create the plots that appear. 

The third function at the very bottom of the file is used to deploy the app locally. 
Run all of the code at once with this function at the bottom and it will automatically bring up a screen displaying the local app on your computer. 
Once you have run all of the code, you can just run this third function (shinyApp(ui, server)) to display a local version of the app. 
Alternatively, if you are using RStudio, there will be a button in the top-right corner of the screen that say "Run App". Clicking on this will also run a local version of the app on your computer. 

If this code doesn't work, you may need to change the working directory of your R instance. Make sure that the working directory is the Shiny App folder from this repo so that it reads the data properly.


### Deploying Your Own Version of the App
The second file is called "shiny permissions.R". This app gives simple instructions for how to deploy your own version of this app to the cloud using Shiny. 
You will need to create your own Shiny account, which can be done [here](https://shinyapps.io). 
Once you create an account, you will need your account name, your account token, and the secret token. 
You will also need to install the rsconnect package, which can be done with the following code: install.packages("rsconnect").
The comments in the script contain further insctructions for how to complete this. 

### Movie Dataset
The movie_dataset.csv file contains the final dataset used for calculating the model. It can be recreated with code from the Data file in this repo.
The model used in the app was the result of several model iterations, which can also be found in the Data file. 

