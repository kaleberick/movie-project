library(rsconnect)

# The code below is used to set up your computer to communicate with the Shiny Apps infrastructure. 
# If you want to connect your computer to Shiny Apps, you will need to go to https://www.shinyapps.io and create an account.
rsconnect::setAccountInfo(name='<your-name>', token='<your-token>', secret='<your-secret>')


# The code below deploys the shiny app to the cloud for other users to access it. 
# If you are trying to deploy your own version of this app, make sure to input the correct 
#     path on your computer to the location of the shiny app file. 
rsconnect::deployApp("<you-file-path>/shiny")

