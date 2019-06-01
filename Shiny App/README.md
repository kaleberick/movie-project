# Shiny App Instructions

There are two R files here. The first and most relevant is called "app.R". 

This file contains all of the code necessary to create the Shiny App, which can be found [here](https://kalebe.shinyapps.io/Box-Office-Predictions/).
You will need to install the shiny package on your computer in order for this script to work. 
You can do so with the following code in R: install.packages("shiny").

Using this R file, you can create your own local version of this Shiny App (and even make your own adjustments or changes). 

The file consists of three functions, as well as a little bit of pre-processing. 
The first function creates the user interface for the app. This controls how the various parts of the app appear to the user. 
The second function creates the actual calculations used to return a prediction and create the plots that appear. 

The third function at the very bottom of the file is used to deploy the app locally. 
You can run all of the code at once with this function and it will automatically bring up a screen displaying the local app on your computer. 
Alternatively, if you are using RStudio, there will be a button in the top-right corner of the screen that say "Run App". Clicking on this will also run a local version of the app on your computer. 


The second file is called "shiny permissions.R". This app gives simple instructions for how to deploy your own version of this app to the cloud using Shiny. 
You will need to create your own Shiny account, which can be done [here](https://shinyapps.io). 
Once you create an account, you will need your account name, your account token, and the secret token. 
You will also need to install the rsconnect package, which can be done with the following code: install.packages("rsconnect").
The comments in the script contain further insctructions for how to complete this. 