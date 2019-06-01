# This script contains the necessary code to scrape the Box Office Mojo site
# It has several functions that scrape the proper information from the site
# Note that I built in delays in the scraping process so that they don't block access to the site
# Running this code will take some time, unless you change the delays to shorter periods of time. 
# Do so at your own risk of getting your IP Address blocked by Box Office Mojo or IMBD.com. 


# You will need the following libraries. 
# You'll have to install them, if you haven't done so 
library(rvest)
library(stringr)
library(xml2)
library(httr)
library(magrittr)
library(tidyverse)
library(dplyr)



# This first function is used to scrape the info from a specific movie's page.
# It has several built-in try-catch functions in order to make sure the function doesn't fail when it encounters something new. 
# Each movie on Box Office Mojo has it's own id, which needs to be supplied to this function.

movie_data <- function(id){
  
  base <- 'https://www.boxofficemojo.com/movies/?id='
  url <- paste(base,id,".htm",sep="")
  
  page <- read_html(url)
  
  tryCatch(
    {
      title_text <- page %>% html_nodes('title') %>% html_text()
      title <- toString(strsplit(title_text," -")[[1]][1])
      
      
      bo_tables <- page %>% html_nodes('table') %>% extract2(8) %>% html_table(fill=TRUE)
      
      opening <- bo_tables[2,23] # Widest opening
      world <- bo_tables[1,13] # Worldwide total
      foreign <- bo_tables[1,7] # Foreign total
      domestic <- bo_tables[1,4] # Domestic total
      
      
      open_string <- strsplit(opening," ")[[1]][1]
      widest_opening <- as.numeric(gsub(",","",open_string))
      
      worldwide_gross <- as.numeric(gsub("\\$","",gsub(",","",world)))
      
      foreign_gross <- as.numeric(gsub("\\$","",gsub(",","",foreign)))
      if(is.na(foreign_gross)){
        e <- simpleError("No foreign.")
        stop(e)
      }
      
      domestic_gross <- as.numeric(gsub("\\$","",gsub(",","",domestic)))
      
      
      misc <- page %>% 
        html_nodes("table") %>% 
        extract2(5) %>% 
        html_table(fill=TRUE)
      
      
      # misc[1,2]
      rate_text <- misc[1,8]
      
      rating <- toString(strsplit(rate_text,": ")[[1]][2])
      
      budget_text <- misc[1,9]
      
      budget_short <- strsplit(strsplit(budget_text,": ")[[1]][2]," ")[[1]][1]
      
      if(budget_short=='N/A'){
        budget <- NA
      }else{
        budget <- as.numeric(gsub("\\$","",budget_short))*1000000
      }
      
      date_text <- misc[1,5]
      full_date <- strsplit(date_text,": ")[[1]][2]
      month <- toString(strsplit(full_date," ")[[1]][1])
      year <- toString(strsplit(full_date," ")[[1]][3])
      
      
      data_points <- data.frame(title,worldwide_gross,domestic_gross,foreign_gross,widest_opening,rating,budget,month,year,stringsAsFactors = FALSE)
      message <- paste("Data successfully collected for '",title,"'",sep="")
      print(message)
      
      return(data_points)
    },
    error=function(error){
      
      tryCatch(
        {
          title_text <- page %>% html_nodes('title') %>% html_text()
          title <- toString(strsplit(title_text," -")[[1]][1])
          
          bo_tables <- page %>% html_nodes('table') %>% extract2(8) %>% html_table(fill=TRUE)
          
          opening <- bo_tables[1,14] # Widest opening
          world <- bo_tables[1,4] # Worldwide total
          foreign_gross <- 0 # Foreign total
          domestic <- bo_tables[1,4] # Domestic total
          
          
          open_string <- strsplit(opening," ")[[1]][1]
          widest_opening <- as.numeric(gsub(",","",open_string))
          
          worldwide_gross <- as.numeric(gsub("\\$","",gsub(",","",world)))
          
          domestic_gross <- as.numeric(gsub("\\$","",gsub(",","",domestic)))
          
          
          misc <- page %>% 
            html_nodes("table") %>% 
            extract2(5) %>% 
            html_table(fill=TRUE)
          
          
          # misc[1,2]
          rate_text <- misc[1,8]
          
          rating <- toString(strsplit(rate_text,": ")[[1]][2])
          
          budget_text <- misc[1,9]
          
          budget_short <- strsplit(strsplit(budget_text,": ")[[1]][2]," ")[[1]][1]
          if(budget_short=='N/A'){
            budget <- NA
          }else{
            budget <- as.numeric(gsub("\\$","",budget_short))*1000000
          }
          
          date_text <- misc[1,5]
          full_date <- strsplit(date_text,": ")[[1]][2]
          month <- toString(strsplit(full_date," ")[[1]][1])
          year <- toString(strsplit(full_date," ")[[1]][3])
          
          
          data_points <- data.frame(title,worldwide_gross,domestic_gross,foreign_gross,widest_opening,rating,budget,month,year,stringsAsFactors = FALSE)
          
          return(data_points)
        },
        error=function(error2){
          print("Can't collect data")
          empty <- data.frame(title,worldwide_gross=NA,domestic_gross=NA,foreign_gross=NA,
                              widest_opening=NA,rating=NA,budget=NA,month=NA,year=NA,  stringsAsFactors=FALSE)
          return(empty)
        }
      )
    } )
}



# Examples
movie_data('ironman')
movie_data('chickenrun')
movie_data('tnmt2')


# This next function is used to grab the movie ids for the top weekly films from a specific year.
# This function requires a specific year to be input and it will return the ids from the top weekly films of that year. 

weekly_list <- function(year){
  
  base1 <- 'https://www.boxofficemojo.com/weekly/?yr='
  base2 <- '&p=.htm'
  year <- toString(year)
  url <- paste(base1,year,base2,sep="")
  
  page <- read_html(url)
  
  links <- page %>% html_nodes('a') %>% html_attr("href")
  
  names <- links[str_detect(links, '/movies/')]
  
  ids <- data.frame(ids= character(),stringsAsFactors=FALSE)
  
  for(i in 1:length(names)){
    id <- strsplit(strsplit(names[i], "id=")[[1]][2],'\\.')[[1]][1]
    ids[i,] <- id
  }
  
  id_list <- unique(ids)
  row.names(id_list) <- NULL
  id_list
  
  return(id_list)
}

# Example
weekly_list(2018)



# This loop below will pull all of the top movies from 1982 through 2019
# It saves the list of ids as a dataframe called "movies"
# This loop has an average 2 minute delay between years. This can be shortened, if desired. 

years <- seq(from=1982, to=2019)
movies <- data.frame(ids = character(),stringsAsFactors = FALSE)

for(i in years){
  names <- weekly_list(i)
  movies <- rbind(movies,names)
  # Randomly delaying the pull times so that it doesn't appear to be a malicious attack. 
  Sys.sleep(runif(1,min=60,max=180))
  print(paste("Finished with year ",i,sep=""))
}

# We need to turn this list of ids into a dataframe and remove the duplicate ids.
movies <- data.frame(movies$ids)
complete_list <- unique(movies)


# This creates a blank dataframe that will be used to store all of the collected movie data.
data <- data.frame(title=character(),worldwide_gross=integer(),domestic_gross=integer(),foreign_gross=integer(),
                   widest_opening=integer(),rating=character(),budget=integer(),month=character(),year=character(),  stringsAsFactors=FALSE)

# The loop below pulls the movie data for each movie id collected previously. 
# It stores all of the collected data in a dataframe called "data"'
# This function will take a very long time to run, depending on the time between pulls.
# It currently waits an average of 135 seconds between pulls. You can shorten this, if desired. 
# I made it such a long delay because I was paranoid about getting my ip address blocked. 


for(i in partial_list){
  print(paste('Pulling data for ',i,sep=""))
  movie <- movie_data(i)
  print(movie)
  data <- rbind(data,movie)
  # The values below control the time between subsequent pulls. Change them to shorten or lengthen the time required to run. 
  Sys.sleep(runif(1,min=90,max=180))
}


# Once that finishes, you have a complete movie data set!
# Check it to make sure everything worked!
nrow(data)
head(data)


# Now that we've pulled all of the data, we still need to do a bit of processing to make sure the data is good for our model.


# First, we need to adjust the domestic earnings for inflation. We can do this in a general way. 
# Box Office Mojo gives the average ticket price for each year. 
# By dividing the earnings by the ticket price, we get an estimate for the number of tickets sold. 
# We then multiply that number of tickets sold by the current average ticket price for 2019. 
# This gives a decent estimate for domestic earnings adjusted for inflation. 


# First, we create a new column that holds the average ticket price for each year. 
data$adjust <- 0
data$adjust[data$year == 1981] = 2.78
data$adjust[data$year == 1982] = 2.94
data$adjust[data$year == 1983] = 3.15
data$adjust[data$year == 1984] = 3.36
data$adjust[data$year == 1985] = 3.55
data$adjust[data$year == 1986] = 3.71
data$adjust[data$year == 1987] = 3.91
data$adjust[data$year == 1988] = 4.11
data$adjust[data$year == 1989] = 3.97
data$adjust[data$year == 1990] = 4.23
data$adjust[data$year == 1991] = 4.21
data$adjust[data$year == 1992] = 4.15
data$adjust[data$year == 1993] = 4.14
data$adjust[data$year == 1994] = 4.18
data$adjust[data$year == 1995] = 4.35
data$adjust[data$year == 1996] = 4.42
data$adjust[data$year == 1997] = 4.59
data$adjust[data$year == 1998] = 4.69
data$adjust[data$year == 1999] = 5.08
data$adjust[data$year == 2000] = 5.39
data$adjust[data$year == 2001] = 5.66
data$adjust[data$year == 2002] = 5.81
data$adjust[data$year == 2003] = 6.03
data$adjust[data$year == 2004] = 6.21
data$adjust[data$year == 2005] = 6.41
data$adjust[data$year == 2006] = 6.55
data$adjust[data$year == 2007] = 6.88
data$adjust[data$year == 2008] = 7.18
data$adjust[data$year == 2009] = 7.5
data$adjust[data$year == 2010] = 7.89
data$adjust[data$year == 2011] = 7.93
data$adjust[data$year == 2012] = 7.96
data$adjust[data$year == 2013] = 8.13
data$adjust[data$year == 2014] = 8.17
data$adjust[data$year == 2015] = 8.43
data$adjust[data$year == 2016] = 8.65
data$adjust[data$year == 2017] = 8.97
data$adjust[data$year == 2018] = 9.11
data$adjust[data$year == 2019] = 9.01
##############


# Then we use that to find the tickets sold and multiply it by $9.01 to get the adjusted earnings. 
data$tickets_sold <- data$domestic_gross / data$adjust
data$gross_adj <- data$tickets_sold * 9.01


# Rather than using the month as a feature in the model, we will do some feature engineering to look at the 
#     season in which the movie was released. 
# This code creates a new column called season, which is populated based on the release month. 
data$season <- NULL
data$season[data$month == 'March' | data$month == 'April' | data$month == 'May'] = 'Spring'
data$season[data$month == 'June' | data$month == 'July' | data$month == 'August'] = 'Summer'
data$season[data$month == 'September' | data$month == 'October' | data$month == 'November'] = 'Fall'
data$season[data$month == 'December' | data$month == 'January' | data$month == 'February'] = 'Winter'

# And with that, our data is ready to go!







